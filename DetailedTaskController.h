//
//  DetailedTaskController.h
//  breeze
//
//  Created by Breeze on 13.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"
#import "PulldownMenu.h"
#import "AddCommentViewController.h"
#import "AddEditTaskViewController.h"
#import "Project.h"
#import "ProjectCards.h"
#import "TimeTrackingViewController.h"
#import "DueDateViewController.h"
#import "TagViewController.h"
#import "ProjectDetailedTodoListsCell.h"
#import "AddEditToodoViewController.h"
#import "MarkTaskVievController.h"
#import "TimeTrackingViewController.h"


@interface DetailedTaskController : UIViewController <UITableViewDelegate,UITableViewDataSource,PulldownMenuDelegate,AddCommentDelegate,AddEditTaskDelegate,DueDateDelegate,EditTagsDelegate,todoListDelegate,AddEditTodoDelegate,MarkTaskDelegate,TimeTrackingDelegate>

@property (atomic) BOOL dueDateViewControllerWorksAsStartDateViewController;
@property (strong) Card *selectedCard;
@property (strong) PulldownMenu *pulldownMenu;
@property (weak, nonatomic) IBOutlet UITableView *taskTableView;
@property (strong,atomic) NSArray *sectionsArray;
@property (strong,atomic) NSArray *timeTrackingArray;
@property (strong,atomic) NSArray *commentsArray;
@property (strong,atomic) NSMutableArray *tagsArray;
@property BOOL isMenuOpened;
@property BOOL needToReloadData;
@property (atomic) BOOL tableviewDidFinishLoading;
@property (atomic) BOOL isFirstLoad;
@property (strong) Comment *selectedComment;
@property (strong) TimeEntery *selectedTimeEntery;
//@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong) Todo * selectedTodo;
@property (strong) NSNumber * selectedTodoList;
- (IBAction)openMenu:(id)sender;


@end
