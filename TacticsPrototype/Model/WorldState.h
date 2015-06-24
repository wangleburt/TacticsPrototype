//
//  WorldState.h
//  TacticsPrototype
//
//  Created by Chris Meill on 6/22/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>

@class WorldLevel;
@class WorldObject;
@class GridOverlayDisplay;

@interface WorldState : NSObject

@property (nonatomic) BOOL gridLinesEnabled;
@property (nonatomic) BOOL gridCoordsEnabled;
@property (nonatomic) CGSize gridDimensions;

@property (nonatomic, readonly) NSArray *worldObjects;
@property (nonatomic, strong) WorldObject *selectedObject;

- (instancetype)initWithLevel:(WorldLevel *)level;

- (GridOverlayDisplay *)currentGridOverlayDisplay;

- (WorldObject *)objectAtPosition:(CGPoint)position;

@end
