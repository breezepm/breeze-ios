//
//  ActivityViewController.m
//  breeze
//
//  Created by Breeze on 05.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import "ActivityViewController.h"
#import "RecentActivityCell.h"
#import "Activity.h"
#import "User.h"
#import "RTLabel.h"
#import "Project.h"

#import "SectionHeader.h"
#import "ProjectCards.h"
#import "Card.h"
#import "ProjectPageViewController.h"
#import "DetailedTaskController.h"

#import "Stage.h"

@interface ActivityViewController ()

@end

@implementation ActivityViewController
static int activityDescriptionLabelWidthIphone=192;
static int activityDescriptionMarginIphone=36;

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
    
    self.isDownloadingMoreRows=NO;
    
    // Do any additional setup after loading the view.
    self.activityTableview.delegate=self;
    self.activityTableview.dataSource=self;
    self.pageviewControllerContentArray=[[NSArray alloc]init];
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self.refreshControl addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];
    [self.activityTableview addSubview:self.refreshControl];
    
    NSLog(@"---subviews of ActivityViewController---");
    NSLog(@"self view:%@",self.view.layer);
    [DATAUTILS listSubviewsOfView:self.view];
    NSLog(@"---subviews of ActivityViewController end---");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)LeftMenu:(id)sender {
    
    NSLog(@"left menu");
    [DATAUTILS downloadUpdates];
    [self presentLeftMenuViewController:self];
}

- (IBAction)rightMenu:(id)sender {
    NSLog(@"fight menu");
    [self presentRightMenuViewController:self];
}

- (NSFetchedResultsController *)fetchedResultsController
{
    
    if (_fetchedResultsController != nil) {
        
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Edit the entity name as appropriate.
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Activity" inManagedObjectContext:[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    
   // [fetchRequest setFetchBatchSize:50];
    
    
    
    // Edit the sort key as appropriate.
    
 
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"created_at" ascending:NO];
   
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    // Edit the section name key path and cache name if appropriate.
    
    // nil for section name key path means "no sections".
    
   NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext sectionNameKeyPath:@"sectionString" cacheName:nil];
    
    
    
    aFetchedResultsController.delegate = self;
    
  
    
    self.fetchedResultsController = aFetchedResultsController;
    
    
    
    
    NSError *error = nil;
    
    if (![self.fetchedResultsController performFetch:&error]) {
        
        // Replace this implementation with code to handle the error appropriately.
        
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        
        abort();
        
    }
    
    
    
    return _fetchedResultsController;
    
}



- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller

{
    if(controller == self.fetchedResultsController){
        [self.activityTableview beginUpdates];
        
    }
    
}



- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo

           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type

{
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            
            [self.activityTableview insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            
            break;
            
            
            
        case NSFetchedResultsChangeDelete:
            
            [self.activityTableview deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            
            break;
            
    }
    
}



- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject

       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type

      newIndexPath:(NSIndexPath *)newIndexPath

{
    
    UITableView *tableView = self.activityTableview;
    
    
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            break;
            
            
            
        case NSFetchedResultsChangeDelete:
            
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            break;
            
            
            
        case NSFetchedResultsChangeUpdate:
            
            [self.activityTableview cellForRowAtIndexPath:indexPath];
            
            break;
            
            
            
        case NSFetchedResultsChangeMove:
            
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            break;
            
    }
    
}



- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller

