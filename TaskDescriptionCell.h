//
//  TaskDescriptionCell.h
//  breeze
//
//  Created by Breeze on 15.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"

@interface TaskDescriptionCell : UITableViewCell <RTLabelDelegate>

@property (weak, nonatomic) IBOutlet RTLabel *taskDescription;

@end
