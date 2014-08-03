//
//  AddEditTaskViewController.h
//  breeze
//
//  Created by Breeze on 20.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"
#import "RemoteImageView.h"
#import "AddEditTaskNameTaskNameCell.h"
#import "AddEditTaskNameTaskDescriptionCell.h"
#import "ACEExpandableTextCell.h"



@protocol AddEditTaskDelegate;
@interface AddEditTaskViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,ACEExpandableTableViewDelegate>
{
        CGFloat _cellHeight[2];
}
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;
@property CGRect fullContentRect;
@property (strong) NSString *taskNameEnteredText;
@property (strong) NSString *taskDesctiptionEnteredText;
@property (strong) NSNumber *currentListId;
@property (weak,nonatomic) id <AddEditTaskDelegate> delegate;
- (IBAction)cancelAction:(id)sender;
- (IBAction)doneAction:(id)sender;
@property BOOL isNewTask;
@property (atomic) BOOL isFirstload;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;


@end
@protocol AddEditTaskDelegate <NSObject>
@optional
-(void) taskContentChanged;

@end