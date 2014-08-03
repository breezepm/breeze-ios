//
//  RecentActivityCell.h
//  breeze
//
//  Created by Breeze on 05.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
#import "RemoteImageView.h"

@interface RecentActivityCell : UITableViewCell <RTLabelDelegate>

@property (weak, nonatomic) IBOutlet RTLabel *activityName;
@property (weak, nonatomic) IBOutlet RemoteImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UIButton *activityActionButton;

//@property (weak, nonatomic) IBOutlet UILabel *ProjectNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *goToProjectButton;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@end
