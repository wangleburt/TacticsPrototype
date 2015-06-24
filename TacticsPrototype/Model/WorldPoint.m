//
//  WorldPoint.m
//  TacticsPrototype
//
//  Created by Chris Meill on 6/24/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import "WorldPoint.h"
#import <UIKit/UIKit.h>

@implementation NSValue (WorldPoint)

+ (NSValue *)valueWithWorldPoint:(WorldPoint)point
{
    return [NSValue valueWithCGPoint:(CGPoint){point.x, point.y}];
}

- (WorldPoint)worldPointValue
{
    CGPoint cgPoint = [self CGPointValue];
    return (WorldPoint){floor(cgPoint.x), floor(cgPoint.y)};
}

@end
