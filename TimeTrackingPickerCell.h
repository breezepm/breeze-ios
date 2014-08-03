//
//  TimeTrackingPickerCell.h
//  breeze
//
//  Created by Breeze on 03.06.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeTrackingPickerCell : UITableViewCell <UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *picker;

-(void)configure;
@end
