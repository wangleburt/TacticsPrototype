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

@interface WorldState ()

@property (nonatomic, strong) WorldLevel *level;

@property (nonatomic, strong) NSMutableArray *playerCharacters;

@end

@implementation WorldState

- (instancetype)initWithLevel:(WorldLevel *)level
{
    self = [super init];
    if (self) {
        self.level = level;
        
        self.playerCharacters = [NSMutableArray array];
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
    return worldObjects;
}

- (void)instantiateCharacterPrototypes
{
    for (Character *dude in self.level.characters) {
        if (dude.team == CharacterTeam_Player) {
            [self.playerCharacters addObject:dude];
        }
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
    }
}

//-------------------------------------------------------------------------------------
#pragma mark - Grid

- (GridOverlayDisplay *)currentGridOverlayDisplay
{
    GridOverlayDisplay *display = [[GridOverlayDisplay alloc] initWithWorldState:self];
    if (self.characterWorldOptions) {
        for (CharacterMovementOption *option in self.characterWorldOptions.moveOptions) {
            display[option.position.x][option.position.y] = [GridOverlayTileDisplay blueTile];
        }
    }
    
    return display;
}

- (CGSize)gridDimensions
{
    return self.level.levelSize;
}

@end
