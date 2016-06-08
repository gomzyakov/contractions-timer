
#import "DurationPickerDataSource.h"

#define kMinuteComponent 0
#define kSecondComponent 1

@implementation DurationPickerDataSource


- (id)init
{
	// use predetermined frame size
	self = [super init];
	if (self)
	{
		[self createDataSource];
	}
	return self;
}


-(void)createDataSource
{
	// create the data source for minutes picker
	NSMutableArray *minutesArray = [[NSMutableArray alloc] init];
	NSMutableArray *secondsArray = [[NSMutableArray alloc] init];
	for (int minute = 0; minute <= 60; minute++) {
		[minutesArray addObject:[NSString stringWithFormat:@"%d %@", minute, @"min"]];
		[secondsArray addObject:[NSString stringWithFormat:@"%d %@", minute, @"sec"]];
	}
	
	_minutesArray = minutesArray;
	_secondsArray = secondsArray;
}


#pragma mark - UIPickerViewDataSource


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	if (component == kMinuteComponent) {
		return [_minutesArray count];
	} else {
		return [_secondsArray count];
	}
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 2;
}


@end
