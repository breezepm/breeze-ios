//
//  CommentCell.h
//  breeze
//
//  Created by Breeze on 15.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemoteImageView.h"
#import "RTLabel.h"

@interface CommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet RemoteImageView *avatarImage;
@property (weak, nonatomic) IBOutlet RTLabel *commentContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentDetailsLabel;


@end
