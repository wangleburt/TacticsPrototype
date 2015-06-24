//
//  WorldObject.h
//  TacticsPrototype
//
//  Created by Chris Meill on 6/23/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>

@interface WorldObject : NSObject

@property (nonatomic) CGPoint position;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *imageFileName;

@end
