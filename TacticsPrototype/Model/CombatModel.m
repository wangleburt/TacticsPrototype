//
//  CombatModel.m
//  TacticsPrototype
//
//  Created by Chris Meill on 6/30/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import "CombatModel.h"
#import "CombatPreview.h"

#import "Character.h"

@implementation CombatModel

+ (instancetype)combatModelFromPreview:(CombatPreview *)preview withFirstAttacker:(Character *)firstAttacker
{
    CombatModel *model = [[CombatModel alloc] init];
    model.playerCharacter = preview.player;
    model.enemyCharacter = preview.enemy;
    
    Character *secondCharacter = nil;
    AttackPreveiw *firstPreview = nil, *secondPreview = nil;
    if ([firstAttacker isEqual:preview.player]) {
        secondCharacter = preview.enemy;
        firstPreview = preview.playerAttack;
        secondPreview = preview.enemyAttack;
    } else {
        secondCharacter = preview.player;
        firstPreview = preview.enemyAttack;
        secondPreview = preview.playerAttack;
    }
    
    AttackModel* (^attackModel)(Character*, Character*, AttackPreveiw*) = ^AttackModel*(Character *attacker, Character *defender, AttackPreveiw *preview)
    {
        if (!preview) {
            return nil;
        }
        
        AttackModel *attackModel = [[AttackModel alloc] init];
        attackModel.attacker = attacker;
        attackModel.defender = defender;
        int hitChance = arc4random() % 101;
        if (hitChance <= preview.hitChance) {
            int critChance = arc4random() % 101;
            if (critChance <= preview.critChance) {
                attackModel.roll = AttackRoll_Crit;
                attackModel.damage = preview.damage * 2;
            } else {
                attackModel.roll = AttackRoll_Hit;
                attackModel.damage = preview.damage;
            }
        } else {
            attackModel.roll = AttackRoll_Miss;
            attackModel.damage = 0;
        }
        attackModel.isKill = NO;
        return attackModel;
    };
    
    NSMutableArray *attacks = [NSMutableArray array];
    AttackModel *firstAttack = attackModel(firstAttacker, secondCharacter, firstPreview);
    [attacks addObject:firstAttack];
    
    if (secondCharacter.health > firstAttack.damage) {
        AttackModel *secondAttack = attackModel(secondCharacter, firstAttacker, secondPreview);
        if (secondAttack) {
            if (firstAttacker.health <= secondAttack.damage) {
                secondAttack.isKill = YES;
            }
            [attacks addObject:secondAttack];
        }
        
    } else {
        firstAttack.isKill = YES;
    }
    
    model.attacks = attacks;
    return model;
}

@end

@implementation AttackModel
@end
