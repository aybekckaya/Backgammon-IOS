//
//  BoardLocation.m
//  Backgammon
//
//  Created by aybek can kaya on 15/06/15.
//  Copyright (c) 2015 aybek can kaya. All rights reserved.
//

#import "BoardLocation.h"

@implementation BoardLocation


-(id)initWithLocationID:(int)theLocationID LocationFrame:(CGRect)theLocationFrame Capacity:(int)flakeCapacity
{
    if(self = [super init])
    {
        idLocation = theLocationID;
        rectLocationFrame = theLocationFrame;
        capacity = flakeCapacity;
        
        stackFlake = [[NSMutableArray alloc]init];
    }
    
    return self;
}


-(int)mostSignificantFlakeID
{
      if([self flakeStackIsEmpty])
      {
          return -1;
      }
    
    int topMostFlakeID = [[stackFlake lastObject] intValue];
  
    return topMostFlakeID;
}

-(int)flakeIDAtIndex:(int)theIndex
{
    return [stackFlake[theIndex] intValue];
}

#pragma mark GETTERS 

-(int)locationID
{
    return idLocation;
}

-(CGRect)locationFrameRect
{
    return rectLocationFrame;
}



#pragma mark Stack Operations 

-(BOOL)flakeStackIsEmpty
{
    if(stackFlake.count == 0)
    {
        return YES;
    }
    return NO;
}


-(NSInteger)flakeStackCount
{
    return stackFlake.count;
}


-(colorType)flakeStackColorType
{
    if([self flakeStackIsEmpty])
    {
        return kBackgammonColorTypeNone;
    }
    
    return self.typeOfColor;
}


-(void)flakeStackPushFlakeID:(int)flakeID
{
    [stackFlake addObject:[NSNumber numberWithInt:flakeID]];
}



-(NSInteger) flakeStackPopFlakeID
{
    NSInteger topMostFlakeID = [[stackFlake lastObject] integerValue];
    [stackFlake removeLastObject];
    
    return topMostFlakeID;
}


#pragma mark GETTERS 

-(int)numberOfFlakes
{
    return stackFlake.count;
}



-(int)capacityFlakes
{
    return capacity;
}

@end
