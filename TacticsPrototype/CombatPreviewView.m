//
//  CombatPreviewView.m
//  TacticsPrototype
//
//  Created by Chris Meill on 6/29/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import "CombatPreviewView.h"
#import "BlockDrawingView.h"

#import "Character.h"
#import "CharacterClass.h"
#import "CombatModel.h"
#import "Weapon.h"
#import "WeaponElement.h"

@interface PreviewElementsPanel : UIView

- (instancetype)initWithTeam:(CharacterTeam)team;

- (void)updateWithAttack:(AttackPreveiw *)attack fromCharacter:(Character *)character;

@end

@interface CombatPreviewView ()

@property (nonatomic, strong) UIImageView *playerAdvantageIcon;
@property (nonatomic, strong) UIImageView *enemyAdvantageIcon;

@property (nonatomic, strong) PreviewElementsPanel *playerPanel;
@property (nonatomic, strong) PreviewElementsPanel *enemyPanel;

@end

@implementation CombatPreviewView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4f];
        
        CGFloat centerWidth = 50;
        
        CGRect centerFrame = (CGRect){CGRectGetMidX(self.bounds) - centerWidth/2, 0, centerWidth, 0};
        BlockDrawingView *centerView = [[BlockDrawingView alloc] initWithFrame:centerFrame];
        centerView.drawBlock = ^void(CGRect rect) {
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSaveGState(context);
            
            UIColor *bgColor = [UIColor colorWithRed:0.94 green:0.86 blue:0.77 alpha:1];
            CGContextSetFillColorWithColor(context, bgColor.CGColor);
            CGContextFillRect(context, rect);
            
            CGRect borderRect = rect;
            borderRect.size.height = 2;
            UIColor *borderColor = [UIColor colorWithRed:0.56 green:0.43 blue:0.3 alpha:1];
            CGContextSetFillColorWithColor(context, borderColor.CGColor);
            CGContextFillRect(context, borderRect);
            
            borderRect.origin.y = CGRectGetMaxY(rect) - CGRectGetHeight(borderRect);
            CGContextFillRect(context, borderRect);
            
            UIColor *shadowColor = [UIColor colorWithWhite:0 alpha:0.1f];
            CGContextSetFillColorWithColor(context, shadowColor.CGColor);
            for (int i=4; i>0; i--) {
                CGRect shadowRect = rect;
                shadowRect.size.width = i;
                CGContextFillRect(context, shadowRect);
                shadowRect.origin.x = CGRectGetMaxX(rect) - CGRectGetWidth(shadowRect) + 3;
                CGContextFillRect(context, shadowRect);
            }
            
            CGContextRestoreGState(context);
        };
        [self addSubview:centerView];
        
        PreviewElementsPanel *playerPanel = [[PreviewElementsPanel alloc] initWithTeam:CharacterTeam_Player];
        CGRect panelFrame = playerPanel.frame;
        panelFrame.origin.x = CGRectGetMidX(self.bounds) - centerWidth/2 - CGRectGetWidth(panelFrame);
        panelFrame.origin.y = CGRectGetMidY(self.bounds) - CGRectGetHeight(panelFrame)/2;
        playerPanel.frame = panelFrame;
        [self addSubview:playerPanel];
        self.playerPanel = playerPanel;
        
        PreviewElementsPanel *enemyPanel = [[PreviewElementsPanel alloc] initWithTeam:CharacterTeam_Enemy];
        panelFrame = enemyPanel.frame;
        panelFrame.origin.y = CGRectGetMinY(self.playerPanel.frame);
        panelFrame.origin.x = CGRectGetMidX(self.bounds) + centerWidth/2;
        enemyPanel.frame = panelFrame;
        [self addSubview:enemyPanel];
        self.enemyPanel = enemyPanel;
        
        centerFrame.origin.y = CGRectGetMinY(panelFrame) + 30;
        centerFrame.size.height = CGRectGetHeight(panelFrame) - 45;
        centerView.frame = centerFrame;
        
        CGRect labelFrame = centerView.bounds;
        labelFrame.size.height = 15;
        labelFrame.origin.y = CGRectGetMaxY(centerView.bounds) - 25;
        UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:10];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"CRIT";
        [centerView addSubview:label];
        
        labelFrame.origin.y -= 23;
        label = [[UILabel alloc] initWithFrame:labelFrame];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:10];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"HIT";
        [centerView addSubview:label];
        
        labelFrame.origin.y -= 23;
        label = [[UILabel alloc] initWithFrame:labelFrame];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:10];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"DMG";
        [centerView addSubview:label];
        
        labelFrame.origin.y -= 23;
        label = [[UILabel alloc] initWithFrame:labelFrame];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:10];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"HP";
        [centerView addSubview:label];
        
        CGFloat iconSize = 15;
        CGRect advIconFrame = (CGRect){CGPointZero, iconSize, iconSize};
        advIconFrame.origin.y = CGRectGetMinY(labelFrame) - 22.5 - iconSize/2;
        CGFloat iconBuffer = (centerWidth - iconSize*2)/3;
        advIconFrame.origin.x = iconBuffer;
        
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:advIconFrame];
        iconView.backgroundColor = [UIColor clearColor];
        iconView.contentMode = UIViewContentModeScaleAspectFit;
        [centerView addSubview:iconView];
        self.playerAdvantageIcon = iconView;
        
        advIconFrame.origin.x += iconSize + iconBuffer;
        iconView = [[UIImageView alloc] initWithFrame:advIconFrame];
        iconView.backgroundColor = [UIColor clearColor];
        iconView.contentMode = UIViewContentModeScaleAspectFit;
        [centerView addSubview:iconView];
        self.enemyAdvantageIcon = iconView;
        
    }
    return self;
}

