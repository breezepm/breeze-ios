//
//  DetailedTaskController.m
//  breeze
//
//  Created by Breeze on 13.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import "DetailedTaskController.h"
#import "DataUtils.h"
#import "AddCommentCell.h"
#import "TaskHeader.h"
#import "TaskNameCell.h"
#import "TaskDescriptionCell.h"
#import "TimeTrackingCell.h"
#import "CommentCell.h"
#import "Comment.h"
#import "AddEditTaskViewController.h"
#import "Card.h"
#import "TimeTrackingViewController.h"
#import "TagsCell.h"
#import "StartDuedateCell.h"
#import "PeoplesViewController.h"
#import "PDKeychainBindings.h"
#import "TodoListContentCell.h"
#import "ProjectDetailedTodoListsCell.h"
#import "AddEditToodoViewController.h"


@interface DetailedTaskController ()

@end

@implementation DetailedTaskController
static CGFloat addCommentButtonHeight=60;
static CGFloat headerHeight=30;
static CGFloat nameCellHeight=90;
static CGFloat descriptionCellHeight=60;
static CGFloat timeTrackingCellHeight=35;
static CGFloat commentCellHeight=90;

static CGFloat datesCellHeight=45;
static CGFloat descriptionLabelPaddingLeftPlusRight=20;
static CGFloat commentLabelPaddingFromTopAndBottom=70;
static CGFloat taskNameLabelPaddingFromTopAndBottom=50;
static CGFloat taskNameLabelWidth=239;
static CGFloat commentLabelWidth=234;
static CGFloat tagsLabelPadding=25;
static int tagsFontSize=17;


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
    self.isFirstLoad=YES;
    NSLog(@"DetailedTaskController:first Load");
    [self setMenu];
    [self createDataArrays];
   
    NSLog(@"searching for time entery");
   // TimeEntery *t=[[DATAUTILS.selectedCard.toTimeEnteriesRelationship allObjects]firstObject];
 
    NSLog(@"searching for time entery finished");
    // Do any additional setup after loading the view.
  
    self.title=@"Task";
    NSLog(@"selected card comments:%@",DATAUTILS.selectedCard.toCommentsRelationship);
    self.taskTableView.delegate=self;
    self.taskTableView.dataSource=self;
    
    NSLog(@"started with cardId:%@ and projectId:%@",DATAUTILS.selectedCard.cardId,DATAUTILS.selectedProject.projectId);
    

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






- (IBAction)openMenu:(id)sender {
    NSLog(@"open menu");
    [self.pulldownMenu animateDropDown];
    [self openCloseMenu];
    
    
}
-(void)setMenu
{
    
    _isMenuOpened=NO;
    _pulldownMenu = [[PulldownMenu alloc] initWithView:self.view];
    [self.view addSubview:_pulldownMenu];
    _pulldownMenu.topMarginPortrait = -20;
    _pulldownMenu.cellHeight = 25;
    _pulldownMenu.handleHeight =0;
    _pulldownMenu.animationDuration = 0.5f;
    
  //  _pulldownMenu.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 310);
    _pulldownMenu.cellColor = [DATAUTILS taskMenuBackgroundcolor];
    _pulldownMenu.cellTextColor=[UIColor blackColor];
    _pulldownMenu.cellFont=[UIFont systemFontOfSize:13];
    _pulldownMenu.cellSelectedColor=[DATAUTILS taskMenuBackgroundcolor];
    [_pulldownMenu insertButton:@"Edit"];
    [_pulldownMenu insertButton:@"Archive"];
    [_pulldownMenu insertButton:@"Track time"];
    [_pulldownMenu insertButton:@"Add startdate"];
    [_pulldownMenu insertButton:@"Add duedate"];
    
    [_pulldownMenu insertButton:@"Assign users"];
    [_pulldownMenu insertButton:@"Mark task"];
    
    [_pulldownMenu insertButton:@"Tag"];
    
    _pulldownMenu.delegate = self;
    _pulldownMenu.menuList.scrollEnabled=NO;
    _pulldownMenu.menuList.bounces=NO;
    [_pulldownMenu loadMenu];
}

