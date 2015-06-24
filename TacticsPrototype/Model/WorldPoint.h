//
//  WorldPoint.h
//  TacticsPrototype
//
//  Created by Chris Meill on 6/24/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>

struct WorldPoint {
   int x;
   int y;
};

typedef struct WorldPoint WorldPoint;

static inline
BOOL __WorldPointEqualToPoint(WorldPoint point1, WorldPoint point2) {
    return point1.x == point2.x && point1.y == point2.y;
}
#define WorldPointEqualToPoint __WorldPointEqualToPoint

@interface NSValue (WorldPoint)

+ (NSValue *)valueWithWorldPoint:(WorldPoint)point;
- (WorldPoint)worldPointValue;

@end
