//
//  CommentsIconCell.m
//  breeze
//
//  Created by Breeze on 09.06.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import "CommentsIconCell.h"
#import "DataUtils.h"

@implementation CommentsIconCell

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
   // NSArray *temp=[DATAUTILS createCommentsArrayFromCard:card];
    
    NSString *text=[NSString stringWithFormat:@"%@",card.comments_count ];
    self.commentTextLabel.text=text;
    [self.commentTextLabel setTextColor:[UIColor lightGrayColor]];
    
   // [self.commentTextLabel setBackgroundColor:[UIColor blueColor]];
   // [self setBackgroundColor:[UIColor blueColor]];
}


@end
