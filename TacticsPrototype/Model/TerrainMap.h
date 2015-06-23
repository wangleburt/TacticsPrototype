//
//  TerrainMap.h
//  TacticsPrototype
//
//  Created by Chris Meill on 6/23/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TerrainTile : NSObject

@property (nonatomic) BOOL blocked;

+ (TerrainTile *)emptyTile;
+ (TerrainTile *)blockedTile;

@end

@interface TerrainTileArray : NSObject

- (TerrainTile *)objectAtIndexedSubscript:(NSUInteger)index;
- (void)setObject:(TerrainTile *)object atIndexedSubscript:(NSUInteger)index;

@end

@interface TerrainMap : NSObject

- (instancetype)initWithDimensions:(CGSize)dimensions;

- (TerrainTileArray *)objectAtIndexedSubscript:(NSUInteger)index;

@end
