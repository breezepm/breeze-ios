//
//  MarkTaskVievController.m
//  breeze
//
//  Created by Breeze on 22.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import "MarkTaskVievController.h"
#import "MarkTaskCell.h"
#import "DataUtils.h"
#import "Project.h"
#import "Card.h"

@interface MarkTaskVievController ()

@end

@implementation MarkTaskVievController
static CGFloat headerHeight=30;
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
    self.startupMark=-1;
    self.view.backgroundColor=[DATAUTILS backgroundColor];
    self.contentTableview.backgroundColor=[DATAUTILS backgroundColor];
    self.title=@"Mark Task";
    self.itemsArray=[NSArray arrayWithObjects:@"Done",@"Ready",@"On Hold",@"Blocked", nil];
    self.contentTableview.allowsMultipleSelection=NO;
    self.contentTableview.dataSource=self;
    self.contentTableview.delegate=self;
    [self setWithSelectedCard];
    // Do any additional setup after loading the view.
    NSLog(@"subviews of mark task viewcontroller");
    [DATAUTILS listSubviewsOfView:self.view];
    NSLog(@"subviews of mark task viewcontroller end");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.itemsArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MarkTaskCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MarkTaskCell"];
    [cell.itemText setText:[self.itemsArray objectAtIndex:indexPath.row]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    if ([DATAUTILS.selectedCard.done boolValue] && indexPath.row==0) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.startupMark=indexPath.row;
       // [cell setSelected:YES];
    }
//    else if ([DATAUTILS.selectedCard.hidden boolValue] && indexPath.row==1)
//    {
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        self.startupMark=indexPath.row;
//        //[cell setSelected:YES];
//    }
    else if ([DATAUTILS.selectedCard.ready boolValue] && indexPath.row==1)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.startupMark=indexPath.row;
       // [cell setSelected:YES];
    }
    else if ([DATAUTILS.selectedCard.onhold boolValue] && indexPath.row==2)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.startupMark=indexPath.row;
      //  [cell setSelected:YES];
    }
    else if ([DATAUTILS.selectedCard.blocked boolValue] && indexPath.row==3)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.startupMark=indexPath.row;
       // [cell setSelected:YES];
    }
    else
    {
        NSLog(@"no mark at startup");
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
    
}

#pragma mark -tableview delegate
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return headerHeight;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *retView=[[UIView alloc]init];
    retView.backgroundColor=[DATAUTILS backgroundColor];
    return retView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *retView=[[UIView alloc]init];
    retView.backgroundColor=[DATAUTILS backgroundColor];
    return retView;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected");
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    
    for (UITableViewCell *cell in [tableView visibleCells]) {
        if (cell.accessoryType==UITableViewCellAccessoryCheckmark) {
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        
    }
    
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
   
    if (indexPath.row!=self.startupMark) {
        
        switch (indexPath.row) {
            case 0:
                [self updateCardwitKey:@"done" andValue:YES];
                break;
            
            case 1:[self updateCardwitKey:@"ready" andValue:YES];
                break;
            case 2:[self updateCardwitKey:@"onhold" andValue:YES];
                break;
            case 3:[self updateCardwitKey:@"blocked" andValue:YES];
                break;
                
                
            default:
                break;
        }

    }
    else
    {
        
        switch (indexPath.row) {
            case 0:
                [self updateCardwitKey:@"done" andValue:NO];
                break;
            
            case 1:[self updateCardwitKey:@"ready" andValue:NO];
                break;
            case 2:[self updateCardwitKey:@"onhold" andValue:NO];
                break;
            case 3:[self updateCardwitKey:@"blocked" andValue:NO];
                break;
                
                
            default:
                break;
        }

    }
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"deselected");
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
}
-(void)setWithSelectedCard
{
    NSLog(@"done:%hhd",[DATAUTILS.selectedCard.done boolValue]);
    NSLog(@"hidden:%hhd",[DATAUTILS.selectedCard.hidden boolValue]);
    NSLog(@"blocked:%hhd",[DATAUTILS.selectedCard.blocked boolValue]);
    NSLog(@"onhold:%hhd",[DATAUTILS.selectedCard.onhold boolValue]);
    NSLog(@"ready:%hhd",[DATAUTILS.selectedCard.ready boolValue]);
    
    
    if ([DATAUTILS.selectedCard.done boolValue]) {
        [self markTaskAtRow:0];
    }
    else if ([DATAUTILS.selectedCard.hidden boolValue])
    {
        [self markTaskAtRow:1];
    }
    else if ([DATAUTILS.selectedCard.ready boolValue])
    {
        [self markTaskAtRow:2];
    }
    else if ([DATAUTILS.selectedCard.onhold boolValue])
    {
        [self markTaskAtRow:3];
    }
    else if ([DATAUTILS.selectedCard.blocked boolValue])
    {
        [self markTaskAtRow:4];
    }
    else
    {
        NSLog(@"no mark at startup");
    }
}
-(void)markTaskAtRow:(NSInteger )row
{
//    NSLog(@"mark task at row:%ld",(long)row);
//    NSIndexPath *index=[NSIndexPath indexPathForRow:row inSection:0];
//    
//    [self.contentTableview selectRowAtIndexPath:index animated:NO scrollPosition:UITableViewScrollPositionTop];
}
-(void)updateCardwitKey:(NSString *)key andValue:(BOOL)val
{
NSArray *keysAttay=[NSArray arrayWithObjects:@"done",@"ready",@"onhold",@"blocked", nil];
   NSArray *objectsArray=[NSArray arrayWithObjects:@"false",@"false",@"false",@"false", nil];
    
    
    
    NSMutableDictionary *atributes=[NSMutableDictionary dictionaryWithObjects:objectsArray forKeys:keysAttay];
    
    if (val) {
        [atributes setObject:@"true" forKey:key];
    }
    else
    {
        [atributes setObject:@"false" forKey:key];
    }
    
    
    NSDictionary *paramsDic=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[DATAUTILS.selectedCard.stage_id stringValue],atributes, nil] forKeys:[NSArray arrayWithObjects:@"stage_id",@"card", nil]];
    
 
    
    NSLog(@"params:%@",paramsDic);
    
    [DATAUTILS updateCardInProject:[DATAUTILS.selectedProject.projectId stringValue] andCard:[DATAUTILS.selectedCard.cardId stringValue] withParams:paramsDic completion:^(BOOL success, NSString *result) {
        
        if (success) {
            NSLog(@"succesfully edited card:%@",result);
            [self.contentTableview reloadData];
            
            if([self.delegate respondsToSelector:@selector(taskContentChanged)])
            {
                [self.delegate taskContentChanged];
                
            }
            else
            {
                NSLog(@"delegate error");
            }
            
            
            //[self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            NSLog(@"error while editing card:%@",result);
            [DATAUTILS DisplayPopupWithTitle:@"Network error" andMessage:@"Error while editing card, check your network connection"];
            [self.contentTableview reloadData];
        }
        
    }];
}
-(void)dealloc
{
    NSLog(@"mark task viewcontroller dealloc");
    self.contentTableview.delegate=nil;
    
    self.contentTableview.dataSource=nil;
}
@end
