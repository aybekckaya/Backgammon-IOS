//
//  BoardTests.m
//  Backgammon
//
//  Created by aybek can kaya on 23/06/15.
//  Copyright (c) 2015 aybek can kaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Board.h"
#import "TesterStock.h"
#import "DicePair.h"

@interface BoardTests : XCTestCase

@property(nonatomic,strong) NSDictionary *gameInitFlakesDct;
//@property(nonatomic , strong) NSDictionary *

/**
   2 dimensional array of dice values in integer format
 */
@property(nonatomic,strong) NSMutableArray *diceValuesForTest;

@property(nonatomic,strong) NSArray *testDictionaries;

@end


@interface Board(Test)

-(BOOL)isFlakeAtLocationID:(int) locationID isCollectableWithDiceValue:(int)theDiceValue;

@end

@implementation BoardTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In future make test gui and save to plist for testing .
    
    NSDictionary *dct = [self gameInitDictionary];
    self.gameInitFlakesDct = dct;
    [[Board sharedBoard] setUpWithFlakeDictionary:dct];
    
   // [self diceSetters];
    
  
   

}

-(void)diceSetters
{
    self.diceValuesForTest = [[NSMutableArray alloc]init];
    
    for(int i=1 ; i<7 ; i++)
    {
        for(int y=1 ; y<7 ; y++)
        {
            int dice1 = i;
            int dice2= y;
            
          //  NSLog(@"%d-%d" , dice1, dice2);
            
            NSArray *arrInner =[[NSArray alloc]initWithObjects:[NSNumber numberWithInt:dice1], [NSNumber numberWithInt:dice2], nil];
            [self.diceValuesForTest addObject:arrInner];
        }
    }
    
}



-(NSDictionary *)gameInitDictionary
{
    // set up init positions
    
    NSMutableDictionary *dctMute = [[NSMutableDictionary alloc]init];
    
    // whites
    
    [dctMute setObject:@{FLAKEVIEW_DICTIONARY_NUMBER_OF_FLAKES_KEY : @"2" , FLAKEVIEW_DICTIONARY_TYPE_OF_FLAKE_KEY : @"0"} forKey:[NSNumber numberWithInt:0]];
    
    [dctMute setObject:@{FLAKEVIEW_DICTIONARY_NUMBER_OF_FLAKES_KEY : @"5" , FLAKEVIEW_DICTIONARY_TYPE_OF_FLAKE_KEY : @"0"} forKey:[NSNumber numberWithInt:11]];
    
    
    [dctMute setObject:@{FLAKEVIEW_DICTIONARY_NUMBER_OF_FLAKES_KEY : @"3" , FLAKEVIEW_DICTIONARY_TYPE_OF_FLAKE_KEY : @"0"} forKey:[NSNumber numberWithInt:16]];
    
    [dctMute setObject:@{FLAKEVIEW_DICTIONARY_NUMBER_OF_FLAKES_KEY : @"5" , FLAKEVIEW_DICTIONARY_TYPE_OF_FLAKE_KEY : @"0"} forKey:[NSNumber numberWithInt:18]];
    
    
    // blacks
    
    [dctMute setObject:@{FLAKEVIEW_DICTIONARY_NUMBER_OF_FLAKES_KEY : @"5" , FLAKEVIEW_DICTIONARY_TYPE_OF_FLAKE_KEY : @"1"} forKey:[NSNumber numberWithInt:5]];
    
    [dctMute setObject:@{FLAKEVIEW_DICTIONARY_NUMBER_OF_FLAKES_KEY : @"3" , FLAKEVIEW_DICTIONARY_TYPE_OF_FLAKE_KEY : @"1"} forKey:[NSNumber numberWithInt:7]];
    
    
    [dctMute setObject:@{FLAKEVIEW_DICTIONARY_NUMBER_OF_FLAKES_KEY : @"5" , FLAKEVIEW_DICTIONARY_TYPE_OF_FLAKE_KEY : @"1"} forKey:[NSNumber numberWithInt:12]];
    
    [dctMute setObject:@{FLAKEVIEW_DICTIONARY_NUMBER_OF_FLAKES_KEY : @"2" , FLAKEVIEW_DICTIONARY_TYPE_OF_FLAKE_KEY : @"1"} forKey:[NSNumber numberWithInt:23]];
    
    
    NSDictionary *dct = [[NSDictionary alloc]initWithDictionary:dctMute];
    
    return dct;

}


- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}



- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

#pragma mark FLAKE_LOCATION_TESTS

