//
//  WorldState.h
//  TacticsPrototype
//
//  Created by Chris Meill on 6/22/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>
#import "WorldPoint.h"

@class WorldLevel;
@class WorldObject;
@class GridOverlayDisplay;
@class CharacterWorldOptions;

@interface WorldState : NSObject

@property (nonatomic, strong, readonly) WorldLevel *level;

@property (nonatomic) BOOL gridLinesEnabled;
@property (nonatomic) BOOL gridCoordsEnabled;
@property (nonatomic) CGSize gridDimensions;

@property (nonatomic, readonly) NSArray *worldObjects;
@property (nonatomic, strong) WorldObject *selectedObject;

@property (nonatomic, strong) CharacterWorldOptions *characterWorldOptions;

- (instancetype)initWithLevel:(WorldLevel *)level;

- (void)startPlayerTurn;

- (GridOverlayDisplay *)currentGridOverlayDisplay;
- (WorldObject *)objectAtPosition:(WorldPoint)position;

@end
