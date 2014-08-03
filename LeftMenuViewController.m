//
//  LeftMenuViewController.m
//  breeze
//
//  Created by Breeze on 06.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "MenuCell.h"
#import "DataUtils.h"


@interface LeftMenuViewController ()

@end

@implementation LeftMenuViewController
static CGFloat menuRowHeight=60;


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
    NSLog(@"left menu - view did load");
    [super viewDidLoad];
    self.itemsArray=[[NSArray alloc]initWithObjects:@"Projects",@"Activity",@"Log out", nil];
    [self setMenu];

    
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.itemsArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MenuCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    [cell.MenuCellItemName setText:[self.itemsArray objectAtIndex:indexPath.row]];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return menuRowHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected row:%ld",(long)indexPath.row);
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    switch (indexPath.row) {
        case 0:
                {
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"ProjectsViewController"]]
                                                         animated:YES];
                    [self.sideMenuViewController hideMenuViewController];
                    
                    
                    break;

                }
            
                   case 1:
                        {
                                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"ActivityViewController"]]
                                                         animated:YES];
                                [self.sideMenuViewController hideMenuViewController];
                                break;
   
                        }
            
        case 2:
            [self logOut];
//            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"rightV"]]
//                                                         animated:YES];
//            [self.sideMenuViewController hideMenuViewController];
            break;
        default:
            break;
    }

}
-(void)setMenu
{
   
    self.menuTableview.center=self.view.center;
    
    self.menuTableview.delegate=self;
    self.menuTableview.dataSource=self;
    NSLog(@"subviews of left menu view controller");
    [DATAUTILS listSubviewsOfView:self.view];
    NSLog(@"subviews of left menu view controller end");
    

}
-(void)logOut
{
    NSLog(@"log out");

    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)dealloc
{
    NSLog(@"left menu dealloc ");
    self.menuTableview.delegate=nil;
    self.menuTableview.dataSource=nil;
}
@end
