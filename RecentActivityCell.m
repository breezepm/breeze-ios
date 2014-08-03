//
//  RecentActivityCell.m
//  breeze
//
//  Created by Breeze on 05.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import "RecentActivityCell.h"

@implementation RecentActivityCell

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
    self.activityName.delegate=self;
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
- (IBAction)activityAction:(id)sender {
}
@end
