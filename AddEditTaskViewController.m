//
//  AddEditTaskViewController.m
//  breeze
//
//  Created by Breeze on 20.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import "AddEditTaskViewController.h"
#import "DataUtils.h"
#import "PDKeychainBindings.h"
#import "Project.h"
#import "ACEExpandableTextCell.h"
#import "AddEditTaskNameHeader.h"

@interface AddEditTaskViewController ()

@end

@implementation AddEditTaskViewController
static CGFloat defaultRowHeight=71;
//static CGFloat defaultRowHeightForNewTasks=150;
static CGFloat defaultHeaderHeight=65;
//static CGFloat defaultKeyboardHeight=216;

static CGFloat padding=20;



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
    self.fullContentRect=self.contentTableView.frame;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
    self.isFirstload=YES;
    self.taskNameEnteredText=[[NSString alloc]init];
    self.taskDesctiptionEnteredText=[[NSString alloc]init];
    if (self.isNewTask) {
        [self setWithNewTask];
    }
    else
    {
        [self setWithTaskToEdit];
    }


    self.view.backgroundColor=[DATAUTILS backgroundColor];
    self.contentTableView.backgroundColor=[DATAUTILS backgroundColor];
    self.contentTableView.delegate=self;
    self.contentTableView.dataSource=self;
    
   // [self focusTaskNameTextView];
    NSLog(@"---subviews of AddEditTaskViewController---");
    NSLog(@"self view:%@",self.view.layer);
    [DATAUTILS listSubviewsOfView:self.view];
    NSLog(@"---subviews of AddEditTaskViewController end---");
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)setWithNewTask
{
     self.title=@"Add task";
     self.taskNameEnteredText=@"";
    self.taskDesctiptionEnteredText=@"";
    self.contentTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
}
-(void)setWithTaskToEdit
{
    self.title=DATAUTILS.selectedCard.name;
    self.taskNameEnteredText=DATAUTILS.selectedCard.name;
    self.taskDesctiptionEnteredText=DATAUTILS.selectedCard.cardDescription;
    self.contentTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return defaultRowHeight;
//}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return defaultHeaderHeight;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    AddEditTaskNameHeader *header=[[[NSBundle mainBundle] loadNibNamed:@"AddEditTaskNameHeader" owner:nil options:nil] objectAtIndex:0];
    header.backgroundColor=[DATAUTILS backgroundColor];
    header.frame=CGRectZero;
    
    if (self.isNewTask) {
                   PDKeychainBindings *bindings=[PDKeychainBindings sharedKeychainBindings];
                  NSString *userName=[bindings objectForKey:@"username"];
                   User *currentUser=[DATAUTILS getUserFromDatabase:userName];
                 //  [cell.userNameLabel setText:userName];
        
       
      
       
                    if (currentUser) {
                        
                      header.avatar.imageURL= [NSURL URLWithString:currentUser.avatar];
                      header.avatar.cacheMode=RIDiskCacheMode;
                      header.avatar.showActivityIndicator=YES;
                      header.avatar.layer.cornerRadius = header.avatar.frame.size.height /2;
                      header.avatar.layer.masksToBounds = YES;
                      header.avatar.layer.borderWidth = 0;
                        
                       [header.projectNameLabel setText:currentUser.name];
       
                  }
                    else
                  {
                       NSLog(@"can't find data about the user:%@",userName);
                  }
        
               }
               else
               {
       
                    User *taskCreator=[[DATAUTILS.selectedCard.toUsersRelationship allObjects]firstObject];
                   [header.projectNameLabel setText:taskCreator.name];
                    header.avatar.imageURL= [NSURL URLWithString:taskCreator.avatar];
                    header.avatar.cacheMode=RIDiskCacheMode;
                    header.avatar.showActivityIndicator=YES;
                    header.avatar.layer.cornerRadius = header.avatar.frame.size.height /2;
                    header.avatar.layer.masksToBounds = YES;
                    header.avatar.layer.borderWidth = 0;
        
               }

    return header;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isNewTask) {
        return 1;
    }
    else
    {
      return 2;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

        return MAX(defaultRowHeight, _cellHeight[indexPath.row]);
   
    
}

- (void)tableView:(UITableView *)tableView updatedHeight:(CGFloat)height atIndexPath:(NSIndexPath *)indexPath
{
    _cellHeight[indexPath.row] = height;
}

- (void)tableView:(UITableView *)tableView updatedText:(NSString *)text atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        self.taskNameEnteredText=text;
    }
    else
    {
        self.taskDesctiptionEnteredText=text;
    }
 //   [_cellData replaceObjectAtIndex:indexPath.section withObject:text];
}

