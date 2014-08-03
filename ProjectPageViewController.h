//
//  ProjectPageViewController.h
//  breeze
//
//  Created by Breeze on 13.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"
#import "Card.h"
#import "ProjectCards.h"
#import "ProjectPageScroll.h"
#import "ProjectPageView.h"
#import "AddEditTaskViewController.h"
#import "projectPageNavigationBar.h"



@interface ProjectPageViewController : UIViewController <UIScrollViewDelegate,AtkDragAndDropManagerDelegate,ProjectTableDelegate,AddEditTaskDelegate>
@property (weak, nonatomic) IBOutlet UINavigationItem *titleBar;
@property (nonatomic, retain) AtkDragAndDropManager *dragAndDropManager;
@property (strong) NSArray *pageContentsArray;
@property (weak, nonatomic) IBOutlet ProjectPageScroll *scroll;


@property (weak, nonatomic) IBOutlet UIPageControl *pageControll;
@property (strong,atomic) NSIndexPath *placeholderIndexpath;
@property (strong,atomic) NSIndexPath *previousPlaceholderIndexpath;
@property (strong,atomic) ProjectPageView *lastPlaceholderView;
@property (strong) Card *selectedCard;
@property (strong,atomic) projectPageNavigationBar *navBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollHeightConstraint;

- (IBAction)AddButton:(id)sender;


@end
