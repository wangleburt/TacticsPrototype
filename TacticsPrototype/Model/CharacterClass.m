//
//  CharacterClass.m
//  TacticsPrototype
//
//  Created by Chris Meill on 6/23/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import "CharacterClass.h"

@interface CharacterClass ()

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *idleImageFileName;
@property (nonatomic, strong) NSString *headImageFileName;

@property (nonatomic) NSUInteger movement;

@property (nonatomic) int attackRangeMin;
@property (nonatomic) int attackRangeMax;

@property (nonatomic) int maxHealth;

@end

@implementation CharacterClass

+ (void)initializeContentIntoManager:(id<MutableContentManager>)contentManager
{
    CharacterClass *footman = [[CharacterClass alloc] init];
    footman.movement = 4;
    footman.name = @"Footman";
    footman.idleImageFileName = @"footman-idle";
    footman.headImageFileName = @"footman-head";
    footman.attackRangeMin = 1;
    footman.attackRangeMax = 1;
    footman.maxHealth = 10;
    [contentManager setContent:footman forKey:@"class_footman"];
    
    CharacterClass *grunt = [[CharacterClass alloc] init];
    grunt.movement = 3;
    grunt.name = @"Grunt";
    grunt.idleImageFileName = @"grunt-idle";
    grunt.headImageFileName = @"grunt-head";
    grunt.attackRangeMin = 1;
    grunt.attackRangeMax = 1;
    grunt.maxHealth = 10;
    [contentManager setContent:grunt forKey:@"class_grunt"];
    
    CharacterClass *archer = [[CharacterClass alloc] init];
    archer.movement = 4;
    archer.name = @"Archer";
    archer.idleImageFileName = @"archer-idle";
    archer.headImageFileName = @"archer-head";
    archer.attackRangeMin = 2;
    archer.attackRangeMax = 2;
    archer.maxHealth = 6;
    [contentManager setContent:archer forKey:@"class_archer"];
}

@end
