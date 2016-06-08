//
//  Contractions.m
//  Contractions
//
//  Created by Gomzyakov on 11.02.13.
//  Copyright (c) 2013 Alexander Gomzyakov. All rights reserved.
//

#import "Contractions.h"
#import "AppDelegate.h"
#import "Contraction.h"

// utils
#import "NSDate-Utilities.h"


@implementation Contractions


#pragma mark -
#pragma mark Initialize


-(Contractions *)init
{
    self = [super init];
    if (self) {
        
        _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        _managedObjectContext = _appDelegate.managedObjectContext;

    }
    
    return self;
}


#pragma mark -
#pragma mark Load data


-(void)loadContractions
{
	AppDelegate *addDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *managedObjectContext = addDelegate.managedObjectContext;
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Contraction" inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	
	NSError *error;
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil) {
		// error processing
		NSLog(@"Error: Can't load the Contraction data.");
	}
	
	_contractionsArray = mutableFetchResults;
    
	// calculate intervals between contractions (in seconds)
	[self calculateIntervals];
    
    [self makeContractionsDict];
	[self makeDaysArray];
}


-(void)reloadContractions
{
    [self loadContractions];
}


#pragma mark -
#pragma mark Prepare data


-(void)makeDaysArray
{
	// В дальнейшем удобно будет использовать массив дней (дни имеют порядок следования), поэтому
	// создаем массив дней-заголовков, сортируем его и инвертируем (последний день первым)
	_daysArray = (NSMutableArray *) [_contractionsDict allKeys];
	_daysArray = (NSMutableArray *) [_daysArray sortedArrayUsingFunction:dateSort context:nil];
}


-(void)makeContractionsDict
{
    _contractionsDict = [[NSMutableDictionary alloc] init];
	
    for (Contraction *cont in _contractionsArray)
    {
        // get contraction day in format @"12.03.2013"
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd.MM.yyyy"];
        NSString *dayKey = [dateFormatter stringFromDate:cont.date];
        
		// create branch, if not exists
		if (![_contractionsDict objectForKey:dayKey]) {
			[_contractionsDict setObject:[[NSMutableArray alloc] init] forKey:dayKey];
        }
		
		// add contraction in day
		NSMutableArray *contractionsInDay = [_contractionsDict objectForKey:dayKey];
		[contractionsInDay addObject:cont];
    }
}


#pragma mark - Days & contractions data counters


-(NSUInteger)daysCount
{
	return [_daysArray count];
}


-(NSUInteger)numberOfContractions
{
	return [_contractionsArray count];
}


-(NSUInteger)numberOfContractionsInDayWithIndex:(NSInteger)dayIndex
{
	NSString *dayName = [_daysArray objectAtIndex:dayIndex];
	return [self countOfContractionsInDayWithName:dayName];
}


-(NSUInteger)countOfContractionsInDayWithName:(NSString *)dayName
{
	return [[_contractionsDict objectForKey:dayName] count];
}


-(NSString *)dayNameAtIndex: (NSUInteger)dayIndex
{
	return [_daysArray objectAtIndex:dayIndex];
}


-(Contraction *)contractionInDayWithIndex:(NSInteger)dayIndex atIndex:(NSInteger)contractionIndex
{
	NSString *dayName = [_daysArray objectAtIndex:dayIndex];
	return [self contractionInDayWithName:dayName atIndex:contractionIndex];
}


-(Contraction *)contractionInDayWithName:(NSString *)dayName atIndex:(NSUInteger)contractionIndex
{
	return [[_contractionsDict objectForKey:dayName] objectAtIndex:contractionIndex];
}


#pragma mark -
#pragma mark Helpers


-(void)calculateIntervals
{
	// calculate intervals if we have two or more contractions
	if (_contractionsArray.count > 1) {
		NSInteger prevContractionIndex = 1;
		for (Contraction *contraction in _contractionsArray)
		{
			Contraction *prevContraction = [_contractionsArray objectAtIndex:prevContractionIndex];
			
			NSInteger interval = [contraction.date timeIntervalSinceDate:prevContraction.date];

			[contraction setValue:[NSNumber numberWithInteger:interval] forKey:@"interval"];
			
			if (prevContractionIndex < (_contractionsArray.count - 1)) {
				prevContractionIndex++;
			}
		}
	}
}


//The date sort function
NSComparisonResult dateSort(NSString *s1, NSString *s2, void *context)
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.yyyy"];
	
    NSDate *d1 = [formatter dateFromString:s1];
    NSDate *d2 = [formatter dateFromString:s2];
	
    //return [d1 compare:d2]; // ascending order
    return [d2 compare:d1]; // descending order
}


#pragma mark - 
#pragma mark Add contractions


-(void)addContractionWithDate:(NSDate *)date duration:(NSInteger)duration
{
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Contraction" inManagedObjectContext:_managedObjectContext];
	
    // insert new contraction in Managed Object Context
    NSManagedObject *contractionData = [[NSManagedObject alloc]initWithEntity:entity insertIntoManagedObjectContext:_managedObjectContext];
	[contractionData setValue:date forKey:@"date"];
	[contractionData setValue:[NSNumber numberWithInteger:duration] forKey:@"duration"];
	
    [_appDelegate saveContext];
}


#pragma mark -
#pragma mark Delete contractions


-(void)deleteContraction:(Contraction *)contraction
{
    // delete current contraction
    [_managedObjectContext deleteObject:contraction];

    [_appDelegate saveContext];
}


-(void)deleteAllContractions
{
    // linking to managedObjectContext
    AppDelegate *addDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = addDelegate.managedObjectContext;
    
	// prepare fetch request
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Contraction"];
    fetchRequest.includesPropertyValues = NO;
    fetchRequest.includesSubentities = NO;
	
    // get all contractions
    NSError *error;
    NSArray *contractions = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
	
    // delete all contractions
    for (NSManagedObject *contraction in contractions) {
        [managedObjectContext deleteObject:contraction];
    }
    
    [_appDelegate saveContext];
}


@end
