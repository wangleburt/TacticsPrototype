//
//  CharacterClass.h
//  TacticsPrototype
//
//  Created by Chris Meill on 6/23/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import "WorldContent.h"

@interface CharacterClass : WorldContent

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *idleImageFileName;
@property (nonatomic, strong, readonly) NSString *headImageFileName;

@property (nonatomic, readonly) NSUInteger movement;

@property (nonatomic, readonly) int attackRangeMin;
@property (nonatomic, readonly) int attackRangeMax;

// stats
@property (nonatomic, readonly) float atkPerLevel;
@property (nonatomic, readonly) float strPerAtk;
@property (nonatomic, readonly) float magicPerAtk;
@property (nonatomic, readonly) float critDmgPerAtk;

@property (nonatomic, readonly) float defPerLevel;
@property (nonatomic, readonly) float armorPerDef;
@property (nonatomic, readonly) float resPerDef;
@property (nonatomic, readonly) float maxHpPerDef;

@property (nonatomic, readonly) float skillPerLevel;
@property (nonatomic, readonly) float accPerSkill;
@property (nonatomic, readonly) float dodgePerSkill;
@property (nonatomic, readonly) float critChancePerSkill;

@end
