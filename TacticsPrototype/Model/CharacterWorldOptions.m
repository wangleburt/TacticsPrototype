//
//  CharacterWorldOptions.m
//  TacticsPrototype
//
//  Created by Chris Meill on 6/24/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import "CharacterWorldOptions.h"
#import "Character.h"
#import "CharacterClass.h"

#import "WorldState.h"
#import "WorldLevel.h"
#import "TerrainMap.h"

@interface CharacterWorldOptions ()

@property (nonatomic, strong) Character *character;

@property (nonatomic, strong) NSArray *moveOptions;
@property (nonatomic, strong) NSArray *attackOptions;

@property (nonatomic, strong) NSSet *pointsInMovementRange;

@end

typedef enum {
    MoveValidity_Valid,
    MoveValidity_PassThrough,
    MoveValidity_Blocked
} MoveValidity;

@interface CharacterMovementOption ()

@property (nonatomic) MoveValidity moveValidity;

@end

@implementation CharacterWorldOptions

- (instancetype)initWithCharacter:(Character *)character worldState:(WorldState *)worldState
{
    self = [super init];
    if (self) {
        self.character = character;
        [self calculateOptionsForWorldState:worldState];
    }
    return self;
}

- (void)calculateOptionsForWorldState:(WorldState *)worldState
{
    CGSize dimensions = worldState.gridDimensions;
    
    BOOL checkedTiles[(int)dimensions.width][(int)dimensions.height];
    for (int i=0; i<dimensions.width; i++) {
        for (int j=0; j<dimensions.height; j++) {
            checkedTiles[i][j] = NO;
        }
    }
    
    NSMutableArray *queue = [NSMutableArray array];
    NSMutableArray *moveOptions = [NSMutableArray array];
    NSMutableArray *attackOptions = [NSMutableArray array];
    NSMutableSet *allMovePoints = [NSMutableSet set];
    
    CharacterMovementOption *root = [[CharacterMovementOption alloc] init];
    root.position = self.character.position;
    root.path = [NSArray arrayWithObject:[NSValue valueWithWorldPoint:root.position]];
    root.moveValidity = MoveValidity_Valid;
    checkedTiles[root.position.x][root.position.y] = YES;
    [queue addObject:root];
    [moveOptions addObject:root];
 
    while (queue.count > 0) {
        CharacterMovementOption *current = queue[0];
        [queue removeObjectAtIndex:0];
        [allMovePoints addObject:[NSValue valueWithWorldPoint:current.position]];
        
        if (current.moveValidity == MoveValidity_Valid) {
            [self addAttackOptionsFromMove:current toArray:attackOptions forWorldState:worldState];
        }
        if (current.path.count >= self.character.movesRemaining + 1) {
            continue;
        }
        
        WorldPoint up = (WorldPoint){current.position.x, current.position.y-1};
        WorldPoint down = (WorldPoint){current.position.x, current.position.y+1};
        WorldPoint left = (WorldPoint){current.position.x-1, current.position.y};
        WorldPoint right = (WorldPoint){current.position.x+1, current.position.y};
        WorldPoint newPoints[4] = {up, down, left, right};
        
        for (int i=0; i<4; i++) {
            WorldPoint point = newPoints[i];
            if (checkedTiles[point.x][point.y]) {
                continue;
            }
            MoveValidity validity = [self moveValidityForPoint:point worldState:worldState];
            if (validity != MoveValidity_Blocked) {
                CharacterMovementOption *newOption = [[CharacterMovementOption alloc] init];
                newOption.position = point;
                NSMutableArray *path = [NSMutableArray arrayWithArray:current.path];
                [path addObject:[NSValue valueWithWorldPoint:point]];
                newOption.path = path;
                newOption.moveValidity = validity;
                checkedTiles[point.x][point.y] = YES;
                [queue addObject:newOption];
                if (validity == MoveValidity_Valid) {
                    [moveOptions addObject:newOption];
                }
            }
        }
    }
    
    self.moveOptions = moveOptions;
    self.attackOptions = [self pruneAttacks:attackOptions];
    self.selectedMoveOption = root;
    self.pointsInMovementRange = allMovePoints;
}

- (void)addAttackOptionsFromMove:(CharacterMovementOption *)moveOption toArray:(NSMutableArray *)attackOptions forWorldState:(WorldState *)worldState
{
    WorldPoint center = moveOption.position;
    int minRange = self.character.characterClass.attackRangeMin;
    int maxRange = self.character.characterClass.attackRangeMax;
    
    WorldPoint (^clamp)(WorldPoint) = ^WorldPoint(WorldPoint point) {
        WorldPoint result;
        result.x = MAX(0, MIN(worldState.gridDimensions.width, point.x));
        result.y = MAX(0, MIN(worldState.gridDimensions.height, point.y));
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
            
            WorldObject *object = [worldState objectAtPosition:target];
            if ([object isKindOfClass:Character.class]) {
                Character *otherCharacter = (Character *)object;
                if (otherCharacter.team == self.character.team) {
                    continue;
                }
            }
            
            CharacterAttackOption *attack = [[CharacterAttackOption alloc] init];
            attack.position = target;
            attack.moveOption = moveOption;
            [attackOptions addObject:attack];
        }
    }
}

