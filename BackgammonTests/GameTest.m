//
//  GameTest.m
//  Backgammon
//
//  Created by aybek can kaya on 24/06/15.
//  Copyright (c) 2015 aybek can kaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Game.h"
#import "TesterStock.h"

@interface GameTest : XCTestCase

@property(nonatomic,strong) NSDictionary *gameInitDct;

// Test case repositionings:

// siyah 6 kapısına kadar kapattı , beyazın tüm taşları  0. indexte
//@property(nonatomic,strong) NSDictionary *dct

// siyahın tüm taşları iceride beyazın tüm tasları 0.indexte

// Beyazın bir kırıgı var siyahın 2.indexte kapısı acık


@property(nonatomic,strong) NSArray *testDictionaries;

@property(nonatomic,strong) Game *currentGame;




@end

@interface Game (Test)

-(int)diceValueUsedToMoveFrom:(int)fromLocationIndex toIndex:(int)toIndex;

@end


@implementation GameTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
  //  self.gameInitDct = [self gameInitDictionary];
    //[[Board sharedBoard] setUpWithFlakeDictionary:self.gameInitDct];
    //NSLog(@"%@" , self.gameInitDct);
    
    
    
    Player *playerWhite = [[Player alloc]initWithPlayerColor:kBackgammomColorTypeWhite playerName:@"Player 1"];
    Player *playerBlack = [[Player alloc]initWithPlayerColor:kBackgammomColorTypeBlack playerName:@"Player 2"];
    
    NSArray *arrPlayers = [[NSArray alloc]initWithObjects:playerWhite,playerBlack, nil];
    
    self.currentGame = [[Game alloc] initWithPlayers:arrPlayers];

    
    
    
    
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


#pragma mark GAME Tests

-(void)testChangeTurn
{
    Player *playerOfCurrentTurn ;
    colorType typeColor;
    
    
    playerOfCurrentTurn = [self.currentGame currentPlayerWhoHasTurn];
    typeColor = playerOfCurrentTurn.typeColor;
    XCTAssertEqual(typeColor, kBackgammomColorTypeWhite);
    
    [self.currentGame changeTurn];
    
    playerOfCurrentTurn = [self.currentGame currentPlayerWhoHasTurn];
    typeColor = playerOfCurrentTurn.typeColor;
    XCTAssertEqual(typeColor, kBackgammomColorTypeBlack);
    
    
    [self.currentGame changeTurn];
    
    playerOfCurrentTurn = [self.currentGame currentPlayerWhoHasTurn];
    typeColor = playerOfCurrentTurn.typeColor;
    XCTAssertEqual(typeColor, kBackgammomColorTypeWhite);
}


