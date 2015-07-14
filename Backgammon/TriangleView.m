//
//  TriangleView.m
//  Backgammon
//
//  Created by aybek can kaya on 21/06/15.
//  Copyright (c) 2015 aybek can kaya. All rights reserved.
//

#import "TriangleView.h"

@implementation TriangleView



- (void)drawRect:(CGRect)rect
{
      if(_ptPeakPoint.assigned == NO)
      {
          _ptPeakPoint.point = CGPointMake(rect.size.width/2, 0);
      }
    
      if(_leftDownPoint.assigned == NO)
      {
          _leftDownPoint.point = CGPointMake(0, rect.size.height);
      }
    
      if(_rightDownPoint.assigned == NO)
      {
          _rightDownPoint.point = CGPointMake(rect.size.width, rect.size.height);
      }
    
    
    // Drawing code
    
    UIBezierPath* trianglePath = [UIBezierPath bezierPath];
    [trianglePath moveToPoint:_ptPeakPoint.point];
    [trianglePath addLineToPoint:_leftDownPoint.point];
    [trianglePath addLineToPoint:_rightDownPoint.point];
    [trianglePath closePath];
    
    CAShapeLayer *triangleMaskLayer = [CAShapeLayer layer];
    [triangleMaskLayer setPath:trianglePath.CGPath];
    
    self.layer.mask = triangleMaskLayer;
    
    
}


#pragma mark SETTERS 


-(void)setPtPeakPoint:(PointBG)ptPeakPoint
{
    _ptPeakPoint.assigned = YES;
    _ptPeakPoint.point = ptPeakPoint.point;
    
    [self setNeedsDisplay];
}


-(void)setLeftDownPoint:(PointBG)leftDownPoint
{
    _leftDownPoint.point = leftDownPoint.point;
    _leftDownPoint.assigned =  YES;
    
      [self setNeedsDisplay];
}

-(void)setRightDownPoint:(PointBG)rightDownPoint
{
    _rightDownPoint.point = rightDownPoint.point;
    _rightDownPoint.assigned = YES;
    
      [self setNeedsDisplay];
}

-(void)setHeight:(float)height
{
    _height = height;
    
      [self setNeedsDisplay];
    
}

@end
