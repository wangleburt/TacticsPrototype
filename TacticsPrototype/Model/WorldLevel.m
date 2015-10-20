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
@property (nonatomic) CGSize nativeMapSize;

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
    level.levelSize = (CGSize){29,20};
    [self setupTerrainForLevel:level levelPreset:LevelPreset_Plains];

    NSMutableArray *characters = [NSMutableArray array];

    Character *player = [[Character alloc] init];
    player.characterClass = [ContentManager contentWithKey:@"class_mage"];
    player.position = (WorldPoint){3,2};
    player.team = CharacterTeam_Player;
    player.level = 1;
    player.key = @"player1";
    player.weapon = [[Weapon alloc] init];
    player.weapon.element = [ContentManager contentWithKey:@"element_fire"];
    [characters addObject:player];
    
    NSArray *classOrder = @[@"class_soldier", @"class_soldier", @"class_soldier",
                            @"class_archer",  @"class_archer",  @"class_archer",
                            @"class_mage",    @"class_mage",    @"class_mage",
                            @"class_thief",   @"class_thief",   @"class_thief"];

    NSMutableArray *positions = [NSMutableArray array];
    [positions addObject:[NSValue valueWithWorldPoint:(WorldPoint){1,1}]];
    [positions addObject:[NSValue valueWithWorldPoint:(WorldPoint){1,2}]];
    [positions addObject:[NSValue valueWithWorldPoint:(WorldPoint){1,3}]];

    [positions addObject:[NSValue valueWithWorldPoint:(WorldPoint){2,4}]];
    [positions addObject:[NSValue valueWithWorldPoint:(WorldPoint){3,4}]];
    [positions addObject:[NSValue valueWithWorldPoint:(WorldPoint){4,4}]];

    [positions addObject:[NSValue valueWithWorldPoint:(WorldPoint){5,1}]];
    [positions addObject:[NSValue valueWithWorldPoint:(WorldPoint){5,2}]];
    [positions addObject:[NSValue valueWithWorldPoint:(WorldPoint){5,3}]];

    [positions addObject:[NSValue valueWithWorldPoint:(WorldPoint){2,0}]];
    [positions addObject:[NSValue valueWithWorldPoint:(WorldPoint){3,0}]];
    [positions addObject:[NSValue valueWithWorldPoint:(WorldPoint){4,0}]];

    NSArray *elements = @[[ContentManager contentWithKey:@"element_earth"],
                          [ContentManager contentWithKey:@"element_water"],
                          [ContentManager contentWithKey:@"element_fire"]];
    NSMutableArray *elementDump = [NSMutableArray arrayWithArray:elements];
    
    
    for (int i=0; i<classOrder.count && positions.count > 0; i++) {
        NSValue *position = positions[0];
        [positions removeObject:position];
    
        Character *dude = [[Character alloc] init];
        NSString *classKey = classOrder[i % classOrder.count];
        dude.characterClass = [ContentManager contentWithKey:classKey];
        dude.position = [position worldPointValue];
        dude.team = CharacterTeam_Enemy;
        dude.level = 1;
        dude.key = [NSString stringWithFormat:@"enemy%i", i+1];
        dude.weapon = [[Weapon alloc] init];
        if (elementDump.count == 0) {
            [elementDump addObjectsFromArray:elements];
        }
        WeaponElement *element = elementDump[arc4random()%elementDump.count];
        [elementDump removeObject:element];
        dude.weapon.element = element;
        [characters addObject:dude];
    }

    level.characters = characters;

    return level;
}

