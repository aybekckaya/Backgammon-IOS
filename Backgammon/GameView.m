//
//  GameView.m
//  Backgammon
//
//  Created by aybek can kaya on 15/06/15.
//  Copyright (c) 2015 aybek can kaya. All rights reserved.
//

#import "GameView.h"


#define FLAKE_MARGIN 3 // Predefined for IPhone 4

#define MAX_NUMBER_OF_FLAKES_AT_EACH_LOCATION 5




@implementation GameView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib
{
    
}

/*
-(void)clearBoard
{
    NSArray *subViews = self.subviews;
    for(id vv in subViews)
    {
        if([vv isKindOfClass:[FlakeView class]])
        {
            [(FlakeView *)vv removeFromSuperview];
        }
        else if([vv isKindOfClass:[DiceView class]])
        {
            [(DiceView *)vv removeFromSuperview];
        }
    }
}
*/

#pragma mark Game Set Up 

/*
    Game set up : includes determine board positions ...
 */

-(void)setUpGame
{
  [self clearBoard];
    
    // calculate processed flake Margin
    
    float flakeMarginDefaultForIphone4 = FLAKE_MARGIN;
    CGRect boundsCurrDevice = [[UIScreen mainScreen] bounds];
    float widthCurrentDevice = boundsCurrDevice.size.width;
    
    flakeMarginProcessed = (float) widthCurrentDevice*flakeMarginDefaultForIphone4 / 480;
    
    if(DEVICE == IPAD)
    {
        flakeMarginProcessed +=5;
    }
    
    //NSLog(@"processed flake margin : %f" , flakeMarginProcessed);
    
   NSArray *positionsOnBoard = [self setUpBoardPositions];
   
    // get init flakes if there are not a saved Game
    GamePlaySaveStock *stock = [[GamePlaySaveStock alloc]init];
    NSDictionary *currentFlakeDictionary = [stock getBoards];
    
    [self alignFlakesWithFlakeDictionary:currentFlakeDictionary positionsOnBoard:positionsOnBoard ];
    
  //  [self temproaryTestOfBoard];
    
    
    
    if(IS_TESTING_FRAME_LOCATIONING == 1)
    {
        [self addSaveForTestingView];
    }
    else
    {
        [self addDiceView];
    }
    
    
    
}


-(void)addSaveForTestingView
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(saveForTestOnTap)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Save" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, self.viewDiceHolder.frame.size.width, self.viewDiceHolder.frame.size.height);
    [self.viewDiceHolder addSubview:button];
    
}

-(void)saveForTestOnTap
{
    
    UIImage *screenShotImage = [self screenShot];
    
    NSData *imageData = UIImageJPEGRepresentation(screenShotImage, 1.0);
    
    int imageCount = [[Plist allLists] count];
    NSString *imageName = [NSString stringWithFormat:@"imageTester-%d.jpg" , imageCount];
    
    NSString *thePath = [self documentsPathForFileName:imageName];
    [imageData writeToFile:thePath atomically:YES];
    
    [[Board sharedBoard] saveBoardPositionings];
    
   UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"Backgammon" message:@"Positions has saved for test" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [alert show];
}

- (NSString *)documentsPathForFileName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    return [documentsPath stringByAppendingPathComponent:name];
}


-(NSArray *)setUpBoardPositions
{
    NSArray *positionRectangles = [self positionsCalculator];
    
    [[Board sharedBoard] setUpBoardLocationsWithBoardFrameRectangles:positionRectangles];
    
    // remove temproary Views
   // [self.viewMiddleTemp removeFromSuperview];
    //[self.viewSizeDeterminatorTemp removeFromSuperview];
    
    self.viewMiddleTemp.alpha =0 ;
    self.viewSizeDeterminatorTemp.alpha =0;
    
    
    //[self visualTestOfPositionRectangles:positionRectangles];
    
    
    return positionRectangles;
}


-(void)visualTestOfPositionRectangles:(NSArray *)arrPositions
{
    for(int i = 0 ; i<arrPositions.count ; i++)
    {
        CGRect spRect = [arrPositions[i] CGRectValue];
        UIView *tmpView = [[UIView alloc]initWithFrame:spRect];
        
        if(i%2 == 0)
        {
          tmpView.backgroundColor = [UIColor colorWithR:231 G:76 B:60 Alpha:0.6];
        }
        else
        {
            //39 174 96
            tmpView.backgroundColor = [UIColor colorWithR:39 G:174 B:96 Alpha:0.6];
        }
        
        [self addSubview:tmpView];
    }
}


-(void)temproaryTestOfBoard
{
    NSDictionary *dctBoard = [[Board sharedBoard] toDictionary];
    ////NSLog(@"Board includes : %@" , dctBoard);
}




