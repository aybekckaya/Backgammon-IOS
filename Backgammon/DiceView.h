//
//  DiceView.h
//  Backgammon
//
//  Created by aybek can kaya on 16/06/15.
//  Copyright (c) 2015 aybek can kaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCDTimer.h"
#import "Constants.h"
#import "TriangleView.h"
#import "DicePair.h"

#define DICE_STATE_KEY @"diceState"
#define DICE_PLAYER_KEY @"dicePlayer"
#define DICE_VALUES_ARRAY_KEY @"diceValues"


typedef enum DiceState
{
  
    kDiceStateReadyToRoll,
    kDiceStateRolling,
    kDiceStateShowValues
    
}DiceState;


typedef enum PlayerStateDiceView
{
    kPlayerStateDiceViewWhite,
    kPlayerStateDiceViewBlack
    
}PlayerStateDiceView;



@protocol DiceViewDelegate <NSObject>

/**
   dice pair will start to rolling 
 */
-(void)diceViewRollDiceOnTap;

-(void)diceViewShouldSendToMiddle;

-(void)diceViewShouldBeReadyForPlayerColor:(colorType) typeColorCurrent;



@end

@interface DiceView : UIView
{
   
    BOOL isRolling;
    GCDTimer *timer;
    int currentTimerIteration;
    
    NSMutableArray *hiderViews;
    
}

@property(nonatomic,weak) id <DiceViewDelegate> delegate;

// Views
@property(nonatomic,strong) IBOutletCollection(UIImageView) NSArray *imViewDices;
@property(nonatomic,weak) IBOutlet UIButton *btnRoll;

//Actions

- (IBAction)rollOnTap:(id)sender;


// variables
@property(nonatomic, assign) DiceState stateDice;
@property(nonatomic,assign) PlayerStateDiceView stateDiceViewPlayer;

//@property(nonatomic,assign) NSArray *diceValuesCurrent;

-(void)rollDice;

-(void)stopRollingDice;

-(void)changeUserTurn;

-(void)updatePlayableDices;

-(NSDictionary *)toDictionary;

@end
