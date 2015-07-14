//
//  ViewController.m
//  Backgammon
//
//  Created by aybek can kaya on 15/06/15.
//  Copyright (c) 2015 aybek can kaya. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /*
    GCDTimer *timer = [GCDTimer timerOnCurrentQueue] ;
    
    [timer scheduleBlock:^{
      
        ////NSLog(@"Timer");
    }
            afterInterval:0.01
                   repeat:YES];

    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:5]];
   // [timer invalidate];
    */
    
   
    
    [self setUpGame];
    [self setUpPlayers];
    
    [self.viewGame bringSubviewToFront:self.viewGame.viewDiceHolder];
    
    
   // [self setUpFlakes];
    
    //[self.viewGame performSelector:@selector(changeUserTurn) withObject:nil afterDelay:2];
     //[self.viewGame performSelector:@selector(changeUserTurn) withObject:nil afterDelay:4];
    
   // [self triangleDrawTest];
    //[self triangleViewTest];
    
    //Dice *theDice = [[Dice alloc]init];
    //[theDice setUpWithConditionsIsPlayed:YES isHalfPlayed:YES];
    
}


-(void)triangleViewTest
{
    TriangleView *viewTriangle = [[TriangleView alloc]initWithFrame:CGRectMake(50, 50, 200, 200)];
    
    
    
   // viewTriangle.backgroundColor = [UIColor blackColor];
    [self.view addSubview:viewTriangle];
    
    
      [self.viewGame removeFromSuperview];
    
      //[self performSelector:@selector(setPointTest:) withObject:viewTriangle afterDelay:2];
}

-(void)setPointTest:(TriangleView *)viewTriangle
{
    PointBG ptStruct;
    ptStruct.point = CGPointMake(0, 50);
    viewTriangle.ptPeakPoint = ptStruct;
    

}


-(void)triangleDrawTest
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(50,50, 200, 200)];
    
    UIBezierPath* trianglePath = [UIBezierPath bezierPath];
    [trianglePath moveToPoint:CGPointMake(100, 0)];
    [trianglePath addLineToPoint:CGPointMake(0,view.frame.size.height)];
    [trianglePath addLineToPoint:CGPointMake(view.frame.size.width, view.frame.size.height)];
    [trianglePath closePath];
    
    CAShapeLayer *triangleMaskLayer = [CAShapeLayer layer];
    [triangleMaskLayer setPath:trianglePath.CGPath];
    
    
    
    view.backgroundColor = [UIColor blackColor];
    view.layer.mask = triangleMaskLayer;
    
    [self.viewGame removeFromSuperview];
    
    [self.view addSubview:view];
    [self.view bringSubviewToFront:view];
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}


#pragma mark Setting up Game 

-(void)setUpGame
{
    // dicepair set up from dictionary
    NSDictionary *dctDicePair = [[[GamePlaySaveStock alloc]init] getDicePair];
    if(dctDicePair != nil)
    {
        [[DicePair sharedDicePair] setUpWithDicePairDictionary:dctDicePair];
        
        /*
        DicePair *pairDice = [DicePair sharedDicePair];
        
        int diceVal1 = pairDice.dice1.diceValue;
        int diceVal2 = pairDice.dice2.diceValue;
         */
    }
    
    [self.viewGame setUpGame];
    self.viewGame.delegate = self;
    self.viewGame.datasource = self;
}

-(void)setUpPlayers
{
    NSDictionary *dctGame = [[[GamePlaySaveStock alloc]init] getGame];
    if(dctGame == nil)
    {
        Player *playerWhite = [[Player alloc]initWithPlayerColor:kBackgammomColorTypeWhite playerName:@"Player 1"];
        Player *playerBlack = [[Player alloc]initWithPlayerColor:kBackgammomColorTypeBlack playerName:@"Player 2"];
        
        NSArray *arrPlayers = [[NSArray alloc]initWithObjects:playerWhite,playerBlack, nil];
        
        currentGame = [[Game alloc] initWithPlayers:arrPlayers];

    }
    else
    {
        currentGame = [[Game alloc]initWithGameDictionary:dctGame];
    }
    
    
  //  BOOL canPlay = [currentGame isPlayerCanPlayWithCurrentDices];
    
   // self.viewGame.canPlayWithCurrentDiceValues = canPlay;
}


-(void)setUpFlakes
{
    
}


#pragma mark GameView delegate




/**
    use for AI
 */
-(void)gameViewShouldGetSuggestionsForDiceValues:(NSArray *)diceValues
{
    //__block NSArray *suggestionsArr;
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
            // get suggestions at the background
        
        //suggestionsArr  = [currentGame suggestionsForDiceValues:diceValues];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            // set the suggestions
            
            //self.viewGame.suggestions = suggestionsArr;
        });
    });
    
}

-(void)gameViewDicesHavePlayed
{
    [currentGame changeTurn];
}

-(void)gameViewChangedCurrentUser
{
    [currentGame changeTurn];
}


