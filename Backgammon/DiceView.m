//
//  DiceView.m
//  Backgammon
//
//  Created by aybek can kaya on 16/06/15.
//  Copyright (c) 2015 aybek can kaya. All rights reserved.
//

#import "DiceView.h"

#define DICE_MINIMUM_ROLL_TIME 0 // seconds


@implementation DiceView



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





-(void)sendDiceToMiddle
{
    DicePair *dicePair = [DicePair sharedDicePair];
    
    
    int diceValOne = dicePair.dice1.diceValue;
    int diceValTwo = dicePair.dice2.diceValue;
    
    NSString *strDiceOne = [NSString stringWithFormat:@"dice-%d.png"  , diceValOne];
    NSString *strDiceTwo = [NSString stringWithFormat:@"dice-%d.png"  , diceValTwo];
    
    ((UIImageView *)self.imViewDices[0]).image = [UIImage imageNamed:strDiceOne];
    ((UIImageView *)self.imViewDices[1]).image = [UIImage imageNamed:strDiceTwo];
    
    isRolling = NO;
    
    
    if([self.delegate respondsToSelector:@selector(diceViewShouldSendToMiddle)])
    {
        [self.delegate diceViewShouldSendToMiddle];
    }
    
}

-(void)sendDiceToRollPosition
{
    // which player ?
    
    colorType typePlayer ;
    
   // self.stateDiceViewPlayer = kPlayerStateDiceViewBlack; // Debugging
    
    if(self.stateDiceViewPlayer == kPlayerStateDiceViewBlack)
    {
        typePlayer = kBackgammomColorTypeBlack;
         ////NSLog(@"Dice view player current : black ");
       
    }
    else if(self.stateDiceViewPlayer == kPlayerStateDiceViewWhite)
    {
        typePlayer = kBackgammomColorTypeWhite;
         ////NSLog(@"Dice view player current : white ");
    }
    
    if([self.delegate respondsToSelector:@selector(diceViewShouldBeReadyForPlayerColor:)])
    {
        [self.delegate diceViewShouldBeReadyForPlayerColor:typePlayer];
    }
}


#pragma mark SETTERS

-(void)setStateDiceViewPlayer:(PlayerStateDiceView)stateDiceViewPlayer
{
    //set the dice position and rotation
    
    if(stateDiceViewPlayer == kPlayerStateDiceViewWhite)
    {
        
    }
    else if(stateDiceViewPlayer == kPlayerStateDiceViewBlack)
    {
        
    }
    
    _stateDiceViewPlayer = stateDiceViewPlayer;
}


-(void)setStateDice:(DiceState)stateDice
{
    if(stateDice == kDiceStateReadyToRoll)
    {
        // show Roll Button
        self.btnRoll.alpha = 1;
        [self.imViewDices[0] setAlpha:0];
        [self.imViewDices[1] setAlpha:0];
        
    }
    else if(stateDice == kDiceStateRolling)
    {
        self.btnRoll.alpha = 0;
        [self.imViewDices[0] setAlpha:1];
        [self.imViewDices[1] setAlpha:1];
    }
    else if(stateDice == kDiceStateShowValues)
    {
        self.btnRoll.alpha = 0;
        [self.imViewDices[0] setAlpha:1];
        [self.imViewDices[1] setAlpha:1];
        
        // ekran ortasına al
        [self performSelector:@selector(sendDiceToMiddle) withObject:nil afterDelay:1];
        // [self performSelector:@selector(sendDiceToRollPosition) withObject:nil afterDelay:1];
    }
    
    _stateDice = stateDice;
}

/*
-(void)setDiceValuesCurrent:(NSArray *)diceValuesCurrent
{
    _diceValuesCurrent = diceValuesCurrent;
    
    // Her set edilmede dice üzerinde oynanan kısımları kapat
}
*/

-(void)changeUserTurn
{
    if(_stateDiceViewPlayer == kPlayerStateDiceViewWhite)
    {
        _stateDiceViewPlayer = kPlayerStateDiceViewBlack;
       // ////NSLog(@"Dice view player current : black ");
    }
    else
    {
        _stateDiceViewPlayer = kPlayerStateDiceViewWhite;
        //////NSLog(@"Dice view player current : white ");
    }
    
    
    
    self.stateDice = kDiceStateReadyToRoll;
    
    [self sendDiceToRollPosition];
}


-(void)rollDice;
{
    currentTimerIteration = 0;
    
    self.stateDice = kDiceStateRolling;
    
    isRolling = YES;
    
     timer = [GCDTimer timerOnCurrentQueue];
    
    __weak typeof(self) weakSelf = self;
    [timer scheduleBlock:^{
        
        int rnd = 1+arc4random()%6;
        NSString *imName = [NSString stringWithFormat:@"dice-%d.png", rnd];
        ((UIImageView *)weakSelf.imViewDices[0]).image = [UIImage imageNamed:imName];
       
        rnd = 1+arc4random()%6;
        imName = [NSString stringWithFormat:@"dice-%d.png", rnd];
        ((UIImageView *)weakSelf.imViewDices[1]).image = [UIImage imageNamed:imName];
        
        currentTimerIteration ++;
        
            }
           afterInterval:0.1
                  repeat:YES];
    
    
}

