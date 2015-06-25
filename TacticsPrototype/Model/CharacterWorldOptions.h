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

@interface CharacterAttackOption : NSObject

@property (nonatomic) WorldPoint position;
@property (nonatomic, strong) CharacterMovementOption *moveOption;

@end

@class Character;
@class WorldState;

@interface CharacterWorldOptions : NSObject

@property (nonatomic, strong, readonly) Character *character;
@property (nonatomic, strong, readonly) NSArray *moveOptions;
@property (nonatomic, strong, readonly) NSArray *attackOptions;

@property (nonatomic, strong) CharacterMovementOption *selectedMoveOption;

- (instancetype)initWithCharacter:(Character *)character worldState:(WorldState *)worldState;

- (BOOL)containsPoint:(WorldPoint)point;
- (CharacterMovementOption *)moveOptionAtPoint:(WorldPoint)point;
- (CharacterAttackOption *)attackOptionAtPoint:(WorldPoint)point;

@end


