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
#import "EnemyAI.h"

@interface WorldState ()

@property (nonatomic, strong) WorldLevel *level;

@property (nonatomic, strong) NSMutableArray *mutablePlayerCharacters;
@property (nonatomic, strong) NSMutableArray *enemyCharacters;

@end

@implementation WorldState

- (instancetype)initWithLevel:(WorldLevel *)level
{
    self = [super init];
    if (self) {
        self.level = level;
        
        self.mutablePlayerCharacters = [NSMutableArray array];
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
    [worldObjects addObjectsFromArray:self.mutablePlayerCharacters];
    [worldObjects addObjectsFromArray:self.enemyCharacters];
    return worldObjects;
}

- (NSArray *)playerCharacters
{
    return self.mutablePlayerCharacters;
}

- (void)instantiateCharacterPrototypes
{
    for (Character *dude in self.level.characters) {
        if (dude.team == CharacterTeam_Player) {
            [self.mutablePlayerCharacters addObject:dude];
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

- (void)setupForNewTurn
{
    for (Character *dude in self.mutablePlayerCharacters) {
        dude.movesRemaining = dude.characterClass.movement;
        dude.isActive = YES;
    }
    for (Character *dude in self.enemyCharacters) {
        dude.movesRemaining = dude.characterClass.movement;
        dude.isActive = YES;
    }
}

- (BOOL)playerHasActiveCharacters
{
    for (Character *dude in self.mutablePlayerCharacters) {
        if (dude.isActive) {
            return YES;
        }
    }
    return NO;
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
    if ([self.mutablePlayerCharacters containsObject:worldObject]) {
        [self.mutablePlayerCharacters removeObject:worldObject];
    } else if ([self.enemyCharacters containsObject:worldObject]) {
        [self.enemyCharacters removeObject:worldObject];
    }
}

- (BOOL)characterHasActionOptions:(Character *)character
{
    if (!character.isActive) {
        return NO;
    }
    
    if (character.movesRemaining > 0) {
        return YES;
    }
    
    // check if character has any attacks from his current position
    WorldPoint center = character.position;
    int minRange = character.characterClass.attackRangeMin;
    int maxRange = character.characterClass.attackRangeMax;
    
    WorldPoint (^clamp)(WorldPoint) = ^WorldPoint(WorldPoint point) {
        WorldPoint result;
        result.x = MAX(0, MIN(self.gridDimensions.width, point.x));
        result.y = MAX(0, MIN(self.gridDimensions.height, point.y));
        return result;
    };
    WorldPoint min = clamp((WorldPoint){center.x-maxRange, center.y-maxRange});
    WorldPoint max = clamp((WorldPoint){center.x+maxRange, center.y+maxRange});
    
    for (int x=min.x; x<=max.x; x++) {
        for (int y=min.y; y<=max.y; y++) {
            WorldPoint target = (WorldPoint){x,y};
            int distance = WorldPointRangeToPoint(center, target);
            if (distance > maxRange || distance < minRange) {
                continue;
            }
            
            WorldObject *object = [self objectAtPosition:target];
            if ([object isKindOfClass:Character.class]) {
                Character *otherCharacter = (Character *)object;
                if (otherCharacter.team != character.team) {
                    return YES;
                }
            }
        }
    }

    return NO;
}

- (EnemyAI *)enemyAiForEnemyTurn
{
    return [[EnemyAI alloc] initWithCharacters:self.enemyCharacters worldState:self];
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

///********** UNCOMMENT TO HIGHLIGHT BLOCKED TILES ************/
//    for (int i=0; i<self.gridDimensions.width; i++) {
//        for (int j=0; j<self.gridDimensions.height; j++) {
//            if (self.level.terrainTiles[i][j].blocked) {
//                display[i][j] = [GridOverlayTileDisplay redTile];
//            }
//        }
//    }
    
    return display;
}

- (CGSize)gridDimensions
{
    return self.level.levelSize;
}

@end
