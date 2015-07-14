//
//  GameView.h
//  Backgammon
//
//  Created by aybek can kaya on 15/06/15.
//  Copyright (c) 2015 aybek can kaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Story.h"
#import "Board.h"
#import "FlakeView.h"
#import "UIColor+converter.h"
#import "DiceView.h"
#import "SuggestionView.h"
#import "UIView+ScreenShot.h"

@protocol GameViewDelegate <NSObject>



//when call this game should change the current turn 
-(void)gameViewDicesHavePlayed;

-(void)gameViewChangedCurrentUser;

-(void)gameShouldInitialized;

@required
-(void)gameViewShouldCheckForCurrentDicePair:(DicePair *)pairDice;

-(void)gameViewShouldGetSuggestionsForBoardLocation:(BoardLocation *)fromBoardLocation;


@end


@protocol GameViewDatasource <NSObject>

@required

-(colorType)gameViewCurrentPlayerColor;

//-(NSArray *)gameViewSuggestionsForBoardLocation:(BoardLocation *)locationBoard diceValues:(NSArray *)diceValuesArr;

-(BOOL)gameViewCanContinueToPlay;

-(NSString *)gameViewPlayerNameByColor:(colorType) colorOfPlayer;

-(NSDictionary *)gameViewShouldGetCurrentGameDictionary;

@end

@interface GameView : UIView<DiceViewDelegate , BoardDelegate ,UIAlertViewDelegate>
{
    CGFloat flakeMarginProcessed;
    
    // views
    DiceView *viewDice ;
    
    NSArray *flakeViewsArr;
    
    CGRect frameDiceViewHolderDefault;
    CGAffineTransform baseTransformSize;
    
    // dynamics
    FlakeView *viewFlakeOnMove;
    CGPoint flakeMovementStartCenter;
    
    NSMutableArray *suggestionViewsArray;
    
   // BOOL canPlayWithCurrentDiceValues;
    
    
}

@property(nonatomic,weak) id<GameViewDelegate> delegate;
@property(nonatomic,weak) id<GameViewDatasource> datasource;

// temporary views to calculate the board positions 
@property(nonatomic,weak) IBOutlet UIView *viewMiddleTemp;
@property(nonatomic,weak) IBOutlet UIView *viewSizeDeterminatorTemp;

@property(nonatomic,weak) IBOutlet UIView *viewDiceHolder;

// ACTIONS




// dynamic variables

/**
    will be set from Game object . if it has set makes call to diceView to stop animating
 */
@property(nonatomic,strong) NSArray *suggestions;

@property(nonatomic,assign) BOOL canPlayWithCurrentDiceValues;


/**
 will be set from Game object with delegate callback function.
 */
//@property(nonatomic,strong) NSArray *diceValuesCurrent;

/**
   description : will be called from ViewController
 */
-(void)setUpGame;

-(void)changeUserTurn;

@end