-(void)stopRollingDice
{
    
    DicePair *dicePair = [DicePair sharedDicePair];
    
    
    int diceValOne = dicePair.dice1.diceValue;
    int diceValTwo = dicePair.dice2.diceValue;
    
    NSString *strDiceOne = [NSString stringWithFormat:@"dice-%d.png"  , diceValOne];
    NSString *strDiceTwo = [NSString stringWithFormat:@"dice-%d.png"  , diceValTwo];
    
     ((UIImageView *)self.imViewDices[0]).image = [UIImage imageNamed:strDiceOne];
     ((UIImageView *)self.imViewDices[1]).image = [UIImage imageNamed:strDiceTwo];
    
    isRolling = NO;
    
    self.stateDice = kDiceStateShowValues;
    
    [timer invalidate];
    
}


- (IBAction)rollOnTap:(id)sender
{
    [[DicePair sharedDicePair] throwDicePair];
    
    if([self.delegate respondsToSelector:@selector(diceViewRollDiceOnTap)])
    {
        [self.delegate diceViewRollDiceOnTap];
    }
}


-(NSDictionary *)toDictionary
{
    NSMutableDictionary *dctMute = [[NSMutableDictionary alloc]init];
    
    [dctMute setObject:[NSNumber numberWithInt:self.stateDiceViewPlayer] forKey:DICE_PLAYER_KEY];
    
    if(self.stateDice == kDiceStateRolling)
    {
        [self stopRollingDice];
    }
    
    [dctMute setObject:[NSNumber numberWithInt:self.stateDice] forKey:DICE_STATE_KEY];
    
    
    DicePair *dicePair = [DicePair sharedDicePair];
    
    int diceValOne = dicePair.dice1.diceValue;
    int diceValTwo = dicePair.dice2.diceValue;
    
    NSArray *diceValsArr = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:diceValOne], [NSNumber numberWithInt:diceValTwo], nil];
    
    [dctMute setObject:diceValsArr forKey:DICE_VALUES_ARRAY_KEY];
    
    
    return [[NSDictionary alloc]initWithDictionary:dctMute];
}

-(void)updatePlayableDices
{
    /*
    DicePair *pairDice = [DicePair sharedDicePair];
    
    int playPoint = [pairDice totalPointOfPlayedDices];
    NSLog(@" played Point : %d/4" , playPoint);
    
    int remainingPoint = [pairDice remainingPointFromDices];
    NSLog(@" remaining point : %d" , remainingPoint);
    */
    
 //   [self addTriangleViews];
    
    
}

/**
   adds semi-opaque (alpha = 0.5) triangle views to played dices
 */
-(void)addTriangleViews
{
    [self clearTriangleViews];
    
    DicePair *pairDice = [DicePair sharedDicePair];
    if([pairDice isDicePairIsPair])
    {
        int playedPoint = [pairDice totalPointOfPlayedDices];
        
        PointBG peakPtStruct;
        PointBG leftDownPtStruct;
        PointBG rightDownPtStruct;
        float height;
        
        CGRect frameImView1 = [self.imViewDices[0] frame];
        CGRect frameImView2 = [self.imViewDices[1] frame];
        
        for(int i =0 ; i < playedPoint ; i++)
        {
            if(i==0)
            {
                peakPtStruct.point = CGPointMake(0,0);
                rightDownPtStruct.point = CGPointMake(frameImView1.origin.x+frameImView1.size.width, frameImView1.origin.y);
                leftDownPtStruct.point = CGPointMake(frameImView1.origin.x, frameImView1.origin.y + frameImView1.size.height);
                height = frameImView1.size.height/2;
            }
            else if(i==1)
            {
                peakPtStruct.point = CGPointMake(frameImView1.size.width+frameImView1.origin.x,0);
                rightDownPtStruct.point = CGPointMake(frameImView1.origin.x+frameImView1.size.width, frameImView1.origin.y+frameImView1.size.height);
                leftDownPtStruct.point = CGPointMake(frameImView1.origin.x, frameImView1.origin.y + frameImView1.size.height);
                height = frameImView1.size.height/2;
            }
            else if(i==2)
            {
                peakPtStruct.point = CGPointMake(0,0);
                rightDownPtStruct.point = CGPointMake(frameImView2.origin.x+frameImView2.size.width, frameImView2.origin.y);
                leftDownPtStruct.point = CGPointMake(frameImView2.origin.x, frameImView2.origin.y + frameImView2.size.height);
                height = frameImView2.size.height/2;
            }
            else
            {
                peakPtStruct.point = CGPointMake(frameImView2.size.width+frameImView2.origin.x,0);
                rightDownPtStruct.point = CGPointMake(frameImView2.origin.x+frameImView2.size.width, frameImView1.origin.y+frameImView1.size.height);
                leftDownPtStruct.point = CGPointMake(frameImView2.origin.x, frameImView2.origin.y + frameImView2.size.height);
                height = frameImView2.size.height/2;
            }
            
            // add
            
            TriangleView *viewTriangle = [[TriangleView alloc]init];
            viewTriangle.ptPeakPoint = peakPtStruct;
            viewTriangle.rightDownPoint=rightDownPtStruct;
            viewTriangle.leftDownPoint = leftDownPtStruct;
            viewTriangle.height = height;
            
            viewTriangle.backgroundColor = [UIColor blackColor];
            [self addSubview:viewTriangle];
            
        }
        
        
    }
    else
    {
        
    }
}


-(void)clearTriangleViews
{
    NSArray *subViews = self.subviews;
    for(id vv in subViews)
    {
        if([vv isKindOfClass:[TriangleView class]])
        {
            [(TriangleView *)vv removeFromSuperview];
        }
    }
}




@end
