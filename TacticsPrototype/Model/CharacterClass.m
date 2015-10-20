//
//  CharacterClass.m
//  TacticsPrototype
//
//  Created by Chris Meill on 6/23/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import "CharacterClass.h"

@interface CharacterClass ()

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *idleImageFileName;
@property (nonatomic, strong) NSString *headImageFileName;

@property (nonatomic) NSUInteger movement;

@property (nonatomic) AttackType attackType;
@property (nonatomic) int attackRangeMin;
@property (nonatomic) int attackRangeMax;

@property (nonatomic) float baseDamage;
@property (nonatomic) float baseDamagePerLevel;

@property (nonatomic) float atkPerLevel;
@property (nonatomic) float strPerAtk;
@property (nonatomic) float magicPerAtk;
@property (nonatomic) float critDmgPerAtk;
@property (nonatomic) float critDmgBase;

@property (nonatomic) float defPerLevel;
@property (nonatomic) float armorPerDef;
@property (nonatomic) float resPerDef;
@property (nonatomic) float maxHpPerDef;

@property (nonatomic) float skillPerLevel;
@property (nonatomic) float accPerSkill;
@property (nonatomic) float dodgePerSkill;
@property (nonatomic) float critChancePerSkill;
@property (nonatomic) float critChanceBase;

@end

@implementation CharacterClass

+ (void)initializeContentIntoManager:(id<MutableContentManager>)contentManager
{
    [contentManager setContent:[self soldier]   forKey:@"class_soldier"];
    [contentManager setContent:[self archer]    forKey:@"class_archer"];
    [contentManager setContent:[self mage]      forKey:@"class_mage"];
    [contentManager setContent:[self thief]     forKey:@"class_thief"];

    [contentManager setContent:[self grunt]     forKey:@"class_grunt"];
    [contentManager setContent:[self goblin]    forKey:@"class_goblin"];
    [contentManager setContent:[self shaman]    forKey:@"class_shaman"];
    [contentManager setContent:[self rogue]     forKey:@"class_rogue"];
}

//----------------------------------------------------------------------------

+ (CharacterClass *)soldier
{
    CharacterClass *dude = [[CharacterClass alloc] init];
    dude.movement = 3;
    dude.name = @"Soldier";
    dude.idleImageFileName = @"soldier-idle";
    dude.headImageFileName = @"soldier-head";

    dude.attackType = AttackType_Physical;
    dude.attackRangeMin = 1;
    dude.attackRangeMax = 1;
    
    dude.baseDamage = 4;
    dude.baseDamagePerLevel = 0.25;
    
    dude.atkPerLevel = 1;
    dude.defPerLevel = 1;
    dude.skillPerLevel = 1;
    
    dude.strPerAtk = 1;
    dude.magicPerAtk = 0;
    dude.critDmgPerAtk = 0;
    dude.critDmgBase = 2;
    dude.armorPerDef = 1;
    dude.resPerDef = 0.8;
    dude.maxHpPerDef = 0.75;
    dude.accPerSkill = 1;
    dude.dodgePerSkill = 1;
    dude.critChancePerSkill = 0.17;
    dude.critChanceBase = 0;
    
    return dude;
}

+ (CharacterClass *)archer
{
    CharacterClass *dude = [[CharacterClass alloc] init];
    dude.movement = 4;
    dude.name = @"Archer";
    dude.idleImageFileName = @"archer-idle";
    dude.headImageFileName = @"archer-head";

    dude.attackType = AttackType_Physical;
    dude.attackRangeMin = 2;
    dude.attackRangeMax = 2;
    
    dude.baseDamage = 4;
    dude.baseDamagePerLevel = 0.25;
    
    dude.atkPerLevel = 1;
    dude.defPerLevel = 0.75;
    dude.skillPerLevel = 1.25;
    
    dude.strPerAtk = 0.9;
    dude.magicPerAtk = 0;
    dude.critDmgPerAtk = 0;
    dude.critDmgBase = 2;
    dude.armorPerDef = .96;
    dude.resPerDef = 0.96;
    dude.maxHpPerDef = 0.68;
    dude.accPerSkill = 1.06;
    dude.dodgePerSkill = 1;
    dude.critChancePerSkill = 0.143;
    dude.critChanceBase = 0;
    
    return dude;
}

+ (CharacterClass *)mage
{
    CharacterClass *dude = [[CharacterClass alloc] init];
    dude.movement = 3;
    dude.name = @"Mage";
    dude.idleImageFileName = @"mage-idle";
    dude.headImageFileName = @"mage-head";

    dude.attackType = AttackType_Magical;
    dude.attackRangeMin = 1;
    dude.attackRangeMax = 2;
    
    dude.baseDamage = 4;
    dude.baseDamagePerLevel = 0.25;
    
    dude.atkPerLevel = 1;
    dude.defPerLevel = 1;
    dude.skillPerLevel = 1;
    
    dude.strPerAtk = 0;
    dude.magicPerAtk = 1;
    dude.critDmgPerAtk = 0;
    dude.critDmgBase = 2;
    dude.armorPerDef = 0.7;
    dude.resPerDef = 1.2;
    dude.maxHpPerDef = 0.6;
    dude.accPerSkill = 1;
    dude.dodgePerSkill = 1.17;
    dude.critChancePerSkill = 0.17;
    dude.critChanceBase = 0;
    
    return dude;
}

