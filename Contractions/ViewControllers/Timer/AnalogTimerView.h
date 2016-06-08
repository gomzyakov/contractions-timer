//
//  AnalogTimerView.h
//  Contractions
//
//  Created by Gomzyakov on 30.01.13.
//  Copyright (c) 2013 Alexander Gomzyakov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnalogTimerView : UIView

-(AnalogTimerView *)initWithPoint:(CGPoint)_point radius:(CGFloat)radius lineWidth:(CGFloat)_lineWidth;

-(void)setSeconds:(CGFloat)currentSecond;

@end
