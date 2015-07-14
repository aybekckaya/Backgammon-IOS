//
//  DicePair.m
//  Backgammon
//
//  Created by aybek can kaya on 22/06/15.
//  Copyright (c) 2015 aybek can kaya. All rights reserved.
//

#import "DicePair.h"

@implementation DicePair

+(id)sharedDicePair
{
    static DicePair *shared = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    
    return shared;
}

-(id)init
{
    if(self = [super init])
    {
        
    }
    
    return self;
}

-(void)setUpWithDiceValueOne:(int)diceValue1 diceValueTwo:(int)diceValue2
{
    Dice *dice1 = [[Dice alloc]init];
    [dice1 setTheDiceValue:diceValue1];
    
    Dice *dice2 = [[Dice alloc]init];
    [dice2 setTheDiceValue:diceValue2];
    
    isPair = NO;
    if(dice1.diceValue == dice2.diceValue)
    {
        isPair = YES;
    }
    
    dicesArr = [[NSArray alloc]initWithObjects:dice1, dice2 , nil];
}


-(void)throwDicePair
{
    
    Dice *dice1 = [[Dice alloc]init];
    dice1.isPlayed = NO;
    int val = [dice1 throwDice];
    [dice1 setTheDiceValue:val];
    
    Dice *dice2 = [[Dice alloc]init];
    dice2.isPlayed = NO;
    val = [dice2 throwDice];
    [dice2 setTheDiceValue:val];
    
    isPair = NO;
    if(dice1.diceValue == dice2.diceValue)
    {
       isPair=YES;
    }
    
    dicesArr = [[NSArray alloc]initWithObjects:dice1,dice2, nil];
}

-(BOOL)isDicePairIsPair
{
    return isPair;
}

-(NSArray *)getCurrentDicesArray
{
    return dicesArr;
}

-(int)totalPointOfPlayedDices
{
    int point = 0;
    
    if(isPair == YES)
    {
        // look at half pair side also
        
        for(int i = 0 ; i < dicesArr.count ; i++)
        {
            Dice *theDice = dicesArr[i];
            if(theDice.isHalfPlayed)
            {
                point += 1;
            }
            else if(theDice.isPlayed)
            {
                point += 2;
            }
        }
    }
    else
    {
        for(int i =0 ; i<dicesArr.count ; i++)
        {
             Dice *theDice = dicesArr[i];
             if(theDice.isPlayed)
             {
                 point += 2;
             }
        }
    }
    
    
    return point;
}


-(NSDictionary *)toDictionary
{
    NSMutableDictionary *dctMute = [[NSMutableDictionary alloc]init];
    
    NSDictionary *dctDice1 = [self.dice1 toDictionary];
    NSDictionary *dctDice2 = [self.dice2 toDictionary];
    
    NSArray *arrDices = [[NSArray alloc]initWithObjects:dctDice1,dctDice2, nil];
    [dctMute setObject:arrDices forKey:DICE_PAIR_DICE_ARRAY_KEY];
    
    return [[NSDictionary alloc]initWithDictionary:dctMute];
}

-(void)setUpWithDicePairDictionary:(NSDictionary *)dicePairDictionary
{
    NSArray *dicePairArr = dicePairDictionary[DICE_PAIR_DICE_ARRAY_KEY];
    
    Dice *dice1 = [[Dice alloc]init];
    Dice *dice2 = [[Dice alloc]init];
    
    [dice1 setUpWithDictionary:dicePairArr[0]];
    [dice2 setUpWithDictionary:dicePairArr[1]];
    
    isPair = NO;
    if(dice1.diceValue == dice2.diceValue)
    {
        isPair = YES;
    }
    
    dicesArr = [[NSArray alloc]initWithObjects:dice1,dice2, nil];
}


-(int)remainingPointFromDices
{
  
    
    Dice *dice1 = dicesArr[0];
    Dice *dice2 = dicesArr[1];
    
    if(isPair == YES)
    {
        int totalNumberOfPlayed = [self totalPointOfPlayedDices];
        int fullPoint = dice1.diceValue * 4;
        
        int remaining = fullPoint - totalNumberOfPlayed*dice1.diceValue;
        return remaining;
    }
    else
    {
        int playedPoint = 0;
        int fullPoint = dice1.diceValue + dice2.diceValue;
        if(dice1.isPlayed == YES)
        {
            playedPoint += dice1.diceValue;
        }
        
        if(dice2.isPlayed == YES)
        {
            playedPoint += dice2.diceValue;
        }
        
        int remaining = fullPoint - playedPoint;
        
        return remaining;
    }
    
    return 0;
}