-(void)testFlakeLocationCorrectForGameInitPositions
{
    Board *sharedBoard = [Board sharedBoard];
    
    BoardLocation *theLocation;
    int numberOfFlakes;
    //colorType typeColor;
    
    // Check Whites
    
    theLocation = [sharedBoard boardLocationFromIndex:0];
    numberOfFlakes = [theLocation flakeStackCount];
    XCTAssertEqual(numberOfFlakes, 2);
    XCTAssertEqual(theLocation.typeOfColor, 0);
    
    theLocation = [sharedBoard boardLocationFromIndex:11];
    numberOfFlakes = [theLocation flakeStackCount];
    XCTAssertEqual(numberOfFlakes, 5);
    XCTAssertEqual(theLocation.typeOfColor, 0);
    
    
    theLocation = [sharedBoard boardLocationFromIndex:16];
    numberOfFlakes = [theLocation flakeStackCount];
    XCTAssertEqual(numberOfFlakes, 3);
    XCTAssertEqual(theLocation.typeOfColor, 0);
    
    
    theLocation = [sharedBoard boardLocationFromIndex:18];
    numberOfFlakes = [theLocation flakeStackCount];
    XCTAssertEqual(numberOfFlakes, 5);
    XCTAssertEqual(theLocation.typeOfColor, 0);
    
    // Check Blacks
    
    theLocation = [sharedBoard boardLocationFromIndex:23];
    numberOfFlakes = [theLocation flakeStackCount];
    XCTAssertEqual(numberOfFlakes, 2);
    XCTAssertEqual(theLocation.typeOfColor, 1);
    
    theLocation = [sharedBoard boardLocationFromIndex:5];
    numberOfFlakes = [theLocation flakeStackCount];
    XCTAssertEqual(numberOfFlakes, 5);
    XCTAssertEqual(theLocation.typeOfColor, 1);
    
    
    theLocation = [sharedBoard boardLocationFromIndex:12];
    numberOfFlakes = [theLocation flakeStackCount];
    XCTAssertEqual(numberOfFlakes, 5);
    XCTAssertEqual(theLocation.typeOfColor, 1);
    
    
    theLocation = [sharedBoard boardLocationFromIndex:7];
    numberOfFlakes = [theLocation flakeStackCount];
    XCTAssertEqual(numberOfFlakes, 3);
    XCTAssertEqual(theLocation.typeOfColor, 1);
    
    
}

-(void)testMostSignificantFlakeIDsOnBoard
{
    int maxNumberLocations = NUMBER_OF_CAMPING_AREAS+NUMBER_OF_FLUNK_AREAS+PLAYABLE_BOARD_LOCATIONS_COUNT;
    
    for(int i =0 ; i<maxNumberLocations ; i++)
    {
        BoardLocation *location = [[Board sharedBoard] boardLocationFromIndex:i];
          int mostSignificantFlakeID = [location mostSignificantFlakeID];
        if([location flakeStackIsEmpty])
        {
          XCTAssertEqual(mostSignificantFlakeID, -1);
        }
        else
        {
            XCTAssertNotEqual(mostSignificantFlakeID, -1);
        }
    }
    
}


#pragma mark MovingFlakes 

