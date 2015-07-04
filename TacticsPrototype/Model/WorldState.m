//
//  WorldState.m
//  TacticsPrototype
//
//  Created by Chris Meill on 6/22/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import "WorldState.h"
#import "WorldLevel.h"
#import "TerrainMap.h"

#import "GridOverlayDisplay.h"

#import "WorldObject.h"
#import "Character.h"
#import "CharacterClass.h"
#import "CharacterWorldOptions.h"
#import "CombatModel.h"

@interface WorldState ()

@property (nonatomic, strong) WorldLevel *level;

@property (nonatomic, strong) NSMutableArray *playerCharacters;
@property (nonatomic, strong) NSMutableArray *enemyCharacters;

@end

@implementation WorldState

- (instancetype)initWithLevel:(WorldLevel *)level
{
    self = [super init];
    if (self) {
        self.level = level;
        
        self.playerCharacters = [NSMutableArray array];
        self.enemyCharacters = [NSMutableArray array];
        [self instantiateCharacterPrototypes];
    }
    return self;
}

//-------------------------------------------------------------------------------------
#pragma mark - World Objects

- (NSArray *)worldObjects
{
    NSMutableArray *worldObjects = [NSMutableArray array];
    [worldObjects addObjectsFromArray:self.playerCharacters];
    [worldObjects addObjectsFromArray:self.enemyCharacters];
    return worldObjects;
}

- (void)instantiateCharacterPrototypes
{
    for (Character *dude in self.level.characters) {
        if (dude.team == CharacterTeam_Player) {
            [self.playerCharacters addObject:dude];
        } else if (dude.team == CharacterTeam_Enemy) {
            [self.enemyCharacters addObject:dude];
        }
        dude.health = dude.characterClass.maxHealth;
    }
}

- (WorldObject *)objectAtPosition:(WorldPoint)position
{
    NSArray *objects = self.worldObjects;
    for (WorldObject *object in objects) {
        if (WorldPointEqualToPoint(object.position, position)) {
            return object;
        }
    }
    return nil;
}

- (void)startPlayerTurn
{
    for (Character *dude in self.playerCharacters) {
        dude.movesRemaining = dude.characterClass.movement;
        dude.isActive = YES;
    }
    for (Character *dude in self.enemyCharacters) {
        dude.movesRemaining = dude.characterClass.movement;
        dude.isActive = NO;
    }
}

- (void)applyCombat:(CombatModel *)combatModel
{
    for (AttackModel *attack in combatModel.attacks) {
        attack.defender.health = MAX(attack.defender.health - attack.damage, 0);
        if (attack.defender.health <= 0) {
            [self removeWorldObject:attack.defender];
        }
    }
    
    AttackModel *firstAttack = [combatModel.attacks firstObject];
    firstAttack.attacker.isActive = NO;
    firstAttack.attacker.movesRemaining = 0;
}

- (void)removeWorldObject:(WorldObject *)worldObject
{
    if ([self.playerCharacters containsObject:worldObject]) {
        [self.playerCharacters removeObject:worldObject];
    } else if ([self.enemyCharacters containsObject:worldObject]) {
        [self.enemyCharacters removeObject:worldObject];
    }
}

//-------------------------------------------------------------------------------------
#pragma mark - Grid

- (GridOverlayDisplay *)currentGridOverlayDisplay
{
    GridOverlayDisplay *display = [[GridOverlayDisplay alloc] initWithWorldState:self];
    if (self.characterWorldOptions) {
        for (CharacterMovementOption *option in self.characterWorldOptions.moveOptions) {
            if (self.characterWorldOptions.character.team == CharacterTeam_Player) {
                display[option.position.x][option.position.y] = [GridOverlayTileDisplay blueTile];
            } else {
                display[option.position.x][option.position.y] = [GridOverlayTileDisplay darkBlueTile];
            }
        }
        for (CharacterAttackOption *option in self.characterWorldOptions.attackOptions) {
            if (self.characterWorldOptions.character.team == CharacterTeam_Player) {
                display[option.position.x][option.position.y] = [GridOverlayTileDisplay redTile];
            } else {
                display[option.position.x][option.position.y] = [GridOverlayTileDisplay darkRedTile];
            }
        }
    }
    
    return display;
}

- (CGSize)gridDimensions
{
    return self.level.levelSize;
}

@end
