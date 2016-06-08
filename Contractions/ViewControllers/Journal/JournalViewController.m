//
//  JournalViewController.m
//  Contractions
//
//  Created by Gomzyakov on 06.02.13.
//  Copyright (c) 2013 Alexander Gomzyakov. All rights reserved.
//

#import "JournalViewController.h"
#import "AppDelegate.h"
#import "EditViewController.h"
#import "JournalCell.h"
#import "SectionHeader.h"
#import "Contraction.h"
#import "Contractions.h"


@interface JournalViewController () <UITableViewDataSource, UITableViewDelegate>
{
    Contractions *_contractions;
}


@end

@implementation JournalViewController

#pragma mark - View lifecycles

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self __makeUI];

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _contractions = appDelegate.contractions;
}

- (void)viewWillAppear:(BOOL)animated
{
#warning Check contractions counter and show info-message, if counter equal to zero
//	// Check contractions counter and show info-message, if counter equal to zero
//	if ([contractions numberOfContractions] == 0 ) {
//		[self.tableView setHidden:YES];
//	} else {
//		[self.tableView setHidden:NO];
//	}



    // reload table view
#warning правильное решение: увести в экшн кнопки
    [_contractions reloadContractions];
    [self.tableView reloadData];
	
	[YMMCounter reportEvent:@"Показан экран Журнала схваток" failure:nil];
}

#pragma mark -
#pragma mark UITableView data source


// Возвращаем количесво дней с записями о схватках
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_contractions daysCount];
}

// Возвращаем количество записей за конкретный день
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_contractions numberOfContractionsInDayWithIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    JournalCell     *cell           = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (nil == cell) {
        cell = [[JournalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];

        NSUInteger section = [indexPath section];
        NSUInteger row     = [indexPath row];

        // obtain the required contraction
        Contraction *contraction = [_contractions contractionInDayWithIndex:section atIndex:row];

        // write contraction data in cell
        [cell setBeginTime:[contraction humanuzedTime]];
        [cell setDuration:[contraction humanizedDuration]];
        [cell setInterval:[contraction humanizedInterval]];

        // show disclosure indicator ">"
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

#warning в зависимости от интенсивоности схватки выставляем фоновый цвет
        //	[cell setBackgroundColor:[[UIColor alloc] initWithRed:0.5 green:0.5 blue:0.0 alpha:1.0]];
    }

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    NSUInteger row     = [indexPath row];

    Contraction *contraction = [_contractions contractionInDayWithIndex:section atIndex:row];

    EditViewController *contractionDetailViewController = [[EditViewController alloc] initWithStyle:UITableViewStyleGrouped];
    contractionDetailViewController.contraction = contraction;

    [self.navigationController pushViewController:contractionDetailViewController animated:YES];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SectionHeader *customHeaderView = [[SectionHeader alloc] initHeaderWithTitle:[_contractions dayNameAtIndex:section]
                                                                           first:(section == 0)];
    return customHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42.0;
}

#pragma mark - Make UI

- (void)__makeUI
{
    self.title = NSLocalizedStringWithDefaultValue(@"journalView.title",
                                                   @"Localizable",
                                                   [NSBundle mainBundle],
                                                   @"Journal",
                                                   @"Заголовок страницы списка схваток");

    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
}

#pragma mark - Memory management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