-(void)testMovingFlakes
{
    Board *sharedBoard = [Board sharedBoard];
    [sharedBoard setUpWithFlakeDictionary:self.gameInitFlakesDct];
    
    int fromLocationID;
    int toLocationID;
    
    int mostSignificantFlakeIDFrom;
    int mostSignificantFlakeIDTo;
    
    int numberOfFlakes ;
    int numberOfFlakesInTotal;
    
    BoardLocation *locationFrom;
    BoardLocation *locationTo;
    
    BoardLocation *locationBlackFlunk = [sharedBoard boardLocationForBlackFlunkArea];
    BoardLocation *locationWhiteFlunk = [sharedBoard boardLocationForWhiteFlunkArea];
    BoardLocation *locationBlackCamping = [sharedBoard boardLocationForBlackCampingArea];
    BoardLocation *locationWhiteCamping = [sharedBoard boardLocationForWhiteCampingArea];
    
    
    
    // trying to move from empty location
    
    fromLocationID = 1;
    toLocationID = 2;
    
    locationFrom = [sharedBoard boardLocationFromIndex:fromLocationID];
    locationTo = [sharedBoard boardLocationFromIndex:toLocationID];
    
    [sharedBoard moveFlakeFromIndex:locationFrom.locationID toIndex:locationTo.locationID currentFlakeColor:locationFrom.typeOfColor];
    
    numberOfFlakes = [locationTo flakeStackCount];
    XCTAssertEqual(numberOfFlakes, 0);
    
    
    fromLocationID = 3;
    toLocationID = 4;
    
    locationFrom = [sharedBoard boardLocationFromIndex:fromLocationID];
    locationTo = [sharedBoard boardLocationFromIndex:toLocationID];
    
    [sharedBoard moveFlakeFromIndex:locationFrom.locationID toIndex:locationTo.locationID currentFlakeColor:locationFrom.typeOfColor];
    
    numberOfFlakes = [locationTo flakeStackCount];
    XCTAssertEqual(numberOfFlakes, 0);

    
       // usual movement
    
    fromLocationID = 0;
    toLocationID = 4;
    
    locationFrom = [sharedBoard boardLocationFromIndex:fromLocationID];
    mostSignificantFlakeIDFrom = [locationFrom mostSignificantFlakeID];
    
    locationTo = [sharedBoard boardLocationFromIndex:toLocationID];
   
    [sharedBoard moveFlakeFromIndex:locationFrom.locationID toIndex:locationTo.locationID currentFlakeColor:locationFrom.typeOfColor];
   
    mostSignificantFlakeIDTo = [locationTo mostSignificantFlakeID];
    numberOfFlakes = [locationTo flakeStackCount];
    XCTAssertEqual(numberOfFlakes, 1);
    XCTAssertEqual(mostSignificantFlakeIDTo, mostSignificantFlakeIDFrom);
    
    numberOfFlakesInTotal = [sharedBoard totalFlakeCount];
     XCTAssertEqual(numberOfFlakesInTotal, 30);
    
    [sharedBoard setUpWithFlakeDictionary:self.gameInitFlakesDct];
    
    
    fromLocationID = 7;
    toLocationID = 5;
    
    locationFrom = [sharedBoard boardLocationFromIndex:fromLocationID];
    mostSignificantFlakeIDFrom = [locationFrom mostSignificantFlakeID];
    
    locationTo = [sharedBoard boardLocationFromIndex:toLocationID];
    
    [sharedBoard moveFlakeFromIndex:locationFrom.locationID toIndex:locationTo.locationID currentFlakeColor:locationFrom.typeOfColor];
    
    mostSignificantFlakeIDTo = [locationTo mostSignificantFlakeID];
    numberOfFlakes = [locationTo flakeStackCount];
    XCTAssertEqual(numberOfFlakes, 6);
    XCTAssertEqual(mostSignificantFlakeIDTo, mostSignificantFlakeIDFrom);
    
    numberOfFlakesInTotal = [sharedBoard totalFlakeCount];
    XCTAssertEqual(numberOfFlakesInTotal, 30);
    
    [sharedBoard setUpWithFlakeDictionary:self.gameInitFlakesDct];
    
    
    
    fromLocationID = 12;
    toLocationID = 7;
    
    locationFrom = [sharedBoard boardLocationFromIndex:fromLocationID];
    mostSignificantFlakeIDFrom = [locationFrom mostSignificantFlakeID];
    
    locationTo = [sharedBoard boardLocationFromIndex:toLocationID];
    
    [sharedBoard moveFlakeFromIndex:locationFrom.locationID toIndex:locationTo.locationID currentFlakeColor:locationFrom.typeOfColor];
    
    mostSignificantFlakeIDTo = [locationTo mostSignificantFlakeID];
    numberOfFlakes = [locationTo flakeStackCount];
    XCTAssertEqual(numberOfFlakes, 4);
    XCTAssertEqual(mostSignificantFlakeIDTo, mostSignificantFlakeIDFrom);
    
    numberOfFlakesInTotal = [sharedBoard totalFlakeCount];
    XCTAssertEqual(numberOfFlakesInTotal, 30);
    
    [sharedBoard setUpWithFlakeDictionary:self.gameInitFlakesDct];
    
    
    fromLocationID = 11;
    toLocationID = 21;
    
    locationFrom = [sharedBoard boardLocationFromIndex:fromLocationID];
    mostSignificantFlakeIDFrom = [locationFrom mostSignificantFlakeID];
    
    locationTo = [sharedBoard boardLocationFromIndex:toLocationID];
    
    [sharedBoard moveFlakeFromIndex:locationFrom.locationID toIndex:locationTo.locationID currentFlakeColor:locationFrom.typeOfColor];
    
    mostSignificantFlakeIDTo = [locationTo mostSignificantFlakeID];
    numberOfFlakes = [locationTo flakeStackCount];
    XCTAssertEqual(numberOfFlakes, 1);
    XCTAssertEqual(mostSignificantFlakeIDTo, mostSignificantFlakeIDFrom);
    
    numberOfFlakesInTotal = [sharedBoard totalFlakeCount];
    XCTAssertEqual(numberOfFlakesInTotal, 30);
    
    [sharedBoard setUpWithFlakeDictionary:self.gameInitFlakesDct];
    
    
        //to flunk area
    
    fromLocationID = 0;
    toLocationID = locationWhiteFlunk.locationID;
    
    locationFrom = [sharedBoard boardLocationFromIndex:fromLocationID];
    mostSignificantFlakeIDFrom = [locationFrom mostSignificantFlakeID];
    
    locationTo = [sharedBoard boardLocationFromIndex:toLocationID];
    
    [sharedBoard moveFlakeFromIndex:locationFrom.locationID toIndex:locationTo.locationID currentFlakeColor:locationFrom.typeOfColor];
    
    mostSignificantFlakeIDTo = [locationTo mostSignificantFlakeID];
    numberOfFlakes = [locationTo flakeStackCount];
    XCTAssertEqual(numberOfFlakes, 1);
    XCTAssertEqual(mostSignificantFlakeIDTo, mostSignificantFlakeIDFrom);
    
    numberOfFlakesInTotal = [sharedBoard totalFlakeCount];
    XCTAssertEqual(numberOfFlakesInTotal, 30);
    
    [sharedBoard setUpWithFlakeDictionary:self.gameInitFlakesDct];

    
    
    fromLocationID = 5;
    toLocationID = locationBlackFlunk.locationID;
    
    locationFrom = [sharedBoard boardLocationFromIndex:fromLocationID];
    mostSignificantFlakeIDFrom = [locationFrom mostSignificantFlakeID];
    
    locationTo = [sharedBoard boardLocationFromIndex:toLocationID];
    
    [sharedBoard moveFlakeFromIndex:locationFrom.locationID toIndex:locationTo.locationID currentFlakeColor:locationFrom.typeOfColor];
    
    mostSignificantFlakeIDTo = [locationTo mostSignificantFlakeID];
    numberOfFlakes = [locationTo flakeStackCount];
    XCTAssertEqual(numberOfFlakes, 1);
    XCTAssertEqual(mostSignificantFlakeIDTo, mostSignificantFlakeIDFrom);
    
    numberOfFlakesInTotal = [sharedBoard totalFlakeCount];
    XCTAssertEqual(numberOfFlakesInTotal, 30);
    
    [sharedBoard setUpWithFlakeDictionary:self.gameInitFlakesDct];
    
    
    //to camping area
    
   
    fromLocationID = 0;
    toLocationID = locationWhiteCamping.locationID;
    
    locationFrom = [sharedBoard boardLocationFromIndex:fromLocationID];
    mostSignificantFlakeIDFrom = [locationFrom mostSignificantFlakeID];
    
    locationTo = [sharedBoard boardLocationFromIndex:toLocationID];
    
    [sharedBoard moveFlakeFromIndex:locationFrom.locationID toIndex:locationTo.locationID currentFlakeColor:locationFrom.typeOfColor];
    
    mostSignificantFlakeIDTo = [locationTo mostSignificantFlakeID];
    numberOfFlakes = [locationTo flakeStackCount];
    XCTAssertEqual(numberOfFlakes, 1);
    XCTAssertEqual(mostSignificantFlakeIDTo, mostSignificantFlakeIDFrom);
    
    numberOfFlakesInTotal = [sharedBoard totalFlakeCount];
    XCTAssertEqual(numberOfFlakesInTotal, 30);
    
    [sharedBoard setUpWithFlakeDictionary:self.gameInitFlakesDct];
    
    
    
    fromLocationID = 5;
    toLocationID = locationBlackCamping.locationID;
    
    locationFrom = [sharedBoard boardLocationFromIndex:fromLocationID];
    mostSignificantFlakeIDFrom = [locationFrom mostSignificantFlakeID];
    
    locationTo = [sharedBoard boardLocationFromIndex:toLocationID];
    
    [sharedBoard moveFlakeFromIndex:locationFrom.locationID toIndex:locationTo.locationID currentFlakeColor:locationFrom.typeOfColor];
    
    mostSignificantFlakeIDTo = [locationTo mostSignificantFlakeID];
    numberOfFlakes = [locationTo flakeStackCount];
    XCTAssertEqual(numberOfFlakes, 1);
    XCTAssertEqual(mostSignificantFlakeIDTo, mostSignificantFlakeIDFrom);
    
    numberOfFlakesInTotal = [sharedBoard totalFlakeCount];
    XCTAssertEqual(numberOfFlakesInTotal, 30);
    
    [sharedBoard setUpWithFlakeDictionary:self.gameInitFlakesDct];

    
}