- (void)updateWithCombatModel:(CombatModel *)model
{
    [self.enemyPanel updateWithAttack:model.enemyAttack fromCharacter:model.enemy];
    [self.playerPanel updateWithAttack:model.playerAttack fromCharacter:model.player];
    
    void (^setCompImage)(UIImageView *, ElementComparison) = ^void(UIImageView *imageView, ElementComparison comp)
    {
        switch (comp) {
            case ElementComparison_Advantage:
                imageView.image = [UIImage imageNamed:@"arrow-up"];
                break;
            case ElementComparison_Disadvantage:
                imageView.image = [UIImage imageNamed:@"arrow-down"];
                break;
            default:
                imageView.image = nil;
                break;
        }
    };
    
    ElementComparison playerComp = [model.player.weapon.element compareAgainstElement:model.enemy.weapon.element];
    setCompImage(self.playerAdvantageIcon, playerComp);
    
    ElementComparison enemyComp = [model.enemy.weapon.element compareAgainstElement:model.player.weapon.element];
    setCompImage(self.enemyAdvantageIcon, enemyComp);
}

@end

//-------------------------------------------------------------------------------

@interface PreviewElementsPanel ()

@property (nonatomic) CharacterTeam team;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *portrait;
@property (nonatomic, strong) UILabel *healthLabel;
@property (nonatomic, strong) UILabel *elementLabel;
@property (nonatomic, strong) UIImageView *elementIcon;
@property (nonatomic, strong) UILabel *damageLabel;
@property (nonatomic, strong) UILabel *hitLabel;
@property (nonatomic, strong) UILabel *critLabel;

@property (nonatomic, strong) UILabel *noAttackLabel;

@end

@implementation PreviewElementsPanel

