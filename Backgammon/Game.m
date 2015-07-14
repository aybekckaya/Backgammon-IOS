//
//  Game.m
//  Backgammon
//
//  Created by aybek can kaya on 15/06/15.
//  Copyright (c) 2015 aybek can kaya. All rights reserved.
//

#import "Game.h"

@implementation Game


-(id)initWithPlayers:(NSArray *)playersArr
{
    if(self = [super init])
    {
        players = playersArr;
        currentPlayer = players[0];
    }
    
    return self;
}

-(id)initWithGameDictionary:(NSDictionary *)dctGame
{
    if(self = [super init])
    {
        NSArray *playersArr = dctGame[GAME_PLAYERS_ARRAY_KEY];
        Player *pl1 = [[Player alloc]initWithPlayerDictionary:playersArr[0]];
        Player *pl2 = [[Player alloc]initWithPlayerDictionary:playersArr[1]];
        
        players = [[NSArray alloc]initWithObjects:pl1,pl2, nil];
        
        int currentPlayerColor = [dctGame[GAME_CURRENT_PLAYER_COLOR_KEY] intValue];
        currentPlayer = players[currentPlayerColor];
    }
    
    return self;
}


-(void)changeTurn
{
    if(currentPlayer.typeColor == kBackgammomColorTypeWhite)
    {
        currentPlayer = players[1];
    }
    else if(currentPlayer.typeColor == kBackgammomColorTypeBlack)
    {
        currentPlayer = players[0];
    }
}

-(Player *)currentPlayerWhoHasTurn
{
    return currentPlayer;
}


-(Player *)playerByColor:(colorType)playerColor
{
    if(playerColor == kBackgammomColorTypeWhite)
    {
        return players[0];
    }
    else
    {
        return players[1];
    }
    
    return nil;
}


-(NSDictionary *)toDictionary
{
    NSMutableDictionary *dctMute = [[NSMutableDictionary alloc]init];
    
    Player *pl1 = players[0];
    NSDictionary *dctPlayerOne = [pl1 toDictionary];
    
    Player *pl2 = players[1];
    NSDictionary *dctPlayerTwo = [pl2 toDictionary];
    
    NSArray *playersArr = [[NSArray alloc]initWithObjects:dctPlayerOne,dctPlayerTwo, nil];
    [dctMute setObject:playersArr forKey:GAME_PLAYERS_ARRAY_KEY];
    
    colorType typeColorCurrPlayer = currentPlayer.typeColor;
    [dctMute setObject:[NSNumber numberWithInt:typeColorCurrPlayer] forKey:GAME_CURRENT_PLAYER_COLOR_KEY];
    
    return [[NSDictionary alloc]initWithDictionary:dctMute];
}


#pragma mark Suggestions

-(BOOL)isPlayerCanPlayWithCurrentDices
{
    colorType currentPlayerColor = currentPlayer.typeColor;
    Board *sharedBoard = [Board sharedBoard];
    NSArray *allFlakes = [sharedBoard allFlakeLocationsForFlakeColor:currentPlayerColor];
    
    DicePair *pairDices = [DicePair sharedDicePair];
    //NSArray *playingOptionsOfCurrentDices = [pairDices playingOptions];
    int dice1Value = pairDices.dice1.diceValue;
    int dice2Value = pairDices.dice2.diceValue;
    
    NSArray *diceValues = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:dice1Value], [NSNumber numberWithInt:dice2Value], nil];
    
    // Check flunk condition
    
    BoardLocation *locationFlunk;
    int dice1Index , dice2Index;
    if(currentPlayerColor == kBackgammomColorTypeWhite)
    {
        locationFlunk = [sharedBoard boardLocationForWhiteFlunkArea];
        locationFlunk.typeOfColor = kBackgammomColorTypeWhite;
        dice1Index = dice1Value-1;
        dice2Index = dice2Value-1;
    }
    else
    {
        locationFlunk = [sharedBoard boardLocationForBlackFlunkArea];
        locationFlunk.typeOfColor = kBackgammomColorTypeBlack;
        dice1Index = 24-dice1Value;
        dice2Index = 24-dice2Value;
    }
    
    if(![locationFlunk flakeStackIsEmpty])
    {
        
        
        if([sharedBoard isFlunkCanBePutFlunkColor:locationFlunk.typeOfColor diceValue:dice1Value] || [sharedBoard isFlunkCanBePutFlunkColor:locationFlunk.typeOfColor diceValue:dice2Value])
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    // There is no flunk . Gönder gitsin .
    for(int locationCount =0 ; locationCount < allFlakes.count ; locationCount++)
    {
        int locationIndex = [allFlakes[locationCount] intValue];
             
        if([sharedBoard isFlakeFromLocationIndex:locationIndex canBeMovedWithDiceValuesArray:diceValues] )
        {
            return YES;
        }
    }
    
    
    return NO;
}

