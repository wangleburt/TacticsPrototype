//
//  WeaponElement.h
//  TacticsPrototype
//
//  Created by Chris Meill on 6/25/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WorldContent.h"

typedef enum {
    ElementComparison_Advantage,
    ElementComparison_Disadvantage,
    ElementComparison_None
} ElementComparison;

@interface WeaponElement : WorldContent

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *iconFileName;

@property (nonatomic, strong, readonly) NSArray *strongAgainst;
@property (nonatomic, strong, readonly) NSArray *weakAgainst;

- (ElementComparison)compareAgainstElement:(WeaponElement *)otherElement;

@end