{
    
    [self.activityTableview endUpdates];
    
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.

    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Activity *activity=[[self.fetchedResultsController fetchedObjects]objectAtIndex:indexPath.row];
    RecentActivityCell *cell=[tableView dequeueReusableCellWithIdentifier:@"RecentActivityCell"];
    User *user=[[activity.toUsersRelationship allObjects]firstObject];
    NSLog(@"activity id for row:%@",activity.activityId);
   // NSData *avatarData=[NSData dataWithContentsOfURL:[NSURL URLWithString:user.avatar]];
    
    NSLog(@"activity user for row:%@",user);
    cell.avatarImage.imageURL= [NSURL URLWithString:user.avatar];
    cell.avatarImage.cacheMode=RIDiskCacheMode;
    cell.avatarImage.showActivityIndicator=YES;
  
    [cell.activityName setText:[DATAUTILS createActivityDescriptionStringFromActivity:activity]];
   // cell.activityName.delegate=self;
    [cell.timeLabel setText:[DATAUTILS getHourFromActivityTimeString:activity.created_at]];
    CGRect cellFrame=cell.frame;
    cellFrame.size=CGSizeMake(activityDescriptionLabelWidthIphone, [cell.activityName optimumSize].height);
    cell.frame=cellFrame;
    cell.avatarImage.layer.cornerRadius = cell.avatarImage.frame.size.height /2;
    cell.avatarImage.layer.masksToBounds = YES;
    cell.avatarImage.layer.borderWidth = 0;
    Project *project=[[activity.toProjectRelationship allObjects]firstObject];
    
//    [cell.ProjectNameLabel setText:project.name];
//    
//    [cell.ProjectNameLabel setTextColor:[DATAUTILS blueColor]];
    
    [cell.goToProjectButton setTitle:project.name forState:UIControlStateNormal];
    [cell.goToProjectButton setTitle:project.name forState:UIControlStateSelected];
    [cell.goToProjectButton setTitle:project.name forState:UIControlStateHighlighted];
    cell.goToProjectButton.tag=indexPath.row;
    [cell.goToProjectButton addTarget:self action:@selector(goToProjectAtIndexPath:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Activity *activity=[[self.fetchedResultsController fetchedObjects]objectAtIndex:indexPath.row];
    return [self countHeightForCellWithActivity:activity];
    
    //return 80;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SectionHeader *headerView=[[[NSBundle mainBundle] loadNibNamed:@"RecentActivityHeader" owner:nil options:nil] objectAtIndex:0];
    headerView.backgroundColor=[DATAUTILS backgroundColor];
    id sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
   // NSLog(@"sectioninfo:%@",sectionActivity);
   // NSString *sectionName=[DATAUTILS getSectionNameFromDate:[sectionInfo name]];
    
    [headerView.headerTitle setText:[DATAUTILS getSectionNameFromDate:[sectionInfo name]]];
    return headerView;

}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepare for seguage from activity view");
    
    [self.activityTableview deselectRowAtIndexPath:[self.activityTableview indexPathForSelectedRow] animated:NO];
    if ([segue.identifier isEqualToString:@"goToProjectPage"]) {
//        
//        NSIndexPath *selectedIndex=[self.activityTableview indexPathForSelectedRow];
//        [self.activityTableview deselectRowAtIndexPath:selectedIndex animated:YES];
        
       ProjectPageViewController *destination=segue.destinationViewController ;
     //  Activity *activity=[[self.fetchedResultsController fetchedObjects]objectAtIndex:selectedIndex.row];
      
      //  destination.selectedProject=selectedProject;
        destination.pageContentsArray=self.pageviewControllerContentArray;
        
    }
    else
    {
        DetailedTaskController *destination=segue.destinationViewController;
        destination.selectedCard=DATAUTILS.selectedCard;
    }
}

-(CGFloat)countHeightForCellWithActivity:(Activity *)act
{
    RTLabel *tempLabel=[[RTLabel alloc]initWithFrame:CGRectMake(0, 0, activityDescriptionLabelWidthIphone, 999)];
    
    [tempLabel setText:[DATAUTILS createActivityDescriptionStringFromActivity:act]];
    //[tempLabel setText:act.message];
    CGFloat textHeight=[tempLabel optimumSize].height;
    return textHeight+activityDescriptionMarginIphone;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"activity selected at row:%ld",(long)indexPath.row);
    self.view.userInteractionEnabled=NO;
    Activity *activity=[[self.fetchedResultsController fetchedObjects]objectAtIndex:indexPath.row];
    NSLog(@"activity card:%@",[activity.toCardRelationship.toUsersRelationship allObjects]);
    NSLog(@"activity project:%@",[[activity.toProjectRelationship allObjects]firstObject]);
    NSLog(@"activity card:%@",DATAUTILS.selectedCard);
    DATAUTILS.selectedProject=[[activity.toProjectRelationship allObjects]firstObject];
    DATAUTILS.selectedCard=activity.toCardRelationship;
    DATAUTILS.selectedCard.projectId=DATAUTILS.selectedProject.projectId;
    DATAUTILS.selectedCard.toUsersRelationship=activity.toUsersRelationship;
    DATAUTILS.selectedCard.stage_id=activity.toStageRelationship.stageId;
   
    self.view.userInteractionEnabled=NO;

    
    
    NSURLRequest *request = [[RKObjectManager sharedManager] requestWithPathForRouteNamed:@"getCommentsForCard" object:DATAUTILS.selectedCard parameters:nil];
    __weak __typeof__(self) weakSelf = self;
    RKManagedObjectRequestOperation *operation = [[RKObjectManager sharedManager] managedObjectRequestOperationWithRequest:request managedObjectContext:[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        
        DATAUTILS.selectedCard.toCommentsRelationship=[mappingResult set];
           [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext saveToPersistentStore:nil];
        [self performSegueWithIdentifier:@"goToDetailedTaskController" sender:self];
     
        
        weakSelf.view.userInteractionEnabled=YES;
        
      
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        weakSelf.view.userInteractionEnabled=YES;
        NSLog(@"Error while downloading comments:%@",error.description);
           [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext saveToPersistentStore:nil];
        [weakSelf performSegueWithIdentifier:@"goToDetailedTaskController" sender:self];
        
    }];
    
    [weakSelf SuProgressForAFHTTPRequestOperation:operation.HTTPRequestOperation];

    [[RKObjectManager sharedManager].operationQueue addOperation:operation];
    
    


    

    
    
    
}
//- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
//{
//	NSLog(@"did select url %@", url);
//}
-(void)refreshAction
{
    NSLog(@"activity view controller refresh action");
    __weak __typeof__(self) weakSelf = self;
    [[RKObjectManager sharedManager] getObjectsAtPathForRouteNamed:@"GetAllActivities" object:nil parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
      
        
        for (Activity *a in mappingResult.array) {
            a.sectionString=[DATAUTILS getActivitySectionDateStringFromDateString:a.created_at];
            
        }
        
        NSError *error;
        [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext saveToPersistentStore:&error];
        
        [weakSelf.refreshControl endRefreshing];
        [weakSelf.activityTableview reloadData];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
        NSLog(@"downloading error:%@",error.description);
        [DATAUTILS DisplayPopupWithTitle:@"Network error" andMessage:@"Please check your network connection and try again"];
        [weakSelf.refreshControl endRefreshing];
        
    }];
    

    
}

