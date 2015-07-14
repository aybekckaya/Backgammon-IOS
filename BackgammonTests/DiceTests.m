//
//  DiceTests.m
//  Backgammon
//
//  Created by aybek can kaya on 22/06/15.
//  Copyright (c) 2015 aybek can kaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DicePair.h"


@interface DiceTests : XCTestCase



@end

@implementation DiceTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

/*
- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}
*/


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}


#pragma mark Dice Object Tests 

-(void)testDiceSetters
{
   // 2 sets tests requires 16 conditions : isPlayed , isHalfPlayed
    
    // set up conditions for 1st play
    NSMutableArray *dicesWithConditionsArr = [[NSMutableArray alloc]init];
 
    Dice *theDice = [[Dice alloc]init];
    theDice.isPlayed = NO;
    theDice.isHalfPlayed = NO;
    [dicesWithConditionsArr addObject:theDice];
    
    
    theDice = [[Dice alloc]init];
    theDice.isPlayed =YES;
    theDice.isHalfPlayed = NO;
    [dicesWithConditionsArr addObject:theDice];
    
    
    
    theDice = [[Dice alloc]init];
    theDice.isPlayed = NO;
    theDice.isHalfPlayed = YES;
    [dicesWithConditionsArr addObject:theDice];
    
    
    
    theDice = [[Dice alloc]init];
    theDice.isPlayed = YES;
    theDice.isHalfPlayed = YES;
    [dicesWithConditionsArr addObject:theDice];
    
    
    
    for(int i=0 ; i<dicesWithConditionsArr.count ; i++)
    {
        Dice *theDiceInner = dicesWithConditionsArr[i];
        
        BOOL oldConditionIsPlayed = theDiceInner.isPlayed;
        BOOL oldConditionIsHalfPlayed = theDiceInner.isHalfPlayed;
        
        NSLog(@"dice conditions old -> isPlayed : %d , isHalfPlayed : %d" , oldConditionIsPlayed,oldConditionIsHalfPlayed);
        
        // 4 new conditions
        
        // 1
        theDiceInner.isPlayed = YES;
        XCTAssertNotEqual(theDiceInner.isHalfPlayed, YES , @"Dice State Has failed at condition 1");
        
        [theDiceInner setUpWithConditionsIsPlayed:oldConditionIsPlayed isHalfPlayed:oldConditionIsHalfPlayed];
        
        // 2
        
        theDiceInner.isPlayed = NO;
        if(oldConditionIsHalfPlayed == YES)
        {
            XCTAssertNotEqual(theDiceInner.isHalfPlayed, NO , @"Dice state has failed at condition 2");
        }
        
         [theDiceInner setUpWithConditionsIsPlayed:oldConditionIsPlayed isHalfPlayed:oldConditionIsHalfPlayed];
        
        // 3
        
        theDiceInner.isHalfPlayed = YES;
        
        if(oldConditionIsHalfPlayed == YES)
        {
            XCTAssertNotEqual(theDiceInner.isPlayed, NO , @"Dice state has failed at condition 3");
        }
          [theDiceInner setUpWithConditionsIsPlayed:oldConditionIsPlayed isHalfPlayed:oldConditionIsHalfPlayed];
        
        // 4
        
        theDiceInner.isHalfPlayed = NO;
        
        if(oldConditionIsPlayed == NO)
        {
             XCTAssertNotEqual(theDiceInner.isPlayed, YES , @"Dice state has failed at condition 4");
        }
        
       
        
        
    }
    
}



-(void)testTotalValue
{
    DicePair *pairDice = [DicePair sharedDicePair];
    
    // equal dices
    [pairDice setUpWithDiceValueOne:4 diceValueTwo:4];
    
    int theValue = [pairDice totalPointOfPlayedDices];
    XCTAssertEqual(theValue, 0, @"Total dice value has asserted");
    
  //  [pairDice diceValueHasPlayed:3]; // should give NSAssert
    
    // 1. condition
    [pairDice diceValueHasPlayed:4];
    theValue = [pairDice totalPointOfPlayedDices];
    XCTAssertEqual(theValue, 1);
    
    [pairDice diceValueHasPlayed:8];
    theValue = [pairDice totalPointOfPlayedDices];
    XCTAssertEqual(theValue, 3);
    
    
    [pairDice diceValueHasPlayed:4];
    theValue = [pairDice totalPointOfPlayedDices];
    XCTAssertEqual(theValue, 4);
    
     // 2. condition
    
      [pairDice setUpWithDiceValueOne:4 diceValueTwo:4];
    
    [pairDice diceValueHasPlayed:16];
    theValue = [pairDice totalPointOfPlayedDices];
    XCTAssertEqual(theValue, 4);
    
    
    // 3. condition
    [pairDice setUpWithDiceValueOne:4 diceValueTwo:4];
    
    [pairDice diceValueHasPlayed:8];
    theValue = [pairDice totalPointOfPlayedDices];
    XCTAssertEqual(theValue, 2);
    
    [pairDice diceValueHasPlayed:8];
    theValue = [pairDice totalPointOfPlayedDices];
    XCTAssertEqual(theValue, 4);
    
    
    // non-equal dices
    [pairDice setUpWithDiceValueOne:5 diceValueTwo:3];
    
    
    [pairDice diceValueHasPlayed:5];
    theValue = [pairDice totalPointOfPlayedDices];
    XCTAssertEqual(theValue, 2);
    
    
}