/**
 @return : array of 24 elements (CGRect) which includes the positions of location indexes in board.
 */
-(NSArray *)positionsCalculator
{
    NSMutableArray *arrPositions = [[NSMutableArray alloc]initWithCapacity:28];
    
    CGRect middleRectangle = self.viewMiddleTemp.frame;
    CGRect sizeRectangle = self.viewSizeDeterminatorTemp.frame;
    CGRect sizeTemproaryRectangle ;
    
    int locationIndex = 0;
    
    
    float diff =  sizeRectangle.origin.x+sizeRectangle.size.width - middleRectangle.origin.x-middleRectangle.size.width;
    float expectedWidthEachSection = diff /6;
    float expectedHeightEachSection = sizeRectangle.size.height;
    
    sizeRectangle.size.width = expectedWidthEachSection;
    sizeRectangle.origin.x = self.viewSizeDeterminatorTemp.frame.origin.x + self.viewSizeDeterminatorTemp.frame.size.width - expectedWidthEachSection;
    
    ////NSLog(@"size rectangle : %@" , NSStringFromCGRect(sizeRectangle));
    
    // calculate right - up board area's positions
    
    for(int i = 0 ; i<6 ; i++)
    {
        int xPos = sizeRectangle.origin.x-(i*sizeRectangle.size.width);
        CGRect newRectangle  = sizeRectangle;
        // newRectangle.size.width +=10;
        newRectangle.origin.x = xPos;
        ////NSLog(@"rect : %@ " , NSStringFromCGRect(newRectangle));
        
        NSValue *valRepresentation = [NSValue valueWithCGRect:newRectangle];
        [arrPositions insertObject:valRepresentation atIndex:locationIndex];
        
        locationIndex++;
    }
    
    
    
    
    // carry size rectangle to upper left side of board (location Index 6)
    sizeTemproaryRectangle = [[arrPositions lastObject] CGRectValue];
    sizeTemproaryRectangle.origin.x = sizeTemproaryRectangle.origin.x - middleRectangle.size.width-sizeTemproaryRectangle.size.width;
    sizeRectangle = sizeTemproaryRectangle;
    
    // calculate left - up board area's positions
    
    for (int i = 0 ; i<6 ; i++)
    {
        int xPos = sizeRectangle.origin.x-(i*sizeRectangle.size.width);
        CGRect newRectangle  = sizeRectangle;
        newRectangle.origin.x = xPos;
        
        ////NSLog(@"rect 2 : %@ " , NSStringFromCGRect(newRectangle));
        
        NSValue *valRepresentation = [NSValue valueWithCGRect:newRectangle];
        [arrPositions insertObject:valRepresentation atIndex:locationIndex];
        
        locationIndex++;
    }
    
    
    
    
    //calculate positions for the 12 board positions at downSide
    
    int countSectionsUpperSide = arrPositions.count;
    for(int i = countSectionsUpperSide ; i > 0 ; i--)
    {
        int currIndex = i - 1;
        
        CGRect currRect = [arrPositions[currIndex] CGRectValue];
        currRect.origin.y = currRect.origin.y + currRect.size.height;
        
        NSValue *valRepresentation = [NSValue valueWithCGRect:currRect];
        [arrPositions insertObject:valRepresentation atIndex:locationIndex];
        
        
        locationIndex ++;
    }
    
    
     // Determine flunk and camping areas
    
    CGRect frameGameView = self.frame;
    CGRect sampleBoardLocation = [arrPositions[0] CGRectValue];
    
    // white flunk Area
    float lengthEdge =(float) sampleBoardLocation.size.height/5 - flakeMarginProcessed ;
    
    float xPosCenter = frameGameView.size.width/2;
    float yPosCenter = frameGameView.size.height - frameGameView.size.height/5;
    
    CGRect frameWhiteFlunkArea = CGRectMake(xPosCenter-lengthEdge/2, yPosCenter-lengthEdge/2, lengthEdge, lengthEdge);
    NSValue *valRepresentation = [NSValue valueWithCGRect:frameWhiteFlunkArea];
     [arrPositions insertObject:valRepresentation atIndex:locationIndex];
    locationIndex++;
    
    //black Flunk area
    
    yPosCenter =(float)frameGameView.size.height/5;
    
    CGRect frameBlackFlunkArea = CGRectMake(xPosCenter-lengthEdge/2, yPosCenter-lengthEdge/2, lengthEdge, lengthEdge);
     valRepresentation = [NSValue valueWithCGRect:frameBlackFlunkArea];
    [arrPositions insertObject:valRepresentation atIndex:locationIndex];
    locationIndex++;
    
    
    // white camping area
    float width = sampleBoardLocation.size.width;
    float height = sampleBoardLocation.size.height;
    
    float xPos = self.frame.size.width - width;
    float yPos = self.frame.size.height-height;
    
    CGRect frameWhiteCamping = CGRectMake(xPos, yPos, width, height);
   
    valRepresentation = [NSValue valueWithCGRect:frameWhiteCamping];
    [arrPositions insertObject:valRepresentation atIndex:locationIndex];
    locationIndex++;
    
    
    
    // black camping
    CGRect frameBlackCamping = CGRectMake(xPos, 0, width, height);
    
    valRepresentation = [NSValue valueWithCGRect:frameBlackCamping];
    [arrPositions insertObject:valRepresentation atIndex:locationIndex];
    locationIndex++;
    
    return [[NSArray alloc]initWithArray:arrPositions];
}




