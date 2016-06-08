//
//  SettingsViewController.m
//  Contractions
//
//  Created by Gomzyakov on 21.01.13.
//  Copyright (c) 2013 Alexander Gomzyakov. All rights reserved.
//

#import "SettingsViewController.h"
#import "AppDelegate+Context.h"
#import "Contractions.h"
#import "Contraction+Export.h"
#import "SettingsCell.h"
#import <MessageUI/MessageUI.h>

@interface SettingsViewController () <UIAlertViewDelegate, MFMailComposeViewControllerDelegate>
{
    Contractions *_contractions;

    /// Массив содержащий все элементы необходимые для отображения детализированного представления (состоит из нескольких субмассивов).
    NSMutableArray *tableCells;

    /// Субмассив ячеек основной секции
    NSMutableArray *commonSectionCells;

    /// Субмассив ячеек секции резервного копирования списка паролей
    NSMutableArray *backupSectionCells;
}

@property (nonatomic, strong) SettingsCell *cellDeleteAllItems;
@property (nonatomic, strong) SettingsCell *cellExportToMail;

@end

@implementation SettingsViewController

#pragma mark - View Lifecycles

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self __makeUI];
    [self __initArrayOfCells];

    // connect to contractions storage
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _contractions = appDelegate.contractions;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[YMMCounter reportEvent:@"Показан экран Настроек" failure:nil];
}

#pragma mark - Actions

- (void)actionClearJournal
{
    [_contractions deleteAllContractions];
	
	[YMMCounter reportEvent:@"Очищен журнал схваток" failure:nil];
}

- (void)actionDone
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)actionExport
{
    NSString *HTMLStringToExport = [Contraction stringToExportInContext:[AppDelegate sharedContext]];
    if (!HTMLStringToExport) {
        NSLog(@"Export fail!");
        return;
    }

    if ([MFMailComposeViewController canSendMail]) {
        NSString *emailExportTitle = NSLocalizedStringWithDefaultValue(@"settingsView.emailBackup.title",
                                                                       @"Localizable",
                                                                       [NSBundle mainBundle],
                                                                       @"Contractions List",
                                                                       @"Заголовок email-а со списком схваток");

        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        [picker setSubject:emailExportTitle];
        [picker setToRecipients:[NSArray array]];
        [picker setMessageBody:HTMLStringToExport isHTML:YES];
        [picker setMailComposeDelegate:self];
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        NSString *alertTitle = NSLocalizedStringWithDefaultValue(@"common.alert.warning.title",
                                                                 @"Localizable",
                                                                 [NSBundle mainBundle],
                                                                 @"Warning",
                                                                 @"Заголовок алерта сообщающего невозможности экспорта");

        NSString *alertMessage = NSLocalizedStringWithDefaultValue(@"common.alert.emailPrepareError.message",
                                                                   @"Localizable",
                                                                   [NSBundle mainBundle],
                                                                   @"Configure email, then try the export",
                                                                   @"Сообщение алерта сообщающее о невозможности отправить сообщение со списком схваток на e-mail");

        NSString *okButtonTitle = NSLocalizedStringWithDefaultValue(@"common.alert.okButton.title",
                                                                    @"Localizable",
                                                                    [NSBundle mainBundle],
                                                                    @"Ok",
                                                                    @"Стандартная надпись на кнопке алерта: ОК");

        UIAlertView *message = [[UIAlertView alloc] initWithTitle:alertTitle
                                                          message:alertMessage
                                                         delegate:nil
                                                cancelButtonTitle:okButtonTitle
                                                otherButtonTitles:nil];
        [message show];
		
		[YMMCounter reportEvent:@"Неудачная попытка отправить журнал на email: почта не доступна" failure:nil];
    }
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
	switch (result) {
		case MFMailComposeResultCancelled:
			[YMMCounter reportEvent:@"Удачная попытка отправить журнал на email: отправка отменена" failure:nil];
		case MFMailComposeResultSaved:
			[YMMCounter reportEvent:@"Удачная попытка отправить журнал на email: сохранено в черновики" failure:nil];
		case MFMailComposeResultSent:
			[YMMCounter reportEvent:@"Удачная попытка отправить журнал на email: отправлено" failure:nil];
		case MFMailComposeResultFailed:
			[YMMCounter reportEvent:@"Неудачная попытка отправить журнал на email: почта не доступна" failure:nil];
			break;
		default:
			break;
	}

	[controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[tableCells objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return tableCells.count;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    if ([[tableCells objectAtIndex:section] isEqual:commonSectionCells]) {
        return commonSectionCells.count;
    } else if ([[tableCells objectAtIndex:section] isEqual:backupSectionCells]) {
        return backupSectionCells.count;
    }

    return 0;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];

    if ([cell isEqual:self.cellDeleteAllItems]) {
        NSString *title = NSLocalizedStringWithDefaultValue(@"settingsView.deleteAllAlert.title",
                                                            @"Localizable",
                                                            [NSBundle mainBundle],
                                                            @"Attention",
                                                            @"Заголовок выпадающего предупреждения при очистке журнала");

        NSString *message = NSLocalizedStringWithDefaultValue(@"settingsView.deleteAllAlert.message",
                                                              @"Localizable",
                                                              [NSBundle mainBundle],
                                                              @"Are you sure want to clear the contractions history?",
                                                              @"Текст выпадающего предупреждения при очистке журнала");

        NSString *cancelButtonTitle = NSLocalizedStringWithDefaultValue(@"settingsView.cancelButton.title",
                                                                        @"Localizable",
                                                                        [NSBundle mainBundle],
                                                                        @"Cancel",
                                                                        @"Кнопка Отмена выпадающего предупреждения");

        NSString *deleteAllButtonTitle = NSLocalizedStringWithDefaultValue(@"settingsView.deleteAllButton.title",
                                                                           @"Localizable",
                                                                           [NSBundle mainBundle],
                                                                           @"Delete all",
                                                                           @"Кнопка Удалить выпадающего предупреждения при очистке журнала");

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:cancelButtonTitle
                                              otherButtonTitles:deleteAllButtonTitle, nil];
        [alert show];
    } else if ([cell isEqual:self.cellExportToMail]) {
        [self actionExport];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // clear journal
        [self actionClearJournal];
    }
}

