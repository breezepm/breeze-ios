//
//  AssignUsersCell.h
//  breeze
//
//  Created by Breeze on 28.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemoteImageView.h"

@interface AssignUsersCell : UITableViewCell
@property (weak, nonatomic) IBOutlet RemoteImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@end
