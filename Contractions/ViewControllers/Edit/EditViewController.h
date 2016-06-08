//
//  ContractionDetailViewController.h
//  Contractions
//
//  Created by Gomzyakov on 08.02.13.
//  Copyright (c) 2013 Alexander Gomzyakov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Contraction;

@interface EditViewController : UITableViewController

// Contraction data (pushed from JournalViewController)
@property (nonatomic, weak) Contraction *contraction;

@end
