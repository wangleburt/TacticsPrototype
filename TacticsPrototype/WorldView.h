//
//  WorldView.h
//  TacticsPrototype
//
//  Created by Chris Meill on 6/22/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorldPoint.h"

@class WorldLevel;
@class WorldState;

@interface WorldView : UIView

- (instancetype)initWithLevel:(WorldLevel *)level;
- (void)loadSpritesFromState:(WorldState *)state;

- (void)updateGridForState:(WorldState *)state;

- (WorldPoint)gridPositionForTouchLocatoin:(CGPoint)touchLocation;

@end