/**
    Flake can move or not with given dice point Values
 */
-(void)testFlakeMovementDetermination
{
    Board *sharedBoard = [Board sharedBoard];
    BOOL canPlay;
    
      [[Board sharedBoard] setUpWithFlakeDictionary:self.gameInitFlakesDct];
    
    canPlay = [sharedBoard isFlakeFromLocationIndex:0 canBeMovedWithDiceValue:5];
    XCTAssertEqual(canPlay, NO);
    
    canPlay =[sharedBoard isFlakeFromLocationIndex:0 canBeMovedWithDiceValue:10];
    XCTAssertEqual(canPlay, YES);
    
    canPlay = [sharedBoard isFlakeFromLocationIndex:0 canBeMovedWithDiceValue:7];
    XCTAssertEqual(canPlay, NO);
    
    canPlay = [sharedBoard isFlakeFromLocationIndex:0 canBeMovedWithDiceValue:8];
    XCTAssertEqual(canPlay, YES);
    
    
   // sharedBoard.whitesMayCollect = YES;
    //canPlay = [sharedBoard isFlakeFromLocationIndex:0 canBeMovedWithDiceValue:26];
   // XCTAssertEqual(canPlay, YES);
    
     [[Board sharedBoard] setUpWithFlakeDictionary:self.gameInitFlakesDct];
    
   // Testing blacks
    canPlay = [sharedBoard isFlakeFromLocationIndex:23 canBeMovedWithDiceValue:5];
    XCTAssertEqual(canPlay, NO);
    
    canPlay =[sharedBoard isFlakeFromLocationIndex:23 canBeMovedWithDiceValue:10];
    XCTAssertEqual(canPlay, YES);
    
    canPlay = [sharedBoard isFlakeFromLocationIndex:23 canBeMovedWithDiceValue:7];
    XCTAssertEqual(canPlay, NO);
    
    canPlay = [sharedBoard isFlakeFromLocationIndex:23 canBeMovedWithDiceValue:8];
    XCTAssertEqual(canPlay, YES);

}



