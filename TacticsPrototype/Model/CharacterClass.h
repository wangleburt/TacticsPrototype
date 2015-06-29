//
//  CharacterClass.h
//  TacticsPrototype
//
//  Created by Chris Meill on 6/23/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import "WorldContent.h"

@interface CharacterClass : WorldContent

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *idleImageFileName;
@property (nonatomic, strong, readonly) NSString *headImageFileName;

@property (nonatomic, readonly) NSUInteger movement;

@property (nonatomic, readonly) int attackRangeMin;
@property (nonatomic, readonly) int attackRangeMax;

@property (nonatomic, readonly) int maxHealth;

@end
