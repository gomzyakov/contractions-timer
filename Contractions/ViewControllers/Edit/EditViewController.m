//
//  EditContractionViewController.m
//  Contractions
//
//  Created by Gomzyakov on 08.02.13.
//  Copyright (c) 2013 Alexander Gomzyakov. All rights reserved.
//

#import "EditViewController.h"
#import "AppDelegate.h"

#import "DurationPickerDataSource.h"

// models
#import "Contractions.h"
#import "Contraction.h"

// utils
#import "NSDate-Utilities.h"


#define kMinuteComponent 0
#define kSecondComponent 1

@interface EditViewController () <UIActionSheetDelegate, UIPickerViewDelegate>
{
    // Duration picker
    UIActionSheet            *durationActionSheet;
    UIPickerView             *_durationPicker;
    UIToolbar                *durationPickerToolbar;
    DurationPickerDataSource *durationPickerDataSource;

    NSInteger _durationPickerSelectedMinute;
    NSInteger _durationPickerSelectedSecond;

    // Date picker
    UIActionSheet *dateActionSheet;
    UIDatePicker  *datePicker;
    UIToolbar     *datePickerToolbar;

    NSDate *selectedDate;

    AppDelegate *_appDelegate;

    Contractions *_contractions;
}

@property (nonatomic, strong) NSMutableArray *tableCells;

@property (nonatomic, strong) NSMutableArray *timeSectionCells;
@property (nonatomic, strong) NSMutableArray *deleteSectionCells;

@property (nonatomic, strong) UITableViewCell *cellChangeDuration;
@property (nonatomic, strong) UITableViewCell *cellChangeDateAndTime;
@property (nonatomic, strong) UITableViewCell *cellDeleteContraction;

@end

@implementation EditViewController

#pragma mark - View Lifecycles

- (void)viewDidLoad
{
    [super viewDidLoad];

    selectedDate = _contraction.date;

    [self __makeView];
    [self __initArrayOfCells];

    // connect to contractions storage
    _appDelegate  = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _contractions = _appDelegate.contractions;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.cellChangeDuration.detailTextLabel.text    = [self.contraction humanizedDuration];
    self.cellChangeDateAndTime.detailTextLabel.text = [self.contraction humanuzedDateTime];
}

#pragma mark - Actions

- (void)actionChangeDuration
{
    _durationPickerSelectedMinute = _contraction.duration.integerValue / 60;
    _durationPickerSelectedSecond = _contraction.duration.integerValue - _durationPickerSelectedMinute * 60;
    [_durationPicker selectRow:_durationPickerSelectedMinute inComponent:0 animated:NO];
    [_durationPicker selectRow:_durationPickerSelectedSecond inComponent:1 animated:NO];

    [durationActionSheet showInView:self.view];
    [durationActionSheet setBounds:CGRectMake(0, 0, 320, 464)];
}

- (void)actionChangeDateAndTime
{
    [datePicker setDate:selectedDate animated:NO];

    [dateActionSheet showInView:self.view];
    [dateActionSheet setBounds:CGRectMake(0, 0, 320, 464)];
}

