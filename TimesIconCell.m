//
//  TimesIconCell.m
//  breeze
//
//  Created by Breeze on 09.06.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import "TimesIconCell.h"


@implementation TimesIconCell

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
    NSLog(@"Times icon cell set with planed:%@ tracked %@",card.planned_time,card.total_tracked);
   [self.timesTextLabel setTextColor:[UIColor lightGrayColor]];
    [self.timesTextLabel setText: [DATAUTILS getTimesIconCellTextFromCard:card]];
   // [self.timesTextLabel setBackgroundColor:[UIColor blueColor]];
   // [self setBackgroundColor:[UIColor redColor]];
//    int planedHours=[card.planned_time integerValue]/60;
//    int planedMins=[card.planned_time integerValue]-(planedHours*60);
//    int trackedHours=[card.total_tracked integerValue]/60;
//    int trackedMins=[card.total_tracked integerValue]-(trackedHours*60);
//    NSLog(@"planed hours:%d",planedHours);
//    NSLog(@"planed mins:%d",planedMins);
//    NSLog(@"tracked hours:%d",trackedHours);
//    NSLog(@"tracked mins:%d",trackedMins);
//    
//    NSString *planedHoursString=[[NSString alloc]init];
//    NSString *planedMinsString=[[NSString alloc]init];
//    NSString *trackedHoursString=[[NSString alloc]init];
//    NSString *trackedMinsString=[[NSString alloc]init];
//    
//    
//    if (planedHours>0) {
//        planedHoursString=[NSString stringWithFormat:@"%dh",planedHours ];
//    }
//    else
//    {
//        planedHoursString=@"";
//    }
//    if (planedMins>0) {
//        planedMinsString=[NSString stringWithFormat:@"%dm",planedMins ];
//    }
//    else
//    {
//        planedMinsString=@"";
//    }
//    if (trackedHours>0) {
//        trackedHoursString=[NSString stringWithFormat:@"%dh",trackedHours ];
//    }
//    else
//    {
//        trackedHoursString=@"";
//    }
//    if (trackedMins>0) {
//         trackedMinsString=[NSString stringWithFormat:@"%dm",trackedMins ];
//    }
//    else
//    {
//        trackedMinsString=@"";
//    }
//    
//    if ([card.planned_time integerValue]!=0 && [card.total_tracked integerValue]!=0) {
//        NSString *text=[NSString stringWithFormat:@"%@ %@ / %@ %@",planedHoursString,planedMinsString,trackedHoursString,trackedMinsString ];
//        [self.timesTextLabel setText:text];
//    }
//    else if ([card.planned_time integerValue]!=0)
//    {
//        NSString *text=[NSString stringWithFormat:@"%@ %@",planedHoursString,planedMinsString];
//        [self.timesTextLabel setText:text];
//    }
//    else if ([card.total_tracked integerValue]!=0)
//    {
//        NSString *text=[NSString stringWithFormat:@"%@ %@",trackedHoursString,trackedMinsString];
//        [self.timesTextLabel setText:text];
//
//    }
//    else
//    {
//       [self.timesTextLabel setText:@""];
//    }
    
}

@end