#pragma mark AllignmentOfFlakes

-(void)alignFlakesWithFlakeDictionary:(NSDictionary *)dctFlakes positionsOnBoard:(NSArray *) positionsOnTheBoard
{
    
    NSMutableArray *flakeViewsArrMute = [[NSMutableArray alloc]init];
    
    Board *sharedBoard  = [Board sharedBoard];
    sharedBoard.delegate = self;
    
    NSArray *keys = [dctFlakes allKeys];
    
    // dctHighestPriorityFlakes =[[NSMutableDictionary alloc]init];
    
    
    // determine the radius of each flake
    CGRect sampleBoardSection = [positionsOnTheBoard[0] CGRectValue];
    
    float ratio = 0.8;
    float determinedRadiusOfFlake = (float) sampleBoardSection.size.width *ratio;
    
    determinedRadiusOfFlake =(float) sampleBoardSection.size.height /5;
    determinedRadiusOfFlake -= flakeMarginProcessed;
    
    int countFlakes = 0;
    
    for(NSString *theKey in keys)
    {
        int index  = [theKey intValue];
        NSDictionary *infoDct = dctFlakes[theKey];
        
        int amount = [infoDct[FLAKEVIEW_DICTIONARY_NUMBER_OF_FLAKES_KEY] intValue];
        colorType typeFl = [infoDct[FLAKEVIEW_DICTIONARY_TYPE_OF_FLAKE_KEY] intValue];
        
        for(int i = 0 ; i<amount ; i++)
        {
            FlakeView *flView =(FlakeView *)[Story GetViewFromNibByName:@"FlakeView"];
            
            flView.typeOfColor = typeFl;
            flView.currentPositionIndex = index;
            flView.ID = countFlakes;
        
            
            CGRect correspondingRectangle = [positionsOnTheBoard[index] CGRectValue];
            
            float xPosCenter = correspondingRectangle.origin.x + correspondingRectangle.size.width/2;
            
            float yPosCenter ;
            
            if(index < PLAYABLE_BOARD_LOCATIONS_COUNT /2)
            {
                // upper side
                yPosCenter = correspondingRectangle.origin.y + determinedRadiusOfFlake/2 + (i*determinedRadiusOfFlake);
            }
            else
            {
                // down side
                yPosCenter = correspondingRectangle.origin.y + correspondingRectangle.size.height - determinedRadiusOfFlake/2 -(i*determinedRadiusOfFlake);
            }
            
            flView.frame = CGRectMake(0, 0, determinedRadiusOfFlake, determinedRadiusOfFlake);
            flView.center = CGPointMake(xPosCenter, yPosCenter);
            
            [self addSubview:flView];
            
            [flakeViewsArrMute addObject:flView];
            
            // pushing flake to shared controller
            
            [sharedBoard pushFlakeWithColor:flView.typeOfColor toIndex:index flakeID:flView.ID];
            countFlakes++;
            
        }
        
        
        
    }
    
    
    // camping and flunk areas
    
    BoardLocation *locationBlackFlunk = [sharedBoard boardLocationForBlackFlunkArea];
    BoardLocation *locationWhiteFlunk = [sharedBoard boardLocationForWhiteFlunkArea];
    BoardLocation *locationBlackCamping = [sharedBoard boardLocationForBlackCampingArea];
    BoardLocation *locationWhiteCamping = [sharedBoard boardLocationForWhiteCampingArea];
    
    
     [sharedBoard pushFlakeWithColor:kBackgammomColorTypeBlack toIndex:locationBlackFlunk.locationID flakeID:-1];
      [sharedBoard pushFlakeWithColor:kBackgammomColorTypeWhite toIndex:locationWhiteFlunk.locationID flakeID:-1];
      [sharedBoard pushFlakeWithColor:kBackgammomColorTypeBlack toIndex:locationBlackCamping.locationID flakeID:-1];
      [sharedBoard pushFlakeWithColor:kBackgammomColorTypeWhite toIndex:locationWhiteCamping.locationID flakeID:-1];
    
    
    flakeViewsArr = [[NSArray  alloc] initWithArray:flakeViewsArrMute];
    
}



