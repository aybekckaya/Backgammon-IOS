//
//  TesterStock.m
//  Backgammon
//
//  Created by aybek can kaya on 25/06/15.
//  Copyright (c) 2015 aybek can kaya. All rights reserved.
//

#import "TesterStock.h" 


@implementation TesterStock


-(id)initByStockID:(int)testerStockID
{
    if(self = [super init])
    {
        NSString *listName = [NSString stringWithFormat:@"testerStock-%d" , testerStockID];
        Plist *list = [[Plist alloc]initWithPlistName:listName];
        
        if(list != nil)
        {
            dctData = [list read:@"board"];
        }
        
    }
    
    return self;
}


-(NSDictionary *)boardDictionary
{
    return dctData;
}


@end
