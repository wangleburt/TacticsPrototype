//
//  GridOverlayDisplay.m
//  TacticsPrototype
//
//  Created by Chris Meill on 6/22/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import "GridOverlayDisplay.h"
#import "WorldState.h"
#import "WorldObject.h"
#import "CharacterWorldOptions.h"

@interface GridOverlayTileDisplay ()

@property (nonatomic, strong) NSString *type;

@end

@implementation GridOverlayTileDisplay

static CGFloat blueColors[] = {
    0.0f, 0.0f, 0.5f, 0.4f,
    0.0f, 0.3f, 1.0f, 0.4f
};

static CGFloat redColors[] = {
    0.8f, 0.0f, 0.0f, 0.4f,
    1.0f, 0.2f, 0.2f, 0.4f
};

static CGFloat darkBlueColors[] = {
    0.0f, 0.0f, 0.2f, 0.4f,
    0.0f, 0.0f, 0.5f, 0.4f
};

static CGFloat darkRedColors[] = {
    0.3f, 0.0f, 0.0f, 0.4f,
    0.8f, 0.0f, 0.0f, 0.4f
};

+ (GridOverlayTileDisplay *)emptyTile
{
    static GridOverlayTileDisplay *emptyTile;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        emptyTile = [[GridOverlayTileDisplay alloc] init];
        emptyTile.gradientColors = nil;
        emptyTile.type = @"empty";
    });
    
    return emptyTile;
}

+ (GridOverlayTileDisplay *)blueTile
{
    static GridOverlayTileDisplay *blueTile;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        blueTile = [[GridOverlayTileDisplay alloc] init];
        blueTile.gradientColors = blueColors;
        blueTile.type = @"blue";
    });
    
    return blueTile;
}

+ (GridOverlayTileDisplay *)darkBlueTile
{
    static GridOverlayTileDisplay *darkBlueTile;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        darkBlueTile = [[GridOverlayTileDisplay alloc] init];
        darkBlueTile.gradientColors = darkBlueColors;
        darkBlueTile.type = @"dark-blue";
    });
    
    return darkBlueTile;
}

+ (GridOverlayTileDisplay *)redTile
{
    static GridOverlayTileDisplay *redTile;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        redTile = [[GridOverlayTileDisplay alloc] init];
        redTile.gradientColors = redColors;
        redTile.type = @"red";
    });
    
    return redTile;
}

+ (GridOverlayTileDisplay *)darkRedTile
{
    static GridOverlayTileDisplay *darkRedTile;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        darkRedTile = [[GridOverlayTileDisplay alloc] init];
        darkRedTile.gradientColors = darkRedColors;
        darkRedTile.type = @"dark-red";
    });
    
    return darkRedTile;
}

- (NSString *)description
{
    return self.type;
}

@end

//---------------------------------------------------------------------------------------

@interface GridOverlayDisplayArray ()

@property (nonatomic, strong) NSMutableArray *tiles;

@end

@implementation GridOverlayDisplayArray

- (instancetype)initWithSize:(NSUInteger)size
{
    self = [super init];
    if (self) {
        self.tiles = [NSMutableArray arrayWithCapacity:size];
        for (int i=0; i<size; i++) {
            [self.tiles addObject:[GridOverlayTileDisplay emptyTile]];
        }
    }
    return self;
}

- (GridOverlayTileDisplay *)objectAtIndexedSubscript:(NSUInteger)index
{
    return (index < self.tiles.count) ? self.tiles[index] : [GridOverlayTileDisplay emptyTile];
}

- (void)setObject:(GridOverlayTileDisplay *)object atIndexedSubscript:(NSUInteger)index
{
    if (index < self.tiles.count && [object isKindOfClass:GridOverlayTileDisplay.class]) {
        self.tiles[index] = object;
    }
}

+ (GridOverlayDisplayArray *)emptyArray
{
    static GridOverlayDisplayArray *emptyArray;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        emptyArray = [[GridOverlayDisplayArray alloc] initWithSize:0];
    });
    
    return emptyArray;
}

@end

//---------------------------------------------------------------------------------------

@interface GridOverlayDisplay ()

@property (nonatomic, strong) NSMutableArray *arrays;

@property (nonatomic, strong) WorldState *worldState;

@end

WorldPoint const kNoSelectionPosition = (WorldPoint){-1, -1};

@implementation GridOverlayDisplay

- (instancetype)initWithWorldState:(WorldState *)worldState
{
    self = [super init];
    if (self) {
        self.worldState = worldState;
        CGSize gridDimensions = worldState.gridDimensions;
        self.arrays = [NSMutableArray arrayWithCapacity:gridDimensions.width];
        for (int i=0; i<gridDimensions.width; i++) {
            GridOverlayDisplayArray *array = [[GridOverlayDisplayArray alloc] initWithSize:gridDimensions.height];
            if (array) {
                [self.arrays addObject:array];
            }
        }
    }
    return self;
}

- (GridOverlayDisplayArray *)objectAtIndexedSubscript:(NSUInteger)index
{
    return (index < self.arrays.count) ? self.arrays[index] : [GridOverlayDisplayArray emptyArray];
}

- (void)setObject:(GridOverlayDisplayArray *)object atIndexedSubscript:(NSUInteger)index
{
    if (index < self.arrays.count && [object isKindOfClass:GridOverlayDisplayArray.class]) {
        self.arrays[index] = object;
    }
}

- (BOOL)showGridLines
{
    return self.worldState.gridLinesEnabled;
}

- (BOOL)showCoordinates
{
    return self.worldState.gridCoordsEnabled;
}

- (WorldPoint)selectionPosition
{
    if (self.worldState.characterWorldOptions.selectedMoveOption) {
        return self.worldState.characterWorldOptions.selectedMoveOption.position;
    } else if (self.worldState.selectedObject) {
        return self.worldState.selectedObject.position;
    } else {
        return kNoSelectionPosition;
    }
}

@end
