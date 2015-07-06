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

    [self setupTerrainForLevel:level];
    
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
    
    dude = [[Character alloc] init];
    dude.characterClass = [ContentManager contentWithKey:@"class_grunt"];
    dude.position = (WorldPoint){9, 1};
    dude.team = CharacterTeam_Enemy;
    dude.key = @"grunt2";
    dude.weapon = [[Weapon alloc] init];
    dude.weapon.damage = 5;
    dude.weapon.element = [ContentManager contentWithKey:@"element_none"];
    [characters addObject:dude];
    
    dude = [[Character alloc] init];
    dude.characterClass = [ContentManager contentWithKey:@"class_grunt"];
    dude.position = (WorldPoint){10, 0};
    dude.team = CharacterTeam_Enemy;
    dude.key = @"grunt3";
    dude.weapon = [[Weapon alloc] init];
    dude.weapon.damage = 5;
    dude.weapon.element = [ContentManager contentWithKey:@"element_none"];
    [characters addObject:dude];
    
    level.characters = characters;
    
    return level;
}

+ (WorldLevel *)levelWithDimensions:(CGSize)dimensions numPlayers:(int)numPlayers numEnemies:(int)numEnemies
{
    WorldLevel *level = [[WorldLevel alloc] init];
    level.levelSize = dimensions;
    level.mapImageFileName = @"map32x16";

    [self setupTerrainForLevel:level];

    NSMutableArray *characters = [NSMutableArray array];
    NSArray *elements = @[[ContentManager contentWithKey:@"element_earth"],
                          [ContentManager contentWithKey:@"element_water"],
                          [ContentManager contentWithKey:@"element_fire"]];
    
    NSMutableArray *positions = [NSMutableArray array];
    int maxY = (numPlayers > 15) ? 5 : 4;
    int maxX = (numPlayers > 10) ? 7 : 6;
    for (int x=0; x<maxX; x++) {
        for (int y=0; y<maxY; y++) {
            if (!level.terrainTiles[x][y].blocked) {
                WorldPoint point = (WorldPoint){x, y};
                [positions addObject:[NSValue valueWithWorldPoint:point]];
            }
        }
    }
    for (int i=0; i<numPlayers; i++) {
        NSValue *position = positions[arc4random() % positions.count];
        [positions removeObject:position];
        
        Character *dude = [[Character alloc] init];
        NSString *classKey = ((i+1) % 3 == 0) ? @"class_archer" : @"class_footman";
        dude.characterClass = [ContentManager contentWithKey:classKey];
        dude.position = [position worldPointValue];
        dude.team = CharacterTeam_Player;
        dude.key = [NSString stringWithFormat:@"player%i", i+1];
        dude.weapon = [[Weapon alloc] init];
        dude.weapon.damage = 4;
        dude.weapon.element = elements[arc4random()%3];
        [characters addObject:dude];
    }
    
    [positions removeAllObjects];
    for (int x=0; x<dimensions.width; x++) {
        for (int y=0; y<dimensions.height; y++) {
            if ((x > maxX || y > maxY) &&
                !level.terrainTiles[x][y].blocked) {
                WorldPoint point = (WorldPoint){x, y};
                [positions addObject:[NSValue valueWithWorldPoint:point]];
            }
        }
    }
    for (int i=0; i<numEnemies && positions.count > 0; i++) {
        NSValue *position = positions[arc4random() % positions.count];
        [positions removeObject:position];
    
        Character *dude = [[Character alloc] init];
        dude.characterClass = [ContentManager contentWithKey:@"class_grunt"];
        dude.position = [position worldPointValue];
        dude.team = CharacterTeam_Enemy;
        dude.key = [NSString stringWithFormat:@"enemy%i", i+1];
        dude.weapon = [[Weapon alloc] init];
        dude.weapon.damage = 4;
        dude.weapon.element = elements[arc4random()%3];
        [characters addObject:dude];
    }

    level.characters = characters;

    return level;
}

+ (void)setupTerrainForLevel:(WorldLevel *)level
{
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
        if (y >= level.levelSize.height) {
            continue;
        }
        for (int x=0; x<32; x++) {
            if (x >= level.levelSize.width) {
                continue;
            }
            char type = [terrain characterAtIndex:y*32+x];
            if (type == 'N') {
                level.terrainTiles[x][y] = [TerrainTile blockedTile];
            } else {
                level.terrainTiles[x][y] = [TerrainTile emptyTile];
            }
        }
    }
}

@end
