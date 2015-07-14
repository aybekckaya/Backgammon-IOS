//
//  Story.m
//  Fresco
//
//  Created by Levent YILDIRIM on 11/27/13.
//  Copyright (c) 2013 Pozitifmobil. All rights reserved.
//

#import "Story.h"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE_5 ([[UIScreen mainScreen] bounds].size.height == 568)

@implementation Story

+(UIStoryboard *)storyBoard
{
   
    if(IS_IPAD)
    {
        //return [UIStoryboard storyboardWithName:@"Storyboard_IPAD" bundle:nil];
    }
   return  [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
}



+(id)viewController:(NSString *)identifier
{
    UIStoryboard *story=[self storyBoard];
    return [story instantiateViewControllerWithIdentifier:identifier];
}

+(id)GetViewFromNibByName:(NSString *)nibName
{
    NSArray* views = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
    
    return [views objectAtIndex:0];
}

+(BOOL)isIpad
{
    return IS_IPAD;
}


+(BOOL)isIphone5
{
    return IS_IPHONE_5;
}


+(BOOL)isPortrait
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if(orientation == 0 || orientation == UIInterfaceOrientationPortrait)
    {
        return YES;
    }
    return NO;
}

+(BOOL)isLandscape
{
    return ![self isPortrait];
}


+(float)keyboardHeight
{
   // float height;
    if([self isIpad] == YES)
    {
        // ipad
        if([self isPortrait] == YES)
        {
            return 264;
        }
        else
        {
            return 352;
        }
            
    }
    else if([self isIphone5] == YES)
    {
        // iphone 5
        if([self isPortrait] == YES)
        {
            return 216;
        }
        else
        {
            return 162;
        }

    }
    else
    {
        // iphone 4
        if([self isPortrait] == YES)
        {
            return 216;
        }
        else
        {
            return 162;
        }

    }
    
    return 0;
}


@end