-(BOOL)isAllDicesPlayed
{
   if([self totalPointOfPlayedDices] == 4)
   {
       return YES;
   }
    
    return NO;
}


-(NSArray *)getCurrentRawDiceValues
{
    Dice *dice1 = dicesArr[0];
    Dice *dice2 = dicesArr[1];
    
    int dice1Value = dice1.diceValue;
    int dice2Value = dice2.diceValue;
    
    
    return [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:dice1Value], [NSNumber numberWithInt:dice2Value], nil];
}



-(NSArray *)playingOptions
{
    if([self isAllDicesPlayed] == YES)
    {
        return [[NSArray alloc]init];
    }
    
    NSMutableArray *optionsPlayingIntegerValues = [[NSMutableArray alloc]init];
    
    Dice *dice1 = dicesArr[0];
    Dice *dice2 = dicesArr[1];
    
    if(isPair == YES)
    {
        int fullPointOfCurrentDicePair = dice1.diceValue * 4;
        int playedPoints = [self totalPointOfPlayedDices];
        
        int remainingPoints = fullPointOfCurrentDicePair - playedPoints*dice1.diceValue;
        
        int divisionPoint = remainingPoints / dice1.diceValue;
        [optionsPlayingIntegerValues addObject:[NSNumber numberWithInt:remainingPoints]];
        
        while (divisionPoint > 1)
        {
            remainingPoints -= dice1.diceValue;
            divisionPoint = remainingPoints / dice1.diceValue;
            
            [optionsPlayingIntegerValues addObject:[NSNumber numberWithInt:remainingPoints]];
        }
        
    }
    else
    {
        int fullPointOfCurrentDicePair = dice1.diceValue + dice2.diceValue;
        int remainingPoint = [self remainingPointFromDices];
        
        if(remainingPoint == fullPointOfCurrentDicePair)
        {
            [optionsPlayingIntegerValues addObject:[NSNumber numberWithInt:fullPointOfCurrentDicePair]];
            [optionsPlayingIntegerValues addObject:[NSNumber numberWithInt:dice1.diceValue]];
            [optionsPlayingIntegerValues addObject:[NSNumber numberWithInt:dice2.diceValue]];
        }
        else
        {
           [optionsPlayingIntegerValues addObject:[NSNumber numberWithInt:remainingPoint]];
        }
    }
    
    
   [optionsPlayingIntegerValues sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
    
       int object1Integer = [obj1 intValue];
       int object2Integer = [obj2 intValue];
       
       return object1Integer > object2Integer;
    }];
    
    return [[NSArray alloc]initWithArray:optionsPlayingIntegerValues];
}


-(void)diceValueHasPlayed:(int)latestPlayedDiceValue
{
   // NSMutableArray *diceArrayMutable = [[NSMutableArray alloc]initWithArray:dicesArr];
   
    Dice *dice1 = dicesArr[0];
    Dice *dice2 = dicesArr[1];
    
    if(isPair == YES)
    {
       
        NSAssert(latestPlayedDiceValue%dice1.diceValue == 0, @"This dice value can not be played");
        
        
        int numberOfPlayedDiceInLastMovement = latestPlayedDiceValue/dice1.diceValue; // between 1 - 4
        
        for(int i =0 ; i<numberOfPlayedDiceInLastMovement ; i++)
        {
            //Dice *theDice = dicesArr[i];
          
            if(dice1.isPlayed == NO)
            {
                dice1.isHalfPlayed = YES;
            }
            else if(dice2.isPlayed == NO)
            {
                dice2.isHalfPlayed = YES;
            }
        }
        
    }
    else
    {
        int diceTotal = dice1.diceValue + dice2.diceValue;
        
        if(latestPlayedDiceValue == diceTotal)
        {
            // all played
            dice1.isPlayed = YES;
            dice2.isPlayed = YES;
        }
        else if(latestPlayedDiceValue != diceTotal)
        {
            if(dice2.diceValue == latestPlayedDiceValue)
            {
                dice2.isPlayed = YES;
            }
            else
            {
                dice1.isPlayed = YES;
            }
        }
        else
        {
            // Assert
        }
    }
    
    
    dicesArr = [[NSArray alloc]initWithObjects:dice1,dice2, nil];
}


#pragma mark GETTERS 

-(Dice *)dice1
{
    return dicesArr[0];
}


-(Dice *)dice2
{
    return dicesArr[1];
}

@end
