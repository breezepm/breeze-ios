//
//  DatesIconCell.m
//  breeze
//
//  Created by Breeze on 09.06.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import "DatesIconCell.h"
#import "DataUtils.h"

@implementation DatesIconCell

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
//    NSString *startDateString=[[NSString alloc]init];
//    NSString *dueDateString=[[NSString alloc]init];
//    startDateString=[DATAUTILS createProjectCardDueDateIconStringFromTimestamp:card.startdate];
//    dueDateString=[DATAUTILS createProjectCardDueDateIconStringFromTimestamp:card.duedate];
//    
//    if ([startDateString length]>0 && [dueDateString length]>0 ) {
//        self.datesTextlabel.text=[NSString stringWithFormat:@"%@ - %@",startDateString,dueDateString];
//
//    }
//    else if ([startDateString length]>0)
//    {
//        self.datesTextlabel.text=startDateString;
//
//    }
//    else if ([dueDateString length]>0)
//    {
//        self.datesTextlabel.text=dueDateString;
//
//    }
//    else
//    {
//        self.datesTextlabel.text=@"";
//    }
    
    [self.datesTextlabel setText:[DATAUTILS getDatesIconCellTextFromCard:card]] ;
    [self.datesTextlabel setTextColor:[UIColor lightGrayColor]];
    
}

@end