-(void)testCanPlay
{
    BOOL playability;
    DicePair *pairDice = [DicePair sharedDicePair];
    Board *sharedBoard = [Board sharedBoard];
    int currIndexOfTest = 0;
    NSDictionary *boardDct;
    
    /**
        Oyuncu : Beyaz
     */
    
    /*
        Arrange test dices:
     
        3-3  , 6-5 , 5-4 , 3-2 , 1-1, 6-6 , 4-3 , 5-5
     
     */
    
    TesterStock *stock;
    
    // tester-stock-1
    stock = [[TesterStock alloc]initByStockID:1];
    boardDct = stock.boardDictionary;
    [sharedBoard setUpWithFlakeDictionary:boardDct];
    
  //  NSLog(@"board : %@" , boardDct);
    
    [pairDice setUpWithDiceValueOne:3 diceValueTwo:3];
    playability = [self.currentGame isPlayerCanPlayWithCurrentDices];
    XCTAssertEqual(playability, YES);
    
    [pairDice setUpWithDiceValueOne:1 diceValueTwo:1];
    playability = [self.currentGame isPlayerCanPlayWithCurrentDices];
    XCTAssertEqual(playability, YES);
    
    [pairDice setUpWithDiceValueOne:6 diceValueTwo:5];
    playability = [self.currentGame isPlayerCanPlayWithCurrentDices];
    XCTAssertEqual(playability, YES);
    
    [pairDice setUpWithDiceValueOne:4 diceValueTwo:5];
    playability = [self.currentGame isPlayerCanPlayWithCurrentDices];
    XCTAssertEqual(playability, YES);
    
    [pairDice setUpWithDiceValueOne:3 diceValueTwo:2];
    playability = [self.currentGame isPlayerCanPlayWithCurrentDices];
    XCTAssertEqual(playability, YES);
    
    
    [pairDice setUpWithDiceValueOne:6 diceValueTwo:6];
    playability = [self.currentGame isPlayerCanPlayWithCurrentDices];
    XCTAssertEqual(playability, YES);
    
    
    [pairDice setUpWithDiceValueOne:3 diceValueTwo:4];
    playability = [self.currentGame isPlayerCanPlayWithCurrentDices];
    XCTAssertEqual(playability, YES);
    
    [pairDice setUpWithDiceValueOne:5 diceValueTwo:5];
    playability = [self.currentGame isPlayerCanPlayWithCurrentDices];
    XCTAssertEqual(playability, NO);
    
    currIndexOfTest++;
    
    
     // tester-stock-2
    stock = [[TesterStock alloc]initByStockID:2];
    boardDct = stock.boardDictionary;
    
    [sharedBoard setUpWithFlakeDictionary:boardDct];
    
    //  NSLog(@"board : %@" , boardDct);
    
    [pairDice setUpWithDiceValueOne:3 diceValueTwo:3];
    playability = [self.currentGame isPlayerCanPlayWithCurrentDices];
    XCTAssertEqual(playability, NO);
    
    [pairDice setUpWithDiceValueOne:6 diceValueTwo:5];
    playability = [self.currentGame isPlayerCanPlayWithCurrentDices];
    XCTAssertEqual(playability, NO);
    
    [pairDice setUpWithDiceValueOne:4 diceValueTwo:5];
    playability = [self.currentGame isPlayerCanPlayWithCurrentDices];
    XCTAssertEqual(playability, NO);
    
    [pairDice setUpWithDiceValueOne:3 diceValueTwo:2];
    playability = [self.currentGame isPlayerCanPlayWithCurrentDices];
    XCTAssertEqual(playability, NO);
    
    
    [pairDice setUpWithDiceValueOne:6 diceValueTwo:6];
    playability = [self.currentGame isPlayerCanPlayWithCurrentDices];
    XCTAssertEqual(playability, NO);
    
    
    [pairDice setUpWithDiceValueOne:3 diceValueTwo:4];
    playability = [self.currentGame isPlayerCanPlayWithCurrentDices];
    XCTAssertEqual(playability, NO);
    
    [pairDice setUpWithDiceValueOne:5 diceValueTwo:5];
    playability = [self.currentGame isPlayerCanPlayWithCurrentDices];
    XCTAssertEqual(playability, NO);
    
    [pairDice setUpWithDiceValueOne:1 diceValueTwo:1];
    playability = [self.currentGame isPlayerCanPlayWithCurrentDices];
    XCTAssertEqual(playability, YES);
    
    currIndexOfTest++;
    
    
    
     // tester-stock-3
    stock = [[TesterStock alloc]initByStockID:3];
    boardDct = stock.boardDictionary;
    [sharedBoard setUpWithFlakeDictionary:boardDct];
    
    //  NSLog(@"board : %@" , boardDct);
    
    [pairDice setUpWithDiceValueOne:3 diceValueTwo:3];
    playability = [self.currentGame isPlayerCanPlayWithCurrentDices];
    XCTAssertEqual(playability, NO);
    
    [pairDice setUpWithDiceValueOne:6 diceValueTwo:5];
    playability = [self.currentGame isPlayerCanPlayWithCurrentDices];
    XCTAssertEqual(playability, NO);
    
    [pairDice setUpWithDiceValueOne:4 diceValueTwo:5];
    playability = [self.currentGame isPlayerCanPlayWithCurrentDices];
    XCTAssertEqual(playability, NO);
    
    [pairDice setUpWithDiceValueOne:3 diceValueTwo:2];
    playability = [self.currentGame isPlayerCanPlayWithCurrentDices];
    XCTAssertEqual(playability, NO);
    
    
    [pairDice setUpWithDiceValueOne:6 diceValueTwo:6];
    playability = [self.currentGame isPlayerCanPlayWithCurrentDices];
    XCTAssertEqual(playability, NO);
    
    
    [pairDice setUpWithDiceValueOne:3 diceValueTwo:4];
    playability = [self.currentGame isPlayerCanPlayWithCurrentDices];
    XCTAssertEqual(playability, NO);
    
    [pairDice setUpWithDiceValueOne:5 diceValueTwo:5];
    playability = [self.currentGame isPlayerCanPlayWithCurrentDices];
    XCTAssertEqual(playability, NO);
    
    [pairDice setUpWithDiceValueOne:1 diceValueTwo:1];
    playability = [self.currentGame isPlayerCanPlayWithCurrentDices];
    XCTAssertEqual(playability, YES);
    
    currIndexOfTest++;


    // tester-stock-4
    stock = [[TesterStock alloc]initByStockID:4];
    boardDct = stock.boardDictionary;
    [sharedBoard setUpWithFlakeDictionary:boardDct];
    
    //  NSLog(@"board : %@" , boardDct);
    
    [pairDice setUpWithDiceValueOne:3 diceValueTwo:3];
    playability = [self.currentGame isPlayerCanPlayWithCurrentDices];
    XCTAssertEqual(playability, NO);
    
    [pairDice setUpWithDiceValueOne:6 diceValueTwo:5];
    playability = [self.currentGame isPlayerCanPlayWithCurrentDices];
    XCTAssertEqual(playability, YES);
    
    [pairDice setUpWithDiceValueOne:4 diceValueTwo:5];
    playability = [self.currentGame isPlayerCanPlayWithCurrentDices];
    XCTAssertEqual(playability, NO);
    
    [pairDice setUpWithDiceValueOne:3 diceValueTwo:2];
    playability = [self.currentGame isPlayerCanPlayWithCurrentDices];
    XCTAssertEqual(playability, NO);
    
    
    [pairDice setUpWithDiceValueOne:6 diceValueTwo:6];
    playability = [self.currentGame isPlayerCanPlayWithCurrentDices];
    XCTAssertEqual(playability, YES);
    
    
    [pairDice setUpWithDiceValueOne:3 diceValueTwo:4];
    playability = [self.currentGame isPlayerCanPlayWithCurrentDices];
    XCTAssertEqual(playability, NO);
    
    [pairDice setUpWithDiceValueOne:5 diceValueTwo:5];
    playability = [self.currentGame isPlayerCanPlayWithCurrentDices];
    XCTAssertEqual(playability, NO);
    
    [pairDice setUpWithDiceValueOne:1 diceValueTwo:1];
    playability = [self.currentGame isPlayerCanPlayWithCurrentDices];
    XCTAssertEqual(playability, YES);
    
    currIndexOfTest++;
    
    
    
}

