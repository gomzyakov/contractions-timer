//
//  GListBarButtonView.m
//  Contractions
//
//  Created by Alexander Gomzyakov on 20.12.13.
//  Copyright (c) 2013 Alexander Gomzyakov. All rights reserved.
//

#import "GListBarButtonView.h"

@implementation GListBarButtonView

- (id)init
{
	CGRect frame = CGRectMake(0.0, 0.0, 40.0, 30.0);
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
	//// Color Declarations
	UIColor* color = [UIColor colorWithRed: 0.498 green: 0.498 blue: 0.498 alpha: 1];
	
	//// Rounded Rectangle 3 Drawing
	UIBezierPath* roundedRectangle3Path = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(10.5, 14, 20, 2.5) cornerRadius: 1.25];
	[color setFill];
	[roundedRectangle3Path fill];
	
	
	//// Rounded Rectangle Drawing
	UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(10.5, 20, 20, 2.5) cornerRadius: 1.25];
	[color setFill];
	[roundedRectanglePath fill];
	
	
	//// Rounded Rectangle 2 Drawing
	UIBezierPath* roundedRectangle2Path = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(10.5, 8, 20, 2.5) cornerRadius: 1.25];
	[color setFill];
	[roundedRectangle2Path fill];
	
	
}


@end