-(void)addDiceView
{
    if(IS_TESTING_FRAME_LOCATIONING == 1)
    {
        return;
    }
    
    viewDice = [Story GetViewFromNibByName:@"DiceView"];
    viewDice.delegate = self;
    
    viewDice.frame = CGRectMake(0, 0, self.viewDiceHolder.frame.size.width, self.viewDiceHolder.frame.size.height);
    
    //frameDiceViewHolderDefault = viewDice.frame;
    if(frameDiceViewHolderDefault.origin.x == 0)
    {
         // set once 
         frameDiceViewHolderDefault = self.viewDiceHolder.frame;
    }
   
    
    //baseTransformSize = viewDice.transform;
    
    [self.viewDiceHolder addSubview:viewDice];
    
    [self bringSubviewToFront:self.viewDiceHolder];
    
    self.viewDiceHolder.backgroundColor = [UIColor clearColor];
    viewDice.backgroundColor = [UIColor clearColor];
    
    // self.viewDiceHolder.backgroundColor = [UIColor redColor];
    //viewDice.backgroundColor =[UIColor greenColor];
    
    
    // get from saved stock
    GamePlaySaveStock *stock = [[GamePlaySaveStock alloc]init];
    NSDictionary *dctDiceView = [stock getDices];
    
    if(dctDiceView == nil)
    {
        // Dice init
        viewDice.stateDiceViewPlayer = kPlayerStateDiceViewWhite;
        viewDice.stateDice = kDiceStateReadyToRoll;
        
        [self diceViewShouldBeReadyForPlayerColor:kBackgammomColorTypeWhite];
    }
    else
    {
        int diceStateInteger = [dctDiceView[DICE_STATE_KEY] intValue];
        int diceViewPlayerInteger = [dctDiceView[DICE_PLAYER_KEY] intValue];
        
        viewDice.stateDice = diceStateInteger;
        viewDice.stateDiceViewPlayer = diceViewPlayerInteger;
        
        [self diceViewShouldBeReadyForPlayerColor:diceViewPlayerInteger];
    }
    
  
    
}


#pragma mark Dice Throw

-(void)diceViewRollDiceOnTap
{
    // demand suggestions from Game object
     [viewDice rollDice];
    
    DicePair *pair = [DicePair sharedDicePair];
    
    [self.delegate gameViewShouldCheckForCurrentDicePair:pair];
    
}





-(void)diceViewShouldBeReadyForPlayerColor:(colorType)typeColorCurrent
{
    CGRect diceNewFrame ;
    if(typeColorCurrent == kBackgammomColorTypeWhite)
    {
        diceNewFrame = frameDiceViewHolderDefault;
    }
    else if(typeColorCurrent == kBackgammomColorTypeBlack)
    {
        float xPos = self.frame.size.width - frameDiceViewHolderDefault.size.width-frameDiceViewHolderDefault.origin.x;
        diceNewFrame = frameDiceViewHolderDefault;
        diceNewFrame.origin.x = xPos;
        
    }
    
   // CGAffineTransform transformSize = baseTransformSize;
    CGAffineTransform transformSize = CGAffineTransformMakeScale(1, 1);
    CGAffineTransform transformRotateAndSize;
    
    if(typeColorCurrent == kBackgammomColorTypeWhite)
    {
        transformRotateAndSize = CGAffineTransformRotate(transformSize, DEGREES_TO_RADIANS(0)); // white
    }
    else
    {
         transformRotateAndSize = CGAffineTransformRotate(transformSize, DEGREES_TO_RADIANS(180)); // black
    }
    
  //  transformRotateAndSize = transformSize;
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
       
        self.viewDiceHolder.frame = diceNewFrame;
        self.viewDiceHolder.transform = transformRotateAndSize;
        
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)diceViewShouldSendToMiddle
{
    CGAffineTransform transform = CGAffineTransformMakeScale(1, 1);
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
       
        self.viewDiceHolder.transform = transform;
        self.viewDiceHolder.center = self.center;
        
    } completion:^(BOOL finished) {
        
        
        
    }];
    
}


-(void)changeUserTurn
{
    // change the current user turn (Model)
    if([self.delegate respondsToSelector:@selector(gameViewChangedCurrentUser)])
    {
        [self.delegate gameViewChangedCurrentUser];
    }
    
    // change the current user turn (View)
    
    [viewDice changeUserTurn];
}


#pragma mark SETTERS

