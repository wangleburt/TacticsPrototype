//
//  CharacterInfoPanel.h
//  TacticsPrototype
//
//  Created by Chris Meill on 6/26/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Character;

@interface CharacterInfoPanel : UIView

- (void)updateForCharacter:(Character *)character;

@end
