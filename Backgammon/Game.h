//
//  Game.h
//  Backgammon
//
//  Created by aybek can kaya on 15/06/15.
//  Copyright (c) 2015 aybek can kaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"
#import "Board.h"
#import "DicePair.h"

//#define GAME_DCT_KEY @"gameSavedStock"
#define GAME_PLAYERS_ARRAY_KEY @"playersArray"
#define GAME_CURRENT_PLAYER_COLOR_KEY @"currentPlayerColor"


@interface Game : NSObject
{
    NSArray *players;
    
    // dynamics
    Player *currentPlayer;
    NSMutableArray *currentDiceValues; // use for AI
    NSArray *allFlakeLocationIDsOfCurrentPlayer; // use for AI
}

-(id)initWithPlayers:(NSArray *)playersArr;

-(id)initWithGameDictionary:(NSDictionary *)dctGame;

-(void)changeTurn;

-(Player *)currentPlayerWhoHasTurn;

-(Player *)playerByColor:(colorType) playerColor;

-(NSDictionary *)toDictionary;


#pragma mark Suggestions

/**
   current dices has determined at DicePair.h . If player has tapped roll button . This method will called asyncronously. 
 @return : true if any flake can be moved with current dice Values
 */
-(BOOL)isPlayerCanPlayWithCurrentDices;


-(BOOL)isPlayerCanContinueToPlayWithCurrentDices;

/**
    @return: suggestion array which includes playable board indexes
 */
-(NSArray *)suggestionsFromBoardLocation:(BoardLocation *)fromLocation;

-(NSArray *)convertRawSuggestionValues:(NSArray *)arrSuggestionRawValues toSuggestionObjectsFromLocation:(BoardLocation *)fromLocation;






@end
