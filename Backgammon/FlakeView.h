//
//  FlakeView.h
//  BackgammonViewTranslate
//
//  Created by aybek can kaya on 13/06/15.
//  Copyright (c) 2015 aybek can kaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"





@interface FlakeView : UIView
{
    
}

@property(nonatomic) int ID;
@property(nonatomic , assign) colorType typeOfColor;
@property(nonatomic) int currentPositionIndex; // use for rollBack

@property (weak, nonatomic) IBOutlet UIImageView *imViewFlake;
@property (weak, nonatomic) IBOutlet UILabel *lblFlake;


@end
