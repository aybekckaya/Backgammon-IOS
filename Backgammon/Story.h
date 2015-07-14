//
//  Story.h
//  Fresco
//
//  Created by Levent YILDIRIM on 11/27/13.
//  Copyright (c) 2013 Pozitifmobil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Story : NSObject

+(UIStoryboard *)storyBoard;

+(id)viewController:(NSString *)identifier;

+(BOOL) isIpad;

+(BOOL)isIphone5;

+(float)keyboardHeight;

+(BOOL)isPortrait;

+(BOOL)isLandscape;

+(id)GetViewFromNibByName:(NSString *)nibName;

/*
    
 UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
 
 if(orientation == 0) //Default orientation
 //UI is in Default (Portrait) -- this is really a just a failsafe.
 else if(orientation == UIInterfaceOrientationPortrait)
 //Do something if the orientation is in Portrait
 else if(orientation == UIInterfaceOrientationLandscapeLeft)
 // Do something if Left
 else if(orientation == UIInterfaceOrientationLandscapeRight)
 //Do something if right
 
 */

@end