-(void)setCanPlayWithCurrentDiceValues:(BOOL)canPlayWithCurrentDiceValues
{
    // stop dice
    [viewDice stopRollingDice];
    
    _canPlayWithCurrentDiceValues = canPlayWithCurrentDiceValues;
    
    if(canPlayWithCurrentDiceValues == NO)
    {
        [self performSelector:@selector(changeUserTurn) withObject:nil afterDelay:1.5];
    }
}



/*
-(void)setSuggestions:(NSArray *)suggestions
{
    _suggestions = suggestions;
    
    [self suggestionLogTester:suggestions];
    
    // show suggested places on board 
    
}
*/

-(void)suggestionLogTester:(NSArray *)suggestions
{
    for(int i = 0 ; i< suggestions.count ; i++)
    {
        Suggestion *theSuggestion = suggestions[i];
        NSLog(@"Suggestion to Location ID : %d" , theSuggestion.toBoardIndex);
    }
}


#pragma mark TOUCHES

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    viewFlakeOnMove = nil;  // anti - initialize viewFlake On the move (this will set at below)
 
    if(viewDice.stateDice != kDiceStateShowValues
       && IS_TESTING_FRAME_LOCATIONING == 0)
    {
        return;
    }
    
    NSSet *theTouchesSet = [event allTouches];
    UITouch *touch = [theTouchesSet anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    
    
    Board *sharedBoard = [Board sharedBoard];
    int locationIndex  = [sharedBoard locationIndexAtPoint:touchLocation];
    
    // if any location found
    if(locationIndex != -1)
    {
        BoardLocation *locationBoard = [sharedBoard boardLocationFromIndex:locationIndex];
        int flakeID = [locationBoard mostSignificantFlakeID];
        
        // if there is any flake
        if(flakeID != -1)
        {
            viewFlakeOnMove =(FlakeView *)flakeViewsArr[flakeID];
            flakeMovementStartCenter = viewFlakeOnMove.center;
            [self bringSubviewToFront:viewFlakeOnMove];
            
           // ////NSLog(@"found flake ID : %d" , viewFlakeOnMove.ID);
            
            // get suggestions for this flake view here .
           
            [self.delegate gameViewShouldGetSuggestionsForBoardLocation:locationBoard];
            
           // [self suggestionLogTester:self.suggestions];
            
            [self showSuggestionViewVisualizeEffects:self.suggestions];
        }
       
    }
  
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if((viewFlakeOnMove != nil && self.suggestions != nil) || IS_TESTING_FRAME_LOCATIONING == 1)
    {
        NSSet *theTouchesSet = [event allTouches];
        UITouch *touch = [theTouchesSet anyObject];
        CGPoint touchLocation = [touch locationInView:self];
        viewFlakeOnMove.center = touchLocation;
    }
   
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
   if((viewFlakeOnMove != nil && self.suggestions != nil) || IS_TESTING_FRAME_LOCATIONING == 1)
    {
        
        NSSet *theTouchesSet = [event allTouches];
        UITouch *touch = [theTouchesSet anyObject];
        CGPoint touchLocation = [touch locationInView:self];
        
        Board *sharedBoard = [Board sharedBoard];
        int locationIndex  = [sharedBoard locationIndexAtPoint:touchLocation];
        
        if(locationIndex == -1)
        {
            // flake unfortunately moved out of board . So it should return to previous place
            [self moveFlakeView:viewFlakeOnMove toBoardIndex:viewFlakeOnMove.currentPositionIndex];
        }
        else
        {
            // check if the location is in suggestions . if not it cannot be played
            // Board updating will take after the animation ends .
            // this is a bad programming structure .
            // FIND A WAY FOR DECOUPLING
            
            // suggestion check
            
            BOOL shouldResideToNewPlace = NO;
            
            for(Suggestion *theSuggestion in self.suggestions)
            {
                if(locationIndex == theSuggestion.toBoardIndex)
                {
                    shouldResideToNewPlace = YES;
                    [self moveFlakeView:viewFlakeOnMove toBoardIndex:locationIndex];
                    [self diceValueHasPlayed:theSuggestion.dicePointRequired];
                    
                    break;
                }
            }
            
            if(!shouldResideToNewPlace)
            {
                // do not change the place
                 [self moveFlakeView:viewFlakeOnMove toBoardIndex:viewFlakeOnMove.currentPositionIndex];
            }
           
        }

        // reset  "flake view on the run" after animation ends
      
        // reseting suggestions Arr
        self.suggestions = nil;
        [self hideSuggestionViewVisualizeEffects];
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(viewFlakeOnMove != nil)
    {
         [self moveFlakeView:viewFlakeOnMove toBoardIndex:viewFlakeOnMove.currentPositionIndex];
    }
   
}

-(void)diceValueHasPlayed:(int) dicePointValue
{
    if(IS_TESTING_FRAME_LOCATIONING == 1)
    {
        return;
    }
    
    NSLog(@"latest value played : %d" , dicePointValue);
    
    [self saveCurrentState];
    [[DicePair sharedDicePair] diceValueHasPlayed:dicePointValue];
    
    if([[DicePair sharedDicePair] isAllDicesPlayed])
    {
        // change the turn of current player
        
        [viewDice changeUserTurn];
        
        if([self.delegate respondsToSelector:@selector(gameViewDicesHavePlayed)])
        {
            [self.delegate gameViewDicesHavePlayed];
        }
        
        UndoManager *manager = [[UndoManager alloc]init];
        [manager removeAllContents];
    }
    else
    {
        
        //[self saveCurrentState];
        
    }
   
}


#pragma mark SAVE_GET STATE

-(void)saveCurrentState
{
    NSMutableDictionary *dctMute = [[NSMutableDictionary alloc]init];
    
    NSDictionary *dctDiceView = [viewDice toDictionary];
    NSDictionary *dctDicePair = [[DicePair sharedDicePair] toDictionary];
    NSDictionary *dctGame = [self.datasource gameViewShouldGetCurrentGameDictionary];
    NSDictionary *boardDct = [[Board sharedBoard] toDictionaryWithoutDelegation];
    
    [dctMute setObject:dctDiceView forKey:SAVE_STOCK_DICE_KEY];
    [dctMute setObject:dctDicePair forKey:SAVE_STOCK_DICE_PAIR_KEY];
    [dctMute setObject:dctGame forKey:SAVE_STOCK_GAME_KEY];
    [dctMute setObject:boardDct forKey:SAVE_STOCK_BOARD_KEY];
    
    UndoManager *manager = [[UndoManager alloc]init];
    [manager save:dctMute];
    
    
}



#pragma mark Board Delegate 

-(void)boardWillAboutToSaveGameState
{
    //NSLog(@"ss");

    GamePlaySaveStock *stock =[[GamePlaySaveStock alloc]init];
    
     // Saving dice View
    NSDictionary *dctDiceView = [viewDice toDictionary];
    [stock saveDices:dctDiceView];
    
    // Saving DicePair
    NSDictionary *dctDicePair = [[DicePair sharedDicePair] toDictionary];
    [stock saveDicePair:dctDicePair];
    
    // saving game
    NSDictionary *dctGame = [self.datasource gameViewShouldGetCurrentGameDictionary];
    [stock saveGame:dctGame];
    
}


-(void)boardGameHasWonByPlayerColor:(colorType)typeColorOfWinningPlayer winingType:(PlayerWinType)winType
{
    NSString *playerName = [self.datasource gameViewPlayerNameByColor:typeColorOfWinningPlayer];
    
    NSString *message = [NSString stringWithFormat:@"%@ has won the game.", playerName ];
    
    if(winType == kPlayerWinTypeMars)
    {
        message = [NSString stringWithFormat:@"%@ has won the game. MARS :))", playerName ];
    }
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Backgammon" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    alert.tag = 11;
    [alert show];
    
}

-(void)clearBoard
{
    NSArray *arrSubviews = self.subviews ;
    
    for(id vv in arrSubviews)
    {
        if([vv isKindOfClass:[FlakeView class]])
        {
            [(FlakeView *)vv removeFromSuperview];
        }
    }
    
    [viewDice removeFromSuperview];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 11)
    {
        [self clearBoard];
        
        if([self.delegate respondsToSelector:@selector(gameShouldInitialized)])
        {
            [self.delegate gameShouldInitialized];
        }
    }
}


