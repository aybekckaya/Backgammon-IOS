//
//  TriangleView.h
//  Backgammon
//
//  Created by aybek can kaya on 21/06/15.
//  Copyright (c) 2015 aybek can kaya. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct
{
    CGPoint point;
    BOOL assigned;
} PointBG;

@interface TriangleView : UIView
{
    
}

/**
   @description : if not assigned peakPoint -> 0, this->width / 2
 */
@property(nonatomic,assign) PointBG ptPeakPoint;

/**
     @description : if not assigned height: this->height
 */
@property(nonatomic,assign) float height;


/**
    @description if not assigned : leftPt = (0 , this->height)
 */
@property(nonatomic,assign) PointBG leftDownPoint;


/**
 @description if not assigned : rightPt = (this->width , this->height)
 */
@property(nonatomic,assign) PointBG rightDownPoint;



@end