#pragma mark - pulldown menu delegate

-(void)menuItemSelected:(NSIndexPath *)indexPath
{
    NSLog(@"%d",indexPath.item);
    
    [self.pulldownMenu animateDropDown];
    [self openCloseMenu];
    if (indexPath.item==0) {
        [self performSegueWithIdentifier:@"goToAddEditTaskController" sender:self];
        
        
    }
    if (indexPath.item==1) {
        
        [self.navigationController popViewControllerAnimated:YES];
        [self archiveTheCard:DATAUTILS.selectedCard];
        
    }
    
    if (indexPath.item==2) {
        self.selectedTimeEntery=nil;
        [self performSegueWithIdentifier:@"goToTimeTrackingViewController" sender:self];
        
    }
    if (indexPath.item==3) {
        NSLog(@"startDate ViewController");
        self.dueDateViewControllerWorksAsStartDateViewController=YES;
        [self performSegueWithIdentifier:@"goToDueDateViewController" sender:self];
        
    }
    if (indexPath.item==4) {
        NSLog(@"duedate Viewcontroller");
        self.dueDateViewControllerWorksAsStartDateViewController=NO;
        [self performSegueWithIdentifier:@"goToDueDateViewController" sender:self];
        
    }
    
    if (indexPath.item==5) {
        [self performSegueWithIdentifier:@"goToPeoplesViewController" sender:self];
    }
    
    if (indexPath.item==6) {
        [self performSegueWithIdentifier:@"goToMarkTaskVievController" sender:self];
    }
    
    
    if (indexPath.item==7) {
        [self performSegueWithIdentifier:@"goToTagViewController" sender:self];
    }
    
}

-(void)pullDownAnimated:(BOOL)open
{
    if (open)
    {
        NSLog(@"menu opened");
        //_isMenuOpened=YES;
    }
    else
    {
        NSLog(@"menu closed");
        //_isMenuOpened=NO;
        
            }
}

