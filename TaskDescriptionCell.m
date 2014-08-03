//
//  TaskDescriptionCell.m
//  breeze
//
//  Created by Breeze on 15.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import "TaskDescriptionCell.h"

@implementation TaskDescriptionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    self.taskDescription.delegate=self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL *)url
{
    NSLog(@"selected url:%@",url.absoluteString);
    [[UIApplication sharedApplication]openURL:url];
}
@end
