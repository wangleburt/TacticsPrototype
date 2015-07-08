//
//  CombatPreview.m
//  TacticsPrototype
//
//  Created by Chris Meill on 6/29/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import "CombatPreview.h"
#import "Character.h"
#import "CharacterClass.h"
#import "CharacterStats.h"
#import "Weapon.h"
#import "WeaponElement.h"

@interface CombatPreview ()

@property (nonatomic, strong) Character *player;
@property (nonatomic, strong) Character *enemy;

@property (nonatomic, strong) AttackPreveiw *playerAttack;
@property (nonatomic, strong) AttackPreveiw *enemyAttack;

@end

@implementation CombatPreview

- (instancetype)initWithPlayer:(Character *)player andEnemy:(Character *)enemy range:(int)range
{
    self = [super init];
    if (self) {
        self.player = player;
        self.enemy = enemy;
        
        self.playerAttack = [self attackWithAttacker:player defender:enemy range:range];
        self.enemyAttack = [self attackWithAttacker:enemy defender:player range:range];
    }
    return self;
}

- (AttackPreveiw *)attackWithAttacker:(Character *)attacker defender:(Character *)defender range:(int)range
{
    if (range < attacker.characterClass.attackRangeMin || range > attacker.characterClass.attackRangeMax) {
        return nil;
    }
    
    AttackPreveiw *attack = [[AttackPreveiw alloc] init];
    
    int pDmg = MAX(0, attacker.stats.str - defender.stats.armor);
    int mDmg = MAX(0, attacker.stats.magic - defender.stats.res);
    int damage = pDmg + mDmg;
    
    int baseHit = 70 + attacker.stats.acc - defender.stats.dodge;

    ElementComparison comp = [attacker.weapon.element compareAgainstElement:defender.weapon.element];
    if (comp == ElementComparison_Advantage) {
        attack.damage = MAX(3, damage * 1.5);
        attack.hitChance = MAX(0, MIN(100, baseHit * 1.5));
    } else if (comp == ElementComparison_Disadvantage) {
        attack.damage = damage * 0.6;
        attack.hitChance = MAX(0, MIN(100, baseHit * 0.6));
    } else {
        attack.damage = damage;
        attack.hitChance = MAX(0, MIN(100, baseHit));
    }
    
    attack.critChance = attacker.stats.critChance;
    
    return attack;
}

@end

@implementation AttackPreveiw
@end
