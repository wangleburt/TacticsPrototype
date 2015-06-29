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

@interface CharacterInfoPanel ()

@property (nonatomic, strong) UIImageView *portrait;
@property (nonatomic, strong) UILabel *nameLabel;
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
        
        CGRect healthFrame = (CGRect){CGPointZero, 115, 15};
        healthFrame.origin.x = CGRectGetMaxX(portraitFrame) + 5;
        healthFrame.origin.y = CGRectGetHeight(self.bounds) - healthFrame.size.height - 15 - kShadowOffset;
        UILabel *healthLabel = [[UILabel alloc] initWithFrame:healthFrame];
        healthLabel.backgroundColor = [UIColor clearColor];
        healthLabel.textColor = [UIColor colorWithWhite:1 alpha:0.9];
        healthLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        healthLabel.minimumScaleFactor = 0.8;
        healthLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:healthLabel];
        self.healthLabel = healthLabel;
        
        CGRect nameFrame = CGRectOffset(healthFrame, 0, -healthFrame.size.height-5);
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:nameFrame];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = [UIColor colorWithWhite:1 alpha:0.9];
        nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        nameLabel.minimumScaleFactor = 0.8;
        nameLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:nameLabel];
        self.nameLabel = nameLabel;
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
    self.healthLabel.text = [NSString stringWithFormat:@"Health: %i/%i", character.health, character.characterClass.maxHealth];
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
