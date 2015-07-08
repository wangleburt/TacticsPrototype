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

@property (nonatomic) int attackRangeMin;
@property (nonatomic) int attackRangeMax;

@property (nonatomic) float atkPerLevel;
@property (nonatomic) float strPerAtk;
@property (nonatomic) float magicPerAtk;
@property (nonatomic) float critDmgPerAtk;

@property (nonatomic) float defPerLevel;
@property (nonatomic) float armorPerDef;
@property (nonatomic) float resPerDef;
@property (nonatomic) float maxHpPerDef;

@property (nonatomic) float skillPerLevel;
@property (nonatomic) float accPerSkill;
@property (nonatomic) float dodgePerSkill;
@property (nonatomic) float critChancePerSkill;

@end

@implementation CharacterClass

+ (void)initializeContentIntoManager:(id<MutableContentManager>)contentManager
{
    [contentManager setContent:[self footman]   forKey:@"class_footman"];
    [contentManager setContent:[self archer]    forKey:@"class_archer"];
    [contentManager setContent:[self mage]      forKey:@"class_mage"];
    [contentManager setContent:[self ninja]     forKey:@"class_ninja"];

    [contentManager setContent:[self grunt]     forKey:@"class_grunt"];
    [contentManager setContent:[self goblin]    forKey:@"class_goblin"];
    [contentManager setContent:[self shaman]    forKey:@"class_shaman"];
}

//----------------------------------------------------------------------------

+ (CharacterClass *)footman
{
    CharacterClass *footman = [[CharacterClass alloc] init];
    footman.movement = 3;
    footman.name = @"Soldier";
    footman.idleImageFileName = @"footman-idle";
    footman.headImageFileName = @"footman-head";
    footman.attackRangeMin = 1;
    footman.attackRangeMax = 1;
    
    footman.atkPerLevel = 1;
    footman.defPerLevel = 1;
    footman.skillPerLevel = 1;
    
    footman.strPerAtk = 1;
    footman.magicPerAtk = 0;
    footman.critDmgPerAtk = 2;
    footman.armorPerDef = 0.8;
    footman.resPerDef = 0.4;
    footman.maxHpPerDef = 0.75;
    footman.accPerSkill = 1;
    footman.dodgePerSkill = 1;
    footman.critChancePerSkill = 0.2;
    
    return footman;
}

+ (CharacterClass *)archer
{
    CharacterClass *archer = [[CharacterClass alloc] init];
    archer.movement = 4;
    archer.name = @"Archer";
    archer.idleImageFileName = @"archer-idle";
    archer.headImageFileName = @"archer-head";
    archer.attackRangeMin = 2;
    archer.attackRangeMax = 2;
    
    archer.atkPerLevel = 1;
    archer.defPerLevel = 0.75;
    archer.skillPerLevel = 1.25;
    
    archer.strPerAtk = 1.1;
    archer.magicPerAtk = 0;
    archer.critDmgPerAtk = 2;
    archer.armorPerDef = 0.8;
    archer.resPerDef = 0.5;
    archer.maxHpPerDef = 0.6;
    archer.accPerSkill = 1.2;
    archer.dodgePerSkill = 1;
    archer.critChancePerSkill = 0.2;
    
    return archer;
}

+ (CharacterClass *)mage
{
    CharacterClass *mage = [[CharacterClass alloc] init];
    mage.movement = 3;
    mage.name = @"Mage";
    mage.idleImageFileName = @"mage-idle";
    mage.headImageFileName = @"mage-head";
    mage.attackRangeMin = 1;
    mage.attackRangeMax = 2;
    
    mage.atkPerLevel = 1;
    mage.defPerLevel = 0.5;
    mage.skillPerLevel = 1.25;
    
    mage.strPerAtk = 0;
    mage.magicPerAtk = 0.9;
    mage.critDmgPerAtk = 2;
    mage.armorPerDef = 0.5;
    mage.resPerDef = 1.25;
    mage.maxHpPerDef = 0.9;
    mage.accPerSkill = 1.2;
    mage.dodgePerSkill = 0.85;
    mage.critChancePerSkill = 0.2;
    
    return mage;
}

