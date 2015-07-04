//
//  CombatPreview.h
//  TacticsPrototype
//
//  Created by Chris Meill on 6/29/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Character;

@interface AttackPreveiw : NSObject

@property (nonatomic) int damage;
@property (nonatomic) int hitChance;
@property (nonatomic) int critChance;

@end

@interface CombatPreview : NSObject

@property (nonatomic, strong, readonly) Character *player;
@property (nonatomic, strong, readonly) Character *enemy;

@property (nonatomic, strong, readonly) AttackPreveiw *playerAttack;
@property (nonatomic, strong, readonly) AttackPreveiw *enemyAttack;

- (instancetype)initWithPlayer:(Character *)player andEnemy:(Character *)enemy range:(int)range;

@end
