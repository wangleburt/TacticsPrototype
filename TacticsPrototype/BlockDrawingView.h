//
//  BlockDrawingView.h
//  TacticsPrototype
//
//  Created by Chris Meill on 6/23/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlockDrawingView : UIView

@property (nonatomic, copy) void (^drawBlock)(CGRect drawRect);

@end
