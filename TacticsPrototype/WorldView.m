//
//  WorldView.m
//  TacticsPrototype
//
//  Created by Chris Meill on 6/22/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import "WorldView.h"
#import "WorldLevel.h"
#import "WorldState.h"
#import "WorldObject.h"
#import "CombatModel.h"

#import "Character.h"
#import "Weapon.h"
#import "WeaponElement.h"

#import "GridOverlayView.h"
#import "GridOverlayDisplay.h"

@interface WorldView ()

@property (nonatomic, strong) WorldLevel *level;

@property (nonatomic, strong) GridOverlayView *overlayView;
@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UIView *spriteView;

@property (nonatomic, strong) NSMutableDictionary *sprites;

@end

static CGFloat const kWorldGridUnitSize = 80.0f;

#define spriteCenter(point) CGPointMake((0.5f+point.x)*kWorldGridUnitSize, \
                                        (0.5f+point.y)*kWorldGridUnitSize)

@implementation WorldView

- (instancetype)initWithLevel:(WorldLevel *)level
{
    CGRect frame = (CGRect){CGPointZero, level.levelSize.width*kWorldGridUnitSize, level.levelSize.height*kWorldGridUnitSize};
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        self.level = level;
        
        CGRect bgFrame = (CGRect){CGPointZero, kWorldGridUnitSize * 32, kWorldGridUnitSize * 16};
        UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:bgFrame];
        backgroundView.image = [UIImage imageNamed:level.mapImageFileName];
        backgroundView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:backgroundView];
        self.backgroundView = backgroundView;
        
        GridOverlayView *overlayView = [[GridOverlayView alloc] initWithGridDimensions:level.levelSize unitSize:kWorldGridUnitSize];
        [self addSubview:overlayView];
        self.overlayView = overlayView;
        
        UIView *spriteView = [[UIView alloc] initWithFrame:self.bounds];
        spriteView.backgroundColor = [UIColor clearColor];
        [self addSubview:spriteView];
        self.spriteView = spriteView;
        
        self.sprites = [NSMutableDictionary dictionary];
    }
    return self;
}

//--------------------------------------------------------------------------------------
#pragma mark - Sprites

- (void)loadSpritesFromState:(WorldState *)state
{
    NSArray *worldObjects = state.worldObjects;
    CGRect baseFrame = (CGRect){CGPointZero, kWorldGridUnitSize, kWorldGridUnitSize};
    
    for (WorldObject *object in worldObjects) {
        UIImageView *sprite = [[UIImageView alloc] initWithFrame:baseFrame];
        sprite.backgroundColor = [UIColor clearColor];
        sprite.contentMode = UIViewContentModeScaleAspectFit;
        sprite.image = [UIImage imageNamed:object.imageFileName];
        sprite.center = spriteCenter(object.position);
        [self.sprites setObject:sprite forKey:object.key];
        [self.spriteView addSubview:sprite];
        
        if ([object isKindOfClass:Character.class]) {
            WeaponElement *element = ((Character *)object).weapon.element;
            UIImageView *elementIcon = [[UIImageView alloc] initWithFrame:(CGRect){3,3,10,10}];
            elementIcon.backgroundColor = [UIColor clearColor];
            elementIcon.contentMode = UIViewContentModeScaleAspectFit;
            elementIcon.image = [UIImage imageNamed:element.iconFileName];
            [sprite addSubview:elementIcon];
        }
    }
}

- (void)updateDisplayPositionForWorldObject:(WorldObject *)object
{
    UIView *sprite = [self.sprites objectForKey:object.key];
    sprite.center = spriteCenter(object.position);
}

- (void)updateSpriteForObject:(WorldObject *)object active:(BOOL)isActive
{
    UIImageView *sprite = [self.sprites objectForKey:object.key];
    if (!sprite) {
        return;
    }
    
    UIImage *image = [UIImage imageNamed:object.imageFileName];
    if (!isActive) {
        image = [self convertImageToGreyscale:image];
    }
    sprite.image = image;
}

