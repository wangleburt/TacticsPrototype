//
//  WorldLevel.h
//  TacticsPrototype
//
//  Created by Chris Meill on 6/22/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>

@class TerrainMap;

@interface WorldLevel : NSObject

@property (nonatomic, readonly) CGSize levelSize;
@property (nonatomic, readonly) CGSize nativeMapSize;

@property (nonatomic, strong, readonly) NSString *mapImageFileName;
@property (nonatomic, strong, readonly) TerrainMap *terrainTiles;
@property (nonatomic, strong, readonly) NSArray *characters;

@end

typedef enum {
    LevelPreset_Rivers,
    LevelPreset_Plains
} LevelPreset;

@interface WorldLevel (TestLevel)

+ (WorldLevel *)levelWithDimensions:(CGSize)dimensions numPlayers:(int)numPlayers numEnemies:(int)numEnemies levelPreset:(LevelPreset)levelPreset;

@end