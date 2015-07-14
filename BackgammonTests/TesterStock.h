//
//  TesterStock.h
//  Backgammon
//
//  Created by aybek can kaya on 25/06/15.
//  Copyright (c) 2015 aybek can kaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Plist.h"

@interface TesterStock : NSObject
{
    NSDictionary *dctData;
}

@property(nonatomic,readonly) NSDictionary *boardDictionary;

-(id)initByStockID:(int) testerStockID;



@end
