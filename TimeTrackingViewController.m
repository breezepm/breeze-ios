//
//  TimeTrackingViewController.m
//  breeze
//
//  Created by Breeze on 21.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import "TimeTrackingViewController.h"
#import "DataUtils.h"
#import "DatePickerCell.h"
#import "Project.h"
#import "Card.h"
#import "TimeTrackingCommentCell.h"
#import "DetailedTaskController.h"
#import "TimeTrackingPickerCell.h"


@interface TimeTrackingViewController ()

@end

@implementation TimeTrackingViewController
static CGFloat headerHeight=20;
static CGFloat footerHeight=20;
static CGFloat rowHeight=45;
static CGFloat commentCellHeight=200;

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
    self.title=@"Time Tracking";
    self.isDetailedDateViewEnabled=NO;
    self.isDetailedTrackingViewEnabled=NO;
  //  [self setTextView];
    
    if (self.selectedTimeEntery) {
        self.hoursTracked=[self.selectedTimeEntery.tracked integerValue]/60;
        self.minsTracked=[self.selectedTimeEntery.tracked integerValue]-60*self.hoursTracked;
        self.enteryDate=[DATAUTILS getDateFromTimestamp:self.selectedTimeEntery.logged_date];
    }
    else
    {
        self.hoursTracked=0;
        self.minsTracked=0;
        self.enteryDate=[NSDate date];
    }

    self.timesTableview.delegate=self;
    self.timesTableview.dataSource=self;
   
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    NSLog(@"subviews of timetracking viewcontroller");
    [DATAUTILS listSubviewsOfView:self.view];
    NSLog(@"subviews of timetracking viewcontroller end");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)cancelAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneAction:(id)sender {
    
    
        if ([self.timesTableview numberOfRowsInSection:0]>1) {
            DatePickerCell *cellDate=(DatePickerCell *)[self.timesTableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
              self.enteryDate=cellDate.datePicker.date;
        }
       if ([self.timesTableview numberOfRowsInSection:1]>1) {
           
           
           TimeTrackingPickerCell *pickerCell=(TimeTrackingPickerCell *)[self.timesTableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
           
           self.hoursTracked=[pickerCell.picker selectedRowInComponent:0];
           self.minsTracked=[pickerCell.picker selectedRowInComponent:1];

           
           
           
           
        }
    
    NSDateFormatter *toDateFormatter=[[NSDateFormatter alloc]init];
    [toDateFormatter setDateFormat:@"YYYY'-'MM'-'dd"];
    if (self.enteryDate==NULL) {
        self.enteryDate=[NSDate date];
    }
    NSLog(@"done with date:%@ tracked:%d mins:%d",self.enteryDate,self.hoursTracked,self.minsTracked);
    
    
    NSString *timestamp=[toDateFormatter stringFromDate:self.enteryDate];
   NSString *trackedHoursString=[NSString stringWithFormat:@"%d",self.hoursTracked *60 +self.minsTracked];
    
    NSArray *keysArray=[NSArray arrayWithObjects:@"desc",@"logged_date",@"tracked", nil];
    NSArray *objectsArray=[NSArray arrayWithObjects:self.textView.text,timestamp,trackedHoursString, nil];
    
    
    NSDictionary *params=[NSDictionary dictionaryWithObjects:objectsArray forKeys:keysArray];
    
    NSLog(@"done with params:%@",params);
    
    if (self.selectedTimeEntery) {
       // NSLog(@"not implemented yet");
        
        NSLog(@"sending edit request");
        NSString *path=[NSString stringWithFormat:@"/projects/%@/cards/%@/time_entry/%@",DATAUTILS.selectedProject.projectId,DATAUTILS.selectedCard.cardId,self.selectedTimeEntery.enteryId ];
            __weak __typeof__(self) weakSelf = self;
        
        [[RKObjectManager sharedManager]putObject:nil path:path parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            NSLog(@"succesfully edited time entery:%@",mappingResult.array);
            NSLog(@"http response:%@",operation.HTTPRequestOperation.responseString);
            
            
            
            
            
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"Error while editing time entry:%@",error.description);
            [DATAUTILS DisplayPopupWithTitle:@"Network error" andMessage:error.description];
           // NSLog(@"http response:%@",operation.HTTPRequestOperation.responseString);
            
        }];
        
        
        
        
        
        
    }
    else
    {
        NSLog(@"sending request");
      NSString *path=[NSString stringWithFormat:@"/projects/%@/cards/%@/time_entry",DATAUTILS.selectedProject.projectId,DATAUTILS.selectedCard.cardId ];
            __weak __typeof__(self) weakSelf = self;
      [[RKObjectManager sharedManager]postObject:nil path:path parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
          NSLog(@"adding time antery success:%@",mappingResult.array);
          NSLog(@"http response:%@",operation.HTTPRequestOperation.responseString);
          [DATAUTILS.selectedCard addToTimeEnteriesRelationship:[mappingResult set]];
          NSInteger temp=[DATAUTILS.selectedCard.total_tracked integerValue];
          temp=temp+weakSelf.hoursTracked *60 +weakSelf.minsTracked;
          
          DATAUTILS.selectedCard.total_tracked=[[NSNumber alloc]initWithInteger:temp];
          
          [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext saveToPersistentStore:nil];
          
          
          
          
            [weakSelf.navigationController popViewControllerAnimated:YES];
          
          
          
      } failure:^(RKObjectRequestOperation *operation, NSError *error) {
          NSLog(@"addint time entery error:%@",error.description);
          [DATAUTILS DisplayPopupWithTitle:@"Network Error" andMessage:@"Error while adding time entery"];
          NSLog(@"http response:%@",operation.HTTPRequestOperation.responseString);
          
      }];
    }
    
    
    
    
   
}




