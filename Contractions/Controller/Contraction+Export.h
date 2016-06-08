//
//  Contraction+Export.h
//  Contractions
//
//  Created by Alexander Gomzyakov on 21.04.14.
//  Copyright (c) 2014 Alexander Gomzyakov. All rights reserved.
//

#import "Contraction.h"

@interface Contraction (Export)

/**
 Возвращает данные в HTML-формате для экспорта списка схваток.
 */
+ (NSString *)stringToExportInContext:(NSManagedObjectContext *)context;

@end
