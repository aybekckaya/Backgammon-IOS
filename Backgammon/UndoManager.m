//
//  UndoManager.m
//  Backgammon
//
//  Created by aybek can kaya on 01/07/15.
//  Copyright (c) 2015 aybek can kaya. All rights reserved.
//

#import "UndoManager.h"

@implementation UndoManager

-(id)init
{
    if(self = [super init])
    {
        listUndo = [[Plist alloc]initWithPlistName:UNDO_PLIST_NAME];
    }
    
    return self;
}


-(void)save:(NSDictionary *)gameAllDictionary
{
    NSMutableArray *arrMute = [[NSMutableArray alloc]init];
    if([listUndo keyExists:GAMES_ARRAY_NAME])
    {
        arrMute = [listUndo read:GAMES_ARRAY_NAME];
    }
    
    [arrMute addObject:gameAllDictionary];
    [listUndo write:arrMute Key:GAMES_ARRAY_NAME];
}


-(NSDictionary *)getLatestGameDictionary
{
    if(![listUndo keyExists:GAMES_ARRAY_NAME])
    {
        return nil;
    }
    
    NSMutableArray *arrMute = [listUndo read:GAMES_ARRAY_NAME];
    NSDictionary *latestDct = [arrMute lastObject];
    
    [arrMute removeLastObject];
    [listUndo write:arrMute Key:GAMES_ARRAY_NAME];
    
    return latestDct ;
}


-(void)removeAllContents
{
    [listUndo removeAllObjects];
}


@end
