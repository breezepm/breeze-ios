//
//  AddEditTaskNameTaskNameCell.h
//  breeze
//
//  Created by Breeze on 20.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemoteImageView.h"
//#import "GCPlaceholderTextView.h"

#import "LPlaceholderTextView.h"
@interface AddEditTaskNameTaskNameCell : UITableViewCell
@property (weak, nonatomic) IBOutlet RemoteImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet LPlaceholderTextView *TaskNameTextView;

@end
