//
//  WorldViewController.h
//  TacticsPrototype
//
//  Created by Chris Meill on 6/22/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WorldLevel;

@interface WorldViewController : UIViewController

- (instancetype)initWithLevel:(WorldLevel *)level;

@end
