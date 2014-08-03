//
//  ProjectsViewController.m
//  breeze
//
//  Created by Breeze on 06.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import "ProjectsViewController.h"
#import "Project.h"
#import "ProjectsCell.h"

#import "ProjectCards.h"
#import "DataUtils.h"
#import "ProjectPageViewController.h"
#import "ProjectsCellNotStar.h"
#import "SuProgress.h"

@interface ProjectsViewController ()

@end

@implementation ProjectsViewController


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
    
       self.projectsViewTappCounterl=0;
  
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];
    [self.projectsTableview addSubview:self.refreshControl];
    
//    UIRefreshControl *refreshControl = [UIRefreshControl new];
//    
//    [refreshControl addTarget:self action:@selector(loadProjects) forControlEvents:UIControlEventValueChanged];
//    
//    self.projectsTableview.refreshControl = refreshControl;
    // Do any additional setup after loading the view.
    
    self.pageviewControllerContentArray=[[NSArray alloc]init];
    
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/projects.json" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"downloaded");
//        for (Project *p in mappingResult.array) {
//            [[RKObjectManager sharedManager]getObjectsAtPathForRouteNamed:@"people" object:p parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//                NSLog(@"downloaded peoples");
//            } failure:^(RKObjectRequestOperation *operation, NSError *error) {
//                NSLog(@"cant download peoples");
//            }];
//        }
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
        NSLog(@"downloading error");
    }];
    
    
    self.projectsTableview.delegate=self;
    self.projectsTableview.dataSource=self;
    
    NSLog(@"---subviews of ProjectsViewController---");
    NSLog(@"self view:%@",self.view.layer);
    [DATAUTILS listSubviewsOfView:self.view];
    NSLog(@"---subviews of ProjectsViewController end---");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)leftMenu:(id)sender {
    [self presentLeftMenuViewController:self];
   // [DATAUTILS downloadUpdates];
}

- (NSFetchedResultsController *)fetchedResultsController
{
    
    if (_fetchedResultsController != nil) {
        
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Edit the entity name as appropriate.
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Project" inManagedObjectContext:[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    
    [fetchRequest setFetchBatchSize:20];
    
    
    
    // Edit the sort key as appropriate.
    
    
    NSSortDescriptor *starSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"star" ascending:NO];
    NSSortDescriptor *alphabeticalyDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = @[starSortDescriptor,alphabeticalyDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    // Edit the section name key path and cache name if appropriate.
    
    // nil for section name key path means "no sections".
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    
    
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
        self.view.userInteractionEnabled=NO;
        [self.projectsTableview beginUpdates];
        
    }
    
}



- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo

           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type

{
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            
            [self.projectsTableview insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            
            break;
            
            
            
        case NSFetchedResultsChangeDelete:
            
            [self.projectsTableview deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            
            break;
            
    }
    
}



- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject

       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type

      newIndexPath:(NSIndexPath *)newIndexPath

{
    
    UITableView *tableView = self.projectsTableview;
    
    
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            break;
            
            
            
        case NSFetchedResultsChangeDelete:
            
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            break;
            
            
            
        case NSFetchedResultsChangeUpdate:
            
            [self.projectsTableview cellForRowAtIndexPath:indexPath];
            
            break;
            
            
            
        case NSFetchedResultsChangeMove:
            
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            break;
            
    }
    
}



- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller

{
    
    [self.projectsTableview endUpdates];
    
    self.view.userInteractionEnabled=YES;
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
    Project *project=[[self.fetchedResultsController fetchedObjects]objectAtIndex:indexPath.row];
  
     if ([project.star boolValue])
     {
    
    ProjectsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ProjectsCell"];

    
    [cell.projectNameLabel setText:project.name];
    NSLog(@"project star:%@",project.star);
    
    [cell.starImageView setHidden:NO];
    [cell.starImageView setImage:[UIImage imageNamed:@"star"]];
    return cell;
     }
    else
    {
        ProjectsCellNotStar *cell=[tableView dequeueReusableCellWithIdentifier:@"ProjectsCellNotStar"];
        [cell.projectNameLabel setText:project.name];
        return cell;
        
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.projectsViewTappCounterl++;
    NSLog(@"projects view tapp counter%d",self.projectsViewTappCounterl);
    self.view.userInteractionEnabled=NO;
    //Project *project=[[self.fetchedResultsController fetchedObjects]objectAtIndex:indexPath.row];
    NSLog(@"projects view project selected");
     Project *selectedProject=[[self.fetchedResultsController fetchedObjects]objectAtIndex:indexPath.row];
    DATAUTILS.selectedProject=selectedProject;
    NSLog(@"projects page selected project:%@",DATAUTILS.selectedProject.name);

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
                    // [self.progressView setHidden:YES];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        weakSelf.view.userInteractionEnabled=YES;
        [DATAUTILS DisplayPopupWithTitle:@"Network error" andMessage:@"Cannot download data"];
   
    }];
    
     //[tableView deselectRowAtIndexPath:indexPath animated:NO];
    [weakSelf SuProgressForAFHTTPRequestOperation:operation.HTTPRequestOperation];

    
    [[RKObjectManager sharedManager].operationQueue addOperation:operation];
    
    
    
    

    
    
 
    
    
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   
    NSIndexPath *selectedIndex= [[self.projectsTableview indexPathsForSelectedRows]firstObject];
    [self.projectsTableview deselectRowAtIndexPath:selectedIndex animated:NO];
    ProjectPageViewController *destination=segue.destinationViewController;
   destination.pageContentsArray=self.pageviewControllerContentArray;
   // destination.selectedProject=[[self.fetchedResultsController fetchedObjects]objectAtIndex:selectedIndex.row];
//
     //destination.pagesArray=self.pageviewControllerContentArray ;
//        destination.selectedProject=[[self.fetchedResultsController fetchedObjects]objectAtIndex:selectedIndex.row];
}

-(void)refreshAction
{
    NSLog(@"Projects view controller refresh action");
        __weak __typeof__(self) weakSelf = self;
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/projects.json" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"downloaded");
    
        [weakSelf.refreshControl endRefreshing];
        [weakSelf.projectsTableview reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
        NSLog(@"downloading error");
        [DATAUTILS DisplayPopupWithTitle:@"Network error" andMessage:@"Please check your network connection and try again"];
        [weakSelf.refreshControl endRefreshing];
    }];

}
-(void)dealloc
{
    NSLog(@"projects view dealloc");
    self.projectsTableview.delegate=nil;
    self.projectsTableview.dataSource=nil;
}
@end