-(void)openCloseMenu
{
    if (_isMenuOpened) {
        NSLog(@"Pull down menu closed!");
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        CGRect tableRect=self.taskTableView.frame;
        
       // tableRect.origin.y=self.taskTableView.frame.origin.y-240;
         tableRect.origin.y=0;
        self.taskTableView.frame=tableRect;
        [UIView commitAnimations];
        _isMenuOpened=NO;

    }
    else
    {
        NSLog(@"Pull down menu open!");
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        CGRect tableRect=self.taskTableView.frame;
        
        //tableRect.origin.y=self.taskTableView.frame.origin.y+240;
        tableRect.origin.y=200;
        self.taskTableView.frame=tableRect;
        [UIView commitAnimations];
        _isMenuOpened=YES;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    //return 1;
    return [self.sectionsArray count];
    
    //NSLog(@"number of sections:%d",[[self.fetchedResultsController sections] count]);
    //return [[self.fetchedResultsController sections] count];
}







-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if ([[self.sectionsArray objectAtIndex:indexPath.section]isEqualToString:@"button"]) {
        AddCommentCell *cell=[tableView dequeueReusableCellWithIdentifier:@"AddCommentCell"];
        cell.backgroundColor=[DATAUTILS backgroundColor];
        [cell.addCommentLabel setTextColor:[DATAUTILS signInButtonColour]];
       // [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    
    else if ([[self.sectionsArray objectAtIndex:indexPath.section]isEqualToString:@"Tags"])
    {
        NSLog(@"add tags cell");
        TagsCell *tagsCell=[tableView dequeueReusableCellWithIdentifier:@"TagsCell"];
       
        
        @synchronized(self.class)
        {
           [tagsCell setWithTagsArray:self.tagsArray];
           [tagsCell.tagsCollection reloadData];
        }
        
        return tagsCell;
    }
    
    else if ([[self.sectionsArray objectAtIndex:indexPath.section]isEqualToString:@"name"])
    {
        TaskNameCell *cell=[tableView dequeueReusableCellWithIdentifier:@"TaskNameCell"];
        [cell.nameLabel setText:DATAUTILS.selectedCard.name];
        User *user=[[DATAUTILS.selectedCard.toUsersRelationship allObjects]firstObject];
        NSLog(@"detailed task controller:user:%@",user);
        NSLog(@"detailed task controller task todo lists:%@",[DATAUTILS.selectedCard.toToDoListsRelationship allObjects]);
        NSString *detailedString=[NSString stringWithFormat:@"Posted by: %@ %@",user.name, [DATAUTILS createPostedByStringFromTimestamp:DATAUTILS.selectedCard.created_at]];
        [cell.descriptionLabel setText:detailedString];
        [cell.descriptionLabel setTextColor:[UIColor lightGrayColor]];
        
        cell.avatarImage.imageURL= [NSURL URLWithString:user.avatar];
        cell.avatarImage.cacheMode=RIDiskCacheMode;
        cell.avatarImage.showActivityIndicator=YES;
        cell.avatarImage.layer.cornerRadius = cell.avatarImage.frame.size.height /2;
        cell.avatarImage.layer.masksToBounds = YES;
        cell.avatarImage.layer.borderWidth = 0;
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
    else if ([[self.sectionsArray objectAtIndex:indexPath.section]isEqualToString:@"description"])
    {
        TaskDescriptionCell *cell =[tableView dequeueReusableCellWithIdentifier:@"TaskDescriptionCell"];
        //cell.taskDescription.frame.size.height=[self countDescriptionLabelHeight];
        CGRect desctiptionRect=cell.taskDescription.frame;
        desctiptionRect.size.height=[self countDescriptionLabelHeight];
        cell.taskDescription.frame=desctiptionRect;
        [cell.taskDescription setText:DATAUTILS.selectedCard.cardDescription];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    
    
    else if ([[self.sectionsArray objectAtIndex:indexPath.section]isEqualToString:@"Time Tracking"])
    {
        TimeTrackingCell *cell=[tableView dequeueReusableCellWithIdentifier:@"TimeTrackingCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        TimeEntery *enteryForRow=[self.timeTrackingArray objectAtIndex:indexPath.row];
        
        [cell.dateLabel setText:[DATAUTILS createTimeEnteryDateFromTimestampString:enteryForRow.logged_date]];
        
        User *timeEnteryUser=[DATAUTILS getUserWithIdFromDatabase:enteryForRow.user_id];
        [cell.usernameLabel setText:timeEnteryUser.name];
       
        NSString *hoursLabelText=[NSString stringWithFormat:@"%d h", [enteryForRow.tracked integerValue]/60 ];
        [cell.hoursLabel setText:hoursLabelText];
        return cell;
    }
    
    else if ([[self.sectionsArray objectAtIndex:indexPath.section]isEqualToString:@"Dates"])
    {
        StartDuedateCell *cell=[tableView dequeueReusableCellWithIdentifier:@"StartDuedateCell"];
        
        NSString *startDateString=[DATAUTILS createDuedateStringFromDate:DATAUTILS.selectedCard.startdate];
        NSString *dueDateString=[DATAUTILS createDuedateStringFromDate:DATAUTILS.selectedCard.duedate];
        
        NSLog(@"start date string:%@",startDateString);
        NSLog(@"duedate string:%@",dueDateString);

        if ([startDateString length]==0) {
            startDateString=@"-";
        }
        if ([dueDateString length]==0) {
            dueDateString=@"-";
        }
        
        [cell.startDateLabel setText:startDateString];
        [cell.dueDateLabel setText:dueDateString];
        
        [cell.startDateLabel setTextColor:[UIColor lightGrayColor]];
        [cell.dueDateLabel setTextColor:[UIColor lightGrayColor]];
        
        cell.startDateLabel.layer.borderColor=[UIColor lightGrayColor].CGColor;
        cell.dueDateLabel.layer.borderColor=[UIColor lightGrayColor].CGColor;
        
        cell.startDateLabel.layer.borderWidth=1.0;
        cell.dueDateLabel.layer.borderWidth=1.0;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
        
    }

    else if ([[self.sectionsArray objectAtIndex:indexPath.section]isEqualToString:@"Discussion"])
    {
        CommentCell *cell=[tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
        Comment *commentForRow=[self.commentsArray objectAtIndex:indexPath.row];
        NSLog(@"Comment for row:is UNsynchronized:%hhd",[commentForRow.isUnSynchronized boolValue]);
        
        //User *user=[DATAUTILS getUserForComment:commentForRow];
        User *user=commentForRow.toUsersRelationship;
        NSLog(@"user for comment for row:%@ user id:%@",user.name,user.userId);
        

        if (user==nil) {
            PDKeychainBindings *bindings=[PDKeychainBindings sharedKeychainBindings];
                     NSString *userName=[bindings objectForKey:@"username"];
                 user=[DATAUTILS getUserFromDatabase:userName];
        }
        
        NSString *detailedString=[NSString stringWithFormat:@"Posted by: %@ %@",user.name, [DATAUTILS createPostedByStringFromTimestamp:commentForRow.created_at]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.avatarImage.imageURL= [NSURL URLWithString:user.avatar];
        cell.avatarImage.cacheMode=RIDiskCacheMode;
        cell.avatarImage.showActivityIndicator=YES;
        cell.avatarImage.layer.cornerRadius = cell.avatarImage.frame.size.height /2;
        cell.avatarImage.layer.masksToBounds = YES;
        cell.avatarImage.layer.borderWidth = 0;
        [cell.commentDetailsLabel setTextColor:[UIColor lightGrayColor]];
        [cell.commentDetailsLabel setText:detailedString];
       // [cell.commentContentUiLabel setText:commentForRow.comment];
        [cell.commentContentLabel setText:commentForRow.comment];
        CGRect commentContentFrame=cell.commentContentLabel.frame;
       commentContentFrame.size.height=[DATAUTILS countHeightforText:commentForRow.comment InRTLABELwithWidth:commentLabelWidth];
       cell.commentContentLabel.frame=commentContentFrame;
        cell.commentContentLabel.backgroundColor=[UIColor clearColor];
        if ([commentForRow.isUnSynchronized boolValue]) {
           
            cell.backgroundColor=[DATAUTILS unsynchronizedCommentsBackgroundColor];
            
        }
        else
        {
            cell.backgroundColor=[DATAUTILS backgroundColor];
        }
        
        
        return cell;
    
    }

    else if ([[self.sectionsArray objectAtIndex:indexPath.section]isEqualToString:@"todo"])
    {
        ProjectDetailedTodoListsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ProjectDetailedTodoListsCell"];
    
        [cell setWithListArray:[DATAUTILS.selectedCard.toToDoListsRelationship allObjects]];
        
        //cell.backgroundColor=[UIColor greenColor];
        cell.delegate=self;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    
    else
    {
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"tempTaskContent"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sectionsArray objectAtIndex:indexPath.section]isEqualToString:@"button"]) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
        NSLog(@"add comment ");
        self.selectedComment=nil;
        [self performSegueWithIdentifier:@"goToAddCommentViewController" sender:self];
       // [self showAddCommentAlert];
    }
    else if ([[self.sectionsArray objectAtIndex:indexPath.section]isEqualToString:@"Discussion"]) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        Comment *commentForRow=[self.commentsArray objectAtIndex:indexPath.row];
        
        if ([commentForRow.isUnSynchronized boolValue]) {
            [DATAUTILS DisplayPopupWithTitle:@"Unsynchronized comment" andMessage:@"Cannot edit unsynchronized comments"];
        }
        
        else
        {
            if ([DATAUTILS checkIfUserIsOwnerOfAComment:commentForRow]) {
                NSLog(@"edit comment ");
                self.selectedComment=[self.commentsArray objectAtIndex:indexPath.row];
                [self performSegueWithIdentifier:@"goToAddCommentViewController" sender:self];

            }
            else
            {
                NSLog(@"selected comment but not an owner");
            }
            
        }
        
        
      
        
    }

    
    else if ([[self.sectionsArray objectAtIndex:indexPath.section]isEqualToString:@"Time Tracking"]) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
        NSLog(@"edit Time Tracking ");
        self.selectedTimeEntery=[self.timeTrackingArray objectAtIndex:indexPath.row];
        
        if ([DATAUTILS checkIfUserIsOwnerOfaTimeEntery:self.selectedTimeEntery]) {
            [self performSegueWithIdentifier:@"goToTimeTrackingViewController" sender:self];
        }
        else
        {
            NSLog(@"selected time entery, but not an owner");
        }
        
  
    }

    
    else
    {
        NSLog(@"other click");
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"DetailedTaskController:tableView willDisplayCell");
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        //end of loading
        //for example [activityIndicator stopAnimating];
        NSLog(@"project page tableview : did finish loading");
        [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(tableDidFinishLoading) userInfo:nil repeats:NO];
    }
    
    else
    {
        self.tableviewDidFinishLoading=NO;
       // self.view.userInteractionEnabled=NO;
        self.navigationItem.leftBarButtonItem.enabled=NO;
        
        self.navigationItem.backBarButtonItem.enabled=NO;
    }
}



-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"DetailedTaskController:tableView didEndDisplayingCell");
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSString *sectionName=[self.sectionsArray objectAtIndex:section];
    
    if (([sectionName isEqualToString:@"name"] && ![DATAUTILS checkIfTaskIsMarked:DATAUTILS.selectedCard])||[sectionName isEqualToString:@"description"] ||[sectionName isEqualToString:@"todo"] ) {
        return 0;
    }
    else
    {
        return headerHeight;
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *sectionName=[self.sectionsArray objectAtIndex:section];
    
    if ([sectionName isEqualToString:@"description"] ) {
        return nil;
    }
    
    else if ([sectionName isEqualToString:@"name"])
    {
        if ([DATAUTILS checkIfTaskIsMarked:DATAUTILS.selectedCard]) {
            return  [DATAUTILS cardStatusHeaderForCard:DATAUTILS.selectedCard];
        }
        else
        {
            return nil;
        }
    }
    
    else if ([sectionName isEqualToString:@"button"])
    {
        UIView *header=[[[NSBundle mainBundle] loadNibNamed:@"ButtonPaddingView" owner:nil options:nil] objectAtIndex:0];
        
        return header;
    }
    
    else
    {
        NSString *sectionName=[self.sectionsArray objectAtIndex:section];
        TaskHeader *header=[[[NSBundle mainBundle] loadNibNamed:@"TaskHeader" owner:nil options:nil] objectAtIndex:0];
        header.backgroundColor=[DATAUTILS backgroundColor];
        [header.headerName setText:sectionName];
        if ([sectionName isEqualToString:@"Time Tracking"]) {
            NSLog(@"need to count times here");
           
            NSLog(@"time tracking for header:%@",DATAUTILS.selectedCard.total_tracked);
            NSString *headerText=[NSString stringWithFormat:@"%d h",[DATAUTILS.selectedCard.total_tracked integerValue]/60];
            [header.headerTime setText:headerText ];
        }
        
        return header;
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
   return [DATAUTILS countNumberofObjectsInDetailedTaskControllerForCard:DATAUTILS.selectedCard andSectionName:[self.sectionsArray objectAtIndex:section] andCommentsArray:self.commentsArray];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.sectionsArray objectAtIndex:indexPath.section]isEqualToString:@"button"]) {
        return addCommentButtonHeight;
    }
    
    
    
    else if ([[self.sectionsArray objectAtIndex:indexPath.section]isEqualToString:@"name"])
    {
        if ([DATAUTILS.selectedCard.name length]>0) {
            NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  [UIFont systemFontOfSize:17], NSFontAttributeName,
                                                  nil];
            
            CGFloat tempHeight=[DATAUTILS countHeightForTextInTaskCellFrameWithWidth:taskNameLabelWidth andText:DATAUTILS.selectedCard.name withAtributes:attributesDictionary]+taskNameLabelPaddingFromTopAndBottom;
            
            if (tempHeight>nameCellHeight) {
                return tempHeight+10;
            }
            else
            {
                return nameCellHeight;
            }
        }
        else
        {
           return nameCellHeight; 
        }
        
        
        
        
    }
    else if ([[self.sectionsArray objectAtIndex:indexPath.section]isEqualToString:@"description"])
    {
        if ([DATAUTILS.selectedCard.cardDescription length]!=0) {
           
            CGFloat height=[self countDescriptionLabelHeight]+10;
            if (height<descriptionCellHeight) {
                return descriptionCellHeight;
            }
            else
            {
                
                
                return height;
            }
            
            
            
      
        }
        else
        {
            return descriptionCellHeight;
       }
        
        
    }
    
    
    else if ([[self.sectionsArray objectAtIndex:indexPath.section]isEqualToString:@"Time Tracking"])
    {
        
        return timeTrackingCellHeight;
    }
    
    else if ([[self.sectionsArray objectAtIndex:indexPath.section]isEqualToString:@"todo"])
    {
        NSLog(@"count todo cell height started");
        CGFloat height=[DATAUTILS countHeigtForTodoCellInTaskControllerWithTodoListsArray:[DATAUTILS.selectedCard.toToDoListsRelationship allObjects]];
        NSLog(@"count todo cell height finished");
        return height;
        //return 100;  // need to count todo cell height here
    }
    
    else if ([[self.sectionsArray objectAtIndex:indexPath.section]isEqualToString:@"Discussion"])
    {
       
//        CGFloat TextHeight=0;
        Comment *commentForRow=[self.commentsArray objectAtIndex:indexPath.row];
//        
//        if ([commentForRow.comment length]>0) {
//            NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
//                                                  [UIFont systemFontOfSize:11], NSFontAttributeName,
//                                                  nil];
//            
//            TextHeight=[DATAUTILS countHeightForTextInTaskCellFrameWithWidth:commentLabelWidth andText:commentForRow.comment withAtributes:attributesDictionary];
//            
//           
//        }
//        
//        if (TextHeight+commentLabelPaddingFromTopAndBottom<commentCellHeight) {
//            return  commentCellHeight;
//        }
//        else
//        {
//          return TextHeight+commentLabelPaddingFromTopAndBottom;  
//        }
        
        
        
        if ([commentForRow.comment length]==0 || [DATAUTILS countHeightforText:commentForRow.comment InRTLABELwithWidth:commentLabelWidth]+commentLabelPaddingFromTopAndBottom <commentCellHeight) {
            return commentCellHeight;
        }
        
        else
        {
             return  [DATAUTILS countHeightforText:commentForRow.comment InRTLABELwithWidth:commentLabelWidth]+commentLabelPaddingFromTopAndBottom;
        }
       
        
    }
    
    else if ([[self.sectionsArray objectAtIndex:indexPath.section]isEqualToString:@"Tags"])
    {
        NSArray *tagsArray=DATAUTILS.selectedCard.tags;
        
        CGFloat contentHeight=[DATAUTILS countHeightForTagsCellWithTags:tagsArray withFontSize:tagsFontSize];
        return contentHeight+tagsLabelPadding;
       // return 200;

        
        
    }
    
    else if ([[self.sectionsArray objectAtIndex:indexPath.section]isEqualToString:@"Dates"])
    {
        return datesCellHeight;
        
    }
    
    else
    {
                return 0;
    }

}
-(void)createDataArrays
{
    NSLog(@"create data arrays");
   
    @synchronized (self)
    {
        self.sectionsArray=[[NSArray alloc]init];
        self.timeTrackingArray=[[NSArray alloc]init];
        self.commentsArray=[[NSArray alloc]init];
        
        self.tagsArray=[[NSMutableArray alloc]init];
        self.tagsArray=[[DATAUTILS.selectedCard.tags allObjects]mutableCopy];
        self.commentsArray=[DATAUTILS createCommentsArrayFromCard:DATAUTILS.selectedCard];
        
        self.sectionsArray=[DATAUTILS createSectionNamesArrayFromCard:DATAUTILS.selectedCard andCommentsArray:self.commentsArray];
        self.timeTrackingArray=[DATAUTILS createTimeEnteriesSortedArrayFromCard:DATAUTILS.selectedCard];
        
        
        NSLog(@"comments array:%@",self.commentsArray);
       // NSLog(@"sections:%@",self.sectionsArray);
    }
    NSLog(@"create data arays finished");
}