-(void)boardFlakeHasFlunkedFlakeID:(int)flakeIDThatHasFlunked
{
    FlakeView *viewFlakeFlunked = flakeViewsArr[flakeIDThatHasFlunked];
    int flakeCurrentPositionIndex = viewFlakeFlunked.currentPositionIndex;
    
    BoardLocation *locationNext ;
    if(viewFlakeFlunked.typeOfColor == kBackgammomColorTypeBlack)
    {
        // black flunk Area
        locationNext = [[Board sharedBoard] boardLocationForBlackFlunkArea];
    }
    else if(viewFlakeFlunked.typeOfColor == kBackgammomColorTypeWhite)
    {
        // whie flunk Area
        locationNext = [[Board sharedBoard] boardLocationForWhiteFlunkArea];
    }
    
    // flunk updater
    float xPosCenterFlunk = locationNext.locationFrameRect.origin.x + locationNext.locationFrameRect.size.width/2;
     float yPosCenterFlunk = locationNext.locationFrameRect.origin.y + locationNext.locationFrameRect.size.height/2;
    
    CGPoint centerForFlunkedFlake = CGPointMake(xPosCenterFlunk, yPosCenterFlunk);
    
    // current flake updater
    
    BoardLocation *locationPrevious = [[Board sharedBoard] boardLocationFromIndex:flakeCurrentPositionIndex];
    int prevFlakeID = [locationPrevious mostSignificantFlakeID];
    FlakeView *prevFlakeView = flakeViewsArr[prevFlakeID];
    
    CGPoint prevFlakeNewCenter = prevFlakeView.center;
    if(flakeCurrentPositionIndex < 12)
    {
        // upper side
        prevFlakeNewCenter.y -= prevFlakeView.frame.size.height;
    }
    else if(flakeCurrentPositionIndex >= 12)
    {
        // down side
          prevFlakeNewCenter.y += prevFlakeView.frame.size.height;
    }
    
    
    viewFlakeFlunked.currentPositionIndex = locationNext.locationID;
    
    NSMutableArray *updateLocationsArr = [[NSMutableArray alloc]init];
    [updateLocationsArr addObject:locationNext];
    [updateLocationsArr addObject:locationPrevious];
    
    NSArray *arrUpdateLocs = [[NSArray alloc]initWithArray:updateLocationsArr];
    
    // Animate next positions
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
       
        viewFlakeFlunked.center = centerForFlunkedFlake;
        prevFlakeView.center = prevFlakeNewCenter;
        
    } completion:^(BOOL finished) {
        
        // update Labels
        
        [self updateFlakeViewsAtBoardLocations:arrUpdateLocs];
    }];
    
    
    
}


