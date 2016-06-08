//
//  Contractions.h
//  Contractions
//
//  Created by Gomzyakov on 11.02.13.
//  Copyright (c) 2013 Alexander Gomzyakov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Contraction;
@class AppDelegate;

@interface Contractions : NSObject {
	// data storages
	NSMutableArray *_contractionsArray;
	NSMutableDictionary *_contractionsDict;
	
    // used in table section headers
    // Разделы (дни) отсортированные в обратном порядке
	// Массив содержит строки вида @"11.3.2013"
	NSMutableArray *_daysArray;
	
	// work with Core Data
	AppDelegate *_appDelegate;
	NSManagedObjectContext *_managedObjectContext;
}

-(void)loadContractions;
-(void)reloadContractions;

-(void)deleteContraction:(Contraction *)contraction;
-(void)addContractionWithDate:(NSDate *)date duration:(NSInteger)duration;

-(void)deleteAllContractions;

-(Contraction *)contractionInDayWithIndex:(NSInteger)dayIndex atIndex:(NSInteger)contractionIndex;

-(NSUInteger)daysCount;
-(NSString *)dayNameAtIndex: (NSUInteger)dayIndex;

-(NSUInteger)numberOfContractions;
-(NSUInteger)numberOfContractionsInDayWithIndex:(NSInteger)dayIndex;

@end
