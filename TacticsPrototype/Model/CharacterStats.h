//
//  CharacterStats.h
//  TacticsPrototype
//
//  Created by Chris Meill on 7/7/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CharacterClass;

@interface CharacterStats : NSObject

@property (nonatomic, readonly) int atk;
@property (nonatomic, readonly) int str;
@property (nonatomic, readonly) int magic;
@property (nonatomic, readonly) float critDmg;

@property (nonatomic, readonly) int def;
@property (nonatomic, readonly) int armor;
@property (nonatomic, readonly) int res;
@property (nonatomic, readonly) int maxHp;

@property (nonatomic, readonly) int skill;
@property (nonatomic, readonly) int acc;
@property (nonatomic, readonly) int dodge;
@property (nonatomic, readonly) int critChance;

@property (nonatomic, readonly) float baseDamage;

- (instancetype)initWithAtk:(float)atk def:(float)def skill:(float)skill;
- (void)updateWithClass:(CharacterClass *)characterClass;


@end
