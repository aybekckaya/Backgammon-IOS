//
//  Board.h
//  Backgammon
//
//  Created by aybek can kaya on 15/06/15.
//  Copyright (c) 2015 aybek can kaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BoardLocation.h"
#import "Suggestion.h"
#import "GamePlaySaveStock.h"

#define PLAYABLE_BOARD_LOCATIONS_COUNT 24
#define NUMBER_OF_CAMPING_AREAS 2
#define NUMBER_OF_FLUNK_AREAS 2


typedef enum PlayerWinType
{
    kPlayerWinTypeNormal,
    kPlayerWinTypeMars
}PlayerWinType;

/*
typedef enum BoardLocationGameLogic
{
    kBoardLocationGamePlayNone ,
    kBoardLocationGamePlayRequireFlunk
    
}BoardLocationLogic;
*/

@protocol BoardDelegate <NSObject>

-(void)boardWillAboutToSaveGameState;

-(void)boardFlakeHasFlunkedFlakeID:(int)flakeIDThatHasFlunked;

@required
-(void)boardGameHasWonByPlayerColor:(colorType) typeColorOfWinningPlayer winingType:(PlayerWinType) winType;

@end

@interface Board : NSObject
{
    NSMutableArray *boardLocationsArr;
}

@property(nonatomic,weak) id <BoardDelegate> delegate;

// can collect
@property(nonatomic,readonly) BOOL blacksMayCollect;
@property(nonatomic, readonly) BOOL whitesMayCollect;

+(id)sharedBoard;

-(void)setUpBoardLocationsWithBoardFrameRectangles:(NSArray *)boardFrameRects;

/**
   CAUTION : Use only for testing . Yer degistirmede stack->pop dogru sekilde yapılıyor mu bunun kontrolü icin kullan.
 */
-(int)totalFlakeCount;


/**
   use dictionary flakes as dependency injection value. USE THIS FUNTION FOR TESTs . 
 (Look at BoardTests )
 */
-(void)setUpWithFlakeDictionary:(NSDictionary *)dictionaryFlakes;


/**
    to allign the flakes at the begining of the game (no visual representation ) . this method will update board locations array
 */
-(void)pushFlakeWithColor:(colorType) typeOfColor toIndex:(int)theIndex flakeID:(int) theFlakeID;


/**
    will be called after each user moves
 */
-(void) moveFlakeFromIndex:(int) fromIndex toIndex:(int)toIndex currentFlakeColor:(colorType) flakeCurrentColor;

/**
    specificallly used for saving . Also this is useful to use this method for testing
 */
-(NSDictionary *)toDictionary;


-(NSDictionary *)toDictionaryWithoutDelegation;

/**
    when user taps on game view this method will called to determine correct location 
  @return: boardLocationIndex . If not found returns -1.
 */
-(int)locationIndexAtPoint:(CGPoint ) ptSupplied;

/**
    @return: BoardLocation object at specified index
 */
-(BoardLocation *)boardLocationFromIndex:(int) index;


-(BoardLocation *)boardLocationForWhiteFlunkArea;
-(BoardLocation *)boardLocationForBlackFlunkArea;
-(BoardLocation *)boardLocationForWhiteCampingArea;
-(BoardLocation *)boardLocationForBlackCampingArea;

-(BoardLocation *)flunkLocationByColor:(colorType ) typeColor;
-(BoardLocation *)campingLocationByColor:(colorType) typeColor;

/**
     @return : location index of current dice value if it is played from locationFrom. if player cannot collect then returns -1 , else if player can collect returns the index of camping area. Otherwise returns correct index with given dice value .
 */
-(int)locationIndexForColor:(colorType) typeColor fromLocationIndex:(int)fromIndex diceValue:(int)diceValue;

#pragma mark FLAKE_POSITIONS

/**
    @return : all flake positions with supplied color. Example : if colorType == kBackgammonColorWhite then method will return all board location indexes IDs of white flakes
 */
-(NSArray *)allFlakeLocationsForFlakeColor:(colorType) flakeColorType;





#pragma mark CHECKS+LOGIC

-(BOOL)isFlakeFromLocationIndex:(int)fromLocationIndex canBeMovedWithDiceValue:(int)theDiceValue;

/**
   dice values integers are playing options from DicePair.h . Call once as player rolls the dices 
 */
-(BOOL)isFlakeFromLocationIndex:(int)fromLocationIndex canBeMovedWithDiceValuesArray:(NSArray *)diceValuesIntegers;


-(BOOL)isFlunkCanBePutFlunkColor:(colorType)flunkColorType diceValue:(int) diceVal;

-(BOOL)isLocation:(BoardLocation *) locationTo playableForFlakeColor:(colorType) typeColor;

-(BOOL)isPlayerColorHasFlunkPlayerColor:(colorType) typeColor;

/**
    flunkable : Kırılabilir :)) 
    @return : true if player with type color can flunk by playing to location ID 
    Turkish : Eger typeColor ile belirtilen oyuncu locationID ile belirtilen pozisyona geldiginde rakip taşı kırabilir ise true döner . 
 */
-(BOOL)isFlakeAtLocationID:(int) locationID isFlunkableByFlakeColor:(colorType ) typeColor;

//-(BOOL) isBoardLoca
//-(NSArray *)playableBoardLocationIDFromBlackFlunkAreaWithDiceValue:(int) diceValue;


#pragma mark SAVE + INITIALIZE 

-(void)saveBoardPositionings;



@end
