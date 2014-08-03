//
//  AttachmentsIconCell.m
//  breeze
//
//  Created by Breeze on 10.06.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import "AttachmentsIconCell.h"

@implementation AttachmentsIconCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setWithCard:(Card *)card
{
    
    [self.attachmentTextLabel setTextColor:[UIColor lightGrayColor]];
    [self.attachmentTextLabel setText:[card.attachments_count stringValue] ];
}

@end
