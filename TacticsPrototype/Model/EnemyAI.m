//
//  EnemyAI.m
//  TacticsPrototype
//
//  Created by Chris Meill on 7/4/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import "EnemyAI.h"

#import "WorldState.h"
#import "WorldLevel.h"
#import "TerrainMap.h"

#import "Character.h"
#import "CharacterWorldOptions.h"

@interface EnemyAI ()

@property (nonatomic, strong) WorldState *worldState;
@property (nonatomic, strong) NSMutableArray *characterOrder;

@end

@interface PathfinderHelper : NSObject

@property (nonatomic) int pathLength;
@property (nonatomic) WorldPoint position;
@property (nonatomic) int heuristicValue;

@property (nonatomic, strong) CharacterMovementOption *baseMovement;

@end

@implementation EnemyAI

- (instancetype)initWithCharacters:(NSArray *)characters worldState:(WorldState *)worldState
{
    self = [super init];
    if (self) {
        self.worldState = worldState;
        self.characterOrder = [self arrangeCharacters:characters];
    }
    return self;
}

//-------------------------------------------------------------------------------------
#pragma mark - Character Order

- (NSMutableArray *)arrangeCharacters:(NSArray *)characters
{
    NSMutableArray *characterOrder = [NSMutableArray array];
    NSMutableSet *remainingCharacters = [NSMutableSet setWithArray:characters];
    
    if (characters.count == 0) {
        return characterOrder;
    }
    
    Character *last = [self firstCharacterInArray:characters];
    [characterOrder addObject:last];
    [remainingCharacters removeObject:last];
    
    while (characterOrder.count < characters.count) {
        Character *next = nil;
        int nextDistance = INT_MAX;
        for (Character *dude in remainingCharacters) {
            int distance = WorldPointRangeToPoint(dude.position, last.position);
            if (distance < nextDistance) {
                next = dude;
                nextDistance = distance;
            }
        }
        [characterOrder addObject:next];
        [remainingCharacters removeObject:next];
        last = next;
    }
    
    return characterOrder;
}

- (Character *)firstCharacterInArray:(NSArray *)characters
{
    Character *first = nil;
    int firstDistance = INT_MAX;
    
    int (^distanceToPlayers)(Character*) = ^int(Character *dude) {
        int closest = INT_MAX;
        for (Character *player in self.worldState.playerCharacters) {
            closest = MIN(closest, WorldPointRangeToPoint(dude.position, player.position));
        }
        return closest;
    };
    for (Character *dude in characters) {
        int distance = distanceToPlayers(dude);
        if (distance < firstDistance) {
            first = dude;
            firstDistance = distance;
        }
    }
    return first;
}

//-------------------------------------------------------------------------------------
#pragma mark - Choosing Actions

- (EnemyAction *)nextAction
{
    if (self.characterOrder.count == 0) {
        return nil;
    }
    Character *character = [self.characterOrder firstObject];
    [self.characterOrder removeObject:character];
    
    // see if there's anyone in striking distance
    CharacterWorldOptions *options = [[CharacterWorldOptions alloc] initWithCharacter:character worldState:self.worldState];
    CharacterAttackOption *attack = [self bestAttackFromOptions:options];
    if (attack) {
        EnemyAction *action = [[EnemyAction alloc] init];
        action.character = character;
        action.attack = attack;
        action.move = attack.moveOption;
        return action;
    }
    
    // if not, start A*
    CharacterMovementOption *move = [self bestMoveOptionFromOptions:options];
    if (move) {
        EnemyAction *action = [[EnemyAction alloc] init];
        action.character = character;
        action.move = move;
        return action;
    }
    
    // still noting? okay just move to the next guy
    return [self nextAction];
}

