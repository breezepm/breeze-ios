//
//  ActivityViewController.h
//  breeze
//
//  Created by Breeze on 05.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataUtils.h"
#import "ResideMenu.h"
#import "RemoteImageView.h"
#import "RTLabel.h"
#import "SuProgress.h"






@interface ActivityViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *activityTableview;
- (IBAction)LeftMenu:(id)sender;
- (IBAction)rightMenu:(id)sender;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
//@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong) UIRefreshControl *refreshControl;
@property (strong) Activity *selectedActivity;
@property (strong) NSArray *pageviewControllerContentArray;
@property (atomic) BOOL isDownloadingMoreRows;
@end
