//
//  LoginScreenCell.m
//  breeze
//
//  Created by Breeze on 19.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import "LoginScreenCell.h"

@implementation LoginScreenCell

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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)dealloc
{
    NSLog(@"login screen cell delalloc:%@",self);
    self.textField.delegate=nil;
    
}
@end
