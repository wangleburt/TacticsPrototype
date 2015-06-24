//
//  GridOverlayDisplay.h
//  TacticsPrototype
//
//  Created by Chris Meill on 6/22/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>

@interface GridOverlayTileDisplay : NSObject

@property (nonatomic) CGFloat *gradientColors;

+ (GridOverlayTileDisplay *)emptyTile;
+ (GridOverlayTileDisplay *)blueTile;
+ (GridOverlayTileDisplay *)redTile;

@end

@interface GridOverlayDisplayArray : NSObject

- (GridOverlayTileDisplay *)objectAtIndexedSubscript:(NSUInteger)index;
- (void)setObject:(GridOverlayTileDisplay *)object atIndexedSubscript:(NSUInteger)index;

@end

@class WorldState;

@interface GridOverlayDisplay : NSObject

@property (nonatomic, readonly) BOOL showGridLines;
@property (nonatomic, readonly) BOOL showCoordinates;

@property (nonatomic, readonly) CGPoint selectionPosition;

- (instancetype)initWithWorldState:(WorldState *)worldState;

- (GridOverlayDisplayArray *)objectAtIndexedSubscript:(NSUInteger)index;

@end

extern CGPoint const kNoSelectionPosition;
