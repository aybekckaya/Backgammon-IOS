//
//  UIColor+converter.m
//  QRtablet
//
//  Created by aybek can kaya on 9/11/14.
//  Copyright (c) 2014 aybek can kaya. All rights reserved.
//

#import "UIColor+converter.h"

@implementation UIColor (converter)

+(UIColor *)colorWithR:(float)r G:(float)g B:(float)b Alpha:(float)alpha
{
    return  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:alpha];
}

@end