-(void)newCommentAdded
{


    NSLog(@"detailed task controller :new comment added");

    
}

-(CGFloat)countDescriptionLabelHeight
{
    NSLog(@"count description label height started");
    if ([DATAUTILS.selectedCard.cardDescription length]>0) {
        CGFloat width=[UIScreen mainScreen].bounds.size.width-descriptionLabelPaddingLeftPlusRight;
        RTLabel *tempLabel=[[RTLabel alloc]initWithFrame:CGRectMake(0, 0, width, 999)];
        [tempLabel setText:DATAUTILS.selectedCard.cardDescription];
        CGFloat retHeight=[tempLabel optimumSize].height;
        NSLog(@"description row height:%f",retHeight);
        NSLog(@"count description label height finished 1");
        return retHeight;
    }
    else
    {
        NSLog(@"count description label height finished 2");
        return descriptionCellHeight;
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"goToAddCommentViewController"])
    {
        AddCommentViewController *destination=segue.destinationViewController;
        destination.delegate=self;
        destination.commentToEdit=self.selectedComment;
    
        
    }
   else if ([segue.identifier isEqualToString:@"goToAddEditTaskController"]) {
        AddEditTaskViewController *destination=segue.destinationViewController;
        destination.isNewTask=NO;
        destination.delegate=self;
       // [self openCloseMenu];
    }
   else if ([segue.identifier isEqualToString:@"goToTimeTrackingViewController"]) {
        TimeTrackingViewController *destination=segue.destinationViewController;
       destination.selectedTimeEntery=self.selectedTimeEntery;
        destination.delegate=self;
    }
    
   else if ([segue.identifier isEqualToString:@"goToDueDateViewController"]) {
        DueDateViewController *destination=segue.destinationViewController;
        destination.worksAsStartDateViewController=self.dueDateViewControllerWorksAsStartDateViewController;
        destination.delegate=self;
    }
    
   else if ([segue.identifier isEqualToString:@"goToTagViewController"]) {
        TagViewController *destination=segue.destinationViewController;
        destination.delegate=self;
    }
   else if ([segue.identifier isEqualToString:@"goToAddEditToodoViewController"]) {
        NSLog(@"do to edit todo");
        AddEditToodoViewController *destination=segue.destinationViewController;
        destination.selectedTodo=self.selectedTodo;
        destination.listId=self.selectedTodoList;
        destination.delegate=self;
        
    }
    
   else if ([segue.identifier isEqualToString:@"goToMarkTaskVievController"]) {
        MarkTaskVievController *destination=segue.destinationViewController;
        destination.delegate=self;
    }
    
    
    else
    {
        NSLog(@"Unrecognized segue identifier:%@",segue.identifier);
    }
}