+ (CharacterClass *)ninja
{
    CharacterClass *ninja = [[CharacterClass alloc] init];
    ninja.movement = 4;
    ninja.name = @"Ninja";
    ninja.idleImageFileName = @"ninja-idle";
    ninja.headImageFileName = @"ninja-head";
    ninja.attackRangeMin = 1;
    ninja.attackRangeMax = 1;
    
    ninja.atkPerLevel = 1.25;
    ninja.defPerLevel = 0.75;
    ninja.skillPerLevel = 1.25;
    
    ninja.strPerAtk = .8;
    ninja.magicPerAtk = 0;
    ninja.critDmgPerAtk = 2.85;
    ninja.armorPerDef = 0.6;
    ninja.resPerDef = 0.6;
    ninja.maxHpPerDef = 0.6;
    ninja.accPerSkill = 1.6;
    ninja.dodgePerSkill = 2;
    ninja.critChancePerSkill = 0.58;

    return ninja;
}

//----------------------------------------------------------------------------

+ (CharacterClass *)grunt
{
    CharacterClass *grunt = [[CharacterClass alloc] init];
    grunt.movement = 3;
    grunt.name = @"Grunt";
    grunt.idleImageFileName = @"grunt-idle";
    grunt.headImageFileName = @"grunt-head";
    grunt.attackRangeMin = 1;
    grunt.attackRangeMax = 1;
    
    grunt.atkPerLevel = 1;
    grunt.defPerLevel = 1;
    grunt.skillPerLevel = 1;
    
    grunt.strPerAtk = 1;
    grunt.magicPerAtk = 0;
    grunt.critDmgPerAtk = 2;
    grunt.armorPerDef = 0.8;
    grunt.resPerDef = 0.4;
    grunt.maxHpPerDef = 0.75;
    grunt.accPerSkill = 1;
    grunt.dodgePerSkill = 1;
    grunt.critChancePerSkill = 0.2;
    
    return grunt;
}

+ (CharacterClass *)goblin
{
    CharacterClass *goblin = [[CharacterClass alloc] init];
    goblin.movement = 3;
    goblin.name = @"Goblin";
    goblin.idleImageFileName = @"goblin-idle";
    goblin.headImageFileName = @"goblin-head";
    goblin.attackRangeMin = 2;
    goblin.attackRangeMax = 2;
    
    goblin.atkPerLevel = 1;
    goblin.defPerLevel = 0.75;
    goblin.skillPerLevel = 1.25;
    
    goblin.strPerAtk = 1.1;
    goblin.magicPerAtk = 0;
    goblin.critDmgPerAtk = 2;
    goblin.armorPerDef = 0.8;
    goblin.resPerDef = 0.5;
    goblin.maxHpPerDef = 0.6;
    goblin.accPerSkill = 1.2;
    goblin.dodgePerSkill = 1;
    goblin.critChancePerSkill = 0.2;
    
    return goblin;
}

+ (CharacterClass *)shaman
{
    CharacterClass *shaman = [[CharacterClass alloc] init];
    shaman.movement = 3;
    shaman.name = @"Shaman";
    shaman.idleImageFileName = @"shaman-idle";
    shaman.headImageFileName = @"shaman-head";
    shaman.attackRangeMin = 1;
    shaman.attackRangeMax = 2;
    
    shaman.atkPerLevel = 1;
    shaman.defPerLevel = 0.5;
    shaman.skillPerLevel = 1.25;
    
    shaman.strPerAtk = 0;
    shaman.magicPerAtk = 0.9;
    shaman.critDmgPerAtk = 2;
    shaman.armorPerDef = 0.5;
    shaman.resPerDef = 1.25;
    shaman.maxHpPerDef = 0.9;
    shaman.accPerSkill = 1.2;
    shaman.dodgePerSkill = 0.85;
    shaman.critChancePerSkill = 0.2;
    
    return shaman;
}

@end
