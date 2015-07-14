//
//  GamePlaySaveStock.m
//  Backgammon
//
//  Created by aybek can kaya on 15/06/15.
//  Copyright (c) 2015 aybek can kaya. All rights reserved.
//

#import "GamePlaySaveStock.h"

@implementation GamePlaySaveStock

-(void)saveBoards:(NSDictionary *)boardDictionary
{
    if(IS_TESTING_FRAME_LOCATIONING == 1)
    {
        NSArray *allLists = [Plist allLists];
        int count = allLists.count;
        NSString *pilstName = [NSString stringWithFormat:@"%@-%d" , SAVE_STOCK_TEST_PLIST_PREFIX_NAME , count];
        Plist *listNew = [[Plist alloc] initWithPlistName:pilstName];
        [listNew write:boardDictionary Key:SAVE_STOCK_BOARD_KEY];

        
    }
    else
    {
        Plist *list = [[Plist alloc]initWithPlistName:SAVE_STOCK_PLIST_NAME];
        [list write:boardDictionary Key:SAVE_STOCK_BOARD_KEY];
    }
    
    
}



-(NSDictionary *)getBoards
{
     Plist *list = [[Plist alloc]initWithPlistName:SAVE_STOCK_PLIST_NAME];
    
    if([list keyExists:SAVE_STOCK_BOARD_KEY])
    {
        // there is a saved game
        NSDictionary *dct = [list read:SAVE_STOCK_BOARD_KEY];
        return dct;
    }
    else if(IS_TESTING_GAME_END == 1)
    {
        NSMutableDictionary *dctMute = [[NSMutableDictionary alloc]init];
        
        // whites
        
        [dctMute setObject:@{FLAKEVIEW_DICTIONARY_NUMBER_OF_FLAKES_KEY : @"1" , FLAKEVIEW_DICTIONARY_TYPE_OF_FLAKE_KEY : @"0"} forKey:[NSNumber numberWithInt:21]];
        
        
        // blacks
        
        [dctMute setObject:@{FLAKEVIEW_DICTIONARY_NUMBER_OF_FLAKES_KEY : @"1" , FLAKEVIEW_DICTIONARY_TYPE_OF_FLAKE_KEY : @"1"} forKey:[NSNumber numberWithInt:5]];
        
      
        
        
        // Camping and flunk Areas
        [dctMute setObject:@{FLAKEVIEW_DICTIONARY_NUMBER_OF_FLAKES_KEY : @"0" , FLAKEVIEW_DICTIONARY_TYPE_OF_FLAKE_KEY : @"0"} forKey:[NSNumber numberWithInt:24]];
        
        [dctMute setObject:@{FLAKEVIEW_DICTIONARY_NUMBER_OF_FLAKES_KEY : @"0" , FLAKEVIEW_DICTIONARY_TYPE_OF_FLAKE_KEY : @"1"} forKey:[NSNumber numberWithInt:25]];
        
        [dctMute setObject:@{FLAKEVIEW_DICTIONARY_NUMBER_OF_FLAKES_KEY : @"14" , FLAKEVIEW_DICTIONARY_TYPE_OF_FLAKE_KEY : @"0"} forKey:[NSNumber numberWithInt:26]];
        
        [dctMute setObject:@{FLAKEVIEW_DICTIONARY_NUMBER_OF_FLAKES_KEY : @"14" , FLAKEVIEW_DICTIONARY_TYPE_OF_FLAKE_KEY : @"1"} forKey:[NSNumber numberWithInt:27]];
        
        NSDictionary *dct = [[NSDictionary alloc]initWithDictionary:dctMute];
        
        return dct;
    }
    else if(IS_TESTING_COLLECTING == 1)
    {
        NSMutableDictionary *dctMute = [[NSMutableDictionary alloc]init];
        
        // whites
        
        [dctMute setObject:@{FLAKEVIEW_DICTIONARY_NUMBER_OF_FLAKES_KEY : @"2" , FLAKEVIEW_DICTIONARY_TYPE_OF_FLAKE_KEY : @"0"} forKey:[NSNumber numberWithInt:21]];
        
        [dctMute setObject:@{FLAKEVIEW_DICTIONARY_NUMBER_OF_FLAKES_KEY : @"5" , FLAKEVIEW_DICTIONARY_TYPE_OF_FLAKE_KEY : @"0"} forKey:[NSNumber numberWithInt:20]];
        
        
        [dctMute setObject:@{FLAKEVIEW_DICTIONARY_NUMBER_OF_FLAKES_KEY : @"3" , FLAKEVIEW_DICTIONARY_TYPE_OF_FLAKE_KEY : @"0"} forKey:[NSNumber numberWithInt:19]];
        
        [dctMute setObject:@{FLAKEVIEW_DICTIONARY_NUMBER_OF_FLAKES_KEY : @"5" , FLAKEVIEW_DICTIONARY_TYPE_OF_FLAKE_KEY : @"0"} forKey:[NSNumber numberWithInt:18]];
        
        
        // blacks
        
        [dctMute setObject:@{FLAKEVIEW_DICTIONARY_NUMBER_OF_FLAKES_KEY : @"5" , FLAKEVIEW_DICTIONARY_TYPE_OF_FLAKE_KEY : @"1"} forKey:[NSNumber numberWithInt:5]];
        
        [dctMute setObject:@{FLAKEVIEW_DICTIONARY_NUMBER_OF_FLAKES_KEY : @"3" , FLAKEVIEW_DICTIONARY_TYPE_OF_FLAKE_KEY : @"1"} forKey:[NSNumber numberWithInt:4]];
        
        
        [dctMute setObject:@{FLAKEVIEW_DICTIONARY_NUMBER_OF_FLAKES_KEY : @"5" , FLAKEVIEW_DICTIONARY_TYPE_OF_FLAKE_KEY : @"1"} forKey:[NSNumber numberWithInt:3]];
        
        [dctMute setObject:@{FLAKEVIEW_DICTIONARY_NUMBER_OF_FLAKES_KEY : @"2" , FLAKEVIEW_DICTIONARY_TYPE_OF_FLAKE_KEY : @"1"} forKey:[NSNumber numberWithInt:2]];
        
        
        // Camping and flunk Areas
        [dctMute setObject:@{FLAKEVIEW_DICTIONARY_NUMBER_OF_FLAKES_KEY : @"0" , FLAKEVIEW_DICTIONARY_TYPE_OF_FLAKE_KEY : @"0"} forKey:[NSNumber numberWithInt:24]];
        
        [dctMute setObject:@{FLAKEVIEW_DICTIONARY_NUMBER_OF_FLAKES_KEY : @"0" , FLAKEVIEW_DICTIONARY_TYPE_OF_FLAKE_KEY : @"1"} forKey:[NSNumber numberWithInt:25]];
        
        [dctMute setObject:@{FLAKEVIEW_DICTIONARY_NUMBER_OF_FLAKES_KEY : @"0" , FLAKEVIEW_DICTIONARY_TYPE_OF_FLAKE_KEY : @"0"} forKey:[NSNumber numberWithInt:26]];
        
        [dctMute setObject:@{FLAKEVIEW_DICTIONARY_NUMBER_OF_FLAKES_KEY : @"0" , FLAKEVIEW_DICTIONARY_TYPE_OF_FLAKE_KEY : @"1"} forKey:[NSNumber numberWithInt:27]];
        
        NSDictionary *dct = [[NSDictionary alloc]initWithDictionary:dctMute];
        
        return dct;

    }
    else
    {
        // set up init positions
        
        NSMutableDictionary *dctMute = [[NSMutableDictionary alloc]init];
        
        // whites
        
        [dctMute setObject:@{FLAKEVIEW_DICTIONARY_NUMBER_OF_FLAKES_KEY : @"2" , FLAKEVIEW_DICTIONARY_TYPE_OF_FLAKE_KEY : @"0"} forKey:[NSNumber numberWithInt:0]];
        
        [dctMute setObject:@{FLAKEVIEW_DICTIONARY_NUMBER_OF_FLAKES_KEY : @"5" , FLAKEVIEW_DICTIONARY_TYPE_OF_FLAKE_KEY : @"0"} forKey:[NSNumber numberWithInt:11]];
        
        
        [dctMute setObject:@{FLAKEVIEW_DICTIONARY_NUMBER_OF_FLAKES_KEY : @"3" , FLAKEVIEW_DICTIONARY_TYPE_OF_FLAKE_KEY : @"0"} forKey:[NSNumber numberWithInt:16]];
        
        [dctMute setObject:@{FLAKEVIEW_DICTIONARY_NUMBER_OF_FLAKES_KEY : @"5" , FLAKEVIEW_DICTIONARY_TYPE_OF_FLAKE_KEY : @"0"} forKey:[NSNumber numberWithInt:18]];
        
        
        // blacks
        
        [dctMute setObject:@{FLAKEVIEW_DICTIONARY_NUMBER_OF_FLAKES_KEY : @"5" , FLAKEVIEW_DICTIONARY_TYPE_OF_FLAKE_KEY : @"1"} forKey:[NSNumber numberWithInt:5]];
        
        [dctMute setObject:@{FLAKEVIEW_DICTIONARY_NUMBER_OF_FLAKES_KEY : @"3" , FLAKEVIEW_DICTIONARY_TYPE_OF_FLAKE_KEY : @"1"} forKey:[NSNumber numberWithInt:7]];
        
        
        [dctMute setObject:@{FLAKEVIEW_DICTIONARY_NUMBER_OF_FLAKES_KEY : @"5" , FLAKEVIEW_DICTIONARY_TYPE_OF_FLAKE_KEY : @"1"} forKey:[NSNumber numberWithInt:12]];
        
        [dctMute setObject:@{FLAKEVIEW_DICTIONARY_NUMBER_OF_FLAKES_KEY : @"2" , FLAKEVIEW_DICTIONARY_TYPE_OF_FLAKE_KEY : @"1"} forKey:[NSNumber numberWithInt:23]];

        
        // Camping and flunk Areas
          [dctMute setObject:@{FLAKEVIEW_DICTIONARY_NUMBER_OF_FLAKES_KEY : @"0" , FLAKEVIEW_DICTIONARY_TYPE_OF_FLAKE_KEY : @"0"} forKey:[NSNumber numberWithInt:24]];
        
         [dctMute setObject:@{FLAKEVIEW_DICTIONARY_NUMBER_OF_FLAKES_KEY : @"0" , FLAKEVIEW_DICTIONARY_TYPE_OF_FLAKE_KEY : @"1"} forKey:[NSNumber numberWithInt:25]];
        
         [dctMute setObject:@{FLAKEVIEW_DICTIONARY_NUMBER_OF_FLAKES_KEY : @"0" , FLAKEVIEW_DICTIONARY_TYPE_OF_FLAKE_KEY : @"0"} forKey:[NSNumber numberWithInt:26]];
        
         [dctMute setObject:@{FLAKEVIEW_DICTIONARY_NUMBER_OF_FLAKES_KEY : @"0" , FLAKEVIEW_DICTIONARY_TYPE_OF_FLAKE_KEY : @"1"} forKey:[NSNumber numberWithInt:27]];
        
        NSDictionary *dct = [[NSDictionary alloc]initWithDictionary:dctMute];

        return dct;
    }
    
    
    return nil;
}


