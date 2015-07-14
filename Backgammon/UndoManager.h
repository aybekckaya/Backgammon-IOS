//
//  UndoManager.h
//  Backgammon
//
//  Created by aybek can kaya on 01/07/15.
//  Copyright (c) 2015 aybek can kaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Plist.h"

#define UNDO_PLIST_NAME @"undoList"

#define GAMES_ARRAY_NAME @"gamesArray"

#define SAVE_STOCK_PLIST_NAME @"savedStock"
#define SAVE_STOCK_BOARD_KEY @"board"

#define SAVE_STOCK_TEST_PLIST_PREFIX_NAME @"testerStock"
//#define SAVE_STOCK_TEST_PLIST_PREFIX_NAME @"testerStock"

#define SAVE_STOCK_DICE_KEY @"diceSaveStock"

#define SAVE_STOCK_GAME_KEY @"gameSaveStock"

#define SAVE_STOCK_DICE_PAIR_KEY @"dicePairSaveStock"



@interface UndoManager : NSObject
{
    Plist *listUndo;
}

-(void)save:(NSDictionary *)gameAllDictionary;

-(NSDictionary *)getLatestGameDictionary;

-(void)removeAllContents;


@end
