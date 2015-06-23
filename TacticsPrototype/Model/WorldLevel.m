//
//  WorldLevel.m
//  TacticsPrototype
//
//  Created by Chris Meill on 6/22/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import "WorldLevel.h"
#import "TerrainMap.h"

@interface WorldLevel ()

@property (nonatomic) CGSize levelSize;
@property (nonatomic, strong) NSString *mapImageFileName;
@property (nonatomic, strong) TerrainMap *terrainTiles;

@end

@implementation WorldLevel

@end

@implementation WorldLevel (TestLevel)

+ (WorldLevel *)testLevel
{
    WorldLevel *level = [[WorldLevel alloc] init];
    level.levelSize = CGSizeMake(32, 16);
    level.mapImageFileName = @"map32x16";

    level.terrainTiles = [[TerrainMap alloc] initWithDimensions:level.levelSize];
    NSString *terrain =
       @"NNNNNNYYNYYYYYYYYNNNYYYYYYYYYYYY"
        "NYYNNYYYYYYYYYYYYYYNNNNYYYYYYYYY"
        "YYYYYYYYNNYYYYYYYYYNNNNNNNNYYYYY"
        "YYYYYYYYYNNNYYYYYYYNNNNYYYNNYYYY"
        "NNYYYYYYYNYNNYYYNNNNNNNYYYYNYYNN"
        "YNNNNYYYYNYYYYYYYYYNNNNYYYYYYYYY"
        "YYYYNNNNNNYYNNYYYYYYYNYNNNYYYYYY"
        "YYYYYYYNNNYYYNYYYYYYYYYYYYYYYYYY"
        "YYYYYYYYNNNNYNYYYYYYYNYYYYYYYYYY"
        "YYYYYYYYYYYNYNYYYYYYYNNNYYYYYYYY"
        "YYYYYYYYYYYYYNNYYYYYYYNNNYYYYYYY"
        "YYYYYYYYYYYNNYNYYYYYYYNYYYYYYYYY"
        "YYYYYYYYYYYYNNNNYYYYYNNYYYYYYYYY"
        "YYYYYYYYYYYYYYNNYYYYNNYYYYYYYYYY"
        "YYYYYYYYYYYYYYNNYYYYYYYYYYYYYYYY"
        "YYYYYYYYYYYYYYYNNYYYNYYYYYYYYYYY";
    for (int y=0; y<16; y++) {
        for (int x=0; x<32; x++) {
            char type = [terrain characterAtIndex:y*32+x];
            if (type == 'N') {
                level.terrainTiles[x][y] = [TerrainTile blockedTile];
            } else {
                level.terrainTiles[x][y] = [TerrainTile emptyTile];
            }
        }
    }
    
    return level;
}

@end
