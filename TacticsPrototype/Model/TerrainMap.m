//
//  TerrainMap.m
//  TacticsPrototype
//
//  Created by Chris Meill on 6/23/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import "TerrainMap.h"

@implementation TerrainTile

+ (TerrainTile *)emptyTile
{
    static TerrainTile *emptyTile;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        emptyTile = [[TerrainTile alloc] init];
        emptyTile.blocked = NO;
    });
    
    return emptyTile;
}

+ (TerrainTile *)blockedTile
{
    static TerrainTile *blockedTile;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        blockedTile = [[TerrainTile alloc] init];
        blockedTile.blocked = YES;
    });
    
    return blockedTile;
}

- (NSString *)description
{
    return (self.blocked) ? @"N" : @"Y";
}

@end

//---------------------------------------------------------------------------------------

@interface TerrainTileArray ()

@property (nonatomic, strong) NSMutableArray *tiles;

@end

@implementation TerrainTileArray

- (instancetype)initWithSize:(NSUInteger)size
{
    self = [super init];
    if (self) {
        self.tiles = [NSMutableArray arrayWithCapacity:size];
        for (int i=0; i<size; i++) {
            [self.tiles addObject:[TerrainTile emptyTile]];
        }
    }
    return self;
}

- (TerrainTile *)objectAtIndexedSubscript:(NSUInteger)index
{
    return (index < self.tiles.count) ? self.tiles[index] : [TerrainTile emptyTile];
}

- (void)setObject:(TerrainTile *)object atIndexedSubscript:(NSUInteger)index
{
    if (index < self.tiles.count && [object isKindOfClass:TerrainTile.class]) {
        self.tiles[index] = object;
    }
}

+ (TerrainTileArray *)emptyArray
{
    static TerrainTileArray *emptyArray;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        emptyArray = [[TerrainTileArray alloc] initWithSize:0];
    });
    
    return emptyArray;
}

- (NSUInteger)count
{
    return self.tiles.count;
}

- (NSString *)description
{
    NSMutableString *description = [NSMutableString string];
    for (TerrainTile *tile in self.tiles) {
        [description appendString:tile.description];
    }
    return description;
}

@end

//---------------------------------------------------------------------------------------

@interface TerrainMap ()

@property (nonatomic, strong) NSMutableArray *arrays;

@end

@implementation TerrainMap

- (instancetype)initWithDimensions:(CGSize)dimensions
{
    self = [super init];
    if (self) {
        self.arrays = [NSMutableArray arrayWithCapacity:dimensions.width];
        for (int i=0; i<dimensions.width; i++) {
            TerrainTileArray *array = [[TerrainTileArray alloc] initWithSize:dimensions.height];
            if (array) {
                [self.arrays addObject:array];
            }
        }
    }
    return self;
}

- (TerrainTileArray *)objectAtIndexedSubscript:(NSUInteger)index
{
    return (index < self.arrays.count) ? self.arrays[index] : [TerrainTileArray emptyArray];
}

- (void)setObject:(TerrainTileArray *)object atIndexedSubscript:(NSUInteger)index
{
    if (index < self.arrays.count && [object isKindOfClass:TerrainTileArray.class]) {
        self.arrays[index] = object;
    }
}

- (NSString *)description
{
    NSMutableString *string = [NSMutableString string];
    for (int j=0; j<[self.arrays[0] count]; j++) {
        for (int i=0; i<self.arrays.count; i++) {
            [string appendString:self[i][j].blocked ? @"N" : @"Y"];
        }
        [string appendString:@"\n"];
    }
    return string;
}

@end