- (void)actionDeleteContraction
{
    NSString *message = NSLocalizedStringWithDefaultValue(@"editView.alert.deleteContraction.message",
                                                          @"Localizable",
                                                          [NSBundle mainBundle],
                                                          @"Are you sure want to delete this contraction?",
                                                          @"Предупреждение: Вы уверены что хотите удалить запись в журнале схваток?");

    NSString *cancelButtonTitle = NSLocalizedStringWithDefaultValue(@"editView.alert.cancelButton.title",
                                                                    @"Localizable",
                                                                    [NSBundle mainBundle],
                                                                    @"Cancel",
                                                                    @"Кнопка Отмена выпадающего предупреждения");

    NSString *deleteButtonTitle = NSLocalizedStringWithDefaultValue(@"common.alert.deleteButton.title",
                                                                    @"Localizable",
                                                                    [NSBundle mainBundle],
                                                                    @"Delete",
                                                                    @"Заголовок стандартной кнопки Удалить");

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:deleteButtonTitle, nil];
    [alert show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [_contractions deleteContraction:_contraction];

        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - PickerView tap Done

- (void)durationPickerDoneTap
{
    NSInteger duration = (_durationPickerSelectedMinute * 60) + _durationPickerSelectedSecond;
    self.contraction.duration = [NSNumber numberWithInteger:duration];

    self.cellChangeDuration.detailTextLabel.text = [self.contraction humanizedDuration];

    [durationActionSheet dismissWithClickedButtonIndex:0 animated:YES];
	
}

- (void)datePickerDoneTap
{
    self.contraction.date = datePicker.date;

    self.cellChangeDateAndTime.detailTextLabel.text = [self.contraction humanuzedDateTime];

    [dateActionSheet dismissWithClickedButtonIndex:0 animated:YES];

}

- (void)datePickerSelectTodayTap
{
    NSDate *today = [NSDate date];
    [datePicker setDate:today animated:YES];
}

- (void)datePickerSelectYesterdayTap
{
    NSDate *yesterday = [NSDate dateYesterday];
    [datePicker setDate:yesterday animated:YES];
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == kMinuteComponent) {
        return [durationPickerDataSource.minutesArray objectAtIndex:row];
    } else {
        return [durationPickerDataSource.secondsArray objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == kMinuteComponent) {
        _durationPickerSelectedMinute = row;
    } else {
        _durationPickerSelectedSecond = row;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (pickerView == _durationPicker) {
        return 100;
    } else {
        return 100;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    if (pickerView == _durationPicker) {
        return 40;
    } else {
        return 40;
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self.tableCells objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.tableCells.count;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    if ([[self.tableCells objectAtIndex:section] isEqual:self.timeSectionCells]) {
        return self.timeSectionCells.count;
    } else if ([[self.tableCells objectAtIndex:section] isEqual:self.deleteSectionCells]) {
        return self.deleteSectionCells.count;
    }

    return 0;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];

    if ([cell isEqual:self.cellChangeDuration]) {
        [self actionChangeDuration];
    } else if ([cell isEqual:self.cellChangeDateAndTime]) {
        [self actionChangeDateAndTime];
    } else if ([cell isEqual:self.cellDeleteContraction]) {
        NSString *title = NSLocalizedStringWithDefaultValue(@"editView.alert.clearJournal.title",
                                                            @"Localizable",
                                                            [NSBundle mainBundle],
                                                            @"Attention",
                                                            @"Заголовок выпадающего предупреждения при очистке журнала");

        NSString *message = NSLocalizedStringWithDefaultValue(@"editView.alert.deleteContraction.message",
                                                              @"Localizable",
                                                              [NSBundle mainBundle],
                                                              @"Are you sure want to delete this contraction?",
                                                              @"Предупреждение: Вы уверены что хотите удалить запись в журнале схваток?");

        NSString *cancelButtonTitle = NSLocalizedStringWithDefaultValue(@"editView.alert.cancelButton.title",
                                                                        @"Localizable",
                                                                        [NSBundle mainBundle],
                                                                        @"Cancel",
                                                                        @"Кнопка Отмена выпадающего предупреждения");

        NSString *deleteAllButtonTitle = NSLocalizedStringWithDefaultValue(@"common.alert.deleteButton.title",
                                                                           @"Localizable",
                                                                           [NSBundle mainBundle],
                                                                           @"Delete",
                                                                           @"Заголовок стандартной кнопки Удалить");

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:cancelButtonTitle
                                              otherButtonTitles:deleteAllButtonTitle, nil];
        [alert show];
    }
}

#pragma mark - Make View

- (void)__makeView
{
    self.title = NSLocalizedStringWithDefaultValue(@"editView.title",
                                                   @"Localizable",
                                                   [NSBundle mainBundle],
                                                   @"Edit Contraction",
                                                   @"Заголовок страницы редактирования схватки");

    [self __createDurationActionSheet];
    [self __createDateAndTimeActionSheet];

    // Кнопочка для сохранения отредактированной схватки
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveContraction:)];

    [self __addConstraints];
}

- (void)__createDurationActionSheet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];

    [actionSheet setBounds:CGRectMake(0, 0, 320, 464)];
    actionSheet.backgroundColor = [UIColor whiteColor];

    durationActionSheet = actionSheet;

    [self __createDurationPickerToolbar];
    [self __createDurationPicker];

    [durationActionSheet addSubview:durationPickerToolbar];
    [durationActionSheet addSubview:_durationPicker];
}