-(void)testUsingCorrectDiceValuesInSuggestions
{
    
    Game *currentGame = [[Game alloc]init];
    Board *sharedBoard = [Board sharedBoard];
    DicePair *pairDice = [DicePair sharedDicePair];
    TesterStock *stock ;
    NSArray *suggestions;
    BoardLocation *fromLocation;
    int diceValDetermined;
    NSArray *playingOptionsArr;
    
    // Test 1
    stock = [[TesterStock alloc]initByStockID:1];
    [sharedBoard setUpWithFlakeDictionary:stock.boardDictionary];
    
    [pairDice setUpWithDiceValueOne:4 diceValueTwo:4];
    playingOptionsArr = [pairDice playingOptions];
    
    fromLocation = [sharedBoard boardLocationFromIndex:11];
    suggestions = [currentGame suggestionsFromBoardLocation:fromLocation];
    if(suggestions.count > 0)
    {
        diceValDetermined = [currentGame diceValueUsedToMoveFrom:fromLocation.locationID toIndex:[suggestions[0] intValue]];
        XCTAssertEqual(diceValDetermined, 4);
        diceValDetermined = [currentGame diceValueUsedToMoveFrom:fromLocation.locationID toIndex:[suggestions[1] intValue]];
        XCTAssertEqual(diceValDetermined, 8);
        diceValDetermined = [currentGame diceValueUsedToMoveFrom:fromLocation.locationID toIndex:[suggestions[2] intValue]];
        XCTAssertEqual(diceValDetermined, 12);
    }
   
    
    
    
    [pairDice setUpWithDiceValueOne:5 diceValueTwo:4];
    playingOptionsArr = [pairDice playingOptions];
    fromLocation = [sharedBoard boardLocationFromIndex:11];
    suggestions = [currentGame suggestionsFromBoardLocation:fromLocation];
    diceValDetermined = [currentGame diceValueUsedToMoveFrom:fromLocation.locationID toIndex:[suggestions[0] intValue]];
    XCTAssertEqual(diceValDetermined, 9);

    
    
    [pairDice setUpWithDiceValueOne:4 diceValueTwo:4];
    playingOptionsArr = [pairDice playingOptions];
    
    fromLocation = [sharedBoard boardLocationFromIndex:12];
    suggestions = [currentGame suggestionsFromBoardLocation:fromLocation];
    diceValDetermined = [currentGame diceValueUsedToMoveFrom:fromLocation.locationID toIndex:[suggestions[0] intValue]];
    XCTAssertEqual(diceValDetermined, 4);
    
    
    [pairDice setUpWithDiceValueOne:4 diceValueTwo:5];
    playingOptionsArr = [pairDice playingOptions];
    
    fromLocation = [sharedBoard boardLocationFromIndex:12];
    suggestions = [currentGame suggestionsFromBoardLocation:fromLocation];
    diceValDetermined = [currentGame diceValueUsedToMoveFrom:fromLocation.locationID toIndex:[suggestions[0] intValue]];
    XCTAssertEqual(diceValDetermined, 9);

    
    
    // Test 2
    
    stock = [[TesterStock alloc]initByStockID:2];
    [sharedBoard setUpWithFlakeDictionary:stock.boardDictionary];
    
    
    BoardLocation *whiteFlunkArea  = [sharedBoard boardLocationForWhiteFlunkArea];
    
    [pairDice setUpWithDiceValueOne:1 diceValueTwo:2];
     fromLocation = [sharedBoard boardLocationFromIndex:whiteFlunkArea.locationID];
    suggestions = [currentGame suggestionsFromBoardLocation:fromLocation];
    diceValDetermined = [currentGame diceValueUsedToMoveFrom:fromLocation.locationID toIndex:0];
    
    XCTAssertEqual(1, diceValDetermined);
    
    [pairDice setUpWithDiceValueOne:1 diceValueTwo:1];
    fromLocation = [sharedBoard boardLocationFromIndex:whiteFlunkArea.locationID];
    suggestions = [currentGame suggestionsFromBoardLocation:fromLocation];
    diceValDetermined = [currentGame diceValueUsedToMoveFrom:fromLocation.locationID toIndex:0];

     XCTAssertEqual(1, diceValDetermined);
    
    
    // Test 3
    
    stock = [[TesterStock alloc]initByStockID:3];
    [sharedBoard setUpWithFlakeDictionary:stock.boardDictionary];
    
    
    [pairDice setUpWithDiceValueOne:1 diceValueTwo:6];
    fromLocation = [sharedBoard boardLocationFromIndex:whiteFlunkArea.locationID];
    suggestions = [currentGame suggestionsFromBoardLocation:fromLocation];
    diceValDetermined = [currentGame diceValueUsedToMoveFrom:fromLocation.locationID toIndex:0];
    
    XCTAssertEqual(1, diceValDetermined);
    
    [pairDice setUpWithDiceValueOne:6 diceValueTwo:1];
    fromLocation = [sharedBoard boardLocationFromIndex:0];
    suggestions = [currentGame suggestionsFromBoardLocation:fromLocation];
    diceValDetermined = [currentGame diceValueUsedToMoveFrom:fromLocation.locationID toIndex:6];
    
    XCTAssertEqual(6, diceValDetermined);

    
    
    // Test 4
    
    stock = [[TesterStock alloc]initByStockID:4];
   
    [sharedBoard setUpWithFlakeDictionary:stock.boardDictionary];
    
    
    [pairDice setUpWithDiceValueOne:1 diceValueTwo:6];
    fromLocation = [sharedBoard boardLocationFromIndex:whiteFlunkArea.locationID];
    suggestions = [currentGame suggestionsFromBoardLocation:fromLocation];
    diceValDetermined = [currentGame diceValueUsedToMoveFrom:fromLocation.locationID toIndex:0];
    
    XCTAssertEqual(1, diceValDetermined);
    
    [pairDice setUpWithDiceValueOne:6 diceValueTwo:1];
    fromLocation = [sharedBoard boardLocationFromIndex:whiteFlunkArea.locationID];
    suggestions = [currentGame suggestionsFromBoardLocation:fromLocation];
    diceValDetermined = [currentGame diceValueUsedToMoveFrom:fromLocation.locationID toIndex:5];
    
    XCTAssertEqual(6, diceValDetermined);

    
    // Test 7 -> black has flunk
    
    stock = [[TesterStock alloc]initByStockID:7];
    
    [sharedBoard setUpWithFlakeDictionary:stock.boardDictionary];
    BoardLocation *blackFlunkArea = [sharedBoard boardLocationForBlackFlunkArea];
    
    [pairDice setUpWithDiceValueOne:1 diceValueTwo:6];
    fromLocation = [sharedBoard boardLocationFromIndex:blackFlunkArea.locationID];
    suggestions = [currentGame suggestionsFromBoardLocation:fromLocation];
    diceValDetermined = [currentGame diceValueUsedToMoveFrom:fromLocation.locationID toIndex:23];
    
    XCTAssertEqual(1, diceValDetermined);

    
    [pairDice setUpWithDiceValueOne:1 diceValueTwo:6];
    fromLocation = [sharedBoard boardLocationFromIndex:blackFlunkArea.locationID];
    suggestions = [currentGame suggestionsFromBoardLocation:fromLocation];
    diceValDetermined = [currentGame diceValueUsedToMoveFrom:fromLocation.locationID toIndex:18];
    
    XCTAssertEqual(6, diceValDetermined);
    
    
    
    // Test 9 - > whites can collect
    
    
    stock = [[TesterStock alloc]initByStockID:9];
    
    [sharedBoard setUpWithFlakeDictionary:stock.boardDictionary];
    BoardLocation *whiteCampingArea = [sharedBoard boardLocationForWhiteCampingArea];
    
    [pairDice setUpWithDiceValueOne:1 diceValueTwo:5];
    fromLocation = [sharedBoard boardLocationFromIndex:18];
    suggestions = [currentGame suggestionsFromBoardLocation:fromLocation];
    diceValDetermined = [currentGame diceValueUsedToMoveFrom:fromLocation.locationID toIndex:whiteCampingArea.locationID];
    
    XCTAssertEqual(6, diceValDetermined);
    
    
    [pairDice setUpWithDiceValueOne:1 diceValueTwo:4];
    fromLocation = [sharedBoard boardLocationFromIndex:5];
    suggestions = [currentGame suggestionsFromBoardLocation:fromLocation];
    diceValDetermined = [currentGame diceValueUsedToMoveFrom:fromLocation.locationID toIndex:0];
    
    XCTAssertEqual(5, diceValDetermined);
    
    
    
    // Test 12 - > blacks may collect
    
    stock = [[TesterStock alloc]initByStockID:12];
    
    [sharedBoard setUpWithFlakeDictionary:stock.boardDictionary];
    BoardLocation *blackCampingArea = [sharedBoard boardLocationForBlackCampingArea];
    
    [pairDice setUpWithDiceValueOne:5 diceValueTwo:4];
    fromLocation = [sharedBoard boardLocationFromIndex:5];
    suggestions = [currentGame suggestionsFromBoardLocation:fromLocation];
    diceValDetermined = [currentGame diceValueUsedToMoveFrom:fromLocation.locationID toIndex:blackCampingArea.locationID];
    
    XCTAssertEqual(9, diceValDetermined);
    
}


