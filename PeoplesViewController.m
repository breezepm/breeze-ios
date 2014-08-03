//
//  PeoplesViewController.m
//  breeze
//
//  Created by Breeze on 28.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import "PeoplesViewController.h"
#import "DataUtils.h"
#import "Project.h"
#import "User.h"
#import "AssignUsersCell.h"

@interface PeoplesViewController ()

@end

@implementation PeoplesViewController
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
    

    self.peoplesTable.delegate=self;
    self.peoplesTable.dataSource=self;
    self.peoplesTable.backgroundColor=[DATAUTILS backgroundColor];
    self.view.backgroundColor=[DATAUTILS backgroundColor];
    
   // NSLog(@"users assigned to project:%@",DATAUTILS.selectedProject)
    NSLog(@"subviews of peoples viewcontroller");
    [DATAUTILS listSubviewsOfView:self.view];
    NSLog(@"subviews of peoples viewcontroller end");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSFetchedResultsController *)fetchedResultsController
{
    
    if (_fetchedResultsController != nil) {
        
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Edit the entity name as appropriate.
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    
    // [fetchRequest setFetchBatchSize:50];
    
    
    
    // Edit the sort key as appropriate.
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    
    NSString * predicateString=[NSString stringWithFormat:@"toProjectRelationship.projectId == %@",DATAUTILS.selectedProject.projectId ];
    NSLog(@"predicate string:%@",predicateString);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
    [fetchRequest setPredicate:predicate];
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
        [self.peoplesTable beginUpdates];
        
    }
    
}



- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo

           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type

{
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            
            [self.peoplesTable insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            
            break;
            
            
            
        case NSFetchedResultsChangeDelete:
            
            [self.peoplesTable deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            
            break;
            
    }
    
}



- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject

       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type

      newIndexPath:(NSIndexPath *)newIndexPath

{
    
    UITableView *tableView = self.peoplesTable;
    
    
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            break;
            
            
            
        case NSFetchedResultsChangeDelete:
            
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            break;
            
            
            
        case NSFetchedResultsChangeUpdate:
            
            [self.peoplesTable cellForRowAtIndexPath:indexPath];
            
            break;
            
            
            
        case NSFetchedResultsChangeMove:
            
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            break;
            
    }
    
}



- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller

{
    
    [self.peoplesTable endUpdates];
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    User *userForRow=[[self.fetchedResultsController fetchedObjects]objectAtIndex:indexPath.row];
    NSLog(@"user for row project id:%@",userForRow.projectId);
    AssignUsersCell *cell=[tableView dequeueReusableCellWithIdentifier:@"AssignUsersCell"];
    [cell.usernameLabel setText:userForRow.name];
    NSLog(@"avatar for row:%@",userForRow.avatar);
    User *userWithImage=[DATAUTILS getUserFromDatabase:userForRow.email];
    
    cell.avatar.imageURL= [NSURL URLWithString:userWithImage.avatar];
    cell.avatar.cacheMode=RIDiskCacheMode;
    cell.avatar.showActivityIndicator=YES;
    
    cell.avatar.layer.cornerRadius = cell.avatar.frame.size.height /2;
    cell.avatar.layer.masksToBounds = YES;
    cell.avatar.layer.borderWidth = 0;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    BOOL assigned=[self checkIfUserIsAssignedToCard:userForRow.email];
    
    if (assigned) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AssignUsersCell *cell=(AssignUsersCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType==UITableViewCellAccessoryCheckmark) {
        cell.accessoryType=UITableViewCellAccessoryNone;
        User *selected=[[self.fetchedResultsController fetchedObjects]objectAtIndex:indexPath.row];
        User *selectedUser=[DATAUTILS getUserFromDatabase:selected.email];
            __weak __typeof__(self) weakSelf = self;
        
        NSString *path=[NSString stringWithFormat:@"/projects/%@/cards/%@/people/%@.json",DATAUTILS.selectedProject.projectId,DATAUTILS.selectedCard.cardId,selectedUser.userId ];
        
        [[RKObjectManager sharedManager]deleteObject:nil path:path parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            NSLog(@"succesfully deleted user");
            NSLog(@"operation response:%@",operation.HTTPRequestOperation.responseString);
            NSLog(@"mapping result:%@",mappingResult.array);
            
            NSMutableSet *tempSet=[DATAUTILS.selectedCard.toAssignedUsersRelationship mutableCopy];
            
            for (User *u in tempSet) {
                if ([u.email isEqualToString:selected.email]) {
                    //[tempSet removeObject:selected];
                    [DATAUTILS.selectedCard removeToAssignedUsersRelationshipObject:u];
                }
            }
           // DATAUTILS.selectedCard.toAssignedUsersRelationship=tempSet;
            [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext saveToPersistentStore:nil];
            
           
            [weakSelf recheckAssignedOnCells];
           
           // [self.peoplesTable reloadData];
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"error while deleting users:%@",error.description);
            [DATAUTILS DisplayPopupWithTitle:@"Network error" andMessage:@"Errir while deleting user"];
        }];
    }
    else
        
    {
            __weak __typeof__(self) weakSelf = self;
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
        User *selectedUser=[[self.fetchedResultsController fetchedObjects]objectAtIndex:indexPath.row];
        NSString *path=[NSString stringWithFormat:@"/projects/%@/cards/%@/people.json",DATAUTILS.selectedProject.projectId,DATAUTILS.selectedCard.cardId];
        NSDictionary *params=[NSDictionary dictionaryWithObject:[NSArray arrayWithObject:selectedUser.email] forKey:@"invitees"];
        NSLog(@"path:%@",path);
        NSLog(@"params:%@",params);
        DATAUTILS.selectedCard.projectId=DATAUTILS.selectedProject.projectId;
        [[RKObjectManager sharedManager]postObject:nil path:path parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            NSLog(@"succesfully assigned ussers:%@",mappingResult.array);
            
            DATAUTILS.selectedCard.toAssignedUsersRelationship=[mappingResult set];
           // [DATAUTILS.selectedCard addToAssignedUsersRelationship:[mappingResult set]];
            [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext saveToPersistentStore:nil];
            
            [weakSelf recheckAssignedOnCells];
            
           // [self.peoplesTable reloadData];
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"error while assigning users:%@",operation.HTTPRequestOperation.responseString);
            
        }];
    }
    

}

-(void)recheckAssignedOnCells
{
    for (UITableViewCell *checkCell in [self.peoplesTable visibleCells]) {
      NSIndexPath *indexpath=  [self.peoplesTable indexPathForCell:checkCell];
        User *userForRow=[[self.fetchedResultsController fetchedObjects]objectAtIndex:indexpath.row];
        if ([self checkIfUserIsAssignedToCard:userForRow.email]) {
             checkCell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
             checkCell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    }
}

-(BOOL)checkIfUserIsAssignedToCard:(NSString *)email
{
   // BOOL assigned=NO;
    for (User *u in [DATAUTILS.selectedCard.toAssignedUsersRelationship allObjects]) {
        if ([u.email isEqualToString:email]) {
          //  assigned=YES;
            NSLog(@"assigned");
            return YES;
        }
    }
    return NO;
}
-(void)dealloc
{
    NSLog(@"peoples view controller dealloc");
    self.peoplesTable.dataSource=nil;
    self.peoplesTable.delegate=nil;
}
@end
