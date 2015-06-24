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

@end

@implementation CharacterClass

+ (void)initializeContentIntoManager:(id<MutableContentManager>)contentManager
{
    CharacterClass *footman = [[CharacterClass alloc] init];
    footman.movement = 4;
    footman.imageFileName = @"footman";
    [contentManager setContent:footman forKey:@"class_footman"];
    
    CharacterClass *grunt = [[CharacterClass alloc] init];
    grunt.movement = 3;
    grunt.imageFileName = @"grunt";
    [contentManager setContent:grunt forKey:@"class_grunt"];
}

@end
