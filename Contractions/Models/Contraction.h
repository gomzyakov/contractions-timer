//
//  Contraction.h
//  contractions
//
//  Created by Gomzyakov on 28.04.13.
//  Copyright (c) 2013 Alexander Gomzyakov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Contraction : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSNumber * interval;


// Return humanuzed start time of contraction
// ex. 13:45
-(NSString *) humanuzedTime;

// Return humanuzed duration time of contraction
-(NSString *) humanizedDuration;

// Return humanuzed interval to previous contraction
// ex. "15 sec", "5 hour 45 sec"
-(NSString *)humanizedInterval;

// Return date in format "13 march, 15:45"
-(NSString *) humanuzedDateTime;

@end
