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
        
        UIView *spriteView = [[UIView alloc] initWithFrame:self.bounds];
        spriteView.backgroundColor = [UIColor clearColor];
        [self addSubview:spriteView];
        self.spriteView = spriteView;
        
        GridOverlayView *overlayView = [[GridOverlayView alloc] initWithGridDimensions:level.levelSize unitSize:kWorldGridUnitSize];
        [self addSubview:overlayView];
        self.overlayView = overlayView;
        
        self.sprites = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)loadSpritesFromState:(WorldState *)state
{
    NSArray *worldObjects = state.worldObjects;
    CGRect baseFrame = (CGRect){CGPointZero, kWorldGridUnitSize, kWorldGridUnitSize};
    
    for (WorldObject *object in worldObjects) {
        UIImageView *sprite = [[UIImageView alloc] initWithFrame:baseFrame];
        sprite.backgroundColor = [UIColor clearColor];
        sprite.contentMode = UIViewContentModeScaleAspectFit;
        sprite.image = [UIImage imageNamed:object.imageFileName];
        CGRect frame = sprite.frame;
        frame.origin = (CGPoint){object.position.x*kWorldGridUnitSize, object.position.y*kWorldGridUnitSize};
        sprite.frame = frame;
        [self.sprites setObject:sprite forKey:object.key];
        [self.spriteView addSubview:sprite];
    }
}

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
