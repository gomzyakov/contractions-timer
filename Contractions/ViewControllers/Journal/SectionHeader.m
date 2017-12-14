//
//  SectionHeader.m
//  Contractions
//
//  Created by Алёна Галкина on 07.04.13.
//  Copyright (c) 2013 Alexander Gomzyakov. All rights reserved.
//

#import "SectionHeader.h"
#import "NSDate-Utilities.h"

@interface SectionHeader ()

@property (nonatomic, strong) UILabel *labelDay;
@property (nonatomic, strong) UILabel *labelDuration;
@property (nonatomic, strong) UILabel *labelInterval;

@end

static CGFloat kSelfWidth  = 320.0;
static CGFloat kSelfHeight = 22.0;

@implementation SectionHeader

#pragma mark - Init

- (instancetype)initHeaderWithTitle:(NSString *)dayName first:(BOOL)first
{
    self = [super initWithFrame:CGRectMake(0.0, 0.0, kSelfWidth, kSelfHeight)];
    if (self) {

        const CGFloat colorComp = 229.0/255.0;
        [self setBackgroundColor:[UIColor colorWithRed:colorComp green:colorComp blue:colorComp alpha:1.0]];

        [self __makeView];

        self.labelDay.text = [self humanizeDayName:dayName];

        if (first) {
            self.labelDuration.hidden = NO;
            self.labelInterval.hidden = NO;
        }
    }
    return self;
}

#pragma mark - Make View

- (void)__makeView
{
    [self __createDayLabel];
    [self __createDurationLabel];
    [self __createIntervalLabel];

    [self __addConstraints];
}

- (void)__createDayLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.font            = [UIFont systemFontOfSize:12.0];
    label.textColor       = [UIColor darkGrayColor];
    label.backgroundColor = [UIColor clearColor];

    label.translatesAutoresizingMaskIntoConstraints = NO;

    self.labelDay = label;
    [self addSubview:self.labelDay];
}

- (void)__createDurationLabel
{
    NSString *durationLabelTitle = NSLocalizedStringWithDefaultValue(@"journalView.durationLabel.title",
                                                                     @"Localizable",
                                                                     [NSBundle mainBundle],
                                                                     @"Duration",
                                                                     @"Заголовок колонки Продолжительность на странице Журнала");

    UILabel *label = [[UILabel alloc] init];
    label.font            = [UIFont systemFontOfSize:12.0];
    label.text            = durationLabelTitle;
    label.textColor       = [UIColor darkGrayColor];
    label.backgroundColor = [UIColor clearColor];
    label.hidden          = YES;

    label.translatesAutoresizingMaskIntoConstraints = NO;

    self.labelDuration = label;
    [self addSubview:self.labelDuration];
}

- (void)__createIntervalLabel
{
    NSString *intervalLabelTitle = NSLocalizedStringWithDefaultValue(@"journalView.intervalLabel.title",
                                                                     @"Localizable",
                                                                     [NSBundle mainBundle],
                                                                     @"Frequency",
                                                                     @"Заголовок колонки Интервал на странице Журнала");

    UILabel *label = [[UILabel alloc] init];
    label.font            = [UIFont systemFontOfSize:12.0];
    label.text            = intervalLabelTitle;
    label.textColor       = [UIColor darkGrayColor];
    label.backgroundColor = [UIColor clearColor];
    label.hidden          = YES;

    label.translatesAutoresizingMaskIntoConstraints = NO;

    self.labelInterval = label;
    [self addSubview:self.labelInterval];
}

#pragma mark - Constraint

#pragma mark - Constraints

- (void)__addConstraints
{
    [self __constraintDayLabel];
    [self __constraintDurationLabel];
    [self __constraintIntervalLabel];
}

- (void)__constraintDayLabel
{
    // Отступаем от левого края
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.labelDay
                                                     attribute:NSLayoutAttributeLeading
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeading
                                                    multiplier:1.0f
                                                      constant:16.0]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.labelDay
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0f
                                                      constant:0.0]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.labelDay
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0f
                                                      constant:70.0]];
}

- (void)__constraintDurationLabel
{
    // Отступаем от левого края
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.labelDuration
                                                     attribute:NSLayoutAttributeLeading
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeading
                                                    multiplier:1.0f
                                                      constant:90.0]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.labelDuration
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0f
                                                      constant:0.0]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.labelDuration
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0f
                                                      constant:120.0]];
}

- (void)__constraintIntervalLabel
{
    // Отступаем от левого края
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.labelInterval
                                                     attribute:NSLayoutAttributeLeading
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeading
                                                    multiplier:1.0f
                                                      constant:220.0]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.labelInterval
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0f
                                                      constant:0.0]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.labelInterval
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0f
                                                      constant:60.0]];
}

#pragma mark - Helpers

- (NSString *)humanizeDayName:(NSString *)dayName
{
    // Init humanizator
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];

    // Get current day (today)
    NSDate *today     = [NSDate date];
    NSDate *yesterday = [NSDate dateYesterday];

    // Get day from header string
    NSDate *sectionHeaderDay = [dateFormatter dateFromString:dayName];

    // If current day, output "Today"
    if ([sectionHeaderDay isEqualToDateIgnoringTime:today]) {
        return NSLocalizedStringWithDefaultValue(@"journalView.todaySection.title",
                                                 @"Localizable",
                                                 [NSBundle mainBundle],
                                                 @"Today",
                                                 @"Заголовок секции со списком схваток за сегодняшний день");
    }

    // For esterday output "Esterday"
    if ([sectionHeaderDay isEqualToDateIgnoringTime:yesterday]) {
        return NSLocalizedStringWithDefaultValue(@"journalView.yesterdaySection.title",
                                                 @"Localizable",
                                                 [NSBundle mainBundle],
                                                 @"Yesterday",
                                                 @"Заголовок секции со списком схваток за вчерашний день");
    }

    // An output <day month> (eg. 13 april) for all other days
    [dateFormatter setDateFormat:@"d MMMM"];
    return [dateFormatter stringFromDate:sectionHeaderDay];
}

@end