#pragma mark - Init Static Cells

/**
 Инициализирует массив идентификаторов псевдо-статических ячеек таблицы.
 */
- (void)__initArrayOfCells
{
    tableCells = [NSMutableArray array];

    [self initArrayOfCommonCells];
    [self initArrayOfBaskupCells];

    if (commonSectionCells.count) [tableCells addObject:commonSectionCells];
    if (backupSectionCells.count) [tableCells addObject:backupSectionCells];
}

- (void)initArrayOfCommonCells
{
    NSString *deleteAllItemsCellTitle = NSLocalizedStringWithDefaultValue(@"settingsView.row.deleteAllPasswords.title",
                                                                          @"Localizable",
                                                                          [NSBundle mainBundle],
                                                                          @"Delete All Items",
                                                                          @"Заголовок ячейки удаления всех паролей");

    commonSectionCells = [NSMutableArray array];

    self.cellDeleteAllItems = [[SettingsCell alloc] initWithText:deleteAllItemsCellTitle
                                                       iconNamed:@"delete-all"
                                                 reuseIdentifier:nil];
    [commonSectionCells addObject:self.cellDeleteAllItems];
}

- (void)initArrayOfBaskupCells
{
    NSString *exportToMailCellTitle = NSLocalizedStringWithDefaultValue(@"settingsView.row.exportToEmail.title",
                                                                        @"Localizable",
                                                                        [NSBundle mainBundle],
                                                                        @"Export to Mail",
                                                                        @"Заголовок ячейки создания резервной копии всех паролей которая будет отправленна на e-mail");

    backupSectionCells = [NSMutableArray array];

    self.cellExportToMail = [[SettingsCell alloc] initWithText:exportToMailCellTitle
                                                     iconNamed:@"export"
                                               reuseIdentifier:nil];
    [backupSectionCells addObject:self.cellExportToMail];
}

#pragma mark - UI

- (void)__makeUI
{
    self.title = NSLocalizedStringWithDefaultValue(@"settingsView.title",
                                                   @"Localizable",
                                                   [NSBundle mainBundle],
                                                   @"Settings",
                                                   @"Заголовок страницы настроек");

    [self __createNavBarButtons];
}

- (void)__createNavBarButtons
{
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                  target:self
                                                                                  action:@selector(actionDone)];
    self.navigationItem.leftBarButtonItem = cancelButton;
}

#pragma mark - Memory management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
