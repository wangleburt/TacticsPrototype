//
//  Weapon.m
//  TacticsPrototype
//
//  Created by Chris Meill on 6/25/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import "Weapon.h"
#import "WeaponElement.h"
#import "ContentManager.h"

@interface Weapon ()

@property (nonatomic, strong) NSString *elementKey;
//@property (nonatomic, strong) WeaponElement *element;

@end

@implementation Weapon

- (WeaponElement *)element
{
    if (!_element) {
        _element = [ContentManager contentWithKey:self.elementKey];
    }
    return _element;
}

@end
