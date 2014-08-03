//
//  ViewController.m
//  breeze
//
//  Created by Breeze on 05.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import "ViewController.h"
#import "User.h"
#import "Project.h"
#import "ProjectCards.h"
#import "Card.h"
#import "DataUtils.h"
#import "Activity.h"
#import "PDKeychainBindings.h"

@interface ViewController ()

@end

@implementation ViewController

static CGFloat headerHeight=120;
static CGFloat footerHeight=120;
static CGFloat menuItemHeight=35;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTable];
    
    self.activityView=[[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    self.view.backgroundColor=[DATAUTILS backgroundColor];
    self.pressCounter=0;
    
    NSLog(@"---subviews of viewcontroller---");
    NSLog(@"self view:%@",self.view.layer);
    [DATAUTILS listSubviewsOfView:self.navigationController.view];
    NSLog(@"---subviews of viewcontroller end---");

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //hides keyboard when another part of layout was touched
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - tableview delegate

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return footerHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return headerHeight;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    LoginViewFooter *footer=[[[NSBundle mainBundle] loadNibNamed:@"LoginViewFooter" owner:nil options:nil] objectAtIndex:0];
    footer.backgroundColor=[DATAUTILS backgroundColor];
    //footer.backgroundColor=[UIColor blackColor];

    footer.logInButton.backgroundColor=[DATAUTILS signInButtonColour];
    [footer.logInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footer.logInButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
    [footer.logInButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [footer.logInButton addTarget:self
                 action:@selector(signIn:)
       forControlEvents:UIControlEventTouchUpInside];
    footer.logInButton.layer.cornerRadius=5;
    self.loginFooter=footer;
    return footer;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    LoginViewHeader *header=[[[NSBundle mainBundle] loadNibNamed:@"loginViewHeader" owner:nil options:nil] objectAtIndex:0];
    header.backgroundColor=[DATAUTILS backgroundColor];
    return header;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
    if (indexPath.row==0) {
        LoginScreenCell *cell=[tableView dequeueReusableCellWithIdentifier:@"usernameCell"];
        cell.backgroundColor=[DATAUTILS backgroundColor];
        cell.textField.text=[bindings objectForKey:@"username"];
        cell.textField.delegate=self;
        cell.textField.borderStyle=UITextBorderStyleNone;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.textField setBackgroundColor:[UIColor clearColor]];
        return cell;
        
    }
    else
    {
        LoginScreenCell *cell=[tableView dequeueReusableCellWithIdentifier:@"passwordCell"];
        cell.backgroundColor=[DATAUTILS backgroundColor];
        cell.textField.delegate=self;
        cell.textField.secureTextEntry=YES;
        cell.textField.text=[bindings objectForKey:@"password"];
        cell.textField.borderStyle=UITextBorderStyleNone;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.textField setBackgroundColor:[UIColor clearColor]];
        return cell;
    }
}
-(void)signIn:(id)sender
{
    NSLog(@"sign in :%@",sender);
     [[RKManagedObjectStore defaultStore] resetPersistentStores:nil];
    
    self.pressCounter++;
    [self startActivityAnimation:sender];
   
    
    NSIndexPath *usernameCellIndexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath *passwordCellIndexPath=[NSIndexPath indexPathForRow:1 inSection:0];
    
    
    LoginScreenCell *usernameCell=(LoginScreenCell *)[self.tableViews cellForRowAtIndexPath:usernameCellIndexPath];
    LoginScreenCell *passwordCell=(LoginScreenCell *)[self.tableViews cellForRowAtIndexPath:passwordCellIndexPath];
    NSString *username=usernameCell.textField.text;
    NSString *password=passwordCell.textField.text;
    
    if ([username length]>0 && [password length]>0) {
        
        if ([DATAUTILS checkIfCredentialsChangedUsername:username Password:password]) {
            NSLog(@"need to clear database");
          //  [[RKManagedObjectStore defaultStore] resetPersistentStores:nil];
            NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            for (NSHTTPCookie *cookie in cookieStorage.cookies)
            {
                [cookieStorage deleteCookie:cookie];
            }
           
        }
        
        
        PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
        [bindings setObject:username forKey:@"username"];
        [bindings setObject:password forKey:@"password"];
        
       // NSLog(@"set header with username %@ and password:%@",username,password);
        [[RKObjectManager sharedManager].HTTPClient setAuthorizationHeaderWithUsername:username password:password];
        
        NSLog(@"restkit headers:%@",[[[RKObjectManager sharedManager] HTTPClient] defaultHeaders]);
        
        [[RKObjectManager sharedManager] getObjectsAtPathForRouteNamed:@"GetAllActivities" object:nil parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            
            NSLog(@"login screen:data downloaded");
            NSLog(@"mapping result:%@",mappingResult.array);
            
            for (Activity *a in mappingResult.array) {
                a.sectionString=[DATAUTILS getActivitySectionDateStringFromDateString:a.created_at];
                
            }
            
            
            
            
            NSError *error;
            [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext saveToPersistentStore:&error];
            
            [[RKObjectManager sharedManager] getObjectsAtPath:@"/projects.json" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                
                
                for (Project *proj in mappingResult.array) {
                    [[RKObjectManager sharedManager]getObjectsAtPathForRouteNamed:@"people" object:proj parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                        NSLog(@"downloading peoples");
                    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                        NSLog(@"error while downloading peoples");
                    }];
                
                    
                }
                NSLog(@"downloaded projects");
                [self stopActivityAnimation];
                NSLog(@"press conter:%d",self.pressCounter);
                
                
                
                
                [self performSegueWithIdentifier:@"goToMenuViewController" sender:self];

            } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                NSLog(@"error while downloading projects");
                [self stopActivityAnimation];
                NSLog(@"downloading error:%@",error.description);
                if (error.code==-1009) {
                    [DATAUTILS DisplayPopupWithTitle:@"Login error" andMessage:@"Please check your network connection"];
                }
                else
                {
                    [DATAUTILS DisplayPopupWithTitle:@"Login error" andMessage:@"Please check your credentials"];
                    
                }

            }];

        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            [self stopActivityAnimation];
            NSLog(@"downloading error:%@",error.description);
            if (error.code==-1009) {
                [DATAUTILS DisplayPopupWithTitle:@"Login error" andMessage:@"Please check your network connection"];
            }
            else
            {
                [DATAUTILS DisplayPopupWithTitle:@"Login error" andMessage:@"Please check your credentials"];
                
            }
            
        }];
        
        
       

        
    }
    else
    {
        NSLog(@"please enter your credentials");
        [DATAUTILS DisplayPopupWithTitle:@"Missing credentials" andMessage:@"Please enter your credentials"];
        [self stopActivityAnimation];
    }
    
    

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return menuItemHeight;
}
-(void)setTable
{
    self.tableViews.delegate=self;
    self.tableViews.dataSource=self;
    self.tableViews.scrollEnabled=NO;
    self.tableViews.backgroundColor=[DATAUTILS backgroundColor];

}
- (IBAction)testAction:(id)sender {
    [[RKManagedObjectStore defaultStore] resetPersistentStores:nil];
   [self performSegueWithIdentifier:@"goToMenuViewController" sender:self];
}
-(void)startActivityAnimation:(id)sender
{
    
    self.view.userInteractionEnabled=NO;
    [self.activityView startAnimating];
    [self.loginFooter.logInButton setHidden:YES];
    
    self.activityView.center=self.loginFooter.logInButton.center;
    [self.loginFooter addSubview:self.activityView];
    self.activityView.color=[DATAUTILS signInButtonColour];
    //[senderButton addSubview:self.activityView];
    
}
-(void)stopActivityAnimation
{
    self.view.userInteractionEnabled=YES;
  
     [self.loginFooter.logInButton setHidden:NO];
    
    [self.activityView removeFromSuperview];
    
}

-(void)dealloc
{
    NSLog(@"viewcontroller dealloc");
    self.tableViews.delegate=nil;
    self.tableViews.dataSource=nil;
}
@end
