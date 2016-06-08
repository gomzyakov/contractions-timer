//
//  AppDelegate+Context.h
//  Contractions
//
//  Created by Alexander Gomzyakov on 21.04.14.
//  Copyright (c) 2014 Alexander Gomzyakov. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Context)

+ (NSManagedObjectContext *)sharedContext;

@end