-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cell for row");
    NSLog(@"logged date:%@",self.selectedTimeEntery.logged_date);
    NSLog(@"tracked:%@",self.selectedTimeEntery.tracked);
    
    if (indexPath.row==1) {
       
        
        if (indexPath.section==0) {
            //date
             DatePickerCell *datePicker =[tableView dequeueReusableCellWithIdentifier:@"DatePickerCell"];
            datePicker.datePicker.datePickerMode = UIDatePickerModeDate;
            if (self.selectedTimeEntery) {
                
                if (self.enteryDate) {
                     datePicker.datePicker.date=self.enteryDate;
                }
               
            }
            
            return datePicker;
        }
        else
        {
            //tracked
            TimeTrackingPickerCell *pickerCell=[tableView dequeueReusableCellWithIdentifier:@"TimeTrackingPickerCell"];
            
            if (self.selectedTimeEntery) {
                NSInteger rowToselect=self.hoursTracked;
                [pickerCell.picker selectRow:rowToselect inComponent:0 animated:NO];
            }
            
            [pickerCell configure];
            return pickerCell;
        }
        
        
    }
    else
    {
        if (indexPath.section==2) {
            TimeTrackingCommentCell *commentCell=[tableView dequeueReusableCellWithIdentifier:@"TimeTrackingCommentCell"];
            self.textView=commentCell.commentTextView;
            commentCell.commentTextView.placeholderText=@"Add comment...";
            commentCell.commentTextView.placeholderColor=[UIColor lightGrayColor];
       //     commentCell.commentTextView.realTextColor=[UIColor blackColor];
            
            if (self.selectedTimeEntery) {
                commentCell.commentTextView.text=self.selectedTimeEntery.enteryDescription;
            }
            commentCell.commentTextView.delegate=self;
            return commentCell;
        }
        
        else
        {
            DetailedTimeTrackingCell *Cell=[tableView dequeueReusableCellWithIdentifier:@"DetailedTimeTrackingCell"];
            
            //Cell.textContent.text=rowString;
            
            if (indexPath.section==0) {
                
                
                Cell.textContent.text= [DATAUTILS GetTimeTrackingDateStringFromDate:self.enteryDate];
                
                
            }
            else
            {
                NSString *cellText=[NSString stringWithFormat:@"%d hours %d mins",self.hoursTracked,self.minsTracked ];
                Cell.textContent.text=cellText;
            }
            
            return Cell;
        }
        

    }
    
   
    

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section==0) {
        return headerHeight;
    }
    else
    {
        return 0;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==2) {
        return footerHeight;
    }
    else
    {
        return 0;
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *retView=[[UIView alloc] initWithFrame:CGRectZero];
    retView.backgroundColor=[DATAUTILS backgroundColor ];
    return retView;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *retView=[[UIView alloc]initWithFrame:CGRectZero];
    retView.backgroundColor=[DATAUTILS backgroundColor ];
    return retView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==2) {
        return commentCellHeight;
    }
    else
    {
        if (indexPath.row==0) {
            return rowHeight;
        }
        else
        {
            return 165;
        }

    }
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return 2+self.isDetailedDateViewEnabled+self.isDetailedTrackingViewEnabled;
    
    if (section==0) {
        return 1+self.isDetailedDateViewEnabled;
    }
    else if(section==1)
    {
        return 1+self.isDetailedTrackingViewEnabled;
    }
    else
    {
        return 1;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"tap");
    self.view.userInteractionEnabled=NO;
    int numOfRows=2+self.isDetailedDateViewEnabled+self.isDetailedTrackingViewEnabled;
    NSLog(@"num of rows :%d tapped:%d",numOfRows,indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [tableView beginUpdates];
    
    if (indexPath.section==0) {
        if (self.isDetailedDateViewEnabled) {
          [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
            //need to add here
            DatePickerCell *cell=(DatePickerCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:indexPath.section]];
            self.enteryDate=cell.datePicker.date;
            self.isDetailedDateViewEnabled=NO;
        }
        
        else
        {
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationTop];
            
            self.isDetailedDateViewEnabled=YES;
        }
    }
    
    else
    {
        if (self.isDetailedTrackingViewEnabled) {
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
            //need to add here
            TimeTrackingPickerCell *pickerCell=(TimeTrackingPickerCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:indexPath.section]];
            
            
            
            self.hoursTracked=[pickerCell.picker selectedRowInComponent:0];
            self.minsTracked=[pickerCell.picker selectedRowInComponent:1];
            
           // DatePickerCell *cell=(DatePickerCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:indexPath.section]];
           // NSDate *date=cell.datePicker.date;
           // self.hoursTracked=[DATAUTILS getTrackedHoursFromInterval: [date timeIntervalSince1970]];
            self.isDetailedTrackingViewEnabled=NO;
        }
        
        else
        {
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationTop];
            self.isDetailedTrackingViewEnabled=YES;
        }
    }
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
       [tableView endUpdates];
    
        [self reload];
    self.view.userInteractionEnabled=YES;
    
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    [self.navigationItem.leftBarButtonItem setEnabled:YES];
    
    
}
-(void)reload
{
    NSArray *indexP=[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0],[NSIndexPath indexPathForRow:0 inSection:1], nil];
    
    
    [self.timesTableview reloadRowsAtIndexPaths:indexP withRowAnimation:UITableViewRowAnimationAutomatic];
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSLog(@"keyboard was shown");
 
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    NSLog(@"keyboard height:%f",kbSize.height);
    self.tableview_spaceToBottom.constant=kbSize.height+5;
    
    [self.timesTableview setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
    
    
    }
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    // restore the scroll position
    NSLog(@"keyboard will be hidden");
    self.tableview_spaceToBottom.constant=0;
        
}
-(void)dealloc
{
    NSLog(@"time tracking viewcontroller dealloc");
    self.timesTableview.delegate=nil;
    self.timesTableview.dataSource=nil;
}
@end
