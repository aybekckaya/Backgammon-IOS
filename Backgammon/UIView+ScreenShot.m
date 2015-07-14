//
//  UIView+ScreenShot.m
//  Backgammon
//
//  Created by aybek can kaya on 24/06/15.
//  Copyright (c) 2015 aybek can kaya. All rights reserved.
//

#import "UIView+ScreenShot.h"

@implementation UIView (ScreenShot)

-(UIImage *)screenShot
{
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0f);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
