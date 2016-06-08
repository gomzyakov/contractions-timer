//
//  Contraction+Manager.m
//  Contractions
//
//  Created by Alexander Gomzyakov on 20.04.14.
//  Copyright (c) 2014 Alexander Gomzyakov. All rights reserved.
//

#import "Contraction+Manager.h"

@implementation Contraction (Manager)

+ (NSArray *)fetchContractionsInContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Contraction class])];
    fetchRequest.includesPropertyValues = YES;
    fetchRequest.includesSubentities    = NO;
    fetchRequest.returnsObjectsAsFaults = NO;

//    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"isFavorite = %d", isFavorite];

    NSError *error   = nil;
    NSArray *matches = [context executeFetchRequest:fetchRequest error:&error];

    if (!error) {
        return matches;
    } else {
        NSLog(@"Fetch %@ list error: %@ %@",
              NSStringFromClass([Contraction class]),
              [NSNumber numberWithInteger:error.code],
              error.debugDescription);
        return nil;
    }
}

@end
