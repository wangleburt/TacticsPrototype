//
//  WorldLevel.m
//  TacticsPrototype
//
//  Created by Chris Meill on 6/22/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import "WorldLevel.h"
#import "TerrainMap.h"

#import "ContentManager.h"
#import "Character.h"
#import "Weapon.h"

@interface WorldLevel ()

@property (nonatomic) CGSize levelSize;
@property (nonatomic, strong) NSString *mapImageFileName;
@property (nonatomic, strong) TerrainMap *terrainTiles;
@property (nonatomic, strong) NSArray *characters;

@end

@implementation WorldLevel

@end

@implementation WorldLevel (TestLevel)

+ (WorldLevel *)testLevel
{
    WorldLevel *level = [[WorldLevel alloc] init];
    level.levelSize = CGSizeMake(32, 16);
    level.mapImageFileName = @"map32x16";

    level.terrainTiles = [[TerrainMap alloc] initWithDimensions:level.levelSize];
    NSString *terrain =
       @"NNNNNNYYNYYYYYYYYNNNYYYYYYYYYYYY"
        "NYYNNYYYYYYYYYYYYYYNNNNYYYYYYYYY"
        "YYYYYYYYNNYYYYYYYYYNNNNNNNNYYYYY"
        "YYYYYYYYYNNNYYYYYYYNNNNYYYNNYYYY"
        "NNYYYYYYYNYNNYYYNNNNNNNYYYYNYYNN"
        "YNNNNYYYYNYYYYYYYYYNNNNYYYYYYYYY"
        "YYYYNNNNNNYYNNYYYYYYYNYNNNYYYYYY"
        "YYYYYYYNNNYYYNYYYYYYYYYYYYYYYYYY"
        "YYYYYYYYNNNNYNYYYYYYYNYYYYYYYYYY"
        "YYYYYYYYYYYNYNYYYYYYYNNNYYYYYYYY"
        "YYYYYYYYYYYYYNNYYYYYYYNNNYYYYYYY"
        "YYYYYYYYYYYNNYNYYYYYYYNYYYYYYYYY"
        "YYYYYYYYYYYYNNNNYYYYYNNYYYYYYYYY"
        "YYYYYYYYYYYYYYNNYYYYNNYYYYYYYYYY"
        "YYYYYYYYYYYYYYNNYYYYYYYYYYYYYYYY"
        "YYYYYYYYYYYYYYYNNYYYNYYYYYYYYYYY";
    for (int y=0; y<16; y++) {
        for (int x=0; x<32; x++) {
            char type = [terrain characterAtIndex:y*32+x];
            if (type == 'N') {
                level.terrainTiles[x][y] = [TerrainTile blockedTile];
            } else {
                level.terrainTiles[x][y] = [TerrainTile emptyTile];
            }
        }
    }
    
    NSMutableArray *characters = [NSMutableArray array];
    Character *dude = [[Character alloc] init];
    dude.characterClass = [ContentManager contentWithKey:@"class_footman"];
    dude.position = (WorldPoint){2, 2};
    dude.team = CharacterTeam_Player;
    dude.key = @"foot1";
    dude.weapon = [[Weapon alloc] init];
    dude.weapon.damage = 4;
    dude.weapon.element = [ContentManager contentWithKey:@"element_earth"];
    [characters addObject:dude];
    
    dude = [[Character alloc] init];
    dude.characterClass = [ContentManager contentWithKey:@"class_footman"];
    dude.position = (WorldPoint){3, 3};
    dude.team = CharacterTeam_Player;
    dude.key = @"foot2";
    dude.weapon = [[Weapon alloc] init];
    dude.weapon.damage = 4;
    dude.weapon.element = [ContentManager contentWithKey:@"element_water"];
    [characters addObject:dude];
    
    dude = [[Character alloc] init];
    dude.characterClass = [ContentManager contentWithKey:@"class_archer"];
    dude.position = (WorldPoint){1, 1};
    dude.team = CharacterTeam_Player;
    dude.key = @"archer1";
    dude.weapon = [[Weapon alloc] init];
    dude.weapon.damage = 4;
    dude.weapon.element = [ContentManager contentWithKey:@"element_fire"];
    [characters addObject:dude];
    
    dude = [[Character alloc] init];
    dude.characterClass = [ContentManager contentWithKey:@"class_archer"];
    dude.position = (WorldPoint){2, 1};
    dude.team = CharacterTeam_Player;
    dude.key = @"archer2";
    dude.weapon = [[Weapon alloc] init];
    dude.weapon.damage = 4;
    dude.weapon.element = [ContentManager contentWithKey:@"element_earth"];
    [characters addObject:dude];
    
    dude = [[Character alloc] init];
    dude.characterClass = [ContentManager contentWithKey:@"class_grunt"];
    dude.position = (WorldPoint){4, 2};
    dude.team = CharacterTeam_Enemy;
    dude.key = @"grunt1";
    dude.weapon = [[Weapon alloc] init];
    dude.weapon.damage = 5;
    dude.weapon.element = [ContentManager contentWithKey:@"element_none"];
    [characters addObject:dude];
    
    level.characters = characters;
    
    return level;
}

@end
