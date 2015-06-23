//
//  WorldState.m
//  TacticsPrototype
//
//  Created by Chris Meill on 6/22/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import "WorldState.h"
#import "WorldLevel.h"
#import "TerrainMap.h"

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
    for (int i=0; i<self.level.levelSize.width; i++) {
        for (int j=0; j<self.level.levelSize.height; j++) {
            if (self.level.terrainTiles[i][j].blocked) {
                display[i][j] = [GridOverlayTileDisplay redTile];
            }
        }
    }
    
    return display;
}

- (CGSize)gridDimensions
{
    return self.level.levelSize;
}

@end
