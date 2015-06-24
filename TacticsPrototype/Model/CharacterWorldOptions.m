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
    NSMutableArray *options = [NSMutableArray array];
    
    CharacterMovementOption *root = [[CharacterMovementOption alloc] init];
    root.position = self.character.position;
    root.path = [NSArray arrayWithObject:[NSValue valueWithWorldPoint:root.position]];
    checkedTiles[root.position.x][root.position.y] = YES;
    [queue addObject:root];
    [options addObject:root];
 
    while (queue.count > 0) {
        CharacterMovementOption *current = queue[0];
        [queue removeObjectAtIndex:0];
        
        BOOL isFinal = (current.path.count >= self.character.characterClass.movement);
        
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
            if ([self isValidMovementPoint:point worldState:worldState final:isFinal]) {
                CharacterMovementOption *newOption = [[CharacterMovementOption alloc] init];
                newOption.position = point;
                NSMutableArray *path = [NSMutableArray arrayWithArray:current.path];
                [path addObject:[NSValue valueWithWorldPoint:point]];
                newOption.path = path;
                checkedTiles[point.x][point.y] = YES;
                if (path.count < self.character.characterClass.movement+1) {
                    [queue addObject:newOption];
                }
                [options addObject:newOption];
            }
        }
    }
    self.moveOptions = options;
}

- (BOOL)isValidMovementPoint:(WorldPoint)point worldState:(WorldState *)worldState final:(BOOL)isFinalPosition
{
    if (point.x < 0 || point.x >= worldState.gridDimensions.width) {
        return NO;
    }
    if (point.y < 0 || point.y >= worldState.gridDimensions.width) {
        return NO;
    }
    if (worldState.level.terrainTiles[point.x][point.y].blocked) {
        return NO;
    }
    
    // TODO: check if another unit is in that tile
    
    return YES;
}

@end

@implementation CharacterMovementOption
@end
