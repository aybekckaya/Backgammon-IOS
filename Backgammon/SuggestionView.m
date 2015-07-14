//
//  SuggestionView.m
//  Backgammon
//
//  Created by aybek can kaya on 21/06/15.
//  Copyright (c) 2015 aybek can kaya. All rights reserved.
//

#import "SuggestionView.h"

@implementation SuggestionView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    /*
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect frame = self.bounds;
    CGContextSetLineWidth(context, _borderWidth);
    CGRectInset(frame, 5, 5);
    [_borderColor setFill];
    UIRectFrame(frame);
    */
    
   [super drawRect:rect];
}

-(void)awakeFromNib
{
    self.backgroundColor = [UIColor greenColor];
}



@end
