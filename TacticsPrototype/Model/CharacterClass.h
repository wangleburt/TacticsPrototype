//
//  CharacterClass.h
//  TacticsPrototype
//
//  Created by Chris Meill on 6/23/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import "WorldContent.h"

@interface CharacterClass : WorldContent

@property (nonatomic, readonly) NSUInteger movement;
@property (nonatomic, strong, readonly) NSString *imageFileName;

@end
