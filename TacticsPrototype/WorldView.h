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
@class WorldObject;
@class CombatModel;

@interface WorldView : UIView

- (instancetype)initWithLevel:(WorldLevel *)level;
- (void)loadSpritesFromState:(WorldState *)state;

- (WorldPoint)gridPositionForTouchLocatoin:(CGPoint)touchLocation;
- (void)updateGridForState:(WorldState *)state;
- (void)updateDisplayPositionForWorldObject:(WorldObject *)object;
- (void)updateSpriteForObject:(WorldObject *)object active:(BOOL)isActive;

- (CGRect)visibleRectForMovementPath:(NSArray *)path;
- (void)animateMovementPath:(NSArray *)path forObject:(WorldObject *)object completion:(void (^)())completionBlock;
- (void)animateMovementPath:(NSArray *)movementPath withAnnotationPath:(NSArray *)annotationPath forObject:(WorldObject *)object completion:(void (^)())completionBlock;

- (void)animateCombat:(CombatModel *)combatModel completion:(void (^)(CombatModel *))completionBlock;

@end
