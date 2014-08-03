//
//  MenuNavigationController.m
//  breeze
//
//  Created by Breeze on 26.06.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import "MenuNavigationController.h"
#import "DataUtils.h"

@interface MenuNavigationController ()

@end

@implementation MenuNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"menu navigation controller did load");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"menu view controller: wiev will apear");
    NSLog(@"subviews of navigation controller");
    [DATAUTILS listSubviewsOfView:self.view];
    NSLog(@"subviews of navigation controller end");
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"menu view controller: wiew will disapear");
    NSLog(@"subviews of navigation controller");
    [DATAUTILS listSubviewsOfView:self.view];
    NSLog(@"subviews of navigation controller end");
    [super viewWillDisappear:animated];
}
@end
