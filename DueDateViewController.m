//
//  DueDateViewController.m
//  breeze
//
//  Created by Breeze on 22.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import "DueDateViewController.h"
#import "DataUtils.h"
#import "Card.h"
#import "ProjectCards.h"
#import "Project.h"

@interface DueDateViewController ()

@end

@implementation DueDateViewController

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
    NSLog(@"works as startDateViewController%hhd",self.worksAsStartDateViewController);
    if (self.worksAsStartDateViewController) {
        self.title=@"Add start date";
    }
    else
    {
        self.title=@"Add due date";
    }
    
    [self setColours];
    
    NSLog(@"subviews of duedate viewcontroller");
    [DATAUTILS listSubviewsOfView:self.view];
    NSLog(@"subviews of duedate viewcontroller end");
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

- (IBAction)deleteAction:(id)sender {
    NSLog(@"deleteAction");
    NSDictionary *atributesDictionary;
    if (self.worksAsStartDateViewController) {
            atributesDictionary=[NSDictionary dictionaryWithObject:@"" forKey:@"startdate"];
    }
    else
    {
           atributesDictionary=[NSDictionary dictionaryWithObject:@"" forKey:@"duedate"];
    }

    NSDictionary *paramsdate=[NSDictionary dictionaryWithObject:atributesDictionary forKey:@"card"];
    
    [DATAUTILS updateCardInProject:[DATAUTILS.selectedProject.projectId stringValue] andCard:[DATAUTILS.selectedCard.cardId stringValue] withParams:paramsdate completion:^(BOOL success, NSString *result) {
        
        if (success) {
            NSLog(@"succesfully edited card:%@",result);
            if([self.delegate respondsToSelector:@selector(taskContentChanged)])
            {
                NSLog(@"delegate responds to selector");
                
                //if (result>0) {
                [self.delegate taskContentChanged];
                //}
                
                
            }
            else
            {
                NSLog(@"delegate error");
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            NSLog(@"error while editing card:%@",result);
            [DATAUTILS DisplayPopupWithTitle:@"Network error" andMessage:@"Error while editing card, check your network connection"];
        }
        
    }];
}

- (IBAction)cancelAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneAction:(id)sender {
    NSLog(@"done Action");
    NSString *dateToAdd=[DATAUTILS getDueDateStringFromDate:self.datePicker.date];
    NSDictionary *atributesDictionary;
    if ([dateToAdd length]>0) {
       
        if (self.worksAsStartDateViewController) {
            atributesDictionary=[NSDictionary dictionaryWithObject:dateToAdd forKey:@"startdate"];
        }
        else
        {
            atributesDictionary=[NSDictionary dictionaryWithObject:dateToAdd forKey:@"duedate"];
        }
  
  
    NSDictionary *paramsdate=[NSDictionary dictionaryWithObject:atributesDictionary forKey:@"card"];
    
     [DATAUTILS updateCardInProject:[DATAUTILS.selectedProject.projectId stringValue] andCard:[DATAUTILS.selectedCard.cardId stringValue] withParams:paramsdate completion:^(BOOL success, NSString *result) {
        
        if (success) {
            NSLog(@"succesfully edited card:%@",result);
            if([self.delegate respondsToSelector:@selector(taskContentChanged)])
            {
                NSLog(@"delegate responds to selector");
                
                //if (result>0) {
                    [self.delegate taskContentChanged];
                //}
                
                
            }
            else
            {
                NSLog(@"delegate error");
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            NSLog(@"error while editing card:%@",result);
            [DATAUTILS DisplayPopupWithTitle:@"Network error" andMessage:@"Error while editing card, check your network connection"];
        }
        
    }];
      }
    else
    {
        NSLog(@"Add duedate: date conversion error from date:%@",self.datePicker.date);
        [DATAUTILS DisplayPopupWithTitle:@"Error" andMessage:@"Date conversion error"];
    }
}
-(void)setColours
{
    self.datePicker.datePickerMode=UIDatePickerModeDate;
    self.view.backgroundColor=[DATAUTILS backgroundColor ];
    self.deleteButton.backgroundColor=[UIColor whiteColor];
    
    if (self.worksAsStartDateViewController) {
        [self.deleteButton setTitle:@"Delete startdate" forState:UIControlStateSelected];
        [self.deleteButton setTitle:@"Delete startdate" forState:UIControlStateNormal];
        
        if ([DATAUTILS.selectedCard.startdate length]==0) {
            [self.deleteButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
            [self.deleteButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
        else
        {
            [self.deleteButton setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
            [self.deleteButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            
            NSDate *tempDate=[DATAUTILS getDateFromTimestamp:DATAUTILS.selectedCard.startdate];
            if (tempDate!=NULL) {
                [self.datePicker setDate:tempDate];
            }
        }

        
        
    }
    else
    {
        [self.deleteButton setTitle:@"Delete duedate" forState:UIControlStateSelected];
        [self.deleteButton setTitle:@"Delete duedate" forState:UIControlStateNormal];
        if ([DATAUTILS.selectedCard.duedate length]==0) {
            [self.deleteButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
            [self.deleteButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
        else
        {
            [self.deleteButton setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
            [self.deleteButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            
            NSDate *tempDate=[DATAUTILS getDateFromTimestamp:DATAUTILS.selectedCard.duedate];
            if (tempDate!=NULL) {
                [self.datePicker setDate:tempDate];
            }
        }

    }
    
    
}
@end
