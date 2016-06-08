//
//  AppDelegate.h
//  contractions
//
//  Created by Gomzyakov on 28.04.13.
//  Copyright (c) 2013 Alexander Gomzyakov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Contractions;

@interface AppDelegate : UIResponder

@property (strong, nonatomic) UIWindow *window;

/// Массив в котором храним сущности Contraction
@property (retain, nonatomic) Contractions *contractions;

// Core Data
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
