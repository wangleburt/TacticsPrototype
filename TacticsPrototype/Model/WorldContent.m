//
//  WorldContent.m
//  TacticsPrototype
//
//  Created by Chris Meill on 6/23/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import "WorldContent.h"

@implementation WorldContent

+ (void)initializeContentIntoManager:(id<MutableContentManager>)contentManager
{
    NSAssert(NO, @"Content subclasses must override initializeContentIntoManager:");
}

@end