- (void)__createDateAndTimeActionSheet
{
    dateActionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                  delegate:self
                                         cancelButtonTitle:nil
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:nil];

    [dateActionSheet setBounds:CGRectMake(0, 0, 320, 464)];
    dateActionSheet.backgroundColor = [UIColor whiteColor];

    [self __createDatePicker];
    [self __createDatePickerToolbar];

    [dateActionSheet addSubview:datePickerToolbar];
    [dateActionSheet addSubview:datePicker];
}

- (void)__createDurationPickerToolbar
{
    durationPickerToolbar          = [[UIToolbar alloc] init];
    durationPickerToolbar.barStyle = UIBarStyleBlack;

    durationPickerToolbar.translatesAutoresizingMaskIntoConstraints = NO;

    NSMutableArray *barItems = [[NSMutableArray alloc] init];

    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:self
                                                                               action:nil];

    NSString *doneButtonTitle = NSLocalizedStringWithDefaultValue(@"editView.barButton.done.title",
                                                                  @"Localizable",
                                                                  [NSBundle mainBundle],
                                                                  @"Done",
                                                                  @"Кнопка Готово на всплывашке выбора продолжительности/даты");

    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:doneButtonTitle
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(durationPickerDoneTap)];
    [doneBtn setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}
                           forState:UIControlStateNormal];

    [barItems addObject:flexSpace];
    [barItems addObject:doneBtn];

    [durationPickerToolbar setItems:barItems animated:NO];
}

- (void)__createDurationPicker
{
    _durationPicker = [[UIPickerView alloc] init];

    // setup the data source and delegate for this picker
    durationPickerDataSource   = [[DurationPickerDataSource alloc] init];
    _durationPicker.dataSource = durationPickerDataSource;
    _durationPicker.delegate   = self;

    _durationPicker.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)__createDatePickerToolbar
{
    datePickerToolbar          = [[UIToolbar alloc] init];
    datePickerToolbar.barStyle = UIBarStyleBlack;

    datePickerToolbar.translatesAutoresizingMaskIntoConstraints = NO;

    NSMutableArray *barItems = [[NSMutableArray alloc] init];

    NSString *todayButtonTitle = NSLocalizedStringWithDefaultValue(@"editView.todayBarButton.title",
                                                                   @"Localizable",
                                                                   [NSBundle mainBundle],
                                                                   @"Today",
                                                                   @"Button 'Today' on date picker actionsheet");

    UIBarButtonItem *todayButton = [[UIBarButtonItem alloc] initWithTitle:todayButtonTitle
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(datePickerSelectTodayTap)];

    [todayButton setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}
                               forState:UIControlStateNormal];


    NSString *yesterdayButtonTitle = NSLocalizedStringWithDefaultValue(@"editView.yesterdayBarButton.title",
                                                                       @"Localizable",
                                                                       [NSBundle mainBundle],
                                                                       @"Yesterday",
                                                                       @"Button 'Yesterday' on date picker actionsheet");

    UIBarButtonItem *yesterdayButton = [[UIBarButtonItem alloc] initWithTitle:yesterdayButtonTitle
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(datePickerSelectYesterdayTap)];

    [yesterdayButton setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}
                                   forState:UIControlStateNormal];


    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:self
                                                                               action:nil];

    NSString *doneButtonTitle = NSLocalizedStringWithDefaultValue(@"editView.barButton.done.title",
                                                                  @"Localizable",
                                                                  [NSBundle mainBundle],
                                                                  @"Done",
                                                                  @"Кнопка Готово на всплывашке выбора продолжительности/даты");

    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:doneButtonTitle
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(datePickerDoneTap)];
    [doneBtn setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}
                           forState:UIControlStateNormal];

    [barItems addObject:todayButton];
    [barItems addObject:yesterdayButton];
    [barItems addObject:flexSpace];
    [barItems addObject:doneBtn];

    [datePickerToolbar setItems:barItems animated:NO];
}

- (void)__createDatePicker
{
    datePicker                = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;

    datePicker.translatesAutoresizingMaskIntoConstraints = NO;
}

#pragma mark - Constraints

- (void)__addConstraints
{
    [self __constraintDurationPickerToolbar];
    [self __constraintDurationPicker];

    [self __constraintDatePickerToolbar];
    [self __constraintDatePicker];
}

