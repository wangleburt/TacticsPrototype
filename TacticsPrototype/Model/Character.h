//
//  Character.h
//  TacticsPrototype
//
//  Created by Chris Meill on 6/23/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import "WorldObject.h"

typedef enum {
    CharacterTeam_Player,
    CharacterTeam_Enemy
} CharacterTeam;

@class CharacterClass;
@class Weapon;
@class CharacterStats;

@interface Character : WorldObject

@property (nonatomic) int level;
@property (nonatomic, strong) CharacterClass *characterClass;
@property (nonatomic) CharacterTeam team;
@property (nonatomic, strong) Weapon *weapon;
@property (nonatomic, strong, readonly) CharacterStats *stats;

@property (nonatomic) int health;
@property (nonatomic) int isActive;
@property (nonatomic) NSUInteger movesRemaining;

- (void)setupStats;

@end
