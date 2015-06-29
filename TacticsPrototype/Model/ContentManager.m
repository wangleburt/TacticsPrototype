//
//  ContentManager.m
//  TacticsPrototype
//
//  Created by Chris Meill on 6/23/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import "ContentManager.h"
#import "WorldContent.h"

#import "CharacterClass.h"
#import "WeaponElement.h"

@interface ContentManager () <MutableContentManager>

@property (nonatomic, strong) NSMutableDictionary *contentDict;

@end

@implementation ContentManager

+ (instancetype)sharedContentManager
{
    static ContentManager *sharedContentManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedContentManager = [[ContentManager alloc] init];
    });
    
    return sharedContentManager;
}

+ (id)contentWithKey:(NSString *)key
{
    ContentManager *manager = [self sharedContentManager];
    return [manager.contentDict objectForKey:key];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.contentDict = [NSMutableDictionary dictionary];
        [CharacterClass initializeContentIntoManager:self];
        [WeaponElement initializeContentIntoManager:self];
    }
    return self;
}

- (void)setContent:(id)contentObject forKey:(NSString *)key
{
    if (contentObject && key) {
        [self.contentDict setObject:contentObject forKey:key];
    }
}

@end
