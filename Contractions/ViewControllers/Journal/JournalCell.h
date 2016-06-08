//
//  JournalCell.h
//  Contractions
//
//  Created by Gomzyakov on 06.02.13.
//  Copyright (c) 2013 Alexander Gomzyakov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JournalCell : UITableViewCell {
	
	// Represent of contraction duration, e.g. "1 min 23 sec"
	NSString *duration;
}

@property (copy, nonatomic) NSString *beginTime;  // Время начала схватки
@property (nonatomic) NSString *interval;   // Интервал до предыдущей схватки


-(void) setBeginTime:(NSString *)beginTime;
-(void) setDuration:(NSString *)duration;
-(void) setInterval:(NSString *)interval;

@end
