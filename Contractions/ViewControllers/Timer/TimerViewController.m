//
//  TimerViewController.m
//  Contractions
//
//  Created by Gomzyakov on 20.01.13.
//  Copyright (c) 2013 Alexander Gomzyakov. All rights reserved.
//

#import "TimerViewController.h"
#import "AppDelegate.h"
#import "AnalogTimerView.h"
#import "Contractions.h"
#import "JournalViewController.h"
#import "SettingsViewController.h"
#import "GListBarButtonView.h"
#import "CNTSettingsBarButtonItemView.h"
#import <AudioToolbox/AudioToolbox.h>
#import <iAd/iAD.h>

@interface TimerViewController () <ADBannerViewDelegate>
{
    // Flag of timer started
    BOOL isTimerStarted;

    // Hold seconds number (contraction duration) from begining of contraction start
    NSInteger _durationCounter;

    // Hold milliseconds number from begining of contraction start
    CGFloat _millisecondsCounter;

    // Contraction date, saved on timer start
    NSDate *_contractionDate;

    // Представление аналогового таймера-полоски
    AnalogTimerView *analogTimerView;

    Contractions *_contractions;
}

/// Основной таймер. Тикает каждую секунду для отсчета времени.
@property (strong, nonatomic) NSTimer *timer;

/// Анимационный таймер. Тикает каждые 0.05 секунды для анимации аналогового таймера.
@property (strong, nonatomic) NSTimer *animationTimer;

@property (strong, nonatomic) JournalViewController *journalViewController;

/// Метка с показаниями таймера.
@property (strong, nonatomic) UILabel *labelTime;

@property (strong, nonatomic) UILabel *labelTapAnywhereToStop;

@property (strong, nonatomic) ADBannerView *adView;

@property (nonatomic, assign) BOOL bannerIsVisible;

@end

@implementation TimerViewController

#pragma mark - View Lifecycles

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self __makeView];
    [self __addSingleTapRecognizer];

    self.bannerIsVisible = NO;

    self.journalViewController = [[JournalViewController alloc] initWithStyle:UITableViewStylePlain];

    // Изначально таймер не запущен
    isTimerStarted = NO;

    // connect to contractions storage
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _contractions = appDelegate.contractions;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[YMMCounter reportEvent:@"Показан экран Таймера" failure:nil];
}

#pragma mark - Actions

- (void)actionPresentJournal
{
    [self.navigationController pushViewController:self.journalViewController animated:YES];
}

- (void)actionPresentSettings
{
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *navController          = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)actionStartTimer:(UIButton *)sender
{
    if (isTimerStarted) {
        [self stopTimer];
        self.labelTapAnywhereToStop.hidden = YES;

		[YMMCounter reportEvent:@"Остановка таймера" failure:nil];
	} else {
        [self startTimer];
        self.labelTapAnywhereToStop.hidden = NO;
		
		[YMMCounter reportEvent:@"Запуск таймера" failure:nil];
    }

    isTimerStarted = !isTimerStarted;

    [self playClickSound];
}

#pragma mark - Timer actions

- (void)startTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTicked:) userInfo:nil repeats:YES];

    // Запускаем таймер с помощью которого будет обновляться анимированная полоска
    _animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                                       target:self
                                                     selector:@selector(animateAnalogTimer:)
                                                     userInfo:nil
                                                      repeats:YES];

    // remember the time and date of begining contraction
    _contractionDate = [NSDate date];

    self.labelTime.text = @"00:00";
}

- (void)stopTimer
{
    [self.timer invalidate];
    [self.animationTimer invalidate];

    // Возвращаем полоску таймера к исходному виду (0.0 секунд)
    [analogTimerView setSeconds:0.0];

    self.labelTime.text = NSLocalizedStringWithDefaultValue(@"timerView.labelTime.title",
                                                            @"Localizable",
                                                            [NSBundle mainBundle],
                                                            @"Start",
                                                            @"Заголовок метки отсчета времени в не активном состоянии");

    // Меняем надпись и цвет кнопки Старт
//	[self.startButton setTitleColor:[UIColor colorWithRed:0.227 green:0.675 blue:0.216 alpha:1.0] forState:UIControlStateNormal];

    if (_durationCounter > 0) {
        // store new contraction
        [_contractions addContractionWithDate:_contractionDate duration:_durationCounter];
    }

    _durationCounter     = 0;
    _millisecondsCounter = 0.0;
}

/**
   Действия выполняемые на каждый тик таймера.
 */
- (void)timerTicked:(NSTimer *)timer
{
    _durationCounter++;

    // renew timer label
    [self.labelTime setText:[self getFormatedTime:_durationCounter]];
}

- (void)animateAnalogTimer:(NSTimer *)timer
{
    _millisecondsCounter += 0.05;

    // refresh timer view
    [analogTimerView setSeconds:_millisecondsCounter];
}

#pragma mark - ADBannerViewDelegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    NSLog(@"---");
    if (!self.bannerIsVisible) {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        // баннер сейчас не виден и сдвинут за экран на 50 пикселей
//		banner.frame = CGRectOffset(banner.frame, 0, 50);
        [UIView commitAnimations];
        self.bannerIsVisible = YES;
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"--- 2");
    if (self.bannerIsVisible) {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        // баннер сейчас виден, и мы его убираем, так как что-то не заладилось со связью
//		banner.frame = CGRectOffset(banner.frame, 0, -50);
        [UIView commitAnimations];
        self.bannerIsVisible = NO;
    }
}

