//
//  GridOverlayView.h
//  TacticsPrototype
//
//  Created by Chris Meill on 6/22/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GridOverlayDisplay;

@interface GridOverlayView : UIView

- (instancetype)initWithGridDimensions:(CGSize)gridDimensions unitSize:(CGFloat)unitSize;

- (void)updateViewForDisplay:(GridOverlayDisplay *)display;

@end
