//
//  CombatPreviewView.h
//  TacticsPrototype
//
//  Created by Chris Meill on 6/29/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CombatModel;

@interface CombatPreviewView : UIView

- (void)updateWithCombatModel:(CombatModel *)model;

@end