-(void) taskContentChanged
{
    NSLog(@"detailed task controller task content changed");


}

-(void) tagRemoved:(NSArray *)removedTag
{
    NSLog(@"remove tag");
    
    @synchronized(self)
    {
        NSMutableArray *projectTags=[DATAUTILS.selectedProject.tags mutableCopy];
        
        for (NSString *tag in removedTag) {
            if ([self.tagsArray containsObject:tag]) {
                 [self.tagsArray removeObject:tag];
                //[projectTags removeObject:tag];
            }
            else
            {
                [self.tagsArray addObject:tag];
                
            
            }
        }
        
        
        
        
        DATAUTILS.selectedCard.tags=self.tagsArray;
        DATAUTILS.selectedProject.tags=projectTags;
       
        NSError *error;
        [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext saveToPersistentStore:&error];
        [self createDataArrays];
        [self.taskTableView reloadData];
    }
    
    
}
-(void)editTodo:(Todo *)todo onList:(NSNumber *)list;
{
    self.selectedTodo=todo;
    self.selectedTodoList=list;
    [self performSegueWithIdentifier:@"goToAddEditToodoViewController" sender:self];
    
}

-(void)addNewTodoOnList:(NSNumber *)listId
{
    self.selectedTodo=nil;
    self.selectedTodoList=listId;
    [self performSegueWithIdentifier:@"goToAddEditToodoViewController" sender:self];
}
-(void)viewWillAppear:(BOOL)animated
{
    if (self.tableviewDidFinishLoading && !self.isFirstLoad) {
        NSLog(@"detailed task controler: tableview is ready, can reload");
        [self createDataArrays];
        [self.taskTableView reloadData];
        
    }
    else
    {
        NSLog(@"detailed task controller: tableview not ready, can't reload");
    }
    self.isFirstLoad=NO;
    [DATAUTILS addObserver:self forKeyPath:@"offlineCommentsSyncCounter" options:NSKeyValueObservingOptionNew context:nil];
    NSLog(@"---subviews of detailed task controller---");
    NSLog(@"self view:%@",self.view.layer);
    [DATAUTILS listSubviewsOfView:self.view];
    NSLog(@"---subviews of detailed task controller end---");
    [super viewWillAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"Detailed task controller: view will disapear");
    NSLog(@"---subviews of detailed task controller---");
    NSLog(@"self view:%@",self.view.layer);
    [DATAUTILS listSubviewsOfView:self.view];
    NSLog(@"---subviews of detailed task controller end---");
       [DATAUTILS removeObserver:self forKeyPath:@"offlineCommentsSyncCounter"];
    [super viewWillDisappear:animated];

}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
        NSLog(@"Detailed task controler:RELOAD AFTER SYNC");
        
        [self createDataArrays];
        [self.taskTableView reloadData];

}
-(void)archiveTheCard:(Card *)cardToArchive
{
        __weak __typeof__(self) weakSelf = self;
    NSLog(@"archive the card");
    self.view.userInteractionEnabled=NO;
    NSString *deleteCardPath=[NSString stringWithFormat:@"/projects/%@/cards/%@",DATAUTILS.selectedProject.projectId,DATAUTILS.selectedCard.cardId];
    [[RKObjectManager sharedManager]deleteObject:nil path:deleteCardPath parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"succesfully deleted the card");
        NSLog(@"mapping result:%@",[mappingResult array]);
        NSLog(@"http response:%@",operation.HTTPRequestOperation.responseString);
        NSError *err;
        
        [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext deleteObject:cardToArchive];
        [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext saveToPersistentStore:&err];
        [[RKManagedObjectStore defaultStore].persistentStoreManagedObjectContext deleteObject:cardToArchive];
        [[RKManagedObjectStore defaultStore].persistentStoreManagedObjectContext saveToPersistentStore:&err];
        
       
        if (err) {
            NSLog(@"error while archiving the card:%@",err.description);
        }
        weakSelf.view.userInteractionEnabled=YES;
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        weakSelf.view.userInteractionEnabled=YES;
        NSLog(@"error while deleting the card:%@",error.description);
        NSLog(@"http response:%@",operation.HTTPRequestOperation.responseString);
    }];
    
    
    
   
    
}
-(void)tableDidFinishLoading
{
    NSLog(@"detailed task controller - table did finish loading");
    self.tableviewDidFinishLoading=YES;
    //  self.view.userInteractionEnabled=YES;
    self.navigationItem.leftBarButtonItem.enabled=YES;
    
    self.navigationItem.backBarButtonItem.enabled=YES;

}
-(void)dealloc
{
    NSLog(@"detailed task controller dealloc");
    self.taskTableView.delegate=nil;
    self.taskTableView.dataSource=nil;
}
@end