//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *footer=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
//    footer.backgroundColor=[DATAUTILS backgroundColor];
//    footer.frame=CGRectZero;
//    return footer;
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"creatig cells");
    
    if (indexPath.row==0) {
        ACEExpandableTextCell *cell = [tableView expandableTextCellWithId:@"NameCell"];
        cell.text=self.taskNameEnteredText;
        cell.textView.placeholderText=@"Task name...";
        cell.backgroundColor=[DATAUTILS backgroundColor];
        
        if (self.isNewTask) {
            [cell.textView becomeFirstResponder];
        }
        
        return cell;
    }
    else
    {
        ACEExpandableTextCell *cell = [tableView expandableTextCellWithId:@"DescriptionCell"];
        UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
        separatorLineView.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:separatorLineView];
        cell.text=self.taskDesctiptionEnteredText;
        cell.textView.placeholderText=@"Task description...";
        cell.backgroundColor=[DATAUTILS backgroundColor];
        return cell;
    }
    
    
    
    
}
- (IBAction)cancelAction:(id)sender {
    NSLog(@"cancel editing task");
  [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)doneAction:(id)sender {
    NSLog(@"done action");
    if (self.isNewTask) {
        
        
        
        
        NSLog(@"started adding task on list:%@",self.currentListId);
        

        
        
        

        
        NSDictionary *atributes=[NSDictionary dictionaryWithObject:self.taskNameEnteredText forKey:@"name"];
        
        NSDictionary *paramsDic=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:self.currentListId,atributes, nil] forKeys:[NSArray arrayWithObjects:@"stage_id",@"card", nil]];

       // NSDictionary *paramsDic=[NSDictionary dictionaryWithObject:atributes forKey:@"card"];
        NSLog(@"params:%@",paramsDic);
       
        
        
       [ DATAUTILS createCardInProject:[DATAUTILS.selectedProject.projectId stringValue] withParams:paramsDic completion:^(BOOL success, NSString *result) {
            if (success) {
                NSLog(@"succesfully added card:%@",result);
                
                if([self.delegate respondsToSelector:@selector(taskContentChanged)])
                {
                    [self.delegate taskContentChanged];
                    
                }
                else
                {
                    NSLog(@"delegate error");
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                NSLog(@"error while adding card:%@",result);
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        
        
        }
        
    else
    {
        NSLog(@"started editing task");
        NSArray *keysAttay=[NSArray arrayWithObjects:@"name",@"description", nil];
        
        NSString *taskNameKeyString;
        NSString *taskDescriptionKeyString;
        if (self.taskNameEnteredText && [self.taskNameEnteredText length]>0) {
          taskNameKeyString=[NSString stringWithFormat:@"%@",self.taskNameEnteredText ];
        }
        else
        {
            taskNameKeyString=[[NSString alloc]init];
            
        }
        
        if (self.taskDesctiptionEnteredText && [self.taskDesctiptionEnteredText length]>0) {
             taskDescriptionKeyString=[NSString stringWithFormat:@"%@",self.taskDesctiptionEnteredText ];
        }
        
       else
       {
           taskDescriptionKeyString =[[NSString alloc]init];

       }
        
        NSArray *objectsArray=[NSArray arrayWithObjects:taskNameKeyString,taskDescriptionKeyString, nil];
        
  
        
        NSDictionary *atributes=[NSDictionary dictionaryWithObjects:objectsArray forKeys:keysAttay];
       
        NSLog(@"atributes dic created");
        NSDictionary *paramsDic=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[DATAUTILS.selectedCard.stage_id stringValue],atributes, nil] forKeys:[NSArray arrayWithObjects:@"stage_id",@"card", nil]];
        NSLog(@"params dic created");
      //  NSDictionary *paramsDic=[NSDictionary dictionaryWithObject:atributes forKey:@"card"];
        
        NSLog(@"params:%@",paramsDic);
        
        [DATAUTILS updateCardInProject:[DATAUTILS.selectedProject.projectId stringValue] andCard:[DATAUTILS.selectedCard.cardId stringValue] withParams:paramsDic completion:^(BOOL success, NSString *result) {
            
            if (success) {
                NSLog(@"succesfully edited card:%@",result);
//                if([self.delegate respondsToSelector:@selector(taskContentChanged)])
//                {
//                    NSLog(@"delegate responds to selector");
//                    
//                   // if (result>0) {
//                        [self.delegate taskContentChanged];
//                   // }
//                    
//                    
//                }
//                else
//                {
//                    NSLog(@"delegate error");
//                }
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                NSLog(@"error while editing card:%@",result);
                [DATAUTILS DisplayPopupWithTitle:@"Network error" andMessage:@"Error while editing card, check your network connection"];
            }
            
        }];
        
        
    }
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSLog(@"keyboard was shown");
   
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    NSLog(@"keyboard height:%f",kbSize.height);
  //  CGRect contentTableviewRect=self.fullContentRect;
    
  //  contentTableviewRect.size.height=contentTableviewRect.size.height-kbSize.height*3;
   
   // self.contentTableView.frame=contentTableviewRect;
    
   // self.heightConst.constant=contentTableviewRect.size.height-kbSize.height;
    self.bottomSpace.constant=kbSize.height+padding;
    
}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    // restore the scroll position
    NSLog(@"keyboard will be hidden");
    //self.contentTableView.frame=self.fullContentRect;
    //self.heightConst.constant=self.fullContentRect.size.height;
    self.bottomSpace.constant=0;
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}

-(void)dealloc
{
    NSLog(@"detailed task controller dealloc:%@",self);
    self.delegate=nil;
    self.contentTableView.delegate=nil;
    self.contentTableView.dataSource=nil;
    
}
@end
