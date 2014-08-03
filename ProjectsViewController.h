//
//  ProjectsViewController.h
//  breeze
//
//  Created by Breeze on 06.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResideMenu.h"

@interface ProjectsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate>
- (IBAction)leftMenu:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *projectsTableview;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong) UIRefreshControl *refreshControl;
@property (strong) NSArray *pageviewControllerContentArray;
//@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property int projectsViewTappCounterl;

@end
