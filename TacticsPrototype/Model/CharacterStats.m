//
//  CharacterStats.m
//  TacticsPrototype
//
//  Created by Chris Meill on 7/7/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import "CharacterStats.h"
#import "CharacterClass.h"

@interface CharacterStats ()

@property (nonatomic) int atk;
@property (nonatomic) int str;
@property (nonatomic) int magic;
@property (nonatomic) float critDmg;

@property (nonatomic) int def;
@property (nonatomic) int armor;
@property (nonatomic) int res;
@property (nonatomic) int maxHp;

@property (nonatomic) int skill;
@property (nonatomic) int acc;
@property (nonatomic) int dodge;
@property (nonatomic) int critChance;

@property (nonatomic) float baseDamage;

@end

@implementation CharacterStats

- (instancetype)initWithAtk:(float)atk def:(float)def skill:(float)skill
{
    self = [super init];
    if (self) {
        self.atk = atk;
        self.def = def;
        self.skill = skill;
    }
    return self;
}

- (void)updateWithClass:(CharacterClass *)characterClass
{
    self.str = self.atk*characterClass.strPerAtk;
    self.magic = self.atk*characterClass.magicPerAtk;
    self.critDmg = self.atk*characterClass.critDmgPerAtk + characterClass.critDmgBase;
    
    self.armor = self.def*characterClass.armorPerDef;
    self.res = self.def*characterClass.resPerDef;
    self.maxHp = self.def*characterClass.maxHpPerDef;
    
    self.acc = self.skill*characterClass.accPerSkill;
    self.dodge = self.skill*characterClass.dodgePerSkill;
    self.critChance = self.skill*characterClass.critChancePerSkill + characterClass.critChanceBase;
}

@end
