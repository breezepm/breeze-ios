//
//  TodosIconCell.m
//  breeze
//
//  Created by Breeze on 09.06.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import "TodosIconCell.h"

@implementation TodosIconCell

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
    NSString *text=[NSString stringWithFormat:@"%@/%@",card.done_todos,card.todos_count];
    [self.todosTextLabel setText:text];
    [self.todosTextLabel setTextColor:[UIColor lightGrayColor]];
}


@end