-(void)testIsMovableFromFlunkAreasToBoardAreas
{
    Board *sharedBoard = [Board sharedBoard];
    BOOL movability;
    TesterStock *stock;
    DicePair *pairDice = [DicePair sharedDicePair];
    NSArray *dicePairArr;
    
    BoardLocation *locationWhiteFlunk = [sharedBoard boardLocationForWhiteFlunkArea];
     BoardLocation *locationBlackFlunk = [sharedBoard boardLocationForBlackFlunkArea];
    
    // TESTS
    
    stock = [[TesterStock alloc] initByStockID:2];
    [sharedBoard setUpWithFlakeDictionary:stock.boardDictionary];
    
    [pairDice setUpWithDiceValueOne:6 diceValueTwo:6];
    dicePairArr = [pairDice getCurrentRawDiceValues];
    movability = [sharedBoard isFlakeFromLocationIndex:locationWhiteFlunk.locationID canBeMovedWithDiceValuesArray:dicePairArr];
    XCTAssertEqual(movability, NO);
    
    [pairDice setUpWithDiceValueOne:5 diceValueTwo:4];
    dicePairArr = [pairDice getCurrentRawDiceValues];
    movability = [sharedBoard isFlakeFromLocationIndex:locationWhiteFlunk.locationID canBeMovedWithDiceValuesArray:dicePairArr];
    XCTAssertEqual(movability, NO);
    
    [pairDice setUpWithDiceValueOne:2 diceValueTwo:1];
    dicePairArr = [pairDice getCurrentRawDiceValues];
    movability = [sharedBoard isFlakeFromLocationIndex:locationWhiteFlunk.locationID canBeMovedWithDiceValuesArray:dicePairArr];
    XCTAssertEqual(movability, YES);
    
    
    [pairDice setUpWithDiceValueOne:1 diceValueTwo:1];
    dicePairArr = [pairDice getCurrentRawDiceValues];
    movability = [sharedBoard isFlakeFromLocationIndex:locationWhiteFlunk.locationID canBeMovedWithDiceValuesArray:dicePairArr];
    XCTAssertEqual(movability, YES);
    
    
    // try to move from location not flunk
    
    [pairDice setUpWithDiceValueOne:1 diceValueTwo:1];
    dicePairArr = [pairDice getCurrentRawDiceValues];
    movability = [sharedBoard isFlakeFromLocationIndex:11 canBeMovedWithDiceValuesArray:dicePairArr];
    XCTAssertEqual(movability, NO);
    
    
    
    
    // Test 2 -> black have flunk
    
    stock = [[TesterStock alloc] initByStockID:7];
    //NSLog(@"stock dictionary : %@" , stock.boardDictionary);
    [sharedBoard setUpWithFlakeDictionary:stock.boardDictionary];
    
    [pairDice setUpWithDiceValueOne:6 diceValueTwo:6];
    dicePairArr = [pairDice getCurrentRawDiceValues];
    movability = [sharedBoard isFlakeFromLocationIndex:locationBlackFlunk.locationID canBeMovedWithDiceValuesArray:dicePairArr];
    XCTAssertEqual(movability, NO);
    
    [pairDice setUpWithDiceValueOne:5 diceValueTwo:4];
    dicePairArr = [pairDice getCurrentRawDiceValues];
    movability = [sharedBoard isFlakeFromLocationIndex:locationBlackFlunk.locationID canBeMovedWithDiceValuesArray:dicePairArr];
    XCTAssertEqual(movability, YES);
    
    
    [pairDice setUpWithDiceValueOne:6 diceValueTwo:3];
    dicePairArr = [pairDice getCurrentRawDiceValues];
    movability = [sharedBoard isFlakeFromLocationIndex:locationBlackFlunk.locationID canBeMovedWithDiceValuesArray:dicePairArr];
    XCTAssertEqual(movability, NO);
    
    [pairDice setUpWithDiceValueOne:2 diceValueTwo:1];
    dicePairArr = [pairDice getCurrentRawDiceValues];
    movability = [sharedBoard isFlakeFromLocationIndex:locationBlackFlunk.locationID canBeMovedWithDiceValuesArray:dicePairArr];
    XCTAssertEqual(movability, YES);
    
    
    [pairDice setUpWithDiceValueOne:1 diceValueTwo:1];
    dicePairArr = [pairDice getCurrentRawDiceValues];
    movability = [sharedBoard isFlakeFromLocationIndex:locationBlackFlunk.locationID canBeMovedWithDiceValuesArray:dicePairArr];
    XCTAssertEqual(movability, YES);
    
    
    
    // Test 3 -> black have flunk + white have 1 open door
    
    stock = [[TesterStock alloc] initByStockID:8];
   // NSLog(@"stock dictionary : %@" , stock.boardDictionary);
    [sharedBoard setUpWithFlakeDictionary:stock.boardDictionary];
    
    [pairDice setUpWithDiceValueOne:6 diceValueTwo:6];
    dicePairArr = [pairDice getCurrentRawDiceValues];
    movability = [sharedBoard isFlakeFromLocationIndex:locationBlackFlunk.locationID canBeMovedWithDiceValuesArray:dicePairArr];
    XCTAssertEqual(movability, NO);
    
    [pairDice setUpWithDiceValueOne:5 diceValueTwo:4];
    dicePairArr = [pairDice getCurrentRawDiceValues];
    movability = [sharedBoard isFlakeFromLocationIndex:locationBlackFlunk.locationID canBeMovedWithDiceValuesArray:dicePairArr];
    XCTAssertEqual(movability, YES);
    
    
    [pairDice setUpWithDiceValueOne:6 diceValueTwo:3];
    dicePairArr = [pairDice getCurrentRawDiceValues];
    movability = [sharedBoard isFlakeFromLocationIndex:locationBlackFlunk.locationID canBeMovedWithDiceValuesArray:dicePairArr];
    XCTAssertEqual(movability, NO);
    
    [pairDice setUpWithDiceValueOne:2 diceValueTwo:1];
    dicePairArr = [pairDice getCurrentRawDiceValues];
    movability = [sharedBoard isFlakeFromLocationIndex:locationBlackFlunk.locationID canBeMovedWithDiceValuesArray:dicePairArr];
    XCTAssertEqual(movability, YES);
    
    
    [pairDice setUpWithDiceValueOne:1 diceValueTwo:1];
    dicePairArr = [pairDice getCurrentRawDiceValues];
    movability = [sharedBoard isFlakeFromLocationIndex:locationBlackFlunk.locationID canBeMovedWithDiceValuesArray:dicePairArr];
    XCTAssertEqual(movability, YES);

    
    [pairDice setUpWithDiceValueOne:5 diceValueTwo:5];
    dicePairArr = [pairDice getCurrentRawDiceValues];
    movability = [sharedBoard isFlakeFromLocationIndex:locationBlackFlunk.locationID canBeMovedWithDiceValuesArray:dicePairArr];
    XCTAssertEqual(movability, YES);

    
    [pairDice setUpWithDiceValueOne:3 diceValueTwo:3];
    dicePairArr = [pairDice getCurrentRawDiceValues];
    movability = [sharedBoard isFlakeFromLocationIndex:locationBlackFlunk.locationID canBeMovedWithDiceValuesArray:dicePairArr];
    XCTAssertEqual(movability, NO);
    
    
    
    // try to move from location not flunk
    
    [pairDice setUpWithDiceValueOne:1 diceValueTwo:1];
    dicePairArr = [pairDice getCurrentRawDiceValues];
    movability = [sharedBoard isFlakeFromLocationIndex:12 canBeMovedWithDiceValuesArray:dicePairArr];
    XCTAssertEqual(movability, NO);

    
}