-(BOOL)isPlayerCanContinueToPlayWithCurrentDices
{
    colorType currentPlayerColor = currentPlayer.typeColor;
    Board *sharedBoard = [Board sharedBoard];
  
    
    BoardLocation *flunkLocation = [sharedBoard flunkLocationByColor:currentPlayerColor];
    
    if(![flunkLocation flakeStackIsEmpty])
    {
        NSArray *suggestions = [self suggestionsFromBoardLocation:flunkLocation];
        if(suggestions.count == 0)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    
      NSArray *allFlakes = [sharedBoard allFlakeLocationsForFlakeColor:currentPlayerColor];
    // There is no flunk . Gönder gitsin .
    for(int locationCount =0 ; locationCount < allFlakes.count ; locationCount++)
    {
         int locationIndex = [allFlakes[locationCount] intValue];
        BoardLocation *fromLocation = [sharedBoard boardLocationFromIndex:locationIndex];
        NSArray *suggestions = [self suggestionsFromBoardLocation:fromLocation];
        if(suggestions.count > 0)
        {
            return YES;
        }
    }
    
    return NO;
}


-(NSArray *)suggestionsFromBoardLocation:(BoardLocation *)fromLocation
{
    NSMutableArray *suggestionsArr = [[NSMutableArray alloc]init];

    Board *sharedBoard = [Board sharedBoard];
    DicePair *pairDice = [DicePair sharedDicePair];
    NSArray *playingOptions = [pairDice playingOptions];
    
    colorType typeColorFromLocation = fromLocation.typeOfColor;
    colorType oppositeColor;
    
    if(typeColorFromLocation == kBackgammomColorTypeBlack)
    {
        oppositeColor = kBackgammomColorTypeWhite;
    }
    else
    {
        oppositeColor = kBackgammomColorTypeBlack;
    }
    
    // there is no flake at from location
    if([fromLocation flakeStackIsEmpty])
    {
        return [[NSArray alloc]init];
    }
    
    // if there is a flunk then user should touch that area
    if([sharedBoard isPlayerColorHasFlunkPlayerColor:typeColorFromLocation])
    {
        BoardLocation *flunkLocation = [sharedBoard flunkLocationByColor:typeColorFromLocation];
       
        if(flunkLocation.locationID != fromLocation.locationID)
        {
            // flunk location have not touched
             return [[NSArray alloc]init];
        }
        else
        {
            
            if([pairDice isDicePairIsPair])
            {
                int diceValue = pairDice.dice1.diceValue;
                if([sharedBoard isFlunkCanBePutFlunkColor:typeColorFromLocation diceValue:diceValue])
                {
                    int indexTo = [sharedBoard locationIndexForColor:typeColorFromLocation fromLocationIndex:fromLocation.locationID diceValue:diceValue];
                    if(indexTo != -1)
                    {
                        [suggestionsArr addObject:[NSNumber numberWithInt:indexTo]];
                    }
                }
            }
            else
            {
                int diceValue1= pairDice.dice1.diceValue;
                int diceValue2 = pairDice.dice2.diceValue;
                
                
                if([sharedBoard isFlunkCanBePutFlunkColor:typeColorFromLocation diceValue:diceValue1])
                {
                    int indexTo = [sharedBoard locationIndexForColor:typeColorFromLocation fromLocationIndex:fromLocation.locationID diceValue:diceValue1];
                    if(indexTo != -1)
                    {
                        if(pairDice.dice1.isPlayed == NO)
                        {
                             [suggestionsArr addObject:[NSNumber numberWithInt:indexTo]];
                        }
                        
                       
                    }
                }
                
                if([sharedBoard isFlunkCanBePutFlunkColor:typeColorFromLocation diceValue:diceValue2])
                {
                    int indexTo = [sharedBoard locationIndexForColor:typeColorFromLocation fromLocationIndex:fromLocation.locationID diceValue:diceValue2];
                    if(indexTo != -1)
                    {
                        if(pairDice.dice2.isPlayed == NO)
                        {
                              [suggestionsArr addObject:[NSNumber numberWithInt:indexTo]];
                        }
                        
                      
                    }
                }
                
            }
            
            return [[NSArray alloc]initWithArray:suggestionsArr];
        }
    }
    
    
    // usual playing
    
    if([pairDice isDicePairIsPair])
    {
        // dices paired
        
        for(int i =0 ; i<playingOptions.count ; i++)
        {
            int theDiceValuePlayingOption = [playingOptions[i] intValue];
            int indexTo = [sharedBoard locationIndexForColor:typeColorFromLocation fromLocationIndex:fromLocation.locationID diceValue:theDiceValuePlayingOption];
            if(indexTo != -1)
            {
                BoardLocation *toLocation = [sharedBoard boardLocationFromIndex:indexTo];
                if([sharedBoard isLocation:toLocation playableForFlakeColor:typeColorFromLocation])
                {
                    [suggestionsArr addObject:[NSNumber numberWithInt:indexTo]];
                    
                    if([sharedBoard isFlakeAtLocationID:indexTo isFlunkableByFlakeColor:typeColorFromLocation])
                    {
                        return [[NSArray alloc]initWithArray:suggestionsArr];
                    }
                }
                else
                {
                     return [[NSArray alloc]initWithArray:suggestionsArr];
                }
            }
        }
    }
    else
    {
        // dices are not pair
        if(playingOptions.count == 0)
        {
            return [[NSArray alloc]init];
        }
        else if(playingOptions.count == 1)
        {
            int theDiceValue = [playingOptions[0] intValue];
            int indexTo = [sharedBoard locationIndexForColor:typeColorFromLocation fromLocationIndex:fromLocation.locationID diceValue:theDiceValue];
            if(indexTo != -1)
            {
                BoardLocation *locationTo = [sharedBoard boardLocationFromIndex:indexTo];
                if([sharedBoard isLocation:locationTo playableForFlakeColor:typeColorFromLocation])
                {
                    [suggestionsArr addObject:[NSNumber numberWithInt:indexTo]];
                }
            }
            
        }
        else
        {
            int option1DiceValue = [playingOptions[0] intValue];
            int option2DiceValue = [playingOptions[1] intValue];
            int option3DiceValue = [playingOptions[2] intValue];
            
            int indexTo1 = [sharedBoard locationIndexForColor:typeColorFromLocation fromLocationIndex:fromLocation.locationID diceValue:option1DiceValue];
            
              int indexTo2 = [sharedBoard locationIndexForColor:typeColorFromLocation fromLocationIndex:fromLocation.locationID diceValue:option2DiceValue];
              int indexTo3 = [sharedBoard locationIndexForColor:typeColorFromLocation fromLocationIndex:fromLocation.locationID diceValue:option3DiceValue];
            
            if(indexTo1 != -1 && indexTo2 != -1)
            {
                BoardLocation *locationTo_1 = [sharedBoard boardLocationFromIndex:indexTo1];
                BoardLocation *locationTo_2 = [sharedBoard boardLocationFromIndex:indexTo2];
                
                BOOL playable_1 = [sharedBoard isLocation:locationTo_1 playableForFlakeColor:typeColorFromLocation];
                BOOL playable_2 = [sharedBoard isLocation:locationTo_2 playableForFlakeColor:typeColorFromLocation];
                
                if(playable_1 || playable_2)
                {
                    // can play the sum of these 2 dice values
                    if(indexTo3 != -1)
                    {
                        BoardLocation *locationTo_3 = [sharedBoard boardLocationFromIndex:indexTo3];
                        BOOL playable_3 = [sharedBoard isLocation:locationTo_3 playableForFlakeColor:typeColorFromLocation];
                        if(playable_3)
                        {
                            if([sharedBoard isFlakeAtLocationID:indexTo1 isFlunkableByFlakeColor:typeColorFromLocation] || [sharedBoard isFlakeAtLocationID:indexTo2 isFlunkableByFlakeColor:typeColorFromLocation])
                            {
                                
                            }
                            else
                            {
                                 [suggestionsArr addObject:[NSNumber numberWithInt:indexTo3]];
                            }
                            
                           
                        }
                    }
                    
                }
                
                if(playable_1)
                {
                    [suggestionsArr addObject:[NSNumber numberWithInt:indexTo1]];
                }
                
                if(playable_2)
                {
                    [suggestionsArr addObject:[NSNumber numberWithInt:indexTo2]];
                }
                
            }
            else
            {
                if(indexTo1 != -1)
                {
                    BoardLocation *locationTo = [sharedBoard boardLocationFromIndex:indexTo1];
                    if([sharedBoard isLocation:locationTo playableForFlakeColor:typeColorFromLocation])
                    {
                        [suggestionsArr addObject:[NSNumber numberWithInt:indexTo1]];
                    }
                }
                
                if(indexTo2 != -1)
                {
                    BoardLocation *locationTo = [sharedBoard boardLocationFromIndex:indexTo2];
                    if([sharedBoard isLocation:locationTo playableForFlakeColor:typeColorFromLocation])
                    {
                        [suggestionsArr addObject:[NSNumber numberWithInt:indexTo2]];
                    }
                }
            }
            
        }
        
    }
    
    
    return [[NSArray alloc]initWithArray:suggestionsArr];
}


-(NSArray *)convertRawSuggestionValues:(NSArray *)arrSuggestionRawValues toSuggestionObjectsFromLocation:(BoardLocation *)fromLocation
{
    NSMutableArray *convertedSuggestions = [[NSMutableArray alloc]init];
    
    for(int i =0 ; i<arrSuggestionRawValues.count ; i++)
    {
        Suggestion *sg = [[Suggestion alloc]init];
        sg.fromBoardIndex = fromLocation.locationID;
        sg.toBoardIndex = [arrSuggestionRawValues[i] intValue];
        sg.dicePointRequired = [self diceValueUsedToMoveFrom:fromLocation.locationID toIndex:sg.toBoardIndex];
        [convertedSuggestions addObject:sg];
    }
    
    
    return [[NSArray alloc]initWithArray:convertedSuggestions];
}

/**
    method will looks at playing options of DicePair then get most appropriate playing option from this array
    @return : one of the diceValue (integer) from playing options of current dice pair
 */
-(int)diceValueUsedToMoveFrom:(int)fromLocationIndex toIndex:(int)toIndex
{
    BoardLocation *locationFrom = [[Board sharedBoard] boardLocationFromIndex:fromLocationIndex];
    colorType fromColorType = locationFrom.typeOfColor;
    NSArray *playingOptions = [[DicePair sharedDicePair] playingOptions];
    
    BoardLocation *flunkArea = [[Board sharedBoard] flunkLocationByColor:fromColorType];
    
    // did moved from Flunk area ??
    if(flunkArea.locationID == fromLocationIndex)
    {
        if(fromColorType == kBackgammomColorTypeWhite)
        {
            return toIndex+1;
        }
        else
        {
            return PLAYABLE_BOARD_LOCATIONS_COUNT-toIndex;
        }
    }
    
    // did moved to camping area ??
    
    BoardLocation *campingArea = [[Board sharedBoard] campingLocationByColor:fromColorType];
    if(campingArea.locationID == toIndex)
    {
        int valueMinRequired ;
        
        if(fromColorType == kBackgammomColorTypeWhite)
        {
            valueMinRequired = PLAYABLE_BOARD_LOCATIONS_COUNT-fromLocationIndex;
        }
        else
        {
            valueMinRequired = fromLocationIndex+1;
        }
        
        for(int i =0 ; i<playingOptions.count ; i++)
        {
            int theValueDice = [playingOptions[i] intValue];
            
            if(theValueDice >= valueMinRequired)
            {
                return theValueDice;
            }
        }
    }
    
    
    int value = abs(toIndex - fromLocationIndex);
    
    return value;
}

@end