-(void)testRemainingPoints
{
    DicePair *pairDice = [DicePair sharedDicePair];
    int remainingPt ;
    
    // Çift
    
    [pairDice setUpWithDiceValueOne:4 diceValueTwo:4];
     [pairDice diceValueHasPlayed:8];
    remainingPt = [pairDice remainingPointFromDices];
    XCTAssertEqual(remainingPt, 8);
    
    [pairDice setUpWithDiceValueOne:4 diceValueTwo:4];
    [pairDice diceValueHasPlayed:16];
    remainingPt = [pairDice remainingPointFromDices];
    XCTAssertEqual(remainingPt, 0);
    
    [pairDice setUpWithDiceValueOne:4 diceValueTwo:4];
    [pairDice diceValueHasPlayed:4];
    remainingPt = [pairDice remainingPointFromDices];
    XCTAssertEqual(remainingPt, 12);
    
    
    [pairDice setUpWithDiceValueOne:4 diceValueTwo:4];
    [pairDice diceValueHasPlayed:12];
    remainingPt = [pairDice remainingPointFromDices];
    XCTAssertEqual(remainingPt, 4);
    
    
    
    [pairDice setUpWithDiceValueOne:4 diceValueTwo:4];
    [pairDice diceValueHasPlayed:8];
    [pairDice diceValueHasPlayed:4];
    remainingPt = [pairDice remainingPointFromDices];
    XCTAssertEqual(remainingPt, 4);
    
    [pairDice setUpWithDiceValueOne:4 diceValueTwo:4];
    [pairDice diceValueHasPlayed:4];
    [pairDice diceValueHasPlayed:12];
    remainingPt = [pairDice remainingPointFromDices];
    XCTAssertEqual(remainingPt, 0);
    
    [pairDice setUpWithDiceValueOne:4 diceValueTwo:4];
    [pairDice diceValueHasPlayed:4];
     [pairDice diceValueHasPlayed:4];
    remainingPt = [pairDice remainingPointFromDices];
    XCTAssertEqual(remainingPt, 8);
    
    
    [pairDice setUpWithDiceValueOne:4 diceValueTwo:4];
    [pairDice diceValueHasPlayed:4];
    [pairDice diceValueHasPlayed:4];
    [pairDice diceValueHasPlayed:4];
    remainingPt = [pairDice remainingPointFromDices];
    XCTAssertEqual(remainingPt, 4);

    
    
    
    // Çift Değil
    
     [pairDice setUpWithDiceValueOne:4 diceValueTwo:6];
    [pairDice diceValueHasPlayed:4];
    remainingPt = [pairDice remainingPointFromDices];
    XCTAssertEqual(remainingPt, 6);

    [pairDice setUpWithDiceValueOne:4 diceValueTwo:6];
    [pairDice diceValueHasPlayed:6];
    remainingPt = [pairDice remainingPointFromDices];
    XCTAssertEqual(remainingPt, 4);
    
    
    [pairDice setUpWithDiceValueOne:4 diceValueTwo:6];
    [pairDice diceValueHasPlayed:4];
    [pairDice diceValueHasPlayed:6];
    remainingPt = [pairDice remainingPointFromDices];
    XCTAssertEqual(remainingPt, 0);
    
}