-(void)testSuggestionsWithSuggestionCounts
{
    Board *sharedBoard = [Board sharedBoard];
    TesterStock *stock ;
    NSArray *suggestionsArr;
    BoardLocation *fromLocation;
    
    Game *theGame = [[Game alloc]init];
    DicePair *pairDice = [DicePair sharedDicePair];
    
    // Test 1
    stock = [[TesterStock alloc]initByStockID:1];
    [sharedBoard setUpWithFlakeDictionary:stock.boardDictionary];
    
    fromLocation = [sharedBoard boardLocationFromIndex:0];
    [pairDice setUpWithDiceValueOne:6 diceValueTwo:1];
    suggestionsArr = [theGame suggestionsFromBoardLocation:fromLocation];
    
    XCTAssertEqual(suggestionsArr.count, 0);
    
    
    fromLocation = [sharedBoard boardLocationFromIndex:11];
    [pairDice setUpWithDiceValueOne:6 diceValueTwo:1];
    suggestionsArr = [theGame suggestionsFromBoardLocation:fromLocation];
    
    XCTAssertEqual(suggestionsArr.count, 2);
    
    
    fromLocation = [sharedBoard boardLocationFromIndex:11];
    [pairDice setUpWithDiceValueOne:5 diceValueTwo:5];
    suggestionsArr = [theGame suggestionsFromBoardLocation:fromLocation];
    
    XCTAssertEqual(suggestionsArr.count, 0);
 
    
    fromLocation = [sharedBoard boardLocationFromIndex:0];
    [pairDice setUpWithDiceValueOne:6 diceValueTwo:6];
    suggestionsArr = [theGame suggestionsFromBoardLocation:fromLocation];
    
    XCTAssertEqual(suggestionsArr.count, 0);
    
    
    
    fromLocation = [sharedBoard boardLocationFromIndex:11];
    [pairDice setUpWithDiceValueOne:6 diceValueTwo:5];
    suggestionsArr = [theGame suggestionsFromBoardLocation:fromLocation];
    
    XCTAssertEqual(suggestionsArr.count, 2);
    
    
    fromLocation = [sharedBoard boardLocationFromIndex:11];
    [pairDice setUpWithDiceValueOne:1 diceValueTwo:5];
    suggestionsArr = [theGame suggestionsFromBoardLocation:fromLocation];
    
    XCTAssertEqual(suggestionsArr.count, 1);
    
    
    fromLocation = [sharedBoard boardLocationFromIndex:11];
    [pairDice setUpWithDiceValueOne:1 diceValueTwo:1];
    suggestionsArr = [theGame suggestionsFromBoardLocation:fromLocation];
    
    XCTAssertEqual(suggestionsArr.count, 1);


    fromLocation = [sharedBoard boardLocationFromIndex:11];
    [pairDice setUpWithDiceValueOne:2 diceValueTwo:2];
    suggestionsArr = [theGame suggestionsFromBoardLocation:fromLocation];
    
    XCTAssertEqual(suggestionsArr.count, 4);
    
    
    fromLocation = [sharedBoard boardLocationFromIndex:11];
    [pairDice setUpWithDiceValueOne:4 diceValueTwo:4];
    suggestionsArr = [theGame suggestionsFromBoardLocation:fromLocation];
    
    XCTAssertEqual(suggestionsArr.count, 3);

    
    fromLocation = [sharedBoard boardLocationFromIndex:11];
    [pairDice setUpWithDiceValueOne:6 diceValueTwo:6];
    suggestionsArr = [theGame suggestionsFromBoardLocation:fromLocation];
    
    XCTAssertEqual(suggestionsArr.count, 2);
    
    
    // blacks play
    
    fromLocation = [sharedBoard boardLocationFromIndex:16];
    [pairDice setUpWithDiceValueOne:5 diceValueTwo:5];
    suggestionsArr = [theGame suggestionsFromBoardLocation:fromLocation];
    
    XCTAssertEqual(suggestionsArr.count, 0);
    
    
    
    fromLocation = [sharedBoard boardLocationFromIndex:16];
    [pairDice setUpWithDiceValueOne:4 diceValueTwo:4];
    suggestionsArr = [theGame suggestionsFromBoardLocation:fromLocation];
    
    XCTAssertEqual(suggestionsArr.count, 3);
    
    
    fromLocation = [sharedBoard boardLocationFromIndex:16];
    [pairDice setUpWithDiceValueOne:5 diceValueTwo:4];
    suggestionsArr = [theGame suggestionsFromBoardLocation:fromLocation];
    
    XCTAssertEqual(suggestionsArr.count, 2);
    
}

