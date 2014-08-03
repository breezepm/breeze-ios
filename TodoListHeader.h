//
//  TodoListHeader.h
//  breeze
//
//  Created by Breeze on 29.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlusButton.h"

@interface TodoListHeader : UIView
@property (weak, nonatomic) IBOutlet UILabel *listNameLabel;
@property (weak, nonatomic) IBOutlet PlusButton *plusButton;
- (IBAction)plusButtonAction:(id)sender;

@end