-(void)testPlayingOptions
{
    DicePair *pairDice = [DicePair sharedDicePair];
    NSArray *playingOptionsOfDices;
    BOOL checker ;
    
    // Çift
    [pairDice setUpWithDiceValueOne:5 diceValueTwo:5];
    playingOptionsOfDices = [pairDice playingOptions];
    NSArray *correctArr = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:5] , [NSNumber numberWithInt:10] , [NSNumber numberWithInt:15], [NSNumber numberWithInt:20], nil];
    
    checker = [self playingOptionsValue:playingOptionsOfDices correctArr:correctArr];
    XCTAssertEqual(checker, YES);
    
    
    
    [pairDice setUpWithDiceValueOne:5 diceValueTwo:5];
    [pairDice diceValueHasPlayed:5];
    playingOptionsOfDices = [pairDice playingOptions];
    correctArr = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:5] , [NSNumber numberWithInt:10] , [NSNumber numberWithInt:15],  nil];
    
    checker = [self playingOptionsValue:playingOptionsOfDices correctArr:correctArr];
    XCTAssertEqual(checker, YES);
    
    
    
    [pairDice setUpWithDiceValueOne:5 diceValueTwo:5];
    [pairDice diceValueHasPlayed:10];
    playingOptionsOfDices = [pairDice playingOptions];
    correctArr = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:5] , [NSNumber numberWithInt:10] ,  nil];
    
    checker = [self playingOptionsValue:playingOptionsOfDices correctArr:correctArr];
    XCTAssertEqual(checker, YES);
   
    
    [pairDice setUpWithDiceValueOne:5 diceValueTwo:5];
    [pairDice diceValueHasPlayed:10];
    [pairDice diceValueHasPlayed:5];
    playingOptionsOfDices = [pairDice playingOptions];
    correctArr = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:5] ,  nil];
    
    checker = [self playingOptionsValue:playingOptionsOfDices correctArr:correctArr];
    XCTAssertEqual(checker, YES);
    
    
    [pairDice setUpWithDiceValueOne:5 diceValueTwo:5];
    [pairDice diceValueHasPlayed:10];
    [pairDice diceValueHasPlayed:5];
     [pairDice diceValueHasPlayed:5];
    playingOptionsOfDices = [pairDice playingOptions];
    correctArr = [[NSArray alloc]init];
    
    checker = [self playingOptionsValue:playingOptionsOfDices correctArr:correctArr];
    XCTAssertEqual(checker, YES);
    
    
    
    
    // Çift degil
    
    [pairDice setUpWithDiceValueOne:5 diceValueTwo:3];
    playingOptionsOfDices = [pairDice playingOptions];
   correctArr = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:5] , [NSNumber numberWithInt:3] ,[NSNumber numberWithInt:8] , nil];
    
    checker = [self playingOptionsValue:playingOptionsOfDices correctArr:correctArr];
    XCTAssertEqual(checker, YES);

    
    [pairDice setUpWithDiceValueOne:5 diceValueTwo:3];
    [pairDice diceValueHasPlayed:8];
    playingOptionsOfDices = [pairDice playingOptions];
    correctArr = [[NSArray alloc]init];
    
    checker = [self playingOptionsValue:playingOptionsOfDices correctArr:correctArr];
    XCTAssertEqual(checker, YES);

    
    
    
    
    [pairDice setUpWithDiceValueOne:5 diceValueTwo:3];
    [pairDice diceValueHasPlayed:3];
    playingOptionsOfDices = [pairDice playingOptions];
  correctArr = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:5] ,  nil];
    
    checker = [self playingOptionsValue:playingOptionsOfDices correctArr:correctArr];
    XCTAssertEqual(checker, YES);
    
    
}


#pragma mark FUNCTIONS

-(BOOL)playingOptionsValue:(NSArray *)arrPlayingOptions correctArr:(NSArray *)arrCorrect
{
    if(arrCorrect.count != arrPlayingOptions.count)
    {
        return NO;
    }
    
    
    for(int i =0 ; i<arrCorrect.count ; i++)
    {
        NSNumber *numberCorrect = arrCorrect[i];
        if(![arrPlayingOptions containsObject:numberCorrect])
        {
            return NO;
        }
        
        NSNumber *numberPlayingOption = arrPlayingOptions[i];
        
        if(![arrCorrect containsObject:numberPlayingOption])
        {
            return NO;
        }
    }
    
   
    
    return YES;
}


- (BOOL)valueCheckForPlayingOptionsGiven:(NSArray *)playingOptionsArray numberList:(int)firstArg, ...
{
    NSMutableArray *suppliedNumbers = [[NSMutableArray alloc]init];
    
    va_list args;
    va_start(args, firstArg);
    
    for (int arg = firstArg; arg != nil; arg = va_arg(args, int))
    {
        NSNumber *numberComplement = [NSNumber numberWithInt:arg];
        [suppliedNumbers addObject:numberComplement];
        
        if(![playingOptionsArray containsObject:numberComplement])
        {
            va_end(args);
            return NO;
        }
    }
    
    va_end(args);
    
    
    if(suppliedNumbers.count != playingOptionsArray.count)
    {
        return NO;
    }
    
    
    
    for(int i=0 ; i < suppliedNumbers.count ;i++)
    {
        NSNumber *numberPlaying = playingOptionsArray[i];
        
        if(![suppliedNumbers containsObject:numberPlaying])
        {
            return NO;
        }
        
    }
    
   
    
    return YES;
}


@end
