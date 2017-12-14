//
//  AppDelegate+Context.m
//  Contractions
//
//  Created by Alexander Gomzyakov on 21.04.14.
//  Copyright (c) 2014 Alexander Gomzyakov. All rights reserved.
//

#import "AppDelegate+Context.h"

@implementation AppDelegate (Context)

+ (NSManagedObjectContext *)sharedContext
{
    AppDelegate            *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context     = appDelegate.managedObjectContext;
    return context;
}

@end
