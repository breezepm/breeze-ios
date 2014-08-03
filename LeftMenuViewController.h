//
//  LeftMenuViewController.h
//  breeze
//
//  Created by Breeze on 06.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResideMenu.h"

@interface LeftMenuViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (strong) NSArray *itemsArray;
@property (weak, nonatomic) IBOutlet UITableView *menuTableview;

@end
