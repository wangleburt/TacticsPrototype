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

#import "GridOverlayView.h"
#import "GridOverlayDisplay.h"

@interface WorldView ()

@property (nonatomic, strong) WorldLevel *level;

@property (nonatomic, strong) GridOverlayView *overlayView;
@property (nonatomic, strong) UIImageView *backgroundView;

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
        
        GridOverlayView *overlayView = [[GridOverlayView alloc] initWithGridDimensions:level.levelSize unitSize:kWorldGridUnitSize];
        [self addSubview:overlayView];
        self.overlayView = overlayView;
    }
    return self;
}

- (void)updateGridForState:(WorldState *)state
{
    GridOverlayDisplay *display = [state currentGridOverlayDisplay];    
    [self.overlayView updateViewForDisplay:display];
}

@end