- (CharacterAttackOption *)bestAttackFromOptions:(CharacterWorldOptions *)options
{
    NSMutableArray *attacks = [NSMutableArray array];
    for (CharacterAttackOption *attack in options.attackOptions) {
        WorldObject *target = [self.worldState objectAtPosition:attack.position];
        if ([target isKindOfClass:Character.class] &&
            [(Character *)target team] == CharacterTeam_Player)
        {
            [attacks addObject:attack];
        }
    }
    
    if (attacks.count == 0) {
        return nil;
    }
    
    CharacterAttackOption *bestOption = nil;
    int leastHealth = INT_MAX;
    for (CharacterAttackOption *attack in attacks) {
        Character *target = (Character *)[self.worldState objectAtPosition:attack.position];
        if (target.health < leastHealth) {
            bestOption = attack;
            leastHealth = target.health;
        }
    }
    
    return bestOption;
}

- (CharacterMovementOption *)bestMoveOptionFromOptions:(CharacterWorldOptions *)options
{
    NSMutableArray *partialPaths = [NSMutableArray array];
    NSMutableSet *pointsConsidered = [NSMutableSet set];
    
    int (^heuristic)(PathfinderHelper *) = ^int(PathfinderHelper *helper) {
        int closest = INT_MAX;
        for (Character *player in self.worldState.playerCharacters) {
            closest = MIN(closest, WorldPointRangeToPoint(helper.position, player.position));
        }
        return closest + helper.pathLength;
    };
    
    for (CharacterMovementOption *move in options.moveOptions) {
        if (move.path.count == options.character.movesRemaining+1) {
            PathfinderHelper *helper = [[PathfinderHelper alloc] init];
            helper.pathLength = (int)move.path.count;
            helper.baseMovement = move;
            helper.position = move.position;
            helper.heuristicValue = heuristic(helper);
            [partialPaths addObject:helper];
        } else {
            [pointsConsidered addObject:[NSValue valueWithWorldPoint:move.position]];
        }
    }
    
    NSComparisonResult (^prioritySorter)(id, id) = ^NSComparisonResult(id obj1, id obj2) {
        int value1 = [obj1 heuristicValue];
        int value2 = [obj2 heuristicValue];
        if (value1 > value2) {
            return NSOrderedAscending;
        } else if (value1 < value2) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    };
    
    // A* search!
    CharacterMovementOption *bestOption = nil;
    while (!bestOption && partialPaths.count > 0) {
        [partialPaths sortUsingComparator:prioritySorter];
        PathfinderHelper *helper = [partialPaths lastObject];
        [partialPaths removeLastObject];
        
        WorldPoint current = helper.position;
        if ([pointsConsidered containsObject:[NSValue valueWithWorldPoint:current]]) {
            continue;
        } else {
            [pointsConsidered addObject:[NSValue valueWithWorldPoint:current]];
        }
        
        WorldPoint up = (WorldPoint){current.x, current.y-1};
        WorldPoint down = (WorldPoint){current.x, current.y+1};
        WorldPoint left = (WorldPoint){current.x-1, current.y};
        WorldPoint right = (WorldPoint){current.x+1, current.y};
        WorldPoint newPoints[4] = {up, down, left, right};
        for (int i=0; i<4; i++) {
            WorldPoint nextPoint = newPoints[i];
            NSValue *pointValue = [NSValue valueWithWorldPoint:nextPoint];
            TerrainMap *map = self.worldState.level.terrainTiles;
            BOOL blocked = map[nextPoint.x][nextPoint.y].blocked;
            if (![pointsConsidered containsObject:pointValue] && !blocked) {
                WorldObject *object = [self.worldState objectAtPosition:newPoints[i]];
                if ([object isKindOfClass:Character.class] &&
                    [(Character *)object team] == CharacterTeam_Player)
                {
                    bestOption = helper.baseMovement;
                    break;

                } else {
                    PathfinderHelper *nextHelper = [[PathfinderHelper alloc] init];
                    nextHelper.baseMovement = helper.baseMovement;
                    nextHelper.pathLength = helper.pathLength+1;
                    nextHelper.position = newPoints[i];
                    nextHelper.heuristicValue = heuristic(nextHelper);
                    [partialPaths addObject:nextHelper];
                }
            }
        }
    }
    return bestOption;
}

@end

@implementation EnemyAction
@end

@implementation PathfinderHelper

- (NSString *)description
{
    return [NSString stringWithFormat:@"(%i, %i) - length %i - priority %i", self.position.x, self.position.y, self.pathLength, self.heuristicValue];
}

@end