- (void)addAttack:(CharacterAttackOption *)attack toOptions:(NSMutableArray *)options
{
    CharacterAttackOption *existingOption = nil;
    for (CharacterAttackOption *otherOption in options) {
        if (WorldPointEqualToPoint(attack.position, otherOption.position)) {
            existingOption = otherOption;
            break;
        }
    }
    
    if (!existingOption) {
        [options addObject:attack];
    } else if (attack.moveOption.path.count < existingOption.moveOption.path.count) {
        [options removeObject:existingOption];
        [options addObject:attack];
    }
}

- (NSArray *)pruneAttacks:(NSArray *)attackOptions
{
    NSMutableArray *result = [NSMutableArray array];
    for (CharacterAttackOption *attack in attackOptions) {
        CharacterMovementOption *move = [self moveOptionAtPoint:attack.position];
        if (!move) {
            [result addObject:attack];
        }
    }
    return result;
}

- (MoveValidity)moveValidityForPoint:(WorldPoint)point worldState:(WorldState *)worldState
{
    if (point.x < 0 || point.x >= worldState.gridDimensions.width) {
        return MoveValidity_Blocked;
    }
    if (point.y < 0 || point.y >= worldState.gridDimensions.width) {
        return MoveValidity_Blocked;
    }
    if (worldState.level.terrainTiles[point.x][point.y].blocked) {
        return MoveValidity_Blocked;
    }
    
    WorldObject *object = [worldState objectAtPosition:point];
    if (object) {
        if ([object isKindOfClass:Character.class]) {
            Character *otherCharacter = (Character *)object;
            if (otherCharacter.team == self.character.team) {
                return MoveValidity_PassThrough;
            } else {
                return MoveValidity_Blocked;
            }
        }
    }
    
    return MoveValidity_Valid;
}

- (BOOL)containsPoint:(WorldPoint)point
{
    for (CharacterMovementOption *option in self.moveOptions) {
        if (WorldPointEqualToPoint(point, option.position)) {
            return YES;
        }
    }
    for (CharacterAttackOption *option in self.attackOptions) {
        if (WorldPointEqualToPoint(point, option.position)) {
            return YES;
        }
    }
    return NO;
}

- (CharacterMovementOption *)moveOptionAtPoint:(WorldPoint)point
{
    for (CharacterMovementOption *option in self.moveOptions) {
        if (WorldPointEqualToPoint(point, option.position)) {
            return option;
        }
    }
    return nil;
}

- (CharacterAttackOption *)attackOptionAtPoint:(WorldPoint)point
{
    for (CharacterAttackOption *option in self.attackOptions) {
        if (WorldPointEqualToPoint(point, option.position)) {
            return option;
        }
    }
    return nil;
}

- (NSArray *)pathFromPoint:(WorldPoint)startPoint toPoint:(WorldPoint)endPoint
{
    NSMutableArray *partialPaths = [NSMutableArray array];
    NSMutableSet *pointsConsidered = [NSMutableSet set];
    
    NSArray *root = [NSArray arrayWithObject:[NSValue valueWithWorldPoint:startPoint]];
    [partialPaths addObject:root];
    
    int (^heuristic)(NSArray *) = ^int(NSArray *path) {
        WorldPoint lastPoint = [[path lastObject] worldPointValue];
        int range = WorldPointRangeToPoint(lastPoint, endPoint);
        return range + (int)path.count;
    };
    NSComparisonResult (^prioritySorter)(id, id) = ^NSComparisonResult(id obj1, id obj2) {
        int value1 = heuristic(obj1);
        int value2 = heuristic(obj2);
        if (value1 > value2) {
            return NSOrderedAscending;
        } else if (value1 < value2) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    };
    
    // A* search!
    while (partialPaths.count > 0) {
        [partialPaths sortUsingComparator:prioritySorter];
        NSArray *path = [partialPaths lastObject];
        [partialPaths removeLastObject];
        
        WorldPoint current = [[path lastObject] worldPointValue];
        if ([pointsConsidered containsObject:[path lastObject]]) {
            continue;
        } else {
            [pointsConsidered addObject:[path lastObject]];
        }
        
        WorldPoint up = (WorldPoint){current.x, current.y-1};
        WorldPoint down = (WorldPoint){current.x, current.y+1};
        WorldPoint left = (WorldPoint){current.x-1, current.y};
        WorldPoint right = (WorldPoint){current.x+1, current.y};
        WorldPoint newPoints[4] = {up, down, left, right};
        for (int i=0; i<4; i++) {
            NSValue *nextPoint = [NSValue valueWithWorldPoint:newPoints[i]];
            if (![pointsConsidered containsObject:nextPoint] &&
                [self.pointsInMovementRange containsObject:nextPoint])
            {
                NSMutableArray *nextPath = [NSMutableArray arrayWithArray:path];
                [nextPath addObject:nextPoint];
                if (WorldPointEqualToPoint(newPoints[i], endPoint)) {
                    return nextPath;
                } else {
                    [partialPaths addObject:nextPath];
                }
            }
        }
    }

    // no path found? bummer :(
    return nil;
}

@end

@implementation CharacterMovementOption

- (BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    }
    if (![object isKindOfClass:self.class]) {
        return NO;
    }
    
    CharacterMovementOption *otherOption = (CharacterMovementOption *)object;
    if (WorldPointEqualToPoint(self.position, otherOption.position)) {
        return YES;
    }
    
    return NO;
}

@end

@implementation CharacterAttackOption

- (BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    }
    if (![object isKindOfClass:self.class]) {
        return NO;
    }
    
    CharacterAttackOption *otherOption = (CharacterAttackOption *)object;
    if (WorldPointEqualToPoint(self.position, otherOption.position)) {
        return YES;
    }
    
    return NO;
}

@end
