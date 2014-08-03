//
//  PeoplesViewController.h
//  breeze
//
//  Created by Breeze on 28.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PeoplesViewController : UIViewController <NSFetchedResultsControllerDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *peoplesTable;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@end
