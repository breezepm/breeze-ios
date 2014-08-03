//
//  MenuViewController.h
//  breeze
//
//  Created by Breeze on 05.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"

@interface MenuViewController : RESideMenu <RESideMenuDelegate>
- (IBAction)openMenu:(id)sender;

@end
