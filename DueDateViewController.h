//
//  DueDateViewController.h
//  breeze
//
//  Created by Breeze on 22.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DueDateDelegate;
@interface DueDateViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak,nonatomic) id <DueDateDelegate> delegate;
- (IBAction)deleteAction:(id)sender;
- (IBAction)cancelAction:(id)sender;
- (IBAction)doneAction:(id)sender;

@property BOOL worksAsStartDateViewController;

@end
@protocol DueDateDelegate <NSObject>
@optional
-(void) taskContentChanged;

@end