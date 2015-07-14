//
//  DicePair.h
//  Backgammon
//
//  Created by aybek can kaya on 22/06/15.
//  Copyright (c) 2015 aybek can kaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dice.h"

#define DICE_PAIR_DICE_ARRAY_KEY @"dicesArray"

@interface DicePair : NSObject
{
    NSArray *dicesArr; // includes 2 dice objects
    BOOL isPair;
}

@property(nonatomic , readonly) Dice *dice1;
@property(nonatomic, readonly) Dice *dice2;

+(id)sharedDicePair;

/**
   Look at dice Tests
 */
-(void)setUpWithDiceValueOne:(int) diceValue1 diceValueTwo :(int) diceValue2;


-(void) setUpWithDicePairDictionary:(NSDictionary *)dicePairDictionary;


-(NSDictionary *)toDictionary;

/**
 @description : will set dice array
 */
-(void)throwDicePair;

/**
   çift mi gelmiş
 */
-(BOOL)isDicePairIsPair;

/**
   if all dices has played returns 4 .
 */
-(int)totalPointOfPlayedDices;


-(int)remainingPointFromDices;



-(BOOL)isAllDicesPlayed;


/**
   @return : 2 Dice objects
 */
-(NSArray *)getCurrentDicesArray;


/**
   @return: playing options as integer array. Example 1 : dicesAre 3-2  then playing options are (2,3,5) . At this condition if dice 3 has played before then playing options should be (2) . Example 2 : dices are 4-4 then playing options should be (4,8,12,16). if value 8 has played then playing options should be (4,8)
 */
-(NSArray *)playingOptions;


/**
   @return : 2 dice values in all conditions
 */
-(NSArray *)getCurrentRawDiceValues;

/**
    re-arranges the dice Array
 */
-(void)diceValueHasPlayed:(int) latestPlayedDiceValue;


@end
