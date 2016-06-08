//
//  PSSettingsBarButtonItemView.m
//  password
//
//  Created by Alexander Gomzyakov on 24.12.13.
//  Copyright (c) 2013 Alexander Gomzyakov. All rights reserved.
//

#import "CNTSettingsBarButtonItemView.h"

@implementation CNTSettingsBarButtonItemView

+ (instancetype)buttonWithTarget:(id)target action:(SEL)action
{
    CGRect                       frame       = CGRectMake(0.0, 0.0, 31.0, 31.0);
    CNTSettingsBarButtonItemView *buttonView = [[CNTSettingsBarButtonItemView alloc] initWithFrame:frame];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target
                                                                                 action:action];
    [buttonView addGestureRecognizer:tapGesture];

    return buttonView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    //// Color Declarations
    UIColor *color0 = [UIColor colorWithRed:66.0/256.0 green:118.0/256.0 blue:245.0/256.0 alpha:1];

    //// Bezier Drawing
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(26, 16.52)];
    [bezierPath addLineToPoint:CGPointMake(26, 14.48)];
    [bezierPath addLineToPoint:CGPointMake(23.22, 14.48)];
    [bezierPath addCurveToPoint:CGPointMake(21.67, 10.76) controlPoint1:CGPointMake(23.03, 13.09) controlPoint2:CGPointMake(22.49, 11.82)];
    [bezierPath addLineToPoint:CGPointMake(23.64, 8.79)];
    [bezierPath addLineToPoint:CGPointMake(22.21, 7.36)];
    [bezierPath addLineToPoint:CGPointMake(20.24, 9.33)];
    [bezierPath addCurveToPoint:CGPointMake(16.52, 7.78) controlPoint1:CGPointMake(19.18, 8.51) controlPoint2:CGPointMake(17.91, 7.97)];
    [bezierPath addLineToPoint:CGPointMake(16.52, 5)];
    [bezierPath addLineToPoint:CGPointMake(14.48, 5)];
    [bezierPath addLineToPoint:CGPointMake(14.48, 7.78)];
    [bezierPath addCurveToPoint:CGPointMake(10.76, 9.33) controlPoint1:CGPointMake(13.09, 7.97) controlPoint2:CGPointMake(11.82, 8.51)];
    [bezierPath addLineToPoint:CGPointMake(8.79, 7.36)];
    [bezierPath addLineToPoint:CGPointMake(7.36, 8.79)];
    [bezierPath addLineToPoint:CGPointMake(9.33, 10.76)];
    [bezierPath addCurveToPoint:CGPointMake(7.78, 14.48) controlPoint1:CGPointMake(8.51, 11.82) controlPoint2:CGPointMake(7.97, 13.09)];
    [bezierPath addLineToPoint:CGPointMake(5, 14.48)];
    [bezierPath addLineToPoint:CGPointMake(5, 16.52)];
    [bezierPath addLineToPoint:CGPointMake(7.78, 16.52)];
    [bezierPath addCurveToPoint:CGPointMake(9.33, 20.24) controlPoint1:CGPointMake(7.97, 17.91) controlPoint2:CGPointMake(8.51, 19.18)];
    [bezierPath addLineToPoint:CGPointMake(7.36, 22.21)];
    [bezierPath addLineToPoint:CGPointMake(8.79, 23.64)];
    [bezierPath addLineToPoint:CGPointMake(10.76, 21.67)];
    [bezierPath addCurveToPoint:CGPointMake(14.48, 23.22) controlPoint1:CGPointMake(11.82, 22.49) controlPoint2:CGPointMake(13.09, 23.04)];
    [bezierPath addLineToPoint:CGPointMake(14.48, 26)];
    [bezierPath addLineToPoint:CGPointMake(16.52, 26)];
    [bezierPath addLineToPoint:CGPointMake(16.52, 23.22)];
    [bezierPath addCurveToPoint:CGPointMake(20.24, 21.67) controlPoint1:CGPointMake(17.91, 23.03) controlPoint2:CGPointMake(19.18, 22.49)];
    [bezierPath addLineToPoint:CGPointMake(22.21, 23.64)];
    [bezierPath addLineToPoint:CGPointMake(23.64, 22.21)];
    [bezierPath addLineToPoint:CGPointMake(21.67, 20.24)];
    [bezierPath addCurveToPoint:CGPointMake(23.22, 16.52) controlPoint1:CGPointMake(22.49, 19.18) controlPoint2:CGPointMake(23.03, 17.91)];
    [bezierPath addLineToPoint:CGPointMake(26, 16.52)];
    [bezierPath closePath];
    [bezierPath moveToPoint:CGPointMake(15.5, 21.26)];
    [bezierPath addCurveToPoint:CGPointMake(9.74, 15.5) controlPoint1:CGPointMake(12.32, 21.26) controlPoint2:CGPointMake(9.74, 18.68)];
    [bezierPath addCurveToPoint:CGPointMake(15.5, 9.74) controlPoint1:CGPointMake(9.74, 12.32) controlPoint2:CGPointMake(12.32, 9.74)];
    [bezierPath addCurveToPoint:CGPointMake(21.26, 15.5) controlPoint1:CGPointMake(18.68, 9.74) controlPoint2:CGPointMake(21.26, 12.32)];
    [bezierPath addCurveToPoint:CGPointMake(15.5, 21.26) controlPoint1:CGPointMake(21.26, 18.68) controlPoint2:CGPointMake(18.68, 21.26)];
    [bezierPath closePath];
    bezierPath.miterLimit = 2;

    [color0 setFill];
    [bezierPath fill];
}

@end