-(void)testSuggestionsWithPositionings
{
    Board *sharedBoard = [Board sharedBoard];
    NSArray *correctValuesArr;
    NSArray *suggestionsArr;
    Game *theGame = [[Game alloc]init];
    DicePair *pairDice = [DicePair sharedDicePair];
    TesterStock *stock ;
    BoardLocation *fromLocation;
    BOOL check;
    
    // Test 1
    
    stock = [[TesterStock alloc]initByStockID:1];
    [sharedBoard setUpWithFlakeDictionary:stock.boardDictionary];
    
    [pairDice setUpWithDiceValueOne:4 diceValueTwo:4];
    fromLocation = [sharedBoard boardLocationFromIndex:11];
    suggestionsArr = [theGame suggestionsFromBoardLocation:fromLocation];
    correctValuesArr = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:15], [NSNumber numberWithInt:19] , [NSNumber numberWithInt:23], nil];
    check = [self suggestionsCheckerHelper:suggestionsArr isSameWithArray:correctValuesArr];
    XCTAssertEqual(check, YES);
    
    
    [pairDice setUpWithDiceValueOne:1 diceValueTwo:1];
    fromLocation = [sharedBoard boardLocationFromIndex:11];
    suggestionsArr = [theGame suggestionsFromBoardLocation:fromLocation];
    correctValuesArr = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:12], nil];
    check = [self suggestionsCheckerHelper:suggestionsArr isSameWithArray:correctValuesArr];
    XCTAssertEqual(check, YES);
    
    
    [pairDice setUpWithDiceValueOne:5 diceValueTwo:5];
    fromLocation = [sharedBoard boardLocationFromIndex:11];
    suggestionsArr = [theGame suggestionsFromBoardLocation:fromLocation];
    correctValuesArr = [[NSArray alloc]init];
    check = [self suggestionsCheckerHelper:suggestionsArr isSameWithArray:correctValuesArr];
    XCTAssertEqual(check, YES);
    
    
    [pairDice setUpWithDiceValueOne:6 diceValueTwo:6];
    fromLocation = [sharedBoard boardLocationFromIndex:11];
    suggestionsArr = [theGame suggestionsFromBoardLocation:fromLocation];
    correctValuesArr = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:17], [NSNumber numberWithInt:23] ,  nil];
    check = [self suggestionsCheckerHelper:suggestionsArr isSameWithArray:correctValuesArr];
    XCTAssertEqual(check, YES);
    
    // Test 15
    stock = [[TesterStock alloc]initByStockID:15];
    [sharedBoard setUpWithFlakeDictionary:stock.boardDictionary];
    
    [pairDice setUpWithDiceValueOne:1 diceValueTwo:1];
    fromLocation = [sharedBoard boardLocationFromIndex:0];
    suggestionsArr = [theGame suggestionsFromBoardLocation:fromLocation];
    correctValuesArr = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:1],  nil];
    check = [self suggestionsCheckerHelper:suggestionsArr isSameWithArray:correctValuesArr];
    XCTAssertEqual(check, YES);
    
    [pairDice setUpWithDiceValueOne:2 diceValueTwo:1];
    fromLocation = [sharedBoard boardLocationFromIndex:0];
    suggestionsArr = [theGame suggestionsFromBoardLocation:fromLocation];
    correctValuesArr = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],   nil];
    check = [self suggestionsCheckerHelper:suggestionsArr isSameWithArray:correctValuesArr];
    XCTAssertEqual(check, YES);
    
    
    [pairDice setUpWithDiceValueOne:3 diceValueTwo:1];
    fromLocation = [sharedBoard boardLocationFromIndex:0];
    suggestionsArr = [theGame suggestionsFromBoardLocation:fromLocation];
    correctValuesArr = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:3],   nil];
    check = [self suggestionsCheckerHelper:suggestionsArr isSameWithArray:correctValuesArr];
    XCTAssertEqual(check, YES);

    
    
    
    // Test 16
    stock = [[TesterStock alloc]initByStockID:16];
    [sharedBoard setUpWithFlakeDictionary:stock.boardDictionary];
    
    [pairDice setUpWithDiceValueOne:1 diceValueTwo:1];
    fromLocation = [sharedBoard boardLocationFromIndex:0];
    suggestionsArr = [theGame suggestionsFromBoardLocation:fromLocation];
    correctValuesArr = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:1], nil];
    check = [self suggestionsCheckerHelper:suggestionsArr isSameWithArray:correctValuesArr];
    XCTAssertEqual(check, YES);

    
    [pairDice setUpWithDiceValueOne:2 diceValueTwo:1];
    fromLocation = [sharedBoard boardLocationFromIndex:0];
    suggestionsArr = [theGame suggestionsFromBoardLocation:fromLocation];
    correctValuesArr = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:2], nil];
    check = [self suggestionsCheckerHelper:suggestionsArr isSameWithArray:correctValuesArr];
    XCTAssertEqual(check, YES);
    
    
    [pairDice setUpWithDiceValueOne:3 diceValueTwo:1];
    fromLocation = [sharedBoard boardLocationFromIndex:0];
    suggestionsArr = [theGame suggestionsFromBoardLocation:fromLocation];
    correctValuesArr = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:3], nil];
    check = [self suggestionsCheckerHelper:suggestionsArr isSameWithArray:correctValuesArr];
    XCTAssertEqual(check, YES);
    
    
    // Test 17
    stock = [[TesterStock alloc]initByStockID:17];
    [sharedBoard setUpWithFlakeDictionary:stock.boardDictionary];
    
    [pairDice setUpWithDiceValueOne:2 diceValueTwo:1];
    fromLocation = [sharedBoard boardLocationFromIndex:0];
    suggestionsArr = [theGame suggestionsFromBoardLocation:fromLocation];
    correctValuesArr = [[NSArray alloc]init];
    check = [self suggestionsCheckerHelper:suggestionsArr isSameWithArray:correctValuesArr];
    XCTAssertEqual(check, YES);
    
    [pairDice setUpWithDiceValueOne:5 diceValueTwo:1];
    fromLocation = [sharedBoard boardLocationFromIndex:0];
    suggestionsArr = [theGame suggestionsFromBoardLocation:fromLocation];
    correctValuesArr = [[NSArray alloc]init];
    check = [self suggestionsCheckerHelper:suggestionsArr isSameWithArray:correctValuesArr];
    XCTAssertEqual(check, YES);
    
    
    // Test 18
    stock = [[TesterStock alloc]initByStockID:18];
    [sharedBoard setUpWithFlakeDictionary:stock.boardDictionary];
    
    [pairDice setUpWithDiceValueOne:2 diceValueTwo:3];
    fromLocation = [sharedBoard boardLocationFromIndex:24];
    suggestionsArr = [theGame suggestionsFromBoardLocation:fromLocation];
    correctValuesArr = [[NSArray alloc]init];
    check = [self suggestionsCheckerHelper:suggestionsArr isSameWithArray:correctValuesArr];
    XCTAssertEqual(check, YES);
    
    [pairDice setUpWithDiceValueOne:3 diceValueTwo:6];
    fromLocation = [sharedBoard boardLocationFromIndex:24];
    suggestionsArr = [theGame suggestionsFromBoardLocation:fromLocation];
    correctValuesArr = [[NSArray alloc]init];
    check = [self suggestionsCheckerHelper:suggestionsArr isSameWithArray:correctValuesArr];
    XCTAssertEqual(check, YES);

    
    // 6 , 5
    
    // Test 19
    
    /*
    stock = [[TesterStock alloc]initByStockID:19];
    [sharedBoard setUpWithFlakeDictionary:stock.boardDictionary];
    
    [pairDice setUpWithDiceValueOne:6 diceValueTwo:5];
    fromLocation = [sharedBoard boardLocationFromIndex:24];
    suggestionsArr = [theGame suggestionsFromBoardLocation:fromLocation];
    correctValuesArr = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:4], nil];
    check = [self suggestionsCheckerHelper:suggestionsArr isSameWithArray:correctValuesArr];
    XCTAssertEqual(check, YES);
    */
}






-(BOOL)suggestionsCheckerHelper:(NSArray *)arr1 isSameWithArray:(NSArray *)arr2
{
    if(arr1.count != arr2.count)
    {
        return NO;
    }
    
    for(int i =0 ; i<arr1.count ; i++)
    {
        int arr1Val = [arr1[i] intValue];
        
        if(![arr2 containsObject:[NSNumber numberWithInt:arr1Val]])
        {
            return NO;
        }
        
    }
    
    return YES;
}



@end
