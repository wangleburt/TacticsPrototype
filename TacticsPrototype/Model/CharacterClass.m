//
//  CharacterClass.m
//  TacticsPrototype
//
//  Created by Chris Meill on 6/23/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import "CharacterClass.h"

@interface CharacterClass ()

@property (nonatomic) NSUInteger movement;
@property (nonatomic, strong) NSString *imageFileName;

@property (nonatomic) int attackRangeMin;
@property (nonatomic) int attackRangeMax;

@end

@implementation CharacterClass

+ (void)initializeContentIntoManager:(id<MutableContentManager>)contentManager
{
    CharacterClass *footman = [[CharacterClass alloc] init];
    footman.movement = 4;
    footman.imageFileName = @"footman";
    footman.attackRangeMin = 1;
    footman.attackRangeMax = 1;
    [contentManager setContent:footman forKey:@"class_footman"];
    
    CharacterClass *grunt = [[CharacterClass alloc] init];
    grunt.movement = 3;
    grunt.imageFileName = @"grunt";
    grunt.attackRangeMin = 1;
    grunt.attackRangeMax = 1;
    [contentManager setContent:grunt forKey:@"class_grunt"];
    
    CharacterClass *archer = [[CharacterClass alloc] init];
    archer.movement = 4;
    archer.imageFileName = @"archer";
    archer.attackRangeMin = 2;
    archer.attackRangeMax = 2;
    [contentManager setContent:archer forKey:@"class_archer"];
}

@end
