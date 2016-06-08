//
//  Contraction+Export.m
//  Contractions
//
//  Created by Alexander Gomzyakov on 21.04.14.
//  Copyright (c) 2014 Alexander Gomzyakov. All rights reserved.
//

#import "Contraction+Export.h"
#import "Contraction+Manager.h"

@implementation Contraction (Export)

+ (NSString *)stringToExportInContext:(NSManagedObjectContext *)context
{
    NSArray *contractions = [Contraction fetchContractionsInContext:context];

    NSMutableString *exportString    = [NSMutableString string];
    NSString        *headerFormatter = @"<table><tr><th>%@</th><th>%@</th><th>%@</th></tr>";

    NSString *date = NSLocalizedStringWithDefaultValue(@"settingsView.exportTable.date",
                                                       @"Localizable",
                                                       [NSBundle mainBundle],
                                                       @"Date",
                                                       @"");

    NSString *duration = NSLocalizedStringWithDefaultValue(@"settingsView.exportTable.duration",
                                                           @"Localizable",
                                                           [NSBundle mainBundle],
                                                           @"Duration",
                                                           @"");

    NSString *interval = NSLocalizedStringWithDefaultValue(@"settingsView.exportTable.interval",
                                                           @"Localizable",
                                                           [NSBundle mainBundle],
                                                           @"Interval",
                                                           @"");

    NSString *beginTable = [NSString stringWithFormat:headerFormatter, date, duration, interval];
    exportString = [exportString stringByAppendingString:beginTable].mutableCopy;

    for (Contraction *contraction in contractions) {

        NSString *humanizedDuration = [contraction humanizedDuration];
        NSString *humanizedInterval = [contraction humanizedInterval];

        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"MMM dd, HH:mm"];
        NSString *humanizedDate = [format stringFromDate:contraction.date];

        NSString *pasLine = [NSString stringWithFormat:@"<tr><td>%@</td><td>%@</td><td>%@</td></tr>", humanizedDate, humanizedDuration, humanizedInterval];
        exportString = [exportString stringByAppendingString:pasLine].mutableCopy;
    }

    exportString = [exportString stringByAppendingString:@"</table>"].mutableCopy;

    return exportString;
}

@end
