//
//  WeaponElement.h
//  TacticsPrototype
//
//  Created by Chris Meill on 6/25/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WorldContent.h"

@interface WeaponElement : WorldContent

@property (nonatomic, strong, readonly) NSString *iconFileName;

@property (nonatomic, strong, readonly) NSArray *strongAgainst;
@property (nonatomic, strong, readonly) NSArray *weakAgainst;

@end