+ (WorldLevel *)levelWithDimensions:(CGSize)dimensions numPlayers:(int)numPlayers numEnemies:(int)numEnemies levelPreset:(LevelPreset)levelPreset
{
    WorldLevel *level = [[WorldLevel alloc] init];
    level.levelSize = dimensions;
    

    [self setupTerrainForLevel:level levelPreset:levelPreset];

    NSMutableArray *characters = [NSMutableArray array];
    NSArray *elements = @[[ContentManager contentWithKey:@"element_earth"],
                          [ContentManager contentWithKey:@"element_water"],
                          [ContentManager contentWithKey:@"element_fire"]];
    NSMutableArray *elementDump = [NSMutableArray arrayWithArray:elements];
    NSArray *classOrder = @[@"class_soldier",
                            @"class_soldier",
                            @"class_archer",
                            @"class_mage",
                            @"class_thief"];
    
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

    for (int i=0; i<numPlayers && positions.count > 0; i++) {
        NSValue *position = positions[arc4random() % positions.count];
        [positions removeObject:position];
        
        Character *dude = [[Character alloc] init];
        NSString *classKey = classOrder[i % classOrder.count];
        dude.characterClass = [ContentManager contentWithKey:classKey];
        dude.position = [position worldPointValue];
        dude.team = CharacterTeam_Player;
        dude.level = 20;
        dude.key = [NSString stringWithFormat:@"player%i", i+1];
        dude.weapon = [[Weapon alloc] init];
        if (elementDump.count == 0) {
            [elementDump addObjectsFromArray:elements];
        }
        WeaponElement *element = elementDump[arc4random()%elementDump.count];
        [elementDump removeObject:element];
        dude.weapon.element = element;
        [characters addObject:dude];
    }
    
    
    classOrder = @[@"class_grunt",
                   @"class_grunt",
                   @"class_goblin",
                   @"class_shaman",
                   @"class_rogue"];
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
    [elementDump removeAllObjects];
    
    
    for (int i=0; i<numEnemies && positions.count > 0; i++) {
        NSValue *position = positions[arc4random() % positions.count];
        [positions removeObject:position];
    
        Character *dude = [[Character alloc] init];
        NSString *classKey = classOrder[i % classOrder.count];
        dude.characterClass = [ContentManager contentWithKey:classKey];
        dude.position = [position worldPointValue];
        dude.team = CharacterTeam_Enemy;
        dude.level = 20;
        dude.key = [NSString stringWithFormat:@"enemy%i", i+1];
        dude.weapon = [[Weapon alloc] init];
        if (elementDump.count == 0) {
            [elementDump addObjectsFromArray:elements];
        }
        WeaponElement *element = elementDump[arc4random()%elementDump.count];
        [elementDump removeObject:element];
        dude.weapon.element = element;
        [characters addObject:dude];
    }

    level.characters = characters;

    return level;
}

