//
//  Dice.m
//  Backgammon
//
//  Created by aybek can kaya on 22/06/15.
//  Copyright (c) 2015 aybek can kaya. All rights reserved.
//

#import "Dice.h"
#import "NSObject+KJSerializer.h"

@implementation Dice


-(NSDictionary *)toDictionary
{
    NSMutableDictionary *dctDice = [self getDictionary];
    return [[NSDictionary alloc]initWithDictionary:dctDice];
}

-(void)setUpWithDictionary:(NSDictionary *)dctDice
{
    value = [dctDice[@"diceValue"] intValue];
    
    BOOL isPlayed = [dctDice[@"isPlayed"] boolValue];
    BOOL isHalfPlayed = [dctDice[@"isHalfPlayed"] boolValue];
    
    [self setUpWithConditionsIsPlayed:isPlayed isHalfPlayed:isHalfPlayed];
}



-(int)throwDice
{
    return 1+arc4random()%6;
}

-(void)setTheDiceValue:(int)theValue
{
    value = theValue;
}

-(void)setUpWithConditionsIsPlayed:(BOOL)isPlayed isHalfPlayed:(BOOL)isHalfPlayed
{
    _isHalfPlayed = isHalfPlayed;
    _isPlayed = isPlayed;
}

-(int)getDiceValue
{
    return value;
}

#pragma mark SETTERS 

-(void)setIsPlayed:(BOOL)isPlayed
{
    if(isPlayed == YES)
    {
        self.isHalfPlayed = NO;
    }
    
    _isPlayed = isPlayed;
}

-(void)setIsHalfPlayed:(BOOL)isHalfPlayed
{
    if(_isHalfPlayed == YES && isHalfPlayed == YES)
    {
        // new value is also true
        
        _isHalfPlayed = NO;
        self.isPlayed = YES;
    }
    else
    {
        _isHalfPlayed = isHalfPlayed;
    }
}

#pragma mark GETTERS 

-(int) diceValue
{
    
    
    return value;
}


@end
