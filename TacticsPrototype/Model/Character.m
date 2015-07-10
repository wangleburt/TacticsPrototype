//
//  Character.m
//  TacticsPrototype
//
//  Created by Chris Meill on 6/23/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import "Character.h"
#import "CharacterClass.h"
#import "CharacterStats.h"

@interface Character ()

@property (nonatomic, strong) CharacterStats *stats;

@property (nonatomic) float atk;
@property (nonatomic) float def;
@property (nonatomic) float skill;

@end

@implementation Character

- (NSString *)imageFileName
{
    return self.characterClass.idleImageFileName;
}

- (void)setupStats
{
    self.atk = 10 + self.characterClass.atkPerLevel*self.level;
    self.def = 10 + self.characterClass.defPerLevel*self.level;
    self.skill = 10 + self.characterClass.skillPerLevel*self.level;

    self.stats = [[CharacterStats alloc] initWithAtk:self.atk def:self.def skill:self.skill];
    [self.stats updateWithClass:self.characterClass];
}

@end
