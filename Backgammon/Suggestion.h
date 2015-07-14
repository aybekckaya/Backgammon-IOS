//
//  Suggestion.h
//  Backgammon
//
//  Created by aybek can kaya on 15/06/15.
//  Copyright (c) 2015 aybek can kaya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Suggestion : NSObject
{
    
}

@property(nonatomic) int fromBoardIndex;
@property(nonatomic) int toBoardIndex;

/**
   hangi dice lar oynanırsa from -> to alanına gidebilir
  Örnek : 5-3 geldi ve iki zar birlikte kullanılacak o zaman dicePTrequired -> 8 olur.
 */
@property(nonatomic) int dicePointRequired;


/**
     dynamic value that holds when user play this suggestion 
 */
@property(nonatomic) int playingTurn;

@end
