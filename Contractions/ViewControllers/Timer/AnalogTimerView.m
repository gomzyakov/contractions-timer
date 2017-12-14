//
//  AnalogTimerView.m
//  Contractions
//
//  Created by Gomzyakov on 30.01.13.
//  Copyright (c) 2013 Alexander Gomzyakov. All rights reserved.
//

#import "AnalogTimerView.h"

typedef enum {
	Transparent = 0,
	Yelloy      = 1,
	Green       = 2
} CircleBackgroundColor;


@interface AnalogTimerView () {
	
	// timer visual characteristics
	CGFloat _diameter;
	
	/// Внешний радиус таймера
	CGFloat _radius;
	
	CGFloat _lineWidth;
    
    CGFloat _currentSecond;
}


@end

@implementation AnalogTimerView

#pragma mark -
#pragma mark Initialize


-(AnalogTimerView *)initWithPoint:(CGPoint)_point radius:(CGFloat)radius lineWidth:(CGFloat)lineWidth;
{
	// Convert coordinate point & radius to CGRect parameters
	CGFloat x = _point.x - radius;
	CGFloat y = _point.y - radius;
	CGFloat width = radius * 2;
	CGFloat height = radius * 2;

	self = [super initWithFrame:CGRectMake(x, y, width, height)];
    if (self) {
        // Initialization code
		self.backgroundColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.0 ];
		self.opaque = YES;
		self.clearsContextBeforeDrawing = YES;
		
		_lineWidth = lineWidth;

		// remember radius & diameter
		_radius = radius;
		_diameter = _radius * 2;
		
		// initialize timer counter
		_currentSecond = 0.0;
    }
    return self;
}


#pragma mark -
#pragma mark Setters


-(void)setSeconds:(CGFloat)currentSecond
{
	_currentSecond = currentSecond;
	[self setNeedsDisplay];
}


#pragma mark - Custom Redraw

- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	[self drawBackgroundCircleInContext:context];
	[self drawArcInContext:context];
}

/**
 Отрисовывает фоновую окружность таймера в заданном графическом контексте.
 @param context Графический контекст в рамках которого отрисовывается фоновая окружность.
 */
- (void)drawBackgroundCircleInContext:(CGContextRef)context
{
	UIColor *color;
	// draw background circle only after 1 minit
	if ([self backgroundCircleColor] != Transparent)
	{
		// define background circle color
		if ([self backgroundCircleColor] == Green) {
			// green arc color
			color = [UIColor colorWithRed:(128.0 / 255.0) green:(191.0 / 255.0) blue:(48.0 / 255.0) alpha:1.0];
		} else {
			// yelloy arc color
			color = [UIColor colorWithRed:(192.0 / 255.0) green:(219.0 / 255.0) blue:(11.0 / 255.0) alpha:1.0];
		}
	} else {
		CGFloat colorComponente = 242.0 / 255.0;
		color = [UIColor colorWithRed:colorComponente green:colorComponente blue:colorComponente alpha:1.0];

	}
	
	CGContextSetStrokeColorWithColor(context, color.CGColor);
	CGContextSetFillColorWithColor(context, color.CGColor);
	
	// draw background circle
	CGContextSetLineWidth(context, _lineWidth);
	CGContextAddArc(context, (_diameter / 2), (_diameter / 2), (_radius - _lineWidth/2), [self secondsToRadian:0.0], [self secondsToRadian:60.0], false);
	CGContextStrokePath(context);
}


- (void)drawArcInContext:(CGContextRef)context
{
	UIColor *color;
	if ([self backgroundCircleColor] == Transparent || [self backgroundCircleColor] == Yelloy) {
		// green arc color
		color = [UIColor colorWithRed:(128.0 / 255.0) green:(191.0 / 255.0) blue:(48.0 / 255.0) alpha:1.0];
	} else {
		// yelloy arc color
		color = [UIColor colorWithRed:(192.0 / 255.0) green:(219.0 / 255.0) blue:(11.0 / 255.0) alpha:1.0];
	}
	CGContextSetStrokeColorWithColor(context, color.CGColor);
	CGContextSetFillColorWithColor(context, color.CGColor);
	CGContextSetLineCap(context, kCGLineCapRound);

	// define arc angles
	CGFloat startAngle = [self secondsToRadian:0.0];
	CGFloat endAngle = [self secondsToRadian:fmodf(_currentSecond, 60.0)];
	
	// draw arc
	CGContextSetLineWidth(context, _lineWidth);
	CGContextAddArc(context, (_diameter / 2), (_diameter / 2), (_radius - _lineWidth/2), startAngle, endAngle, false);
	CGContextStrokePath(context);
}

-(CircleBackgroundColor)backgroundCircleColor
{
	NSInteger minutes = _currentSecond / 60.0;
	if (minutes > 0) {
		if (fmodf(minutes, 2)) {
			return Green;
		} else {
			return Yelloy;
		}
	} else {
		return Transparent;
	}
}


#pragma mark -
#pragma mark Helpers


-(CGFloat)degreesToRadian:(CGFloat)degrees
{
	return (M_PI * degrees / 180.0);
}

/**
 Преобразует количество секунд в радианы (необходимы для отрисовки таймера).
 @param seconds Количество секунд прошедшее с начала схватки.
 */
- (CGFloat)secondsToRadian:(CGFloat)seconds
{
	// Соотносим секунды на циферблате и градусы
	CGFloat secondsInDegrees = (seconds * 360) / 60;
	// Преобразуем градусы в радианы, учитывая, что начальное время - это 270 градусов
	return [self degreesToRadian:(270.0+secondsInDegrees)];
}

@end