#pragma mark - Make View

- (void)__makeView
{
    [self __setupNavigationBar];

    self.view.backgroundColor = [UIColor whiteColor];

    [self __createTimeLabel];
    [self __createLabelTapAnywhereToStop];

    // Создаём представление для аналогового таймера
    analogTimerView = [[AnalogTimerView alloc] initWithPoint:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)
                                                      radius:256.0 / 2
                                                   lineWidth:10.0];
    [self.view addSubview:analogTimerView];

    [self __createAdView];

    [self __addConstraints];
}

- (void)__setupNavigationBar
{
    self.navigationItem.title = NSLocalizedStringWithDefaultValue(@"timerView.title",
                                                                  @"Localizable",
                                                                  [NSBundle mainBundle],
                                                                  @"Contractions",
                                                                  @"Схватки");

    UIImage         *menuIcon      = [UIImage imageNamed:@"menu"];
    UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc] initWithImage:menuIcon
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(actionPresentJournal)];
    self.navigationItem.rightBarButtonItem = menuBarButton;

    UIImage         *settingsIcon      = [UIImage imageNamed:@"settings"];
    UIBarButtonItem *settingsBarButton = [[UIBarButtonItem alloc] initWithImage:settingsIcon
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(actionPresentSettings)];
    self.navigationItem.leftBarButtonItem = settingsBarButton;
}

- (void)__createLabelTapAnywhereToStop
{
    const CGFloat colorComp = 92.0 / 255.0;
    const CGFloat kFontSize = 28.0;

    UIColor *labelColor = [UIColor colorWithRed:colorComp green:colorComp blue:colorComp alpha:1.0];
    UIFont  *labelFont  = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:kFontSize];

    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font            = labelFont;
    label.textColor       = labelColor;
    label.textAlignment   = NSTextAlignmentCenter;
    label.hidden          = YES;

    label.translatesAutoresizingMaskIntoConstraints = NO;

    label.text = NSLocalizedStringWithDefaultValue(@"timerView.labelTapAnywhereToStop.title",
                                                   @"Localizable",
                                                   [NSBundle mainBundle],
                                                   @"Tap anywhere to stop",
                                                   @"Заголовок метки остановка времени");

    self.labelTapAnywhereToStop = label;
    [self.view addSubview:self.labelTapAnywhereToStop];
}

- (void)__createTimeLabel
{
    const CGFloat colorComp = 92.0 / 255.0;
    const CGFloat kFontSize = 60.0;

    UIColor *labelColor = [UIColor colorWithRed:colorComp green:colorComp blue:colorComp alpha:1.0];
    UIFont  *labelFont  = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:kFontSize];

    UILabel *label = [[UILabel alloc] init];
    label.font            = labelFont;
    label.backgroundColor = [UIColor clearColor];
    label.textColor       = labelColor;
    label.textAlignment   = NSTextAlignmentCenter;

    label.translatesAutoresizingMaskIntoConstraints = NO;

    label.text = NSLocalizedStringWithDefaultValue(@"timerView.labelTime.title",
                                                   @"Localizable",
                                                   [NSBundle mainBundle],
                                                   @"Start",
                                                   @"Заголовок метки отсчета времени в не активном состоянии");

    self.labelTime = label;
    [self.view addSubview:self.labelTime];
}

- (void)__createAdView
{
    self.adView = [[ADBannerView alloc] init];

    self.adView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:self.adView];
    self.adView.delegate = self;
}

#pragma mark - Constraints

- (void)__addConstraints
{
    [self __constraintLabelTime];
    [self __constraintLabelTapAnywhereToStop];
    [self __constraintAdView];
}

- (void)__constraintLabelTime
{
    const CGFloat kOffset = 20.0;

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.labelTime
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0f
                                                           constant:kOffset]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.labelTime
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0f
                                                           constant:-kOffset]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.labelTime
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0f
                                                           constant:0.0]];
}

- (void)__constraintLabelTapAnywhereToStop
{
    const CGFloat kOffset = 20.0;

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.labelTapAnywhereToStop
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0f
                                                           constant:kOffset]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.labelTapAnywhereToStop
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0f
                                                           constant:-kOffset]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.labelTapAnywhereToStop
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0f
                                                           constant:-20.0]];
}

- (void)__constraintAdView
{
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.adView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    const CGFloat kAdHeight = 50.0;

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.adView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0f
                                                           constant:kAdHeight]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.adView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0f
                                                           constant:0.0]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.adView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0f
                                                           constant:0.0]];
}

#pragma mark - Helpers

- (void)__addSingleTapRecognizer
{
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(actionStartTimer:)];
    [self.view addGestureRecognizer:singleFingerTap];
}

/**
   Преобразует целочисленное количество секунд в строку вида mm:ss
   @param seconds Целочисленное количество секунд.
   @return Строка вида mm:ss
 */
- (NSString *)getFormatedTime:(NSInteger)seconds
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm:ss"];

    NSDate *timeInSeconds = [NSDate dateWithTimeIntervalSince1970:seconds];

    return [dateFormatter stringFromDate:timeInSeconds];
}

/**
   Проигрывает звуковой файл "клик" при нажатии на кнопку старт/стоп.
 */
- (void)playClickSound
{
    SystemSoundID sound;
    CFURLRef      alertURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), (CFStringRef)@"click", CFSTR("caf"), NULL);

    AudioServicesCreateSystemSoundID(alertURL, &sound);
    AudioServicesPlayAlertSound(sound);
}

#pragma mark - Memory management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