- (instancetype)initWithTeam:(CharacterTeam)team
{
    CGRect frame = (CGRect){CGPointZero, 200, 180};
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.team = team;
        BOOL isLeft = (team == CharacterTeam_Enemy);
        
        CGRect portraitFrame = (CGRect){5, 5, 70, 70};
        if (isLeft) {
            portraitFrame.origin.x = CGRectGetWidth(self.bounds) - CGRectGetWidth(portraitFrame) - 5;
        }
        UIImageView *portrait = [[UIImageView alloc] initWithFrame:portraitFrame];
        portrait.backgroundColor = [UIColor clearColor];
        portrait.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:portrait];
        self.portrait = portrait;
        
        CGRect nameFrame = (CGRect){0, 15, 0, 15};
        nameFrame.size.width = CGRectGetWidth(self.bounds) - CGRectGetWidth(portraitFrame) - 20;
        nameFrame.origin.x = isLeft ? 10 : CGRectGetMaxX(portraitFrame) + 5;
        UILabel *label = [[UILabel alloc] initWithFrame:nameFrame];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithWhite:1 alpha:0.9];
        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        label.minimumScaleFactor = 0.8;
        label.adjustsFontSizeToFitWidth = YES;
        label.textAlignment = isLeft ? NSTextAlignmentLeft : NSTextAlignmentRight;
        [self addSubview:label];
        self.nameLabel = label;
        
        CGRect labelFrame = (CGRect){10, 0, 0, 15};
        labelFrame.origin.y = CGRectGetMaxY(nameFrame) + 10;
        labelFrame.size.width = CGRectGetWidth(self.bounds) - 20;
        
        CGRect elemIconFrame = (CGRect){CGPointZero, 20, 20};
        elemIconFrame.origin.y = CGRectGetMidY(labelFrame) - CGRectGetHeight(elemIconFrame)/2;
        elemIconFrame.origin.x = isLeft ? 10 : CGRectGetMaxX(labelFrame) - CGRectGetWidth(elemIconFrame);
        UIImageView *elementIcon = [[UIImageView alloc] initWithFrame:elemIconFrame];
        elementIcon.backgroundColor = [UIColor clearColor];
        elementIcon.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:elementIcon];
        self.elementIcon = elementIcon;
        
        CGRect elemLabelFrame = labelFrame;
        elemLabelFrame.size.width -= CGRectGetWidth(elemIconFrame) + 5;
        elemLabelFrame.origin.x = isLeft ? CGRectGetMaxX(elemIconFrame) + 5 : 10;
        label = [[UILabel alloc] initWithFrame:elemLabelFrame];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithWhite:1 alpha:0.9];
        label.font = [UIFont fontWithName:@"Helvetica" size:13];
        label.minimumScaleFactor = 0.8;
        label.adjustsFontSizeToFitWidth = YES;
        label.textAlignment = isLeft ? NSTextAlignmentLeft : NSTextAlignmentRight;
        [self addSubview:label];
        self.elementLabel = label;
        
        labelFrame.origin.y += CGRectGetHeight(labelFrame) + 15;
        label = [[UILabel alloc] initWithFrame:labelFrame];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithWhite:1 alpha:0.9];
        label.font = [UIFont fontWithName:@"Helvetica" size:13];
        label.textAlignment = isLeft ? NSTextAlignmentLeft : NSTextAlignmentRight;
        [self addSubview:label];
        self.healthLabel = label;
        
        labelFrame.origin.y += CGRectGetHeight(labelFrame) + 8;
        label = [[UILabel alloc] initWithFrame:labelFrame];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithWhite:1 alpha:0.9];
        label.font = [UIFont fontWithName:@"Helvetica" size:13];
        label.textAlignment = isLeft ? NSTextAlignmentLeft : NSTextAlignmentRight;
        [self addSubview:label];
        self.damageLabel = label;
        
        labelFrame.origin.y += CGRectGetHeight(labelFrame) + 8;
        label = [[UILabel alloc] initWithFrame:labelFrame];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithWhite:1 alpha:0.9];
        label.font = [UIFont fontWithName:@"Helvetica" size:13];
        label.textAlignment = isLeft ? NSTextAlignmentLeft : NSTextAlignmentRight;
        [self addSubview:label];
        self.hitLabel = label;
        
        labelFrame.origin.y += CGRectGetHeight(labelFrame) + 8;
        label = [[UILabel alloc] initWithFrame:labelFrame];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithWhite:1 alpha:0.9];
        label.font = [UIFont fontWithName:@"Helvetica" size:13];
        label.textAlignment = isLeft ? NSTextAlignmentLeft : NSTextAlignmentRight;
        [self addSubview:label];
        self.critLabel = label;
        
        CGRect noAttackFrame = labelFrame;
        noAttackFrame.origin.y = CGRectGetMinY(self.damageLabel.frame);
        noAttackFrame.size.height = CGRectGetMaxY(self.critLabel.frame) - CGRectGetMinY(self.damageLabel.frame);
        label = [[UILabel alloc] initWithFrame:noAttackFrame];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithWhite:1 alpha:0.9];
        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"No Attack :(";
        [self addSubview:label];
        self.noAttackLabel = label;
    }
    return self;
}

