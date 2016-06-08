//
//  JournalCell.m
//  Contractions
//
//  Created by Gomzyakov on 06.02.13.
//  Copyright (c) 2013 Alexander Gomzyakov. All rights reserved.
//

#import "JournalCell.h"

// Через эти константы мы будем присваивать
// дескрипноры дочерним представлениям
#define kBeginTimeValueTag 1
#define kDurationValueTag 2
#define kIntervalValueTag 3

@implementation JournalCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		
		// Цвет шрифта в ячейке
		UIColor *labelsColor = [[UIColor alloc] initWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255 alpha:1.0];
		
		// Метка времени начала схватки
		CGRect beginTimeLabelRect = CGRectMake(15, 13, 70, 16);
		UILabel *beginTimeLabel = [[UILabel alloc] initWithFrame:beginTimeLabelRect];
		[beginTimeLabel setTextColor:labelsColor];
		[beginTimeLabel setBackgroundColor:[UIColor clearColor]];
		beginTimeLabel.tag = kBeginTimeValueTag;
		[self.contentView addSubview:beginTimeLabel];

		// Метка продолжительности схватки
		CGRect durationLabelRect = CGRectMake(90, 13, 120, 16);
		UILabel *durationLabel = [[UILabel alloc] initWithFrame:durationLabelRect];
		[durationLabel setTextColor:labelsColor];
		[durationLabel setBackgroundColor:[UIColor clearColor]];
		durationLabel.tag = kDurationValueTag;
		[self.contentView addSubview:durationLabel];

		// Метка продолжительности схватки
		CGRect intervalLabelRect = CGRectMake(220, 13, 90, 16);
		UILabel *intervalLabel = [[UILabel alloc] initWithFrame:intervalLabelRect];
		[intervalLabel setTextColor:labelsColor];
		[intervalLabel setBackgroundColor:[UIColor clearColor]];
		[intervalLabel setTag:kIntervalValueTag];
		[self.contentView addSubview:intervalLabel];

    }
    return self;
}


-(void)setBeginTime:(NSString *)beginTime
{
	if (![_beginTime isEqualToString:beginTime]) {  // Если значение метки начала схватки и параметр отличаются
		_beginTime = [beginTime copy];
		UILabel *beginTimeLabel = (UILabel *)[self.contentView viewWithTag:kBeginTimeValueTag];  // Берем указатель на метку начала схватки по тэгу
		beginTimeLabel.text = _beginTime;  // Присваиваем метке начала схватки новое значение
	}
}


-(void)setDuration:(NSString *)_duration
{
	if (_duration != duration) {
		duration = _duration;
		UILabel *durationLabel = (UILabel *)[self.contentView viewWithTag:kDurationValueTag];
		durationLabel.text = duration;
	}
}


-(void)setInterval:(NSString *)interval
{
	if (interval != _interval) {
		_interval = interval;
		UILabel *intervalLabel = (UILabel *)[self.contentView viewWithTag:kIntervalValueTag];
		intervalLabel.text = _interval;
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
