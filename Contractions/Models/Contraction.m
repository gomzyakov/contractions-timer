//
//  Contraction.m
//  contractions
//
//  Created by Gomzyakov on 28.04.13.
//  Copyright (c) 2013 Alexander Gomzyakov. All rights reserved.
//

#import "Contraction.h"


@implementation Contraction

@dynamic date;
@dynamic duration;
@dynamic interval;


#pragma mark -
#pragma mark Humanization


- (NSString *)humanuzedTime
{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm"];
    return [dateformatter stringFromDate:self.date];
}

- (NSString *)humanizedDuration
{
    return [self humanizeDuration:[self.duration integerValue]];
}

- (NSString *)humanizeDuration:(NSUInteger)_duration
{
    // get minutes & seconds
    NSInteger minutes = floor(_duration % 3600 / 60);
    NSInteger seconds = floor(_duration % 3600 % 60);

    NSString *humanizedDuration = @"";
    if (minutes > 0) {
        NSString *minPostfix = NSLocalizedStringWithDefaultValue(@"common.minPostfix",
                                                                 @"Localizable",
                                                                 [NSBundle mainBundle],
                                                                 @"min",
                                                                 @"Постфикс времени _мин_ (с маленькой буквы, без точки)");
        humanizedDuration = [humanizedDuration stringByAppendingFormat:@"%ld %@ ", (long) minutes, minPostfix];
    }

    NSString *secPostfix = NSLocalizedStringWithDefaultValue(@"common.secPostfix",
                                                             @"Localizable",
                                                             [NSBundle mainBundle],
                                                             @"sec",
                                                             @"Постфикс времени _сек_ (с маленькой буквы, без точки)");

    humanizedDuration = [humanizedDuration stringByAppendingFormat:@"%ld %@", (long) seconds, secPostfix];

    // if contraction duration more than 30 minutes, believe it is incorrect
    if (_duration > 30*60) {
        humanizedDuration = @"";
    }

    return humanizedDuration;
}

- (NSString *)humanizedInterval
{
    NSInteger interval = [self.interval integerValue];

    NSInteger hours   = floor(interval / 3600);
    NSInteger minutes = floor(interval % 3600 / 60);

    NSString *humanizedInterval = @"";
    if (hours == 0) {
        NSString *minPostfix = NSLocalizedStringWithDefaultValue(@"common.minPostfix",
                                                                 @"Localizable",
                                                                 [NSBundle mainBundle],
                                                                 @"min",
                                                                 @"Постфикс времени _мин_ (с маленькой буквы, без точки)");

        humanizedInterval = [humanizedInterval stringByAppendingFormat:@"%ld %@", (long) minutes, minPostfix];
        if (interval < 60) {
            NSString *secPostfix = NSLocalizedStringWithDefaultValue(@"common.secPostfix",
                                                                     @"Localizable",
                                                                     [NSBundle mainBundle],
                                                                     @"sec",
                                                                     @"Постфикс времени _сек_ (с маленькой буквы, без точки)");
            //humanizedInterval = @"менее минуты";
            humanizedInterval = [NSString stringWithFormat:@"%@ %@", [NSNumber numberWithInteger:interval], secPostfix];

        }
    } else {
        NSString *shortMinPostfix = NSLocalizedStringWithDefaultValue(@"common.shortMinPostfix",
                                                                      @"Localizable",
                                                                      [NSBundle mainBundle],
                                                                      @"m",
                                                                      @"Постфикс времени _м_ (одна буква, без точки)");

        NSString *shortHourPostfix = NSLocalizedStringWithDefaultValue(@"common.shortHourPostfix",
                                                                       @"Localizable",
                                                                       [NSBundle mainBundle],
                                                                       @"h",
                                                                       @"Постфикс времени _ч_ (одна буква, без точки)");

        humanizedInterval = [NSString stringWithFormat:@"%ld %@ %02ld %@", (long) hours, shortHourPostfix, (long) minutes, shortMinPostfix];
    }

    // if interval more than 24 hour or equal zero, believe it is incorrect
    if (interval > 24*60*60 || interval == 0) {
        humanizedInterval = @"";
    }

    return humanizedInterval;
}

- (NSString *)humanuzedDateTime
{
    return [self humanuzeDateTime:self.date];
}

- (NSString *)humanuzeDateTime:(NSDate *)_date
{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"dd MMMM, HH:mm"];
    return [dateformatter stringFromDate:_date];
}

@end
