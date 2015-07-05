//
//  EnemyAI.h
//  TacticsPrototype
//
//  Created by Chris Meill on 7/4/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WorldState;
@class Character;
@class CharacterAttackOption;
@class CharacterMovementOption;

@interface EnemyAction : NSObject

@property (nonatomic, strong) Character *character;
@property (nonatomic, strong) CharacterAttackOption *attack;
@property (nonatomic, strong) CharacterMovementOption *move;

@end

@interface EnemyAI : NSObject

- (instancetype)initWithCharacters:(NSArray *)characters worldState:(WorldState *)worldState;

- (EnemyAction *)nextAction;

@end
