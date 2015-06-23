//
//  WorldLevel.m
//  TacticsPrototype
//
//  Created by Chris Meill on 6/22/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import "WorldLevel.h"

@interface WorldLevel ()

@property (nonatomic) CGSize levelSize;
@property (nonatomic, strong) NSString *mapImageFileName;

@end

@implementation WorldLevel

@end

@implementation WorldLevel (TestLevel)

+ (WorldLevel *)testLevel
{
    WorldLevel *level = [[WorldLevel alloc] init];
    level.levelSize = CGSizeMake(32, 28);
    level.mapImageFileName = @"map";
    return level;
}

@end
