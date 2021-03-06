//
//  CharacterInfoPanel.m
//  TacticsPrototype
//
//  Created by Chris Meill on 6/26/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import "CharacterInfoPanel.h"
#import "Character.h"
#import "CharacterClass.h"
#import "CharacterStats.h"
#import "Weapon.h"
#import "WeaponElement.h"

@interface CharacterInfoPanel ()

@property (nonatomic, strong) UIImageView *portrait;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *elementIcon;
@property (nonatomic, strong) UILabel *elementLabel;
@property (nonatomic, strong) UILabel *healthLabel;

@property (nonatomic) CharacterTeam team;

@end

static CGFloat const kShadowOffset = 3;

@implementation CharacterInfoPanel

- (instancetype)init
{
    CGRect frame = (CGRect){CGPointZero, 200 + kShadowOffset, 80 + kShadowOffset};
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        
        CGRect portraitFrame = (CGRect){5, 5, 70, 70};
        UIImageView *portrait = [[UIImageView alloc] initWithFrame:portraitFrame];
        portrait.backgroundColor = [UIColor clearColor];
        portrait.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:portrait];
        self.portrait = portrait;
        
        CGRect nameFrame = (CGRect){0, 13, 0, 15};
        nameFrame.size.width = CGRectGetWidth(self.bounds) - CGRectGetWidth(portraitFrame) - 20;
        nameFrame.origin.x = CGRectGetMaxX(portraitFrame) + 5;
        UILabel *label = [[UILabel alloc] initWithFrame:nameFrame];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithWhite:1 alpha:0.9];
        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        label.minimumScaleFactor = 0.8;
        label.adjustsFontSizeToFitWidth = YES;
        label.textAlignment = NSTextAlignmentLeft;
        [self addSubview:label];
        self.nameLabel = label;
        
        CGRect labelFrame = (CGRect){10, 0, 0, 15};
        labelFrame.origin.y = CGRectGetMaxY(nameFrame) + 5;
        labelFrame.origin.x = nameFrame.origin.x;
        labelFrame.size.width = CGRectGetWidth(self.bounds) - labelFrame.origin.x - 5;
        
        CGRect elemIconFrame = (CGRect){CGPointZero, 20, 20};
        elemIconFrame.origin.y = CGRectGetMidY(labelFrame) - CGRectGetHeight(elemIconFrame)/2;
        elemIconFrame.origin.x = nameFrame.origin.x;
        UIImageView *elementIcon = [[UIImageView alloc] initWithFrame:elemIconFrame];
        elementIcon.backgroundColor = [UIColor clearColor];
        elementIcon.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:elementIcon];
        self.elementIcon = elementIcon;
        
        CGRect elemLabelFrame = labelFrame;
        elemLabelFrame.size.width -= CGRectGetWidth(elemIconFrame) + 5;
        elemLabelFrame.origin.x = CGRectGetMaxX(elemIconFrame) + 5;
        label = [[UILabel alloc] initWithFrame:elemLabelFrame];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithWhite:1 alpha:0.9];
        label.font = [UIFont fontWithName:@"Helvetica" size:13];
        label.minimumScaleFactor = 0.8;
        label.adjustsFontSizeToFitWidth = YES;
        label.textAlignment = NSTextAlignmentLeft;
        [self addSubview:label];
        self.elementLabel = label;
        
        labelFrame.origin.y += CGRectGetHeight(labelFrame) + 5;
        label = [[UILabel alloc] initWithFrame:labelFrame];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithWhite:1 alpha:0.9];
        label.font = [UIFont fontWithName:@"Helvetica" size:13];
        label.textAlignment = NSTextAlignmentLeft;
        [self addSubview:label];
        self.healthLabel = label;
    }
    return self;
}

- (void)updateForCharacter:(Character *)character
{
    if (character == nil) {
        self.hidden = YES;
        return;
    }
    
    self.hidden = NO;
    if (character.team != self.team) {
        self.team = character.team;
        [self setNeedsDisplay];
    }
    
    self.portrait.image = [UIImage imageNamed:character.characterClass.headImageFileName];
    self.nameLabel.text = character.characterClass.name;
    self.elementLabel.text = character.weapon.element.name;
    self.elementIcon.image = [UIImage imageNamed:character.weapon.element.iconFileName];
    self.healthLabel.text = [NSString stringWithFormat:@"Health: %i/%i", character.health, character.stats.maxHp];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGRect panelFrame = CGRectInset(self.bounds, kShadowOffset/2, kShadowOffset/2);
    panelFrame.origin = CGPointZero;
    CGRect shadowFrame = CGRectOffset(panelFrame, kShadowOffset, kShadowOffset);
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRoundedRect:shadowFrame cornerRadius:5];
    UIColor *shadowColor = [UIColor colorWithWhite:0 alpha:0.6];
    CGContextSetFillColorWithColor(context, shadowColor.CGColor);
    CGContextBeginPath(context);
    CGContextAddPath(context, shadowPath.CGPath);
    CGContextFillPath(context);
    
    UIBezierPath *panelPath = [UIBezierPath bezierPathWithRoundedRect:panelFrame cornerRadius:5];
    UIColor *bgColor = (self.team == CharacterTeam_Player) ?
        [UIColor colorWithRed:0.1 green:0.2 blue:1.0 alpha:1] :
        [UIColor colorWithRed:0.8 green:0.0 blue:0.0 alpha:1];
    CGContextSetFillColorWithColor(context, bgColor.CGColor);
    CGContextBeginPath(context);
    CGContextAddPath(context, panelPath.CGPath);
    CGContextFillPath(context);
    
    CGRect portraitRect = CGRectInset(self.portrait.frame, 3, 3);
    UIColor *portraitColor = [UIColor colorWithWhite:0 alpha:0.2];
    CGContextSetFillColorWithColor(context, portraitColor.CGColor);
    CGContextFillEllipseInRect(context, portraitRect);

    portraitRect = CGRectOffset(portraitRect, 1, 1);
    portraitRect.size.width -= 1;
    portraitRect.size.height -= 1;
    CGContextSetFillColorWithColor(context, bgColor.CGColor);
    CGContextFillEllipseInRect(context, portraitRect);
    
    portraitColor = [UIColor colorWithWhite:1 alpha:0.3];
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