-(void)testLocationIndexForColorType
{
    Board *sharedBoard = [Board sharedBoard] ;
    int locationNext ;
    TesterStock *stock ;
    
    // moving blacks
    
    stock = [[TesterStock alloc] initByStockID:1];
    [sharedBoard setUpWithFlakeDictionary:stock.boardDictionary];
    
    locationNext = [sharedBoard locationIndexForColor:kBackgammomColorTypeBlack fromLocationIndex:16 diceValue:6];
    XCTAssertEqual(10, locationNext);
    
    locationNext = [sharedBoard locationIndexForColor:kBackgammomColorTypeBlack fromLocationIndex:5 diceValue:6];
    XCTAssertEqual(-1, locationNext);
    
    
    locationNext = [sharedBoard locationIndexForColor:kBackgammomColorTypeBlack fromLocationIndex:5 diceValue:1];
    XCTAssertEqual(4, locationNext);
    
    
    
    
    // moving whites
    
    
    locationNext = [sharedBoard locationIndexForColor:kBackgammomColorTypeWhite fromLocationIndex:11 diceValue:6];
    XCTAssertEqual(17, locationNext);
    
    locationNext = [sharedBoard locationIndexForColor:kBackgammomColorTypeWhite fromLocationIndex:11 diceValue:36];
    XCTAssertEqual(-1, locationNext);


    
    // Test 2 - > blacks may collect
    stock = [[TesterStock alloc] initByStockID:13];
    [sharedBoard setUpWithFlakeDictionary:stock.boardDictionary];

    BoardLocation *locationBlackCamping = [sharedBoard boardLocationForBlackCampingArea];
    
    locationNext = [sharedBoard locationIndexForColor:kBackgammomColorTypeBlack fromLocationIndex:5 diceValue:16];
    XCTAssertEqual(locationBlackCamping.locationID, locationNext);
    
    
    locationNext = [sharedBoard locationIndexForColor:kBackgammomColorTypeBlack fromLocationIndex:3 diceValue:1];
    XCTAssertEqual(2, locationNext);
    
    locationNext = [sharedBoard locationIndexForColor:kBackgammomColorTypeBlack fromLocationIndex:3 diceValue:4];
    XCTAssertEqual(locationBlackCamping.locationID, locationNext);
    
    locationNext = [sharedBoard locationIndexForColor:kBackgammomColorTypeBlack fromLocationIndex:locationBlackCamping.locationID diceValue:6];
    XCTAssertEqual(-1, locationNext);
    
    
    // Test 3 - > blacks may collect if it had not got a flunk
    
    stock = [[TesterStock alloc] initByStockID:14];
    [sharedBoard setUpWithFlakeDictionary:stock.boardDictionary];
    
   
    
    locationNext = [sharedBoard locationIndexForColor:kBackgammomColorTypeBlack fromLocationIndex:5 diceValue:16];
    XCTAssertEqual(-1, locationNext);
    
    
    locationNext = [sharedBoard locationIndexForColor:kBackgammomColorTypeBlack fromLocationIndex:3 diceValue:1];
    XCTAssertEqual(2, locationNext);
    
    locationNext = [sharedBoard locationIndexForColor:kBackgammomColorTypeBlack fromLocationIndex:3 diceValue:4];
    XCTAssertEqual(-1, locationNext);
    
    locationNext = [sharedBoard locationIndexForColor:kBackgammomColorTypeBlack fromLocationIndex:locationBlackCamping.locationID diceValue:6];
    XCTAssertEqual(-1, locationNext);

    
}


