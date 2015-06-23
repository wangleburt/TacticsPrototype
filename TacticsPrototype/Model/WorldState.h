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
@class GridOverlayDisplay;

@interface WorldState : NSObject

@property (nonatomic) BOOL gridLinesEnabled;
@property (nonatomic) BOOL gridCoordsEnabled;
@property (nonatomic) CGSize gridDimensions;

- (instancetype)initWithLevel:(WorldLevel *)level;

- (GridOverlayDisplay *)currentGridOverlayDisplay;

@end