#pragma mark View Updates 

-(void)updateFlakeViewsAtBoardLocations:(NSArray *)locationsArr
{
    for(BoardLocation *location in locationsArr)
    {
        if(![location flakeStackIsEmpty])
        {
            int mostSignicantFlakeID = [location mostSignificantFlakeID];
            FlakeView *viewFlake = flakeViewsArr[mostSignicantFlakeID];
            
            if([location flakeStackCount] <= location.capacityFlakes)
            {
                viewFlake.lblFlake.text = @"";
            }
            else
            {
                int numberDiff = [location flakeStackCount] - location.capacityFlakes;
                viewFlake.lblFlake.text = [NSString stringWithFormat:@"%d" , numberDiff];
            }

        }
        
    }
}

-(void)moveFlakeView:(FlakeView *)viewFlakeOnRun toBoardIndex:(int)newBoardIndex
{
    CGPoint newCenterPtForFlake;
    
    int prevBoardIndex = viewFlakeOnMove.currentPositionIndex;
    
    ////NSLog(@"view should move to index : %d  , from index: %d" , newBoardIndex, prevBoardIndex);
    
    Board *sharedBoard = [Board sharedBoard];
   BoardLocation *locationBoard = [sharedBoard boardLocationFromIndex:newBoardIndex];
    
    if(newBoardIndex == viewFlakeOnMove.currentPositionIndex)
    {
        // dice not played. flake has broken dreams :(((   it should return to its previous location
        
        newCenterPtForFlake = [self centerForNewlyPushedFlakeViewAtBoardLocation:locationBoard willAddToLocation:NO];
        
    }
    else
    {
        // dice has played so flake view should pop + push to location stack , also dice value updater should be called
        
        newCenterPtForFlake = [self centerForNewlyPushedFlakeViewAtBoardLocation:locationBoard willAddToLocation:YES];
    }
    
    
    // flakeView will sent to correct place with animation
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
        
        viewFlakeOnMove.center = newCenterPtForFlake;
        
    } completion:^(BOOL finished) {
       
       
        
        if(newBoardIndex != viewFlakeOnMove.currentPositionIndex)
        {
             // requires update on board object
            
            [sharedBoard moveFlakeFromIndex:prevBoardIndex toIndex:newBoardIndex currentFlakeColor:viewFlakeOnMove.typeOfColor];
            
            BoardLocation *locationPrev = [[Board sharedBoard] boardLocationFromIndex:prevBoardIndex];
             BoardLocation *locationNext = [[Board sharedBoard] boardLocationFromIndex:newBoardIndex];
            
            NSArray *updateArr = [[NSArray alloc]initWithObjects:locationNext,locationPrev, nil];
            
            [weakSelf updateFlakeViewsAtBoardLocations:updateArr];
            
            viewFlakeOnMove.currentPositionIndex = newBoardIndex;
            
            // Debug pair Dices
          //  NSDictionary *dctDicePair = [[DicePair sharedDicePair] toDictionary];
           // NSLog(@"%@" , dctDicePair);
            
            BOOL allDicesHavePlayed = [[DicePair sharedDicePair] isAllDicesPlayed];
            BOOL isPlayable = [weakSelf.datasource gameViewCanContinueToPlay];
            if(isPlayable == NO && allDicesHavePlayed ==NO)
            {
                [viewDice changeUserTurn];
                
                if([weakSelf.delegate respondsToSelector:@selector(gameViewDicesHavePlayed)])
                {
                    [weakSelf.delegate gameViewDicesHavePlayed];
                }
            }
            
        }
        
         viewFlakeOnMove = nil;
        flakeMovementStartCenter = CGPointZero;
        
    }];
    
}



