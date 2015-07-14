//
//  ViewController.h
//  Backgammon
//
//  Created by aybek can kaya on 15/06/15.
//  Copyright (c) 2015 aybek can kaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameView.h"
#import "Game.h"

#import "TriangleView.h"

@interface ViewController : UIViewController<GameViewDelegate,GameViewDatasource>
{
    Game *currentGame;
}

@property(nonatomic,weak) IBOutlet GameView *viewGame;


- (IBAction)undoOnTap:(id)sender;


@end

/**
 #define UNDO_PLIST_NAME @"undoList"
 
 #define GAMES_ARRAY_NAME @"gamesArray"
 
 #define SAVE_STOCK_PLIST_NAME @"savedStock"
 #define SAVE_STOCK_BOARD_KEY @"board"
 
 #define SAVE_STOCK_TEST_PLIST_PREFIX_NAME @"testerStock"
 //#define SAVE_STOCK_TEST_PLIST_PREFIX_NAME @"testerStock"
 
 #define SAVE_STOCK_DICE_KEY @"diceSaveStock"
 
 #define SAVE_STOCK_GAME_KEY @"gameSaveStock"
 
 #define SAVE_STOCK_DICE_PAIR_KEY @"dicePairSaveStock"
 
 
 */