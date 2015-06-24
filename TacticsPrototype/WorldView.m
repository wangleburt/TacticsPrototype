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
        
        UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
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
    }
}

- (void)updateDisplayPositionForWorldObject:(WorldObject *)object
{
    UIView *sprite = [self.sprites objectForKey:object.key];
    sprite.center = spriteCenter(object.position);
}

- (void)animateAnnotatedMovementPath:(NSArray *)path forObject:(WorldObject *)object completion:(void (^)())completionBlock
{
    if (path.count == 0) {
        completionBlock();
        return;
    }
    
    [self.overlayView setSelectorPosition:kNoSelectionPosition];
    
    UIView *sprite = [self.sprites objectForKey:object.key];
    [self animateMovementPath:path forSprite:sprite completion:^{
        [self.overlayView setSelectorPosition:[[path lastObject] worldPointValue]];
        completionBlock();
    }];
}

- (void)animateMovementPath:(NSArray *)path forObject:(WorldObject *)object completion:(void (^)())completionBlock
{
    if (path.count == 0) {
        completionBlock();
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
        completionBlock();
    }
}

//--------------------------------------------------------------------------------------

- (void)updateGridForState:(WorldState *)state
{
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