- (UIImage *)convertImageToGreyscale:(UIImage *)image
{
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();

    CGBitmapInfo info = (CGBitmapInfo)kCGImageAlphaNone; // docs say this is safe
    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, info);

    CGContextDrawImage(context, imageRect, [image CGImage]);
    CGImageRef imageRef = CGBitmapContextCreateImage(context);

    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);

    info = (CGBitmapInfo)kCGImageAlphaOnly; // docs say this is safe
    context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, nil, info);
    CGContextDrawImage(context, imageRect, [image CGImage]);
    CGImageRef mask = CGBitmapContextCreateImage(context);

    UIImage *newImage = [UIImage imageWithCGImage:CGImageCreateWithMask(imageRef, mask)];
    CGImageRelease(imageRef);
    CGImageRelease(mask);
    return newImage;
}

//--------------------------------------------------------------------------------------
#pragma mark - Movement

- (CGRect)visibleRectForMovementPath:(NSArray *)path
{
    WorldPoint startPosition = [[path firstObject] worldPointValue];
    WorldPoint endPosition = [[path lastObject] worldPointValue];
    
    CGPoint startPoint = (CGPoint){startPosition.x*kWorldGridUnitSize, startPosition.y*kWorldGridUnitSize};
    CGPoint endPoint = (CGPoint){endPosition.x*kWorldGridUnitSize, endPosition.y*kWorldGridUnitSize};
    
    CGRect visibleRect = CGRectZero;
    visibleRect.origin.x = MIN(startPoint.x, endPoint.x);
    visibleRect.size.width = kWorldGridUnitSize + fabs(startPoint.x - endPoint.x);
    visibleRect.origin.y = MIN(startPoint.y, endPoint.y);
    visibleRect.size.height = kWorldGridUnitSize + fabs(startPoint.y - endPoint.y);
    return visibleRect;
}

- (void)animateMovementPath:(NSArray *)movementPath withAnnotationPath:(NSArray *)annotationPath forObject:(WorldObject *)object completion:(void (^)())completionBlock;
{
    if (movementPath.count == 0) {
        if (completionBlock) {
            completionBlock();
        }
        return;
    }
    
    [self.overlayView setSelectorPosition:kNoSelectionPosition];
    [self.overlayView cleanupMovementAnnotations];
    
    UIView *sprite = [self.sprites objectForKey:object.key];
    [self animateMovementPath:movementPath forSprite:sprite completion:^{
        [self.overlayView setSelectorPosition:[[annotationPath lastObject] worldPointValue]];
        [self.overlayView annotateMovementPath:annotationPath];
        if (completionBlock) {
            completionBlock();
        }
    }];
}

- (void)animateMovementPath:(NSArray *)path forObject:(WorldObject *)object completion:(void (^)())completionBlock
{
    if (path.count == 0) {
        if (completionBlock) {
            completionBlock();
        }
        return;
    }

    UIView *sprite = [self.sprites objectForKey:object.key];
    [self animateMovementPath:path forSprite:sprite completion:completionBlock];
}

- (void)animateMovementPath:(NSArray *)path forSprite:(UIView *)sprite completion:(void (^)())completionBlock
{
    WorldPoint startPoint = [path[0] worldPointValue];
    sprite.center = spriteCenter(startPoint);

    if (path.count > 1) {
        WorldPoint endPoint = [path[1] worldPointValue];
        [UIView animateWithDuration:0.05 animations:^{
            sprite.center = spriteCenter(endPoint);
        } completion:^(BOOL finished) {
            NSRange range = NSMakeRange(1, path.count - 1);
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            NSArray *remainingPath = [path objectsAtIndexes:indexSet];
            [self animateMovementPath:remainingPath forSprite:sprite completion:completionBlock];
        }];

    } else {
        if (completionBlock) {
            completionBlock();
        }
    }
}

//--------------------------------------------------------------------------------------
#pragma mark - Attacks

- (void)animateCombat:(CombatModel *)combatModel completion:(void (^)(CombatModel *))completionBlock
{
    [self animateAttacks:combatModel.attacks completion:^{
        if (completionBlock) {
            completionBlock(combatModel);
        }
    }];
}

