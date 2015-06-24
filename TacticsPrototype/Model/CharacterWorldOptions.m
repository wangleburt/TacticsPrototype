//
//  CharacterWorldOptions.m
//  TacticsPrototype
//
//  Created by Chris Meill on 6/24/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import "CharacterWorldOptions.h"
#import "Character.h"

#import "WorldState.h"
#import "WorldLevel.h"
#import "TerrainMap.h"

@interface CharacterWorldOptions ()

@property (nonatomic, strong) Character *character;

@property (nonatomic, strong) NSArray *moveOptions;

@end

typedef enum {
    MoveValidity_Valid,
    MoveValidity_PassThrough,
    MoveValidity_Blocked
} MoveValidity;

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
    NSMutableArray *options = [NSMutableArray array];
    
    CharacterMovementOption *root = [[CharacterMovementOption alloc] init];
    root.position = self.character.position;
    root.path = [NSArray arrayWithObject:[NSValue valueWithWorldPoint:root.position]];
    checkedTiles[root.position.x][root.position.y] = YES;
    if (self.character.movesRemaining > 0) {
        [queue addObject:root];
    }
    [options addObject:root];
 
    while (queue.count > 0) {
        CharacterMovementOption *current = queue[0];
        [queue removeObjectAtIndex:0];
        
        // check up
        WorldPoint upp = (WorldPoint){current.position.x, current.position.y-1};
        WorldPoint down = (WorldPoint){current.position.x, current.position.y+1};
        WorldPoint left = (WorldPoint){current.position.x-1, current.position.y};
        WorldPoint right = (WorldPoint){current.position.x+1, current.position.y};
        WorldPoint newPoints[4] = {upp, down, left, right};
        
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
                checkedTiles[point.x][point.y] = YES;
                if (path.count < self.character.movesRemaining+1) {
                    [queue addObject:newOption];
                }
                if (validity == MoveValidity_Valid) {
                    [options addObject:newOption];
                }
            }
        }
    }
    self.moveOptions = options;
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