- (void)updateWithAttack:(AttackPreveiw *)attack fromCharacter:(Character *)character
{
    self.portrait.image = [UIImage imageNamed:character.characterClass.headImageFileName];
    self.nameLabel.text = character.characterClass.name;
    self.healthLabel.text = [NSString stringWithFormat:@"%i/%i", character.health, character.characterClass.maxHealth];
    WeaponElement *element = character.weapon.element;
    self.elementLabel.text = element.name;
    self.elementIcon.image = [UIImage imageNamed:element.iconFileName];
    
    if (attack) {
        self.damageLabel.text = [NSString stringWithFormat:@"%i", attack.damage];
        self.hitLabel.text = [NSString stringWithFormat:@"%i%%", attack.hitChance];
        self.critLabel.text = [NSString stringWithFormat:@"%i%%", attack.critChance];
        self.noAttackLabel.hidden = YES;
    } else {
        self.damageLabel.text = nil;
        self.hitLabel.text = nil;
        self.critLabel.text = nil;
        self.noAttackLabel.hidden = NO;
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGRect panelFrame = self.bounds;
    UIBezierPath *panelPath = [UIBezierPath bezierPathWithRoundedRect:panelFrame cornerRadius:5];
    UIColor *bgColor = (self.team == CharacterTeam_Player) ?
        [UIColor colorWithRed:0.1 green:0.2 blue:1.0 alpha:1] :
        [UIColor colorWithRed:0.8 green:0.0 blue:0.0 alpha:1];
    CGContextSetFillColorWithColor(context, bgColor.CGColor);
    CGContextBeginPath(context);
    CGContextAddPath(context, panelPath.CGPath);
    CGContextFillPath(context);
    
    CGRect portraitRect = CGRectInset(self.portrait.frame, 3, 3);
    UIColor *shadowColor = [UIColor colorWithWhite:0 alpha:0.2];
    CGContextSetFillColorWithColor(context, shadowColor.CGColor);
    CGContextFillEllipseInRect(context, portraitRect);

    portraitRect = CGRectOffset(portraitRect, 1, 1);
    portraitRect.size.width -= 1;
    portraitRect.size.height -= 1;
    CGContextSetFillColorWithColor(context, bgColor.CGColor);
    CGContextFillEllipseInRect(context, portraitRect);
    
    UIColor *portraitColor = [UIColor colorWithWhite:1 alpha:0.3];
    CGContextSetFillColorWithColor(context, portraitColor.CGColor);
    CGContextFillEllipseInRect(context, portraitRect);
    
    CGRect elemRect = CGRectOffset(self.elementIcon.frame, -1, -1);
    elemRect.size.width += 1;
    elemRect.size.height += 1;
    shadowColor = [UIColor colorWithWhite:0 alpha:0.5];
    CGContextSetFillColorWithColor(context, shadowColor.CGColor);
    CGContextFillEllipseInRect(context, elemRect);
    
    CGFloat borderWidth = 2;
    CGContextSetLineWidth(context, borderWidth);
    CGRect borderFrame = CGRectInset(panelFrame, borderWidth/2, borderWidth/2);
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:borderFrame cornerRadius:5];
    UIColor *borderColor = [UIColor colorWithWhite:0.9 alpha:0.6];
    CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
    CGContextBeginPath(context);
    CGContextAddPath(context, borderPath.CGPath);
    CGContextStrokePath(context);
    
    CGContextRestoreGState(context);
}

@end
