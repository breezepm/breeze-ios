//
//  TimeTrackingPickerCell.m
//  breeze
//
//  Created by Breeze on 03.06.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import "TimeTrackingPickerCell.h"

@implementation TimeTrackingPickerCell

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

-(void)configure
{
    NSLog(@"configure picker");
    self.picker.delegate=self;
    self.picker.dataSource=self;
    
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    NSLog(@"number of components in picker view");
    return 2;
    
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    NSLog(@"number of rows in component picker view");
    if (component==0) {
        return 10000;
    }
    else
    {
        return 60;
    }
    
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    if (component==0) {
        NSString *title=[NSString stringWithFormat:@"%d hours",row ];
        return title;
    }
    else
    {
        NSString *title=[NSString stringWithFormat:@"%d mins",row ];
        return title;
    }
    
}
@end
