//
//  CharacterWorldOptions.h
//  TacticsPrototype
//
//  Created by Chris Meill on 6/24/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WorldPoint.h"

@interface CharacterMovementOption : NSObject

@property (nonatomic) WorldPoint position;
@property (nonatomic, strong) NSArray *path;

@end

@class Character;
@class WorldState;

@interface CharacterWorldOptions : NSObject

@property (nonatomic, strong, readonly) NSArray *moveOptions;

- (instancetype)initWithCharacter:(Character *)character worldState:(WorldState *)worldState;

@end