-(void)gameViewShouldCheckForCurrentDicePair:(DicePair *)pairDice
{
    __block BOOL canPlayWithDiceValues;
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        NSDictionary *dctDicePair = [pairDice toDictionary];
        NSLog(@"dice Pair : %@" , dctDicePair);
             // get result without blocking dice animation
        canPlayWithDiceValues =[currentGame isPlayerCanPlayWithCurrentDices];

        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            self.viewGame.canPlayWithCurrentDiceValues = canPlayWithDiceValues;
        });
    });
}



/**
    sets the suggestions
 */

-(void)gameViewShouldGetSuggestionsForBoardLocation:(BoardLocation *)fromBoardLocation
{
    if(IS_TESTING_FRAME_LOCATIONING == 1)
    {
        NSMutableArray *suggestionsArr = [[NSMutableArray alloc]init];
        
        // suggest everywhere
        for(int i=0 ; i<PLAYABLE_BOARD_LOCATIONS_COUNT + NUMBER_OF_CAMPING_AREAS + NUMBER_OF_FLUNK_AREAS ; i++)
        {
            Suggestion *sg = [[Suggestion alloc]init];
            sg.fromBoardIndex = fromBoardLocation.locationID;
            sg.toBoardIndex = i;
            
            
            [suggestionsArr addObject:sg];
            
        }
        
        NSArray *suggArr = [[NSArray alloc]initWithArray:suggestionsArr];
        self.viewGame.suggestions = suggArr;
        
    }
    else
    {
        Player *currentPlayer = [currentGame currentPlayerWhoHasTurn];
        BoardLocation *locationWhiteFlunk = [[Board sharedBoard] boardLocationForWhiteFlunkArea];
        BoardLocation *locationBlackFlunk = [[Board sharedBoard] boardLocationForBlackFlunkArea];
        
        if(locationBlackFlunk.locationID == fromBoardLocation.locationID)
        {
            fromBoardLocation.typeOfColor = kBackgammomColorTypeBlack;
        }
        else if(locationWhiteFlunk.locationID == fromBoardLocation.locationID)
        {
            fromBoardLocation.typeOfColor = kBackgammomColorTypeWhite;
        }
        
        if(fromBoardLocation.typeOfColor != currentPlayer.typeColor)
        {
            self.viewGame.suggestions = [[NSArray alloc]init];
        }
        else
        {
            NSArray *suggestionsValuesRaw = [currentGame suggestionsFromBoardLocation:fromBoardLocation];
            NSArray *suggestionsObjects = [currentGame convertRawSuggestionValues:suggestionsValuesRaw toSuggestionObjectsFromLocation:fromBoardLocation];
            self.viewGame.suggestions = [[NSArray alloc]initWithArray:suggestionsObjects];
        }
    }
}


-(void)gameShouldInitialized
{
    GamePlaySaveStock *stock = [[GamePlaySaveStock alloc]init];
    [stock removeAllContent];
    
    [self setUpGame];
    [self setUpPlayers];
}

#pragma mark GameView datasource

-(NSString *)gameViewPlayerNameByColor:(colorType)colorOfPlayer
{
    Player *thePlayer=[currentGame playerByColor:colorOfPlayer] ;
    
    return thePlayer.playerName;
}

-(NSDictionary *)gameViewShouldGetCurrentGameDictionary
{
    NSDictionary *dctGame = [currentGame toDictionary];
    return dctGame;
}


-(colorType)gameViewCurrentPlayerColor
{
    Player *currentPlayer = [currentGame currentPlayerWhoHasTurn];
    
    return currentPlayer.typeColor;
}


-(BOOL)gameViewCanContinueToPlay
{
    if(IS_TESTING_FRAME_LOCATIONING == 1)
    {
        return YES;
    }
    
    BOOL canPlayWithDiceValues =[currentGame isPlayerCanContinueToPlayWithCurrentDices];
    
     return canPlayWithDiceValues;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)undoOnTap:(id)sender
{
    UndoManager *manager = [[UndoManager alloc]init];
    
    NSDictionary *gameLatestDct = [manager getLatestGameDictionary];
    
    if(gameLatestDct == nil)
    {
        return;
    }
    
    NSDictionary *boardDct = gameLatestDct[SAVE_STOCK_BOARD_KEY];
    NSDictionary *diceViewDct = gameLatestDct[SAVE_STOCK_DICE_KEY];
    NSDictionary *dicePairDct = gameLatestDct[SAVE_STOCK_DICE_PAIR_KEY];
    NSDictionary *gameDct = gameLatestDct[SAVE_STOCK_GAME_KEY];
    
    GamePlaySaveStock *stock = [[GamePlaySaveStock alloc]init];
    [stock saveBoards:boardDct];
    [stock saveDicePair:dicePairDct];
    [stock saveDices:diceViewDct];
    [stock saveGame:gameDct];
    
    [self setUpGame];
    [self setUpPlayers];
    
}
@end
