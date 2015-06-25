//
//  GridOverlayView.h
//  TacticsPrototype
//
//  Created by Chris Meill on 6/22/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorldPoint.h"

@class GridOverlayDisplay;

@interface GridOverlayView : UIView

- (instancetype)initWithGridDimensions:(CGSize)gridDimensions unitSize:(CGFloat)unitSize;

- (void)updateViewForDisplay:(GridOverlayDisplay *)display;

// for annotating movement selection
- (void)setSelectorPosition:(WorldPoint)selectorPosition;
- (void)cleanupMovementAnnotations;
- (void)annotateMovementPath:(NSArray *)path;

@end