-(void)saveDices:(NSDictionary *)diceDictionary
{
    Plist *list = [[Plist alloc]initWithPlistName:SAVE_STOCK_PLIST_NAME];
    [list write:diceDictionary Key:SAVE_STOCK_DICE_KEY];
}


-(NSDictionary *)getDices
{
     Plist *list = [[Plist alloc]initWithPlistName:SAVE_STOCK_PLIST_NAME];
    if(![list keyExists:SAVE_STOCK_DICE_KEY])
    {
        return nil;
    }
    
    NSDictionary *diceDct = [list read:SAVE_STOCK_DICE_KEY];
    
    return diceDct;
}

-(void)saveGame:(NSDictionary *)gameDictionary
{
    Plist *list = [[Plist alloc]initWithPlistName:SAVE_STOCK_PLIST_NAME];
    [list write:gameDictionary Key:SAVE_STOCK_GAME_KEY];

}


-(NSDictionary *)getGame
{
    Plist *list = [[Plist alloc]initWithPlistName:SAVE_STOCK_PLIST_NAME];
    if(![list keyExists:SAVE_STOCK_GAME_KEY])
    {
        return nil;
    }
    
    NSDictionary *diceDct = [list read:SAVE_STOCK_GAME_KEY];
    
    return diceDct;
}


