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

@interface Character : WorldObject

@property (nonatomic, strong) CharacterClass *characterClass;
@property (nonatomic) CharacterTeam team;

@end