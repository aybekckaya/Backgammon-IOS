//
//  Dice.h
//  Backgammon
//
//  Created by aybek can kaya on 22/06/15.
//  Copyright (c) 2015 aybek can kaya. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Dice : NSObject
{
    int value;
}

@property(nonatomic,assign) BOOL isPlayed;
@property(nonatomic , assign) BOOL isHalfPlayed ; // use for paired dices
//@property(nonatomic) int playingTurn ; // kacıncı sırada oynandı

@property(nonatomic,readonly) int diceValue;

/**
   @return : value between 1-6
 */
-(int)throwDice;

/**
   Look at dice Tests
 */
-(void)setTheDiceValue:(int) theValue;

/**
   Look at dice Tests
 */
-(void)setUpWithConditionsIsPlayed:(BOOL) isPlayed isHalfPlayed:(BOOL)isHalfPlayed;



//-(int)getDiceValue;


-(NSDictionary *)toDictionary;

-(void)setUpWithDictionary:(NSDictionary *)dctDice;


@end
