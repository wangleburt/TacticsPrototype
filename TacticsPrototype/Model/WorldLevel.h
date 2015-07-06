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
@property (nonatomic, strong, readonly) NSString *mapImageFileName;
@property (nonatomic, strong, readonly) TerrainMap *terrainTiles;
@property (nonatomic, strong, readonly) NSArray *characters;

@end


@interface WorldLevel (TestLevel)

+ (WorldLevel *)testLevel;
+ (WorldLevel *)levelWithDimensions:(CGSize)dimensions numPlayers:(int)numPlayers numEnemies:(int)numEnemies;

@end