//
//  TimeTrackingViewController.h
//  breeze
//
//  Created by Breeze on 21.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeEntery.h"
#import "DetailedTimeTrackingCell.h"
#import "TimeEntery.h"
//#import "GCPlaceholderTextView.h"
#import "LPlaceholderTextView.h"
@protocol TimeTrackingDelegate;
@interface TimeTrackingViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
- (IBAction)cancelAction:(id)sender;
- (IBAction)doneAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *timesTableview;
//@property (weak, nonatomic) IBOutlet UITextView *commentTextField;
@property BOOL isDetailedDateViewEnabled;
@property BOOL isDetailedTrackingViewEnabled;
@property (strong) TimeEntery *selectedTimeEntery;
@property (strong,nonatomic) LPlaceholderTextView *textView;
@property (strong,atomic) NSDate *enteryDate;
@property (atomic) NSInteger hoursTracked;
@property (atomic) NSInteger minsTracked;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_spaceToBottom;

@property (weak,nonatomic) id <TimeTrackingDelegate> delegate;
@end


@protocol TimeTrackingDelegate <NSObject>
@optional
-(void) taskContentChanged;

@end