-(void)testIsLocationPlayableForPlayerColor
{
    Board *sharedBoard = [Board sharedBoard] ;
    BOOL playability ;
    TesterStock *stock ;
    
    // Test 1
    
    stock = [[TesterStock alloc]initByStockID:1];
    [sharedBoard setUpWithFlakeDictionary:stock.boardDictionary];
    
    // play for whites
    for(int i=0 ; i<PLAYABLE_BOARD_LOCATIONS_COUNT ; i++)
    {
        playability = [sharedBoard isLocation:[sharedBoard boardLocationFromIndex:i] playableForFlakeColor:kBackgammomColorTypeWhite];
        
        if((i<7 && i>0) || i==16)
        {
            // can not play
            XCTAssertEqual(playability, NO);
        }
        else
        {
            // can play
            XCTAssertEqual(playability, YES);
        }
    }
    
    
    // play for blacks
    
    for(int i=0 ; i<PLAYABLE_BOARD_LOCATIONS_COUNT ; i++)
    {
        playability = [sharedBoard isLocation:[sharedBoard boardLocationFromIndex:i] playableForFlakeColor:kBackgammomColorTypeBlack];
        
        if(i==0 || i==11)
        {
            // can not play
            XCTAssertEqual(playability, NO);
        }
        else
        {
            // can  play
            
            XCTAssertEqual(playability, YES );
        }
    }

    
    
}