- (void)__constraintDurationPickerToolbar
{
    [durationActionSheet addConstraint:[NSLayoutConstraint constraintWithItem:durationPickerToolbar
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:durationActionSheet
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0f
                                                                     constant:-1.0]];

    [durationActionSheet addConstraint:[NSLayoutConstraint constraintWithItem:durationPickerToolbar
                                                                    attribute:NSLayoutAttributeLeading
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:durationActionSheet
                                                                    attribute:NSLayoutAttributeLeading
                                                                   multiplier:1.0f
                                                                     constant:0.0]];

    [durationActionSheet addConstraint:[NSLayoutConstraint constraintWithItem:durationPickerToolbar
                                                                    attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0f
                                                                     constant:320]];

    [durationActionSheet addConstraint:[NSLayoutConstraint constraintWithItem:durationPickerToolbar
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0f
                                                                     constant:44.0]];
}

- (void)__constraintDurationPicker
{
    [durationActionSheet addConstraint:[NSLayoutConstraint constraintWithItem:_durationPicker
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:durationPickerToolbar
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0f
                                                                     constant:0.0]];
}

- (void)__constraintDatePickerToolbar
{
    [dateActionSheet addConstraint:[NSLayoutConstraint constraintWithItem:datePickerToolbar
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:dateActionSheet
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1.0f
                                                                 constant:-1.0]];

    [dateActionSheet addConstraint:[NSLayoutConstraint constraintWithItem:datePickerToolbar
                                                                attribute:NSLayoutAttributeLeading
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:dateActionSheet
                                                                attribute:NSLayoutAttributeLeading
                                                               multiplier:1.0f
                                                                 constant:0.0]];

    [dateActionSheet addConstraint:[NSLayoutConstraint constraintWithItem:datePickerToolbar
                                                                attribute:NSLayoutAttributeWidth
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0f
                                                                 constant:320]];

    [dateActionSheet addConstraint:[NSLayoutConstraint constraintWithItem:datePickerToolbar
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0f
                                                                 constant:44.0]];
}

- (void)__constraintDatePicker
{
    [dateActionSheet addConstraint:[NSLayoutConstraint constraintWithItem:datePicker
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:datePickerToolbar
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0f
                                                                 constant:0.0]];
}

#pragma mark - Init Static Cells

/**
   Инициализирует массив идентификаторов псевдо-статических ячеек таблицы.
 */
- (void)__initArrayOfCells
{
    self.tableCells = [NSMutableArray array];

    [self __initArrayOfTimeCells];
    [self __initArrayOfDeleteCells];

    if (self.timeSectionCells.count) [self.tableCells addObject:self.timeSectionCells];
    if (self.deleteSectionCells.count) [self.tableCells addObject:self.deleteSectionCells];
}

- (void)__initArrayOfTimeCells
{
    NSString *deleteAllItemsCellTitle = NSLocalizedStringWithDefaultValue(@"editView.durationLabel.title",
                                                                          @"Localizable",
                                                                          [NSBundle mainBundle],
                                                                          @"Duration",
                                                                          @"");

    NSString *dateAndTimeCellTitle = NSLocalizedStringWithDefaultValue(@"editView.dateAndTimeLabel.title",
                                                                       @"Localizable",
                                                                       [NSBundle mainBundle],
                                                                       @"Date and Time",
                                                                       @"");

    self.timeSectionCells = [NSMutableArray array];

    self.cellChangeDuration                = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    self.cellChangeDuration.textLabel.text = deleteAllItemsCellTitle;

    self.cellChangeDateAndTime                = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    self.cellChangeDateAndTime.textLabel.text = dateAndTimeCellTitle;

    [self.timeSectionCells addObject:self.cellChangeDuration];
    [self.timeSectionCells addObject:self.cellChangeDateAndTime];
}

- (void)__initArrayOfDeleteCells
{
    NSString *deleteCellTitle = NSLocalizedStringWithDefaultValue(@"editView.deleteLabel.title",
                                                                  @"Localizable",
                                                                  [NSBundle mainBundle],
                                                                  @"Delete Contraction",
                                                                  @"");

    self.deleteSectionCells = [NSMutableArray array];

    self.cellDeleteContraction                         = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    self.cellDeleteContraction.textLabel.text          = deleteCellTitle;
    self.cellDeleteContraction.textLabel.textAlignment = NSTextAlignmentCenter;
    self.cellDeleteContraction.textLabel.textColor     = [UIColor redColor];

    [self.deleteSectionCells addObject:self.cellDeleteContraction];
}

#pragma mark - Memory management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
