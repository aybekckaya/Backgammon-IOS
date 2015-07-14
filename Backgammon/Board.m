//
//  Board.m
//  Backgammon
//
//  Created by aybek can kaya on 15/06/15.
//  Copyright (c) 2015 aybek can kaya. All rights reserved.
//

#import "Board.h"

@implementation Board


+(id)sharedBoard
{
    static Board *shared = nil;
    
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


#pragma mark SETTING UP


-(void) setUpBoardLocationsWithBoardFrameRectangles:(NSArray *)boardFrameRects
{
    boardLocationsArr = [[NSMutableArray alloc] init];
    
    for(int i =0 ; i< PLAYABLE_BOARD_LOCATIONS_COUNT ; i++)
    {
        CGRect frame = [boardFrameRects[i] CGRectValue];
        BoardLocation *brdLocation = [[BoardLocation alloc] initWithLocationID:i LocationFrame:frame Capacity:5];
        [boardLocationsArr addObject:brdLocation];
    }
    
    
    // flunk and camping areas
    for(int i= PLAYABLE_BOARD_LOCATIONS_COUNT ; i<boardFrameRects.count ; i++)
    {
        CGRect frame = [boardFrameRects[i] CGRectValue];
        BoardLocation *brdLocation = [[BoardLocation alloc] initWithLocationID:i LocationFrame:frame Capacity:1];
        
        [boardLocationsArr addObject:brdLocation];
    }
    
      
    
}

-(int)totalFlakeCount
{
    int count = 0;
    
    for(BoardLocation *location in boardLocationsArr)
    {
        int countFlakesInLocation = [location flakeStackCount];
        count+= countFlakesInLocation;
    }
    
    return count;
}


/*
 Format  : 
 [dctMute setObject:@{FLAKEVIEW_DICTIONARY_NUMBER_OF_FLAKES_KEY : @"2" , FLAKEVIEW_DICTIONARY_TYPE_OF_FLAKE_KEY : @"0"} forKey:[NSNumber numberWithInt:0]];

 
 */
-(void)setUpWithFlakeDictionary:(NSDictionary *)dictionaryFlakes
{
    [self clearAllFlakes];
    
  
    
    NSArray *allKeys = [dictionaryFlakes allKeys];
    
    int initFlakeID = 0;
    for(int i =0 ; i< allKeys.count ; i++)
    {
        NSString *key = allKeys[i];
        
        NSDictionary *dctInner = dictionaryFlakes[key];
        int position = [key intValue];
        int numberOfFlakes = [dctInner[FLAKEVIEW_DICTIONARY_NUMBER_OF_FLAKES_KEY] intValue];
        int colorTypeINT = [dctInner[FLAKEVIEW_DICTIONARY_TYPE_OF_FLAKE_KEY] intValue];
        
        colorType typeColor ;
        if(colorTypeINT == 1)
        {
            typeColor = kBackgammomColorTypeBlack;
        }
        else
        {
            typeColor = kBackgammomColorTypeWhite;
        }
        
        for(int i=0 ; i<numberOfFlakes ; i++)
        {
            [self pushFlakeWithColor:typeColor toIndex:position flakeID:initFlakeID];
            initFlakeID++;
        }
        
        
    }
}

/**
    CAUTION : Only use for tests
 */
-(void)clearAllFlakes
{
    boardLocationsArr = [[NSMutableArray alloc] init];
    
    for(int i =0 ; i< PLAYABLE_BOARD_LOCATIONS_COUNT ; i++)
    {
        CGRect frame = CGRectZero;
        BoardLocation *brdLocation = [[BoardLocation alloc] initWithLocationID:i LocationFrame:frame Capacity:5];
        [boardLocationsArr addObject:brdLocation];
    }
    
    
    // flunk and camping areas
    for(int i= PLAYABLE_BOARD_LOCATIONS_COUNT ; i<NUMBER_OF_FLUNK_AREAS+NUMBER_OF_CAMPING_AREAS+PLAYABLE_BOARD_LOCATIONS_COUNT ; i++)
    {
         CGRect frame = CGRectZero;
        BoardLocation *brdLocation = [[BoardLocation alloc] initWithLocationID:i LocationFrame:frame Capacity:1];
        
        [boardLocationsArr addObject:brdLocation];
    }

}




-(void)pushFlakeWithColor:(colorType)typeOfColor toIndex:(int)theIndex flakeID:(int)theFlakeID
{
    BoardLocation *boardLoc = boardLocationsArr[theIndex];
    boardLoc.typeOfColor = typeOfColor;
    
    if(theFlakeID != -1)
    {
          [boardLoc flakeStackPushFlakeID:theFlakeID];
    }
  
}



#pragma mark Game play

-(void)moveFlakeFromIndex:(int)fromIndex toIndex:(int)toIndex currentFlakeColor:(colorType)flakeCurrentColor
{
    // getting current flake
    BoardLocation *locationForCurrentFlake = boardLocationsArr[fromIndex];
    
    if([locationForCurrentFlake flakeStackIsEmpty])
    {
        return;
    }
    
    int flakeIDCurrent = [locationForCurrentFlake flakeStackPopFlakeID];
    
    if(locationForCurrentFlake.numberOfFlakes == 0)
    {
        locationForCurrentFlake.typeOfColor = kBackgammonColorTypeNone;
    }
   
    // next flake
    BoardLocation *locationForNextFlake = boardLocationsArr[toIndex];
    
    
    if(locationForNextFlake.locationID < PLAYABLE_BOARD_LOCATIONS_COUNT)
    {
        // usual playing
        
        if(locationForNextFlake.numberOfFlakes == 0)
        {
            // Açık verdi
            [locationForNextFlake flakeStackPushFlakeID:flakeIDCurrent];
            locationForNextFlake.typeOfColor = flakeCurrentColor;
        }
        else if(locationForNextFlake.numberOfFlakes == 1 && flakeCurrentColor != locationForNextFlake.typeOfColor)
        {
            // Kırdı
            
            int flakeIDFlunked = [locationForNextFlake flakeStackPopFlakeID];
            
            [locationForNextFlake flakeStackPushFlakeID:flakeIDCurrent];
            locationForNextFlake.typeOfColor = flakeCurrentColor;
            
            BoardLocation *pushingLocation;
            
            if(flakeCurrentColor == kBackgammomColorTypeWhite)
            {
                /// push to black flunkAREA
                pushingLocation = [self boardLocationForBlackFlunkArea];
            }
            else if(flakeCurrentColor == kBackgammomColorTypeBlack)
            {
                  /// push to white flunkAREA
                pushingLocation = [self boardLocationForWhiteFlunkArea];
            }
            
              [pushingLocation flakeStackPushFlakeID:flakeIDFlunked];
            
            
            if([self.delegate respondsToSelector:@selector(boardFlakeHasFlunkedFlakeID:)])
            {
                [self.delegate boardFlakeHasFlunkedFlakeID:flakeIDFlunked];
            }
            
            
        }
        else if(locationForNextFlake.numberOfFlakes == 1 && flakeCurrentColor == locationForNextFlake.typeOfColor)
        {
            // Kapı aldı
            [locationForNextFlake flakeStackPushFlakeID:flakeIDCurrent];
            
        }
        else
        {
            // zaten var olan kapının üzerine koydu
            [locationForNextFlake flakeStackPushFlakeID:flakeIDCurrent];
        }

        
    }
    else
    {
        // camping area , flunk area etc...
        
         [locationForNextFlake flakeStackPushFlakeID:flakeIDCurrent];
        
    }
    
    
    // Winning condition checker
    BoardLocation *locationForWhiteCamping = [self boardLocationForWhiteCampingArea];
    BoardLocation *locationForBlackCamping = [self boardLocationForBlackCampingArea];
    
    if([locationForBlackCamping flakeStackCount] == 15)
    {
        if([locationForWhiteCamping flakeStackIsEmpty])
        {
            [self.delegate boardGameHasWonByPlayerColor:kBackgammomColorTypeBlack winingType:kPlayerWinTypeMars];
        }
        else
        {
             [self.delegate boardGameHasWonByPlayerColor:kBackgammomColorTypeBlack winingType:kPlayerWinTypeNormal];
        }
        
       
    }
    else if([locationForWhiteCamping flakeStackCount] == 15)
    {
        
        if([locationForBlackCamping flakeStackIsEmpty])
        {
            [self.delegate boardGameHasWonByPlayerColor:kBackgammomColorTypeWhite winingType:kPlayerWinTypeMars];
        }
        else
        {
            [self.delegate boardGameHasWonByPlayerColor:kBackgammomColorTypeWhite winingType:kPlayerWinTypeNormal];
        }
        

        
       // [self.delegate boardGameHasWonByPlayerColor:kBackgammomColorTypeWhite];
    }
}




-(NSDictionary *)coreDictionary
{
    NSMutableDictionary *dctMute = [[NSMutableDictionary alloc]init];
    
    BoardLocation *locationWhiteFlunk = [self boardLocationForWhiteFlunkArea];
    BoardLocation *locationBlackFlunk = [self boardLocationForBlackFlunkArea];
    BoardLocation *locationWhiteCamping = [self boardLocationForWhiteCampingArea];
    BoardLocation *locationBlackCamping = [self boardLocationForBlackCampingArea];
    
    for(int i = 0; i<boardLocationsArr.count ; i++)
    {
        BoardLocation *locBoard = boardLocationsArr[i];
        
        NSDictionary *dctInner;
        
        if(locBoard.locationID == locationBlackCamping.locationID || locBoard.locationID == locationBlackFlunk.locationID)
        {
            dctInner = @{FLAKEVIEW_DICTIONARY_NUMBER_OF_FLAKES_KEY: [NSNumber numberWithInt:locBoard.numberOfFlakes] , FLAKEVIEW_DICTIONARY_TYPE_OF_FLAKE_KEY : [NSNumber numberWithInt:kBackgammomColorTypeBlack]};
        }
        else if(locBoard.locationID == locationWhiteCamping.locationID || locBoard.locationID == locationWhiteFlunk.locationID)
        {
            dctInner = @{FLAKEVIEW_DICTIONARY_NUMBER_OF_FLAKES_KEY: [NSNumber numberWithInt:locBoard.numberOfFlakes] , FLAKEVIEW_DICTIONARY_TYPE_OF_FLAKE_KEY : [NSNumber numberWithInt:kBackgammomColorTypeWhite]};
        }
        else
        {
            dctInner = @{FLAKEVIEW_DICTIONARY_NUMBER_OF_FLAKES_KEY: [NSNumber numberWithInt:locBoard.numberOfFlakes] , FLAKEVIEW_DICTIONARY_TYPE_OF_FLAKE_KEY : [NSNumber numberWithInt:locBoard.typeOfColor]};
        }
        
        
        
        NSString *key = [NSString stringWithFormat:@"%d" , locBoard.locationID];
        [dctMute setObject:dctInner forKey:key];
        
    }
    
    
    NSDictionary *finalDct = [[NSDictionary alloc]initWithDictionary:dctMute];
    return finalDct;
}



-(NSDictionary *)toDictionaryWithoutDelegation
{
    NSDictionary *coreDct = [self coreDictionary];
    return coreDct;
}


-(NSDictionary *)toDictionary
{
    NSDictionary *coreDct = [self coreDictionary];
    
    if([self.delegate respondsToSelector:@selector(boardWillAboutToSaveGameState)])
    {
        [self.delegate boardWillAboutToSaveGameState];
    }
    
  
    return coreDct;
}


-(void)saveBoardPositionings
{
    if(IS_TESTING_FRAME_LOCATIONING == 1)
    {
        // save for Backgammon tests
        NSDictionary *dctBoard = [self toDictionary];
        GamePlaySaveStock *stock = [[GamePlaySaveStock alloc]init];
        [stock saveBoards:dctBoard];
        
    }
    else
    {
        // game to save REAL
    }
}



-(int)locationIndexAtPoint:(CGPoint)ptSupplied
{
    for(int i =0 ; i<boardLocationsArr.count ; i++)
    {
        BoardLocation  *loc = boardLocationsArr[i];
        if(CGRectContainsPoint(loc.locationFrameRect, ptSupplied))
        {
            return loc.locationID;
        }
    }
    
    return -1; // not found
}



-(BoardLocation *)boardLocationFromIndex:(int)index
{
    return (BoardLocation *)boardLocationsArr[index];
}



#pragma mark Pre-defined board locations 

-(BoardLocation *)boardLocationForWhiteFlunkArea
{
    return (BoardLocation *)boardLocationsArr[PLAYABLE_BOARD_LOCATIONS_COUNT];
}


-(BoardLocation *)boardLocationForBlackFlunkArea
{
    return (BoardLocation *)boardLocationsArr[PLAYABLE_BOARD_LOCATIONS_COUNT+1];
}

-(BoardLocation *)boardLocationForWhiteCampingArea
{
    return (BoardLocation *)boardLocationsArr[PLAYABLE_BOARD_LOCATIONS_COUNT + 2];
}


-(BoardLocation *)boardLocationForBlackCampingArea
{
    return (BoardLocation *)boardLocationsArr[PLAYABLE_BOARD_LOCATIONS_COUNT +3];
}




#pragma mark FLAKE_POSITIONS

-(NSArray *)allFlakeLocationsForFlakeColor:(colorType)flakeColorType
{
    NSMutableArray *arrMute = [[NSMutableArray alloc]init];
    for(BoardLocation *location in boardLocationsArr)
    {
        if(location.typeOfColor == flakeColorType)
        {
            if(![location flakeStackIsEmpty])
            {
                int locationID = location.locationID;
                [arrMute addObject:[NSNumber numberWithInt:locationID]];
            }
        }
    }
    
    return [[NSArray alloc]initWithArray:arrMute];
}


-(int)locationIndexForColor:(colorType)typeColor fromLocationIndex:(int)fromIndex diceValue:(int)diceValue
{
    BoardLocation *theLocation = [self boardLocationFromIndex:fromIndex];
    
    if([theLocation flakeStackIsEmpty])
    {
        return -1;
    }
    
    if(typeColor == kBackgammomColorTypeWhite)
    {
        int indexTo = fromIndex + diceValue;
        BoardLocation *locationCamping = [self boardLocationForWhiteCampingArea];
        BoardLocation *locationFlunk = [self flunkLocationByColor:kBackgammomColorTypeWhite];
        
        if(locationCamping.locationID == fromIndex)
        {
            return -1;
        }
        
        if(fromIndex == locationFlunk.locationID)
        {
            indexTo = diceValue-1;
            return indexTo;
        }
        
        
        if(indexTo >= PLAYABLE_BOARD_LOCATIONS_COUNT)
        {
            if(self.whitesMayCollect == NO)
            {
                return -1;
            }
            else
            {
                // Sallama durumu
                if([self isFlakeAtLocationID:fromIndex isCollectableWithDiceValue:diceValue])
                {
                    return locationCamping.locationID;
                }
                else
                {
                    return -1;
                }
                
                
            }
        }
        
        return indexTo;
    }
    else
    {
        int indexTo = fromIndex - diceValue;
        BoardLocation *locationCamping = [self boardLocationForBlackCampingArea];
        BoardLocation *locationFlunk = [self flunkLocationByColor:kBackgammomColorTypeBlack];
        
        if(locationCamping.locationID == fromIndex)
        {
            return -1;
        }
        
        if(locationFlunk.locationID == fromIndex)
        {
            indexTo = PLAYABLE_BOARD_LOCATIONS_COUNT-diceValue;
            return indexTo;
        }
        
        if(indexTo < 0)
        {
            if(self.blacksMayCollect == NO)
            {
                return -1;
            }
            else
            {
                // Sallama durumu
                if([self isFlakeAtLocationID:fromIndex isCollectableWithDiceValue:diceValue])
                {
                    return locationCamping.locationID;
                }
                else
                {
                    return -1;
                }

            }
        }
        
        return indexTo;
    }
    
    return -1;
}



#pragma mark CHECKS+LOGIC

-(BOOL)isFlakeAtLocationID:(int) locationID isCollectableWithDiceValue:(int)theDiceValue
{
    BoardLocation *locationBoard = [self boardLocationFromIndex:locationID];
    if([locationBoard flakeStackIsEmpty])
    {
        return NO;
    }
    
    colorType typeColor = locationBoard.typeOfColor ;
    
    if(typeColor == kBackgammomColorTypeWhite)
    {
        // whites
        if(self.whitesMayCollect == YES)
        {
            int index = PLAYABLE_BOARD_LOCATIONS_COUNT-locationID;
            if(index == theDiceValue)
            {
                // player touch correct place
                return YES;
            }
            
            int maxIndex = PLAYABLE_BOARD_LOCATIONS_COUNT-7;
            // dokunulan yerden daha büyükte taş var mı , var ise sallamak zorunda
            for(int i =locationID-1; i>maxIndex ; i--)
            {
                BoardLocation *locationAtIndex = [self boardLocationFromIndex:i];
                if(![locationAtIndex flakeStackIsEmpty] && locationAtIndex.typeOfColor == typeColor)
                {
                    return NO;
                }
            }
        }
    }
    else
    {
         // blacks
        if(self.blacksMayCollect == YES)
        {
            int index = 1+locationID;
            if(index == theDiceValue)
            {
                // player touch correct place
                return YES;
            }
            
            int maxIndex = 7;
            // dokunulan yerden daha büyükte taş var mı , var ise sallamak zorunda
            for(int i =index ; i<maxIndex ; i++)
            {
                BoardLocation *locationAtIndex = [self boardLocationFromIndex:i];
                if(![locationAtIndex flakeStackIsEmpty] && locationAtIndex.typeOfColor == typeColor)
                {
                    return NO;
                }
            }
            
        }
    }
    
    return YES;
}


-(BOOL)isFlakeFromLocationIndex:(int)fromLocationIndex canBeMovedWithDiceValuesArray:(NSArray *)diceValuesIntegers
{
    for(int i =0 ; i<diceValuesIntegers.count ; i++)
    {
        int theDiceValue = [diceValuesIntegers[i] intValue];
        if([self isFlakeFromLocationIndex:fromLocationIndex canBeMovedWithDiceValue:theDiceValue])
        {
            return YES;
        }
    }
    
    return NO;
}

-(BOOL)isFlakeFromLocationIndex:(int)fromLocationIndex canBeMovedWithDiceValue:(int)theDiceValue
{
    BoardLocation *locationFrom = [self boardLocationFromIndex:fromLocationIndex];
    colorType typeColorFromLocation = locationFrom.typeOfColor;
    
    if([locationFrom flakeStackIsEmpty])
    {
        // there is no flake at this location
        return NO;
    }
    
    // if from Location is camping area There is no way out from there
    
    if(locationFrom.locationID == [[self boardLocationForWhiteCampingArea] locationID] || locationFrom.locationID == [[self boardLocationForBlackCampingArea] locationID])
    {
        return NO;
    }
    
    // if player has flunk she/he should touch it
    BOOL hasFlunk = [self isPlayerColorHasFlunkPlayerColor:typeColorFromLocation];
    if(hasFlunk == YES)
    {
        BoardLocation *locationOfFlunk = [self flunkLocationByColor:typeColorFromLocation];
        if(locationFrom.locationID != locationOfFlunk.locationID)
        {
            // she / he should have touched flunk area first.
            return NO;
        }
        
        return [self isFlunkCanBePutFlunkColor:typeColorFromLocation diceValue:theDiceValue];
    }
    
    // there is no flunk player plays normally
    
    int locationIndexTo = [self locationIndexForColor:typeColorFromLocation fromLocationIndex:locationFrom.locationID diceValue:theDiceValue];
    if(locationIndexTo == -1)
    {
        return NO;
    }
    
    BoardLocation *locationTo = [self boardLocationFromIndex:locationIndexTo];
    
    return [self isLocation:locationTo playableForFlakeColor:typeColorFromLocation];
}


-(BOOL)isLocation:(BoardLocation *)locationTo playableForFlakeColor:(colorType)typeColor
{
    BoardLocation *locationBlackCamping = [self boardLocationForBlackCampingArea];
    BoardLocation *locationWhiteCamping = [self boardLocationForWhiteCampingArea];
    BoardLocation *locationBlackFlunk = [self boardLocationForBlackFlunkArea];
    BoardLocation *locationWhiteFlunk = [self boardLocationForWhiteFlunkArea];
    
    
    // No way to play to flunk area
    if(locationTo.locationID == locationBlackFlunk.locationID || locationTo.locationID == locationWhiteFlunk.locationID)
    {
        return NO;
    }
    
    if(typeColor == kBackgammomColorTypeWhite)
    {
        if(locationTo.locationID == locationWhiteCamping.locationID)
        {
            return self.whitesMayCollect;
        }
        else
        {
           if(locationTo.typeOfColor == kBackgammomColorTypeBlack && [locationTo flakeStackCount] > 1)
           {
               return NO;
           }
           else
           {
                return YES;
           }
        }
    }
    else
    {
        if(locationTo.locationID == locationBlackCamping.locationID)
        {
            return self.blacksMayCollect;
        }
        else
        {
            if(locationTo.typeOfColor == kBackgammomColorTypeWhite && [locationTo flakeStackCount] > 1)
            {
                return NO;
            }
            else
            {
                return YES;
            }
        }
    }
    
    return NO;
}


-(BOOL)isPlayerColorHasFlunkPlayerColor:(colorType) typeColor
{
    BoardLocation *location = [self flunkLocationByColor:typeColor];
  
    if([location flakeStackIsEmpty])
    {
        return NO;
    }
    
    
    return YES;
}


-(BoardLocation *)flunkLocationByColor:(colorType ) typeColor
{
    if(typeColor == kBackgammomColorTypeWhite)
    {
        return [self boardLocationForWhiteFlunkArea];
    }
    else
    {
        return [self boardLocationForBlackFlunkArea];
    }
    
    return nil;
}


-(BoardLocation *)campingLocationByColor:(colorType) typeColor
{
    if(typeColor == kBackgammomColorTypeWhite)
    {
        return [self boardLocationForWhiteCampingArea];
    }
    else
    {
        return [self boardLocationForBlackCampingArea];
    }
    
    return nil;
}


-(BOOL)isFlunkCanBePutFlunkColor:(colorType)flunkColorType diceValue:(int)diceVal
{
    if(diceVal < 1 || diceVal > 6)
    {
        return NO;
    }
   
    
    if(flunkColorType == kBackgammomColorTypeWhite)
    {
        int theIndex = diceVal-1;
        BoardLocation *location = [self boardLocationFromIndex:theIndex];
        
        if([location flakeStackIsEmpty])
        {
            return YES;
        }
        else if(location.typeOfColor == kBackgammomColorTypeWhite)
        {
            return YES;
        }
        else if([location flakeStackCount] == 1 && location.typeOfColor == kBackgammomColorTypeBlack)
        {
            return YES;
        }
    }
    else
    {
        int theIndex = PLAYABLE_BOARD_LOCATIONS_COUNT-diceVal;
        BoardLocation *location = [self boardLocationFromIndex:theIndex];
        
        if([location flakeStackIsEmpty])
        {
            return YES;
        }
        else if(location.typeOfColor == kBackgammomColorTypeBlack)
        {
            return YES;
        }
        else if([location flakeStackCount] == 1 && location.typeOfColor == kBackgammomColorTypeWhite)
        {
            return YES;
        }
    }
    
    
    return NO;
}


-(NSArray *)playableBoardLocationIDsFromBlackFlunkAreaWithCurrentDicePair:(int)dice1Value dice2Value:(int)dice2Value
{
    NSMutableArray *options = [[NSMutableArray alloc]init];
    
    int index1 = 24-dice1Value;
    int index2 = 24 - dice2Value;
    
    if(dice1Value == dice2Value)
    {
        // Dices are Paired
        BoardLocation *location = [self boardLocationFromIndex:index1];
        
        if([location flakeStackIsEmpty])
        {
            [options addObject:[NSNumber numberWithInt:location.locationID]];
        }
        else if(location.typeOfColor == kBackgammomColorTypeBlack)
        {
             [options addObject:[NSNumber numberWithInt:location.locationID]];
        }
        else if([location flakeStackCount] == 1)
        {
            [options addObject:[NSNumber numberWithInt:location.locationID]];
        }
        
        return [[NSArray alloc]initWithArray:options];
    }
    
    BoardLocation *location1 = [self boardLocationFromIndex:index1];
    BoardLocation *location2 = [self boardLocationFromIndex:index2];
    
    if([location1 flakeStackIsEmpty])
    {
        [options addObject:[NSNumber numberWithInt:location1.locationID]];
    }
    else if(location1.typeOfColor == kBackgammomColorTypeBlack)
    {
        [options addObject:[NSNumber numberWithInt:location1.locationID]];
    }
    else if([location1 flakeStackCount] == 1)
    {
        [options addObject:[NSNumber numberWithInt:location1.locationID]];
    }

    
    if([location2 flakeStackIsEmpty])
    {
        [options addObject:[NSNumber numberWithInt:location2.locationID]];
    }
    else if(location2.typeOfColor == kBackgammomColorTypeBlack)
    {
        [options addObject:[NSNumber numberWithInt:location2.locationID]];
    }
    else if([location2 flakeStackCount] == 1)
    {
        [options addObject:[NSNumber numberWithInt:location2.locationID]];
    }

    
    return [[NSArray alloc]initWithArray:options];
}





-(NSArray *)playableBoardLocationIDsFromWhiteFlunkAreaWithCurrentDicePair:(int)dice1Value dice2Value:(int)dice2Value
{
    
    NSMutableArray *options = [[NSMutableArray alloc]init];
    
    int index1 = dice1Value-1;
    int index2 = dice2Value-1;
    
    if(dice1Value == dice2Value)
    {
        // Dices are Paired
        BoardLocation *location = [self boardLocationFromIndex:index1];
        
        if([location flakeStackIsEmpty])
        {
            [options addObject:[NSNumber numberWithInt:location.locationID]];
        }
        else if(location.typeOfColor == kBackgammomColorTypeWhite)
        {
            [options addObject:[NSNumber numberWithInt:location.locationID]];
        }
        else if([location flakeStackCount] == 1)
        {
            [options addObject:[NSNumber numberWithInt:location.locationID]];
        }
        
        return [[NSArray alloc]initWithArray:options];
    }
    
    BoardLocation *location1 = [self boardLocationFromIndex:index1];
    BoardLocation *location2 = [self boardLocationFromIndex:index2];
    
    if([location1 flakeStackIsEmpty])
    {
        [options addObject:[NSNumber numberWithInt:location1.locationID]];
    }
    else if(location1.typeOfColor == kBackgammomColorTypeWhite)
    {
        [options addObject:[NSNumber numberWithInt:location1.locationID]];
    }
    else if([location1 flakeStackCount] == 1)
    {
        [options addObject:[NSNumber numberWithInt:location1.locationID]];
    }
    
    
    if([location2 flakeStackIsEmpty])
    {
        [options addObject:[NSNumber numberWithInt:location2.locationID]];
    }
    else if(location2.typeOfColor == kBackgammomColorTypeWhite)
    {
        [options addObject:[NSNumber numberWithInt:location2.locationID]];
    }
    else if([location2 flakeStackCount] == 1)
    {
        [options addObject:[NSNumber numberWithInt:location2.locationID]];
    }
    
    
    return [[NSArray alloc]initWithArray:options];
}



#pragma mark Getters 

-(BOOL)blacksMayCollect
{
    BoardLocation *locationFlunk = [self boardLocationForBlackFlunkArea];
    if([locationFlunk flakeStackCount] > 0)
    {
        return NO;
    }
    
    
    BoardLocation *locationCamping = [self boardLocationForBlackCampingArea];
    int countFlakes = [locationCamping flakeStackCount];
    
    for(int i =0; i<6 ; i++)
    {
       int index = i;
        BoardLocation *theLocation = [self boardLocationFromIndex:index];
        
        if(theLocation.typeOfColor == kBackgammomColorTypeBlack)
        {
             countFlakes += [theLocation flakeStackCount];
        }
        
       
    }
    
    if(countFlakes == 15)
    {
        return YES;
    }
    
    
    return NO;
}


-(BOOL)whitesMayCollect
{
    BoardLocation *locationFlunk = [self boardLocationForWhiteFlunkArea];
    if([locationFlunk flakeStackCount] > 0)
    {
        return NO;
    }
    
    
    BoardLocation *locationCamping = [self boardLocationForWhiteCampingArea];
    int countFlakes = [locationCamping flakeStackCount];
    
    for(int i =0; i<6 ; i++)
    {
        
          int index = PLAYABLE_BOARD_LOCATIONS_COUNT-1-i;
        BoardLocation *theLocation = [self boardLocationFromIndex:index];
        
        if(theLocation.typeOfColor == kBackgammomColorTypeWhite)
        {
             countFlakes += [theLocation flakeStackCount];
        }
        
       
    }
    
    if(countFlakes == 15)
    {
        return YES;
    }
    
    
    return NO;
}



-(BOOL)isFlakeAtLocationID:(int)locationID isFlunkableByFlakeColor:(colorType)typeColor
{
    colorType oppositeColor;
    if(typeColor == kBackgammomColorTypeBlack)
    {
        oppositeColor = kBackgammomColorTypeWhite;
    }
    else
    {
        oppositeColor = kBackgammomColorTypeBlack;
    }
    
    BoardLocation *locationTo = [self boardLocationFromIndex:locationID];
    
    if([locationTo flakeStackCount] == 1)
    {
        if(locationTo.typeOfColor == oppositeColor)
        {
            return YES;
        }
    }
    
    
    return NO;
}

@end
