//
//  Contraction+Manager.h
//  Contractions
//
//  Created by Alexander Gomzyakov on 20.04.14.
//  Copyright (c) 2014 Alexander Gomzyakov. All rights reserved.
//

#import "Contraction.h"

@interface Contraction (Manager)

/**
 Возвращает массив всех схваток.
 @param context Контекст управляемого объекта.
 @return Массив сущностей Contraction или nil, если запрос на выборку выполнить не удалось.
 */
+ (NSArray *)fetchContractionsInContext:(NSManagedObjectContext *)context;

@end
