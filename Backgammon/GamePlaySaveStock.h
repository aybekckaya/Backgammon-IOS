//
//  GamePlaySaveStock.h
//  Backgammon
//
//  Created by aybek can kaya on 15/06/15.
//  Copyright (c) 2015 aybek can kaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "Plist.h"



#define SAVE_STOCK_PLIST_NAME @"savedStock"
#define SAVE_STOCK_BOARD_KEY @"board"

#define SAVE_STOCK_TEST_PLIST_PREFIX_NAME @"testerStock"
//#define SAVE_STOCK_TEST_PLIST_PREFIX_NAME @"testerStock"

#define SAVE_STOCK_DICE_KEY @"diceSaveStock"

#define SAVE_STOCK_GAME_KEY @"gameSaveStock"

#define SAVE_STOCK_DICE_PAIR_KEY @"dicePairSaveStock"

@interface GamePlaySaveStock : NSObject
{
    
}

/*
   save Board positions with colors
 */
-(void) saveBoards:(NSDictionary *)boardDictionary;

/**
    @return: if game has saved before then this will return the saved game . If there is no game saved  return init positions of flakes
 */
-(NSDictionary *)getBoards;


-(void)saveDices:(NSDictionary *)diceDictionary;

-(NSDictionary *)getDices;


-(void)saveGame:(NSDictionary *)gameDictionary;

-(NSDictionary *)getGame;


-(void)saveDicePair:(NSDictionary *)dicePairDct;

-(NSDictionary *)getDicePair;


-(void)removeAllContent;

/**
    used For TESTING
 */
-(NSArray *)getBoardsDictionariesForTesting;


@end
