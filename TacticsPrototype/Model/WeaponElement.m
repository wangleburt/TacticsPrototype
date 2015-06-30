//
//  WeaponElement.m
//  TacticsPrototype
//
//  Created by Chris Meill on 6/25/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import "WeaponElement.h"
#import "ContentManager.h"

@interface WeaponElement ()

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *iconFileName;

@property (nonatomic, strong) NSArray *strongAgainstKeys;
@property (nonatomic, strong) NSArray *weakAgainstKeys;

@property (nonatomic, strong) NSArray *strongAgainst;
@property (nonatomic, strong) NSArray *weakAgainst;

@end

@implementation WeaponElement

+ (void)initializeContentIntoManager:(id<MutableContentManager>)contentManager
{
    WeaponElement *fire = [[WeaponElement alloc] init];
    fire.name = @"Fire";
    fire.iconFileName = @"elem-fire";
    fire.strongAgainstKeys = @[@"element_earth", @"element_none"];
    fire.weakAgainstKeys = @[@"element_water"];
    [contentManager setContent:fire forKey:@"element_fire"];
    
    WeaponElement *earth = [[WeaponElement alloc] init];
    earth.name = @"Earth";
    earth.iconFileName = @"elem-earth";
    earth.strongAgainstKeys = @[@"element_water", @"element_none"];
    earth.weakAgainstKeys = @[@"element_fire"];
    [contentManager setContent:earth forKey:@"element_earth"];
    
    WeaponElement *water = [[WeaponElement alloc] init];
    water.name = @"Water";
    water.iconFileName = @"elem-water";
    water.strongAgainstKeys = @[@"element_fire", @"element_none"];
    water.weakAgainstKeys = @[@"element_earth"];
    [contentManager setContent:water forKey:@"element_water"];
    
    WeaponElement *none = [[WeaponElement alloc] init];
    none.name = @"No Element";
    none.iconFileName = @"elem-none";
    none.strongAgainstKeys = @[];
    none.weakAgainstKeys = @[@"element_fire", @"element_earth", @"element_water", @"element_light"];
    [contentManager setContent:none forKey:@"element_none"];
    
    WeaponElement *light = [[WeaponElement alloc] init];
    light.name = @"Light";
    light.iconFileName = @"elem-light";
    light.strongAgainstKeys = @[@"element_fire", @"element_earth", @"element_water", @"element_none"];
    light.weakAgainstKeys = @[];
    [contentManager setContent:light forKey:@"element_light"];
}

- (NSArray *)strongAgainst
{
    if (!_strongAgainst) {
        NSMutableArray *strongAgainst = [NSMutableArray array];
        for (NSString *key in self.strongAgainstKeys) {
            WeaponElement *element = [ContentManager contentWithKey:key];
            if (element && [element isKindOfClass:WeaponElement.class]) {
                [strongAgainst addObject:element];
            }
        }
        _strongAgainst = strongAgainst;
    }
    
    return _strongAgainst;
}

- (NSArray *)weakAgainst
{
    if (!_weakAgainst) {
        NSMutableArray *weakAgainst = [NSMutableArray array];
        for (NSString *key in self.weakAgainstKeys) {
            WeaponElement *element = [ContentManager contentWithKey:key];
            if (element && [element isKindOfClass:WeaponElement.class]) {
                [weakAgainst addObject:element];
            }
        }
        _weakAgainst = weakAgainst;
    }
    
    return _weakAgainst;
}

- (ElementComparison)compareAgainstElement:(WeaponElement *)otherElement
{
    if ([self.strongAgainst containsObject:otherElement]) {
        return ElementComparison_Advantage;
    } else if ([self.weakAgainst containsObject:otherElement]) {
        return ElementComparison_Disadvantage;
    } else {
        return ElementComparison_None;
    }
}

@end