-(void)goToProjectAtIndexPath:(id )sender
{
    UIButton *senderButton=sender;
    NSLog(@"go to project from button :%d",senderButton.tag);
    
    self.view.userInteractionEnabled=NO;
    Activity *activity=[[self.fetchedResultsController fetchedObjects]objectAtIndex:senderButton.tag];
    self.selectedActivity=[[self.fetchedResultsController fetchedObjects]objectAtIndex:senderButton.tag];
    Project *selectedProject=[[activity.toProjectRelationship allObjects]firstObject];
    DATAUTILS.selectedProject=selectedProject;
    NSLog(@"selected project:%@",DATAUTILS.selectedProject);
    
 
    NSURLRequest *request = [[RKObjectManager sharedManager] requestWithPathForRouteNamed:@"ProjectCards" object:selectedProject parameters:nil];
        __weak __typeof__(self) weakSelf = self;
    RKManagedObjectRequestOperation *operation = [[RKObjectManager sharedManager] managedObjectRequestOperationWithRequest:request managedObjectContext:[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"mapping result project cards:%@",mappingResult.array);
        //ProjectCards
        
        for (ProjectCards *card in mappingResult.array) {
            card.projectId=selectedProject.projectId;
        }
        
        [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext saveToPersistentStore:nil];
        weakSelf.pageviewControllerContentArray=[DATAUTILS getProjectCardsFromDatabaseForProject:selectedProject];
        weakSelf.view.userInteractionEnabled=YES;
        [weakSelf performSegueWithIdentifier:@"goToProjectPage" sender:self];
       
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        weakSelf.view.userInteractionEnabled=YES;
        [DATAUTILS DisplayPopupWithTitle:@"Network error" andMessage:@"Cannot download data"];
        
    }];
    
    
    [weakSelf SuProgressForAFHTTPRequestOperation:operation.HTTPRequestOperation];

    
    [[RKObjectManager sharedManager].operationQueue addOperation:operation];
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    
    if (!self.isDownloadingMoreRows) {
        
        
        CGPoint offset = aScrollView.contentOffset;
        CGRect bounds = aScrollView.bounds;
        CGSize size = aScrollView.contentSize;
        UIEdgeInsets inset = aScrollView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float h = size.height;
        // NSLog(@"offset: %f", offset.y);
        // NSLog(@"content.height: %f", size.height);
        // NSLog(@"bounds.height: %f", bounds.size.height);
        // NSLog(@"inset.top: %f", inset.top);
        // NSLog(@"inset.bottom: %f", inset.bottom);
        // NSLog(@"pos: %f of %f", y, h);
        
        float reload_distance = 10;
        if(y > h + reload_distance) {
            self.isDownloadingMoreRows=YES;
            NSLog(@"load more rows");
            NSLog(@"actualy loaded page:%ld",(long)[DATAUTILS getNumberOfActivitiesInDatabase]/25);
            long actualyLoadedPage=(long)[DATAUTILS getNumberOfActivitiesInDatabase]/25;
            NSString *nextPage=[NSString stringWithFormat:@"%ld",actualyLoadedPage+1 ];
            NSDictionary *params= [NSDictionary dictionaryWithObject:nextPage forKey:@"page"];
                __weak __typeof__(self) weakSelf = self;
            [[RKObjectManager sharedManager] getObjectsAtPathForRouteNamed:@"GetAllActivities" object:nil parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                
                
                
                for (Activity *a in mappingResult.array) {
                    a.sectionString=[DATAUTILS getActivitySectionDateStringFromDateString:a.created_at];
                    
                }
                
                NSError *error;
                [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext saveToPersistentStore:&error];
                
                weakSelf.isDownloadingMoreRows=NO;
                
                
            } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                
                NSLog(@"downloading error:%@",error.description);
                [DATAUTILS DisplayPopupWithTitle:@"Network error" andMessage:@"Please check your network connection and try again"];
                weakSelf.isDownloadingMoreRows=NO;
                
            }];
        }
    }
    else
    {
        NSLog(@"currently downloading rows");
    }
}
-(void)dealloc
{
    self.activityTableview.delegate=nil;
    self.activityTableview.dataSource=nil;
}
@end
