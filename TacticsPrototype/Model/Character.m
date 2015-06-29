//
//  Character.m
//  TacticsPrototype
//
//  Created by Chris Meill on 6/23/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import "Character.h"
#import "CharacterClass.h"

@implementation Character

- (NSString *)imageFileName
{
    return self.characterClass.idleImageFileName;
}

@end