+ (CharacterClass *)thief
{
    CharacterClass *dude = [[CharacterClass alloc] init];
    dude.movement = 4;
    dude.name = @"Thief";
    dude.idleImageFileName = @"thief-idle";
    dude.headImageFileName = @"thief-head";

    dude.attackType = AttackType_Physical;
    dude.attackRangeMin = 1;
    dude.attackRangeMax = 1;
    
    dude.baseDamage = 4;
    dude.baseDamagePerLevel = 0.25;
    
    dude.atkPerLevel = 1.25;
    dude.defPerLevel = 0.75;
    dude.skillPerLevel = 1.25;
    
    dude.strPerAtk = .6;
    dude.magicPerAtk = 0;
    dude.critDmgBase = 2.5;
    dude.critDmgPerAtk = 0.0143;
    dude.armorPerDef = .96;
    dude.resPerDef = 0.96;
    dude.maxHpPerDef = 0.72;
    dude.accPerSkill = 1.286;
    dude.dodgePerSkill = 1.286;
    dude.critChancePerSkill = 0.15;
    dude.critChanceBase = 15;

    return dude;
}

//----------------------------------------------------------------------------

+ (CharacterClass *)grunt
{
    CharacterClass *dude = [[CharacterClass alloc] init];
    dude.movement = 3;
    dude.name = @"Grunt";
    dude.idleImageFileName = @"grunt-idle";
    dude.headImageFileName = @"grunt-head";

    dude.attackType = AttackType_Physical;
    dude.attackRangeMin = 1;
    dude.attackRangeMax = 1;
    
    dude.baseDamage = 4;
    dude.baseDamagePerLevel = 0.25;
    
    dude.atkPerLevel = 1;
    dude.defPerLevel = 1;
    dude.skillPerLevel = 1;
    
    dude.strPerAtk = 1;
    dude.magicPerAtk = 0;
    dude.critDmgPerAtk = 0;
    dude.critDmgBase = 2;
    dude.armorPerDef = 1;
    dude.resPerDef = 0.8;
    dude.maxHpPerDef = 0.75;
    dude.accPerSkill = 1;
    dude.dodgePerSkill = 1;
    dude.critChancePerSkill = 0.17;
    dude.critChanceBase = 0;
    
    return dude;
}

+ (CharacterClass *)goblin
{
    CharacterClass *dude = [[CharacterClass alloc] init];
    dude.movement = 3;
    dude.name = @"Goblin";
    dude.idleImageFileName = @"goblin-idle";
    dude.headImageFileName = @"goblin-head";

    dude.attackType = AttackType_Physical;
    dude.attackRangeMin = 2;
    dude.attackRangeMax = 2;
    
    dude.baseDamage = 4;
    dude.baseDamagePerLevel = 0.25;
    
    dude.atkPerLevel = 1;
    dude.defPerLevel = 0.75;
    dude.skillPerLevel = 1.25;
    
    dude.strPerAtk = 0.9;
    dude.magicPerAtk = 0;
    dude.critDmgPerAtk = 0;
    dude.critDmgBase = 2;
    dude.armorPerDef = .96;
    dude.resPerDef = 0.96;
    dude.maxHpPerDef = 0.68;
    dude.accPerSkill = 1.06;
    dude.dodgePerSkill = 1;
    dude.critChancePerSkill = 0.143;
    dude.critChanceBase = 0;
    
    return dude;
}

+ (CharacterClass *)shaman
{
    CharacterClass *dude = [[CharacterClass alloc] init];
    dude.movement = 3;
    dude.name = @"Shaman";
    dude.idleImageFileName = @"shaman-idle";
    dude.headImageFileName = @"shaman-head";

    dude.attackType = AttackType_Magical;
    dude.attackRangeMin = 1;
    dude.attackRangeMax = 2;
    
    dude.baseDamage = 4;
    dude.baseDamagePerLevel = 0.25;
    
    dude.atkPerLevel = 1;
    dude.defPerLevel = 1;
    dude.skillPerLevel = 1;
    
    dude.strPerAtk = 0;
    dude.magicPerAtk = 1;
    dude.critDmgPerAtk = 0;
    dude.critDmgBase = 2;
    dude.armorPerDef = 0.7;
    dude.resPerDef = 1.2;
    dude.maxHpPerDef = 0.6;
    dude.accPerSkill = 1;
    dude.dodgePerSkill = 1.17;
    dude.critChancePerSkill = 0.17;
    dude.critChanceBase = 0;
    
    return dude;
}

+ (CharacterClass *)rogue
{
    CharacterClass *dude = [[CharacterClass alloc] init];
    dude.movement = 4;
    dude.name = @"Rogue";
    dude.idleImageFileName = @"rogue-idle";
    dude.headImageFileName = @"rogue-head";

    dude.attackType = AttackType_Physical;
    dude.attackRangeMin = 1;
    dude.attackRangeMax = 1;
    
    dude.baseDamage = 4;
    dude.baseDamagePerLevel = 0.25;
    
    dude.atkPerLevel = 1.25;
    dude.defPerLevel = 0.75;
    dude.skillPerLevel = 1.25;
    
    dude.strPerAtk = .6;
    dude.magicPerAtk = 0;
    dude.critDmgBase = 2.5;
    dude.critDmgPerAtk = 0.0143;
    dude.armorPerDef = .96;
    dude.resPerDef = 0.96;
    dude.maxHpPerDef = 0.72;
    dude.accPerSkill = 1.286;
    dude.dodgePerSkill = 1.286;
    dude.critChancePerSkill = 0.15;
    dude.critChanceBase = 15;

    return dude;
}

@end
