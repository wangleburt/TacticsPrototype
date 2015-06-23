//
//  WorldState.m
//  TacticsPrototype
//
//  Created by Chris Meill on 6/22/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import "WorldState.h"
#import "WorldLevel.h"

#import "GridOverlayDisplay.h"

@interface WorldState ()

@property (nonatomic, strong) WorldLevel *level;

@end

@implementation WorldState

- (instancetype)initWithLevel:(WorldLevel *)level
{
    self = [super init];
    if (self) {
        self.level = level;
    }
    return self;
}

- (GridOverlayDisplay *)currentGridOverlayDisplay
{
    GridOverlayDisplay *display = [[GridOverlayDisplay alloc] initWithWorldState:self];
    return display;
}

@end