- (void)animateAttacks:(NSArray *)attacks completion:(void (^)())completionBlock
{
    if (!attacks || attacks.count == 0) {
        if (completionBlock) {
            completionBlock();
        }
        return;
    }
    
    AttackModel *attack = [attacks firstObject];
    [self animateAttack:attack completion:^{
        NSRange range = NSMakeRange(1, attacks.count-1);
        NSArray *remaining = [attacks objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
        [self animateAttacks:remaining completion:completionBlock];
    }];
}

- (void)animateAttack:(AttackModel *)attackModel completion:(void (^)())completionBlock
{
    UILabel *attackerLabel = nil;
    if (attackModel.roll != AttackRoll_Hit) {
        attackerLabel = [[UILabel alloc] init];
        attackerLabel.backgroundColor = [UIColor clearColor];
        attackerLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        attackerLabel.textColor = [UIColor blueColor];
        if (attackModel.roll == AttackRoll_Crit) {
            attackerLabel.text = @"CRIT!";
        } else if (attackModel.roll == AttackRoll_Miss) {
            attackerLabel.text = @"MISS!";
        }
        [attackerLabel sizeToFit];
    }
    
    UILabel *defenderLabel = nil;
    if (attackModel.roll != AttackRoll_Miss) {
        defenderLabel = [[UILabel alloc] init];
        defenderLabel.backgroundColor = [UIColor clearColor];
        defenderLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        defenderLabel.textColor = [UIColor redColor];
        defenderLabel.text = [NSString stringWithFormat:@"-%i", attackModel.damage];
        [defenderLabel sizeToFit];
    }
    
    UIView *attackerSprite = [self.sprites objectForKey:attackModel.attacker.key];
    UIView *defenderSprite = [self.sprites objectForKey:attackModel.defender.key];
    
    CGPoint attackerStart = attackerSprite.center;
    CGPoint attackerEnd = defenderSprite.center;
    
    CGPoint delta = (CGPoint){attackerEnd.x-attackerStart.x, attackerEnd.y-attackerStart.y};
    CGFloat distance = sqrt(delta.x*delta.x + delta.y*delta.y);
    CGFloat desiredDistance = kWorldGridUnitSize / 4;
    CGFloat ratio = desiredDistance/distance;
    delta = (CGPoint){delta.x*ratio, delta.y*ratio};
    attackerEnd = (CGPoint){attackerStart.x + delta.x, attackerStart.y + delta.y};
    
    if (attackModel.roll == AttackRoll_Crit) {
        [self animateLabel:attackerLabel overSprite:attackerSprite];
    }
    [UIView animateWithDuration:0.1 animations:^{
        attackerSprite.center = attackerEnd;
    } completion:^(BOOL finished) {
        if (attackModel.roll == AttackRoll_Miss) {
            [self animateLabel:attackerLabel overSprite:attackerSprite];
        } else {
            [self animateLabel:defenderLabel overSprite:defenderSprite];
        }
        [UIView animateWithDuration:0.3 animations:^{
            attackerSprite.center = attackerStart;
            if (attackModel.isKill) {
                defenderSprite.alpha = 0.0f;
            }
        } completion:^(BOOL finished) {
            if (attackModel.isKill) {
                [defenderSprite removeFromSuperview];
                [self.sprites removeObjectForKey:attackModel.defender.key];
            }
            if (completionBlock) {
                completionBlock();
            }
        }];
    }];
}

- (void)animateLabel:(UILabel *)label overSprite:(UIView *)sprite
{
    if (!label) {
        return;
    }
    
    CGPoint center = sprite.center;
    center.y -= kWorldGridUnitSize / 2;
    label.center = center;
    
    [self.spriteView addSubview:label];
    [UIView animateWithDuration:1 animations:^{
        label.alpha = 0;
        label.center = (CGPoint){center.x, center.y - kWorldGridUnitSize/2};
    } completion:^(BOOL finished) {
        [label removeFromSuperview];
    }];
}

//--------------------------------------------------------------------------------------

- (void)updateGridForState:(WorldState *)state
{
    [self.overlayView cleanupMovementAnnotations];

    GridOverlayDisplay *display = [state currentGridOverlayDisplay];
    [self.overlayView updateViewForDisplay:display];
}

- (WorldPoint)gridPositionForTouchLocatoin:(CGPoint)touchLocation
{
    int touchX = floor(touchLocation.x / kWorldGridUnitSize);
    int touchY = floor(touchLocation.y / kWorldGridUnitSize);
    return (WorldPoint){touchX, touchY};
}

@end