//-(BOOL)isFlakeAtLocationID:(int) locationID isCollectableWithDiceValue:(int)theDiceValue

-(void)testCollectableForColorWithCollectableConditions
{
    Board *sharedBoard =[Board sharedBoard];
    TesterStock *stock;
    //DicePair *pairDice = [DicePair sharedDicePair];
    BOOL collectability;
    
    // Test 9
    stock = [[TesterStock alloc]initByStockID:9];
    [sharedBoard setUpWithFlakeDictionary:stock.boardDictionary];
    
    
    collectability = [sharedBoard isFlakeAtLocationID:22 isCollectableWithDiceValue:3];
    XCTAssertEqual(collectability, NO);
    
    collectability = [sharedBoard isFlakeAtLocationID:22 isCollectableWithDiceValue:2];
    XCTAssertEqual(collectability, YES);
    
    collectability = [sharedBoard isFlakeAtLocationID:20 isCollectableWithDiceValue:4];
    XCTAssertEqual(collectability, YES);
    
    collectability = [sharedBoard isFlakeAtLocationID:20 isCollectableWithDiceValue:5];
    XCTAssertEqual(collectability, NO);
    
    collectability = [sharedBoard isFlakeAtLocationID:20 isCollectableWithDiceValue:6];
    XCTAssertEqual(collectability, NO);
    
    collectability = [sharedBoard isFlakeAtLocationID:20 isCollectableWithDiceValue:15];
    XCTAssertEqual(collectability, NO);
    
    
    collectability = [sharedBoard isFlakeAtLocationID:19 isCollectableWithDiceValue:5];
    XCTAssertEqual(collectability, YES);
    
   
    
    collectability = [sharedBoard isFlakeAtLocationID:18 isCollectableWithDiceValue:6];
    XCTAssertEqual(collectability, YES);
    
    
    collectability = [sharedBoard isFlakeAtLocationID:16 isCollectableWithDiceValue:6];
    XCTAssertEqual(collectability, NO);
    
    
    
    // blacks will collect
    
    stock = [[TesterStock alloc]initByStockID:12];
    [sharedBoard setUpWithFlakeDictionary:stock.boardDictionary];
    
    
    collectability = [sharedBoard isFlakeAtLocationID:1 isCollectableWithDiceValue:6];
    XCTAssertEqual(collectability, NO);
    
    collectability = [sharedBoard isFlakeAtLocationID:1 isCollectableWithDiceValue:5];
    XCTAssertEqual(collectability, NO);
    
    collectability = [sharedBoard isFlakeAtLocationID:1 isCollectableWithDiceValue:2];
    XCTAssertEqual(collectability, YES);
    
    collectability = [sharedBoard isFlakeAtLocationID:2 isCollectableWithDiceValue:4];
    XCTAssertEqual(collectability, NO);
    
    collectability = [sharedBoard isFlakeAtLocationID:2 isCollectableWithDiceValue:3];
    XCTAssertEqual(collectability, YES);
    
    
    // Semi - extreme condition for whites
    stock = [[TesterStock alloc]initByStockID:20];
    [sharedBoard setUpWithFlakeDictionary:stock.boardDictionary];
    
    collectability = [sharedBoard isFlakeAtLocationID:20 isCollectableWithDiceValue:5];
    XCTAssertEqual(collectability, YES);
    
    collectability = [sharedBoard isFlakeAtLocationID:20 isCollectableWithDiceValue:6];
    XCTAssertEqual(collectability, YES);
    
    collectability = [sharedBoard isFlakeAtLocationID:20 isCollectableWithDiceValue:4];
    XCTAssertEqual(collectability, YES);
    
    collectability = [sharedBoard isFlakeAtLocationID:21 isCollectableWithDiceValue:5];
    XCTAssertEqual(collectability, NO);
    
    
    // Semi - extreme condition for blacks
    
    stock = [[TesterStock alloc]initByStockID:21];
    [sharedBoard setUpWithFlakeDictionary:stock.boardDictionary];
    
    collectability = [sharedBoard isFlakeAtLocationID:2 isCollectableWithDiceValue:5];
    XCTAssertEqual(collectability, YES);
    
    collectability = [sharedBoard isFlakeAtLocationID:2 isCollectableWithDiceValue:6];
    XCTAssertEqual(collectability, YES);
    
    collectability = [sharedBoard isFlakeAtLocationID:1 isCollectableWithDiceValue:4];
    XCTAssertEqual(collectability, NO);
    

    
}




@end
