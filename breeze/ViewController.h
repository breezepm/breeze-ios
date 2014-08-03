//
//  ViewController.h
//  breeze
//
//  Created by Breeze on 05.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewFooter.h"
#import "LoginViewHeader.h"
#include "LoginScreenCell.h"

@interface ViewController : UIViewController <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableViews;
@property (strong) UIActivityIndicatorView *activityView;
@property int pressCounter;
@property (weak) LoginViewFooter *loginFooter;
- (IBAction)testAction:(id)sender;

@end
