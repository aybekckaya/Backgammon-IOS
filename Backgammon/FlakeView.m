//
//  FlakeView.m
//  BackgammonViewTranslate
//
//  Created by aybek can kaya on 13/06/15.
//  Copyright (c) 2015 aybek can kaya. All rights reserved.
//

#import "FlakeView.h"

@implementation FlakeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}


-(void)setFrame:(CGRect)frame
{
     [super setFrame:frame];
    self.layer.cornerRadius = frame.size.width/2;
    self.layer.masksToBounds = YES;
    
   
}

-(void)setTypeOfColor:(colorType)typeOfColor
{
    _typeOfColor = typeOfColor;
    
    if(typeOfColor == kBackgammomColorTypeWhite)
    {
        self.imViewFlake.image = [UIImage imageNamed:@"flakeWhitePattern.png"];
    }
    else if(typeOfColor == kBackgammomColorTypeBlack)
    {
         self.imViewFlake.image = [UIImage imageNamed:@"flakeBlackPattern.png"];
    }
}





@end
