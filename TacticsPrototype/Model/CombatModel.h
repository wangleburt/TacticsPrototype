//
//  CombatModel.h
//  TacticsPrototype
//
//  Created by Chris Meill on 6/30/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Character;
@class CombatPreview;

typedef enum {
    AttackRoll_Hit,
    AttackRoll_Crit,
    AttackRoll_Miss
} AttackRoll;

@interface AttackModel : NSObject

@property (nonatomic, strong) Character *attacker;
@property (nonatomic, strong) Character *defender;

@property (nonatomic) AttackRoll roll;
@property (nonatomic) int damage;
@property (nonatomic) BOOL isKill;

@end

@interface CombatModel : NSObject

@property (nonatomic, strong) Character *playerCharacter;
@property (nonatomic, strong) Character *enemyCharacter;

@property (nonatomic, strong) NSArray *attacks;

+ (instancetype)combatModelFromPreview:(CombatPreview *)preview withFirstAttacker:(Character *)firstAttacker;

@end
