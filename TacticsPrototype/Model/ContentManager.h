//
//  ContentManager.h
//  TacticsPrototype
//
//  Created by Chris Meill on 6/23/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContentManager : NSObject

+ (instancetype)sharedContentManager;

+ (id)contentWithKey:(NSString *)key;

@end