-(void)saveDicePair:(NSDictionary *)dicePairDct
{
    Plist *list = [[Plist alloc]initWithPlistName:SAVE_STOCK_PLIST_NAME];
    [list write:dicePairDct Key:SAVE_STOCK_DICE_PAIR_KEY];
}


-(NSDictionary * )getDicePair
{
    Plist *list = [[Plist alloc]initWithPlistName:SAVE_STOCK_PLIST_NAME];
    if(![list keyExists:SAVE_STOCK_DICE_PAIR_KEY])
    {
        return nil;
    }
    
    NSDictionary *diceDct = [list read:SAVE_STOCK_DICE_PAIR_KEY];
    
    return diceDct;
}


-(void)removeAllContent
{
     Plist *list = [[Plist alloc]initWithPlistName:SAVE_STOCK_PLIST_NAME];
    [list removeAllObjects];
}


-(NSArray *) getBoardsDictionariesForTesting
{
    NSArray *lists = [Plist allLists];
    
    NSMutableArray *filteredLists = [[NSMutableArray alloc]init];
    
    for(Plist *list in lists)
    {
        NSString *name = [list plistNameOfInstance];
        
        if([name containsString:SAVE_STOCK_TEST_PLIST_PREFIX_NAME])
        {
            [filteredLists addObject:list];
        }
    }
 
    return [[NSArray alloc]initWithArray:filteredLists];
}


@end