-(CGPoint)centerForNewlyPushedFlakeViewAtBoardLocation:(BoardLocation *)locationBoard willAddToLocation:(BOOL) willAdd
{
    if(willAdd == NO)
    {
        return flakeMovementStartCenter;
    }
    
    
    int numElements =[locationBoard flakeStackCount];
    CGRect boardFrame = locationBoard.locationFrameRect;
    
    
  //  //NSLog(@"board Location : %d has element count : %d" , locationBoard.locationID , [locationBoard flakeStackCount] );
    
    if(numElements == 0)
    {
        // it is first element
        float xPos = boardFrame.origin.x+boardFrame.size.width/2;
        float yPos = boardFrame.origin.y + boardFrame.size.height/10 -flakeMarginProcessed/2;
        
        if(locationBoard.locationID > 11 )
        {
            BoardLocation *locationBlackCampingArea = [[Board sharedBoard] boardLocationForBlackCampingArea];
            
            if(locationBoard.locationID == locationBlackCampingArea.locationID)
            {
                yPos = boardFrame.origin.y + boardFrame.size.height/10 ;
            }
            else
            {
                // below row
                yPos = boardFrame.origin.y+boardFrame.size.height - boardFrame.size.height/10+flakeMarginProcessed/2 ;
            }
            
            
        }
        
        
        
        return CGPointMake(xPos, yPos);
    }
    else if(numElements >= locationBoard.capacityFlakes)
    {
         // send to 0 th index of this location array
       int flakeIDAtBasePosition = [locationBoard flakeIDAtIndex:0];
        //int flakeIDAtBasePosition = [locationBoard mostSignificantFlakeID];
        FlakeView *viewReferencedFlake = (FlakeView *) flakeViewsArr[flakeIDAtBasePosition];
        
        return viewReferencedFlake.center;
    }
    
    
    // There is flake(s)
    int mostSignificantFlakeID = [locationBoard mostSignificantFlakeID];
    FlakeView *viewReferencedFlake = (FlakeView *) flakeViewsArr[mostSignificantFlakeID];
    
    ////NSLog(@"reference flake ID : %d" , viewReferencedFlake.ID);
    
    float xPos = viewReferencedFlake.center.x;
    float yPos = viewReferencedFlake.center.y + viewReferencedFlake.frame.size.height;
    
    if(locationBoard.locationID > 11)
    {
        BoardLocation *locationBlackCampingArea = [[Board sharedBoard] boardLocationForBlackCampingArea];
      //  //NSLog(@"black camp area ID : %d , board ID:%d" , locationBlackCampingArea.locationID , locationBoard.locationID);
        
        if(locationBoard.locationID == locationBlackCampingArea.locationID)
        {
            yPos = boardFrame.origin.y + boardFrame.size.height/10 ;
        }
        else
        {
            // below row
           // yPos = boardFrame.origin.y+boardFrame.size.height - boardFrame.size.height/10 ;
            yPos = viewReferencedFlake.center.y - viewReferencedFlake.frame.size.height;
        }
    }
    
  //  //NSLog(@"new Point : %@" , NSStringFromCGPoint(CGPointMake(xPos, yPos)));
    
    return CGPointMake(xPos, yPos);
}

#pragma mark SuggestionView Visualize

-(void)showSuggestionViewVisualizeEffects:(NSArray *)suggestionViews
{
    suggestionViewsArray = [[NSMutableArray alloc]init];
    for(Suggestion *theSuggestion in suggestionViews)
    {
        int toLocationIndex = theSuggestion.toBoardIndex;
        BoardLocation *toLocation = [[Board sharedBoard] boardLocationFromIndex:toLocationIndex];
        SuggestionView *viewSuggestion = [Story GetViewFromNibByName:@"SuggestionView"];
        viewSuggestion.frame = toLocation.locationFrameRect;
        
        if(toLocationIndex < 12)
        {
            viewSuggestion.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(180));
        }
        
        [self addSubview:viewSuggestion];
        
        //NSLog(@"view suggestion : %@" , [viewSuggestion description]);
        
        [suggestionViewsArray addObject:viewSuggestion];
    }
}

-(void)hideSuggestionViewVisualizeEffects
{
    for(SuggestionView *view in suggestionViewsArray)
    {
        [view removeFromSuperview];
    }
}


@end
