//
//  BoardLocation.h
//  Backgammon
//
//  Created by aybek can kaya on 15/06/15.
//  Copyright (c) 2015 aybek can kaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "Constants.h"

@interface BoardLocation : NSObject
{
    int idLocation;
    CGRect rectLocationFrame;
    int capacity;
    
    NSMutableArray *stackFlake; // holds the IDs of flakes
}

@property(nonatomic , readonly) int locationID;
@property(nonatomic, readonly) CGRect locationFrameRect;
@property(nonatomic,readonly) int capacityFlakes;

// dynamic variables
@property(nonatomic,readonly) int numberOfFlakes;
@property(nonatomic) colorType typeOfColor;



-(id)initWithLocationID:(int) theLocationID LocationFrame:(CGRect) theLocationFrame Capacity:(int) flakeCapacity;


/**
     @description: Different from pop . This function does not remove the selected element from stack
    @return: ID of flake at the uppermost element of stack. Returns -1 if element not available .
 */
-(int)mostSignificantFlakeID;

-(int)flakeIDAtIndex:(int)theIndex;

#pragma mark Stack Operations 

-(BOOL) flakeStackIsEmpty;

-(NSInteger) flakeStackCount;

-(colorType) flakeStackColorType;

-(void)flakeStackPushFlakeID:(int) flakeID;

-(NSInteger)flakeStackPopFlakeID;




@end