+ (void)setupTerrainForLevel:(WorldLevel *)level levelPreset:(LevelPreset)levelPreset
{
    CGSize terrainSize;
    NSString *terrain;
    
    switch (levelPreset) {
        case LevelPreset_Rivers:
            level.mapImageFileName = @"map-rivers";
            terrainSize = (CGSize){32,16};
            terrain =
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
            break;
        
        case LevelPreset_Plains:
            level.mapImageFileName = @"map-plains";
            terrainSize = (CGSize){29,20};
            terrain =
               @"YYYYYYYYYYYYYYYYYYYYNNNNNNNNN"
                "YYYYYYYYYYYYYYYYYYYNNNNNNNNNN"
                "YYYYYYYYYYYYYYYYYYYNNNNNNNNNN"
                "YYYYYYYYYYYYYYYYYYYYNNNNNNNNN"
                "YYYYYYYYYYYYYYYYYYYYNNNNNNNNN"
                "YYNYYYYYYYYYYYYYYYYYYNNNNNNNN"
                "YNYYYYYYYYYYYYYYYYYYYYYNNNNNN"
                "NYYYYYYYYYYYYYYYYYYYYYNNNNNNN"
                "YYYYYYYYYYYYYYYYYYYYNNNYYNNNN"
                "YYYYYYYYYYYYYYYYYYYNNYYYYNNNN"
                "YYYYYYYYYYYYYYYYYYNYYYYYYNNNN"
                "YYYYYYYYYYYYYYYYYYYNYYYYYYNNN"
                "YYYYYYYYYYYYYYYYYYYYYYYYYYYNN"
                "YYYYYYYYYYYYYYYYYYYYYYYYYYYNN"
                "YYYYYYYYYYYYYYYYYYYNNYYYYYYNN"
                "YYYYYYYYYYYYYYYYYYYNNYYYYYNNN"
                "YYYYYYYYYYNNNYYYYYYNNYYYYNNNN"
                "YYYYYYYYYYNNNYYYYYYYYYYYYNNNN"
                "YYYYYYYYYYNYNYYYYYYYYYYNNNNNN"
                "YYYYYYYYYYYYYYYYYYYYYYYNNNNNN";
            break;
        
        case LevelPreset_Valley:
            level.mapImageFileName = @"map-valley";
            terrainSize = (CGSize){28,16};
            terrain =
               @"YYYYYNNNNNNNNNNNNNNNNNNNNNYY"
                "YNNNYNNNNNNNNNNNNNNNNNNNYYYY"
                "YNNNYYNNNNNNNNNNNNNNNNNNYYYY"
                "YNYNYYNNNNNNNNNNYNNNNNNYYYYY"
                "YYYYYYYNNNNNNNYYYNNNNNYYYYYY"
                "YYYYYYYNNNNNNNYYYNNNNNYYYYYY"
                "YYYYYYYYYYYYYYYYYNNNNNYYYYYY"
                "YYYYYYYYYYYYYYYYYYNNNNYYYYNY"
                "YYYYYYYYYYYYYYYYYYNYYYYYYYNY"
                "YYYYYYYYYYYYYYYYYYYYYYYYYYNN"
                "YYYYYYYYYYYYYYYYYYYYYYYNYYYY"
                "YYYYYYYYYYNNNNNNYYYYYYYYNYYY"
                "YYYYYYYYYNNNNNNNYYYYYYYYYYYY"
                "YYYYYYYYNNNNNNNNNYYYYYYYYYYY"
                "YYYYYYNNNNNNNNNNNNNNYYYYYYYY"
                "YYYYYNNNNNNNNNNNNNNNNYYYYYYY";
            break;
        
        case LevelPreset_Cross:
            level.mapImageFileName = @"map-cross";
            terrainSize = (CGSize){22,26};
            terrain =
               @"NNNYYYNNNYYNNNNYYYYYYY"
                "NNNYYYNNNYYYNNNYYYYYYY"
                "NYNYYYNYNYYNNNNYYYNNNN"
                "YYYYYYYYYYYNNNYYYNNNNN"
                "YYYYYYYYYYNNYYYYNNNNNN"
                "YYYYYYYYYYYYYYYYYYYYYN"
                "YYYYYYYYYYYYYYYYYYYYYY"
                "YYYYYYYYYYNYYYYYYYYYYY"
                "NYYYYNYYYYNNYYYYYYYYYY"
                "NNNYYNYYYYYNNYYYYYYYYY"
                "NNNYYYNYYYYYNYYYYYNYYY"
                "NNNYYYYNYYYNNNNYYYNYYY"
                "NNNNYYYYNYNNNNYNNNYYYY"
                "NNNYYYYNNNNNNNYYYYYYYY"
                "NNNNYYNNNNNNYYYYYYYNYY"
                "NNNNYYYYYYYYYNNYYYNYYY"
                "NNNNYYYYYYYYYYNYYNYYYY"
                "NNYYYYYYYYYYYYNYNYYYYY"
                "YYYYYYYYYYYYYNNYNYYYYY"
                "YYYYYYYYYYYYNNYYYYYYYY"
                "YYYYYYYYYYYYNYYYNYYYYY"
                "YYYYYYYYYYYYNYYYNYYYYY"
                "YYYYYYYYYYYYNYYYYNYYYY"
                "YYYYYYYYYYYYYYYYYNNNYY"
                "YYYYYYYYYYYNNYYYYYYYYY"
                "YYYYYYYYYYYNYYYYYYYYYY";
            break;
    }

    level.nativeMapSize = terrainSize;
    level.terrainTiles = [[TerrainMap alloc] initWithDimensions:level.levelSize];
    for (int y=0; y<terrainSize.height && y<level.levelSize.height; y++) {
        for (int x=0; x<terrainSize.width && x<level.levelSize.width; x++) {
            char type = [terrain characterAtIndex:y*terrainSize.width+x];
            if (type == 'N') {
                level.terrainTiles[x][y] = [TerrainTile blockedTile];
            } else {
                level.terrainTiles[x][y] = [TerrainTile emptyTile];
            }
        }
    }
}

@end
