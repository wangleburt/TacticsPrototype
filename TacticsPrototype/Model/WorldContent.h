//
//  WorldContent.h
//  TacticsPrototype
//
//  Created by Chris Meill on 6/23/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MutableContentManager <NSObject>

- (void)setContent:(id)contentObject forKey:(NSString *)key;

@end

@interface WorldContent : NSObject

+ (void)initializeContentIntoManager:(id<MutableContentManager>)contentManager;

@end
