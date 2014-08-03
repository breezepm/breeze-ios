//
//  ProjectPageView.m
//  breeze
//
//  Created by Breeze on 13.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import "ProjectPageView.h"
#import "ProjectPageViewCell.h"
#import "ProjectDetailedHeader.h"
#import "DataUtils.h"
#import <QuartzCore/QuartzCore.h>
#import "RemoteImageView.h"
#import "User.h"
#import "colorWithHex.h"
#import "PeoplesAvatasView.h"
#include "ProjectPageViewPlaceholderCell.h"


@implementation ProjectPageView
static bool isPlaceholderFunctionalityEnabled=YES;


static CGFloat rowMarginTopAndBottom=60;

static CGFloat rowMarginLeftRight=20;
static int tagsCellfontSize=10;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)setWithCard
{
    NSLog(@"Project page view - set with card started");
    self.tableview.autoScrollMaxVelocity=5;
    self.tableview.autoScrollVelocity=5;
    
    DATAUTILS.dragEndedWithADrop=YES;
    self.tableview.bounces=YES;
   
    self.cellsCache=[[NSCache alloc]init];
    self.placeholderCellNib=[UINib nibWithNibName:@"ProjectPageViewPlaceholderCell" bundle:nil];
    self.cellNib=[UINib nibWithNibName:@"ProjectPageViewCell" bundle:nil];
    [self.tableview registerNib:self.cellNib forCellReuseIdentifier:@"ProjectPageViewCell"];
    [self.tableview registerNib:self.placeholderCellNib forCellReuseIdentifier:@"ProjectPageViewPlaceholderCell"];
    self.shouldLoadPlaceholder=NO;
   
    //self.itemsArray=[[NSArray alloc]init];
    self.backgroundColor=[DATAUTILS backgroundColor];
    self.tableview.backgroundColor=[DATAUTILS backgroundColor];
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];
    [self.tableview addSubview:self.refreshControl];
     NSLog(@"Project page view - set with card finished");
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

        NSLog(@"ProjectPageView - cellForRowAtIndexPath started (row:%d) placeholder:%hhd",indexPath.row,self.shouldLoadPlaceholder);
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][0];
    NSInteger numberOfObjects=[sectionInfo numberOfObjects];

    
    if ((!self.shouldLoadPlaceholder ||indexPath.row !=self.PlaceholderIndexpath.row) && indexPath.row<numberOfObjects+self.shouldLoadPlaceholder) {
        if (indexPath.row>self.PlaceholderIndexpath.row) {
            NSDate *cellforRowStartTime=[NSDate date];
            NSIndexPath *newIndexPath=[NSIndexPath indexPathForRow:indexPath.row-self.shouldLoadPlaceholder inSection:indexPath.section];
            ProjectPageViewCell *cell=[self createTableviewCellForIndexPath:newIndexPath];
            NSLog(@"Test:tableview cell creation time:%f",[cellforRowStartTime timeIntervalSinceNow]);
            return  cell;

        }
        else
        {
           
            NSDate *cellforRowStartTime=[NSDate date];
         
            ProjectPageViewCell *cell=[self createTableviewCellForIndexPath:indexPath];
            NSLog(@"Test:tableview cell creation time:%f",[cellforRowStartTime timeIntervalSinceNow]);
            return  cell;
        }
        
        
        

    }
    
    
    else
    {
        NSLog(@"placeholder card here (%d)",indexPath.row);
        
        ProjectPageViewPlaceholderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProjectPageViewPlaceholderCell"];
        if (cell == nil) {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ProjectPageViewPlaceholderCell" owner:self options:nil];
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
        }

//        
//        [cell.placeholderImageView setImage:DATAUTILS.placeholderImage];
//        [cell.placeholderImageView setHidden:NO];
//        [cell.placeholderImageView setAlpha:0.3];
        if (indexPath.row>numberOfObjects+self.shouldLoadPlaceholder) {
            cell.backgroundColor=[DATAUTILS backgroundColor];
            cell.placeholderImageView.backgroundColor=[DATAUTILS backgroundColor];
        }
        return  cell;
    }
    
 
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Card *c=[[self.fetchedResultsController fetchedObjects]objectAtIndex:indexPath.row];
    if ([c.isUnsynchronized boolValue]) {
        NSLog(@"selected unsynchronized card");
        [DATAUTILS DisplayPopupWithTitle:@"Synchronization" andMessage:@"This card is unsynchronized"];
    }
    
    else
    {
        NSLog(@"selected row:%ld",(long)indexPath.row);
        DATAUTILS.selectedCard=[[self.fetchedResultsController fetchedObjects]objectAtIndex:indexPath.row];
        DATAUTILS.selectedCard.projectId=DATAUTILS.selectedProject.projectId;
        if([self.delegate respondsToSelector:@selector(projectTable:didSelectCard:)])
        {
            Card *selectedCard=[[self.fetchedResultsController fetchedObjects]objectAtIndex:indexPath.row];
            selectedCard.projectId=DATAUTILS.selectedProject.projectId;
            
            [self.delegate projectTable:tableView didSelectCard:selectedCard];
        }
        

    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    NSLog(@"Project page view - heightForRowAtIndexPath started (row:%d) placeholder:%hhd",indexPath.row,self.shouldLoadPlaceholder );
    
    
    

    if (self.tableview.isTableviewDragged && self.shouldLoadPlaceholder) {
        if ([DATAUTILS.lastPlaceholderList integerValue]==[self.cardToDisplay.cardsId integerValue]) {
            NSLog(@"placeholder didn't end the list");
            if (self.PlaceholderIndexpath.row==indexPath.row) {
                  return  DATAUTILS.placeholderImage.size.height;
            }
            else if (indexPath.row>self.PlaceholderIndexpath.row && indexPath.row>0)
            {
                NSIndexPath *newIndexPath=[NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
                 return [self countHeightForRowForNotPlaceholderCardAtIndexpath:newIndexPath];
            }
            else
            {
                 return [self countHeightForRowForNotPlaceholderCardAtIndexpath:indexPath];
            }
        }
        else
        {
            NSLog(@"placeholder on new list");
            if (indexPath.row==0) {
                return  DATAUTILS.placeholderImage.size.height;
            }
            else
            {
                NSIndexPath *newIndexPath=[NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
                return [self countHeightForRowForNotPlaceholderCardAtIndexpath:newIndexPath];
            }
        }
    }
    else
    {
        return [self countHeightForRowForNotPlaceholderCardAtIndexpath:indexPath];
    }
    

   
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[ProjectPageViewCell class]]) {
        ProjectPageViewCell *prCell=(ProjectPageViewCell *)cell;
        NSLog(@"Project page:tableView dwillDisplayCell %@",prCell.contentName.text);
    }
    
    
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(tableDidFinishLoading) userInfo:nil repeats:NO];
    }
    else
    {
        NSLog(@"tableview did not finish loading");
        self.tableviewDidFinishLoading=NO;
        if ([self.delegate respondsToSelector:@selector(projectTableIsLoading)]) {
            [self.delegate projectTableIsLoading];
        }
    }

    
}
-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[ProjectPageViewCell class]]) {
        ProjectPageViewCell *prCell=(ProjectPageViewCell *)cell;
        NSLog(@"Project page:tableView didEndDisplayingCell %@",prCell.contentName.text);

    }
    
}


- (BOOL)shouldDragStart:(AtkDragAndDropManager *)manager
{
    // Yes, consider me for drags. Returning true here only
    // ensures that isInterested, dragStarted, and dragEnded will
    // be called.
    return YES;
}

- (BOOL)isInterested:(AtkDragAndDropManager *)manager
{
    // If we return true here then dragEntered, dragExited, dragMoved and
    // dragDropped can be called.
    // So, let's see if we are interested in what's on the pasteboard.
    // For the example this is if the pastbaord string matches
    // a string made up from the views tag property.
    
    BOOL ret = NO;
    UIPasteboard *pastebaord = manager.pasteboard;
    NSString *interestedInString =
    [NSString stringWithFormat:@"val-%ld", (long)self.tag];
    if([interestedInString isEqualToString:pastebaord.string])
        ret = YES;
    
    return ret;
}
-(void)dragStarted:(AtkDragAndDropManager *)manager
{

    NSIndexPath *dragedCellIndexPath=[self.tableview indexPathForCell:DATAUTILS.dragedCell];
    NSLog(@"project pageview : drag started (%d,%d)",dragedCellIndexPath.section,dragedCellIndexPath.row);
    DATAUTILS.dragedCard.shouldBeHidden=[[NSNumber alloc]initWithInt:1];
    [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext saveToPersistentStore:nil];
    DATAUTILS.dragEndedWithADrop=NO;

    self.tableview.isTableviewDragged=YES;
    self.tableview.bounces=NO;
    
    
    [self.tableview autoScrollDragStarted];
}
-(void)dragEnded:(AtkDragAndDropManager *)manager
{
    NSLog(@"project page view: drag ended");
    
    if (self.PlaceholderIndexpath) {

    }
    //IF DRAG ENDED WITHOUT A DROP WE SHOULD UNHIDE THE CARD 
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(checkIfDragWasDropped) userInfo:nil repeats:NO];
    


    
    self.tableview.isTableviewDragged=NO;

    [self.tableview autoScrollDragEnded];
    self.tableview.bounces=YES;

  }

-(void)dragEntered:(AtkDragAndDropManager *)manager point:(CGPoint)point
{
    
    NSLog(@"drag entered new page");
   
    [self scrollTableviewToTop];
    DATAUTILS.lastPlaceholderList=self.cardToDisplay.cardsId;
}
-(void)dragDropped:(AtkDragAndDropManager *)manager point:(CGPoint)point
{
    
        NSLog(@"project page: drag dropped");
    DATAUTILS.dragEndedWithADrop=YES;

    
    
    NSLog(@"paste:%@",manager.pasteboard.string);
    CGPoint convertedPoint=[manager.rootView convertPoint:point toView:self.tableview];
     NSIndexPath *index=[self.tableview indexPathForRowAtPoint:convertedPoint];
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][0];
    NSInteger numberOfObjects=[sectionInfo numberOfObjects];
    NSLog(@"number of objects:%ld",(long)numberOfObjects);
    NSLog(@"dropped on row:%ld",(long)index.row);
    NSLog(@"placeholder:%hhd",self.shouldLoadPlaceholder);
    if (numberOfObjects==0) {
        NSLog(@"droped on empty list");

        [DATAUTILS MoveCardWithId:[DATAUTILS.dragedCard.cardId stringValue] ProjectId:[DATAUTILS.selectedProject.projectId stringValue] stage_id:[self.cardToDisplay.cardsId stringValue] prev_id:@"0" completion:^(BOOL success, NSString *result) {
            if (success) {
                NSLog(@"card moved succesfully");
                NSLog(@"result:%@",result);
                
                
     
  
                
            }
            else
            {
                NSLog(@"moving card error");
                NSLog(@"result:%@",result);
          
                [DATAUTILS DisplayPopupWithTitle:@"Network error" andMessage:@"Can't move the task, please try again later"];
            }
        }];

        
    }
    else if ((index==NULL || index.row>=numberOfObjects )&& numberOfObjects!=0 )
    {
        
        NSLog(@"dropped on not empty tableview, not on a row");

        Card *cardForRow=[[self.fetchedResultsController fetchedObjects]lastObject];
        NSLog(@"DROPPED ON CARD:%@",cardForRow.name);
        [DATAUTILS MoveCardWithId:[DATAUTILS.dragedCard.cardId stringValue] ProjectId:[DATAUTILS.selectedProject.projectId stringValue] stage_id:[self.cardToDisplay.cardsId stringValue] prev_id:[cardForRow.cardId stringValue] completion:^(BOOL success, NSString *result) {
            if (success) {
                NSLog(@"card moved succesfully");
                NSLog(@"result:%@",result);
            
               
            }
            else
            {
                NSLog(@"moving card error");
                NSLog(@"result:%@",result);
              
                [DATAUTILS DisplayPopupWithTitle:@"Network error" andMessage:@"Can't move the task, please try again later"];
            }
        }];

    }
    else
    {
        NSLog(@"dropped on cell (%ld)",(long)index.row);
        if (index.row>0) {

            Card *cardForRow=[[self.fetchedResultsController fetchedObjects]objectAtIndex:index.row-1];
            NSLog(@"DROP: PREVIOUS CARD:%@ id:%@",cardForRow.name,cardForRow.cardId);

            

            [DATAUTILS MoveCardWithId:[DATAUTILS.dragedCard.cardId stringValue] ProjectId:[DATAUTILS.selectedProject.projectId stringValue] stage_id:[self.cardToDisplay.cardsId stringValue] prev_id:[cardForRow.cardId stringValue] completion:^(BOOL success, NSString *result) {
                if (success) {
                    NSLog(@"card moved succesfully");
                    NSLog(@"result:%@",result);
                    
               
                    
                }
                else
                {
                    NSLog(@"moving card error");
                    NSLog(@"result:%@",result);
             
                    [DATAUTILS DisplayPopupWithTitle:@"Network error" andMessage:@"Can't move the task, please try again later"];
                }
            }];
            

        }
        else
        {
            
     
            
            [DATAUTILS MoveCardWithId:[DATAUTILS.dragedCard.cardId stringValue] ProjectId:[DATAUTILS.selectedProject.projectId stringValue] stage_id:[self.cardToDisplay.cardsId stringValue] prev_id:@"0" completion:^(BOOL success, NSString *result) {
                if (success) {
                    NSLog(@"card moved succesfully");
                    NSLog(@"result:%@",result);
                    
          
                }
                else
                {
                    NSLog(@"moving card error");
                    NSLog(@"result:%@",result);
                   
                    [DATAUTILS DisplayPopupWithTitle:@"Network error" andMessage:@"Can't move the task, please try again later"];
                }
            }];
        }
        
        
    
    }
    NSLog(@"indexpath for drop:%@",index);
    
    NSLog(@"tableview drag droped");
    NSLog(@"droped on point:(%f,%f) and Card:%@",point.x,point.y,self.cardToDisplay.name);
    
   
    
    
}



#pragma mark - NSFetchResultController

- (NSFetchedResultsController *)fetchedResultsController
{
    
    if (_fetchedResultsController != nil) {
        
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Edit the entity name as appropriate.
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Card" inManagedObjectContext:[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext];
    NSLog(@"set predicate with cardsid:%@ ",self.cardToDisplay.cardsId);
    NSString * predicateString=[NSString stringWithFormat:@"stage_id == %@",self.cardToDisplay.cardsId ];
    NSString *predicateString2=[NSString stringWithFormat:@"shouldBeHidden == nil OR shouldBeHidden == 0"];
    NSPredicate *predicate2=[NSPredicate predicateWithFormat:predicateString2];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
    NSArray *predicatesArray=[NSArray arrayWithObjects:predicate,predicate2, nil];
    NSPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicatesArray];
    [fetchRequest setPredicate:compoundPredicate];

    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    
    //[fetchRequest setFetchBatchSize:50];
    
    
    
    // Edit the sort key as appropriate.
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"position" ascending:YES];
  //  NSSortDescriptor *placeHolderSortDescriptor=[[NSSortDescriptor alloc] initWithKey:@"isPlaceholderCard" ascending:YES];
    
    NSArray *sortDescriptors = @[sortDescriptor];
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
    self.userInteractionEnabled=NO;
    self.shouldLoadPlaceholder=NO;
    if(controller == self.fetchedResultsController){
       [self removePlaceholder];
        
        if (!self.tableview.isTableviewDragged) {
            [self.cellsCache removeAllObjects];
        }
        
        [self.tableview beginUpdates];
        
    }
    
}



- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo

           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type

{
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            NSLog(@"sesion change insert");
            [self.tableview insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationNone];
            
            break;
            
            
            
        case NSFetchedResultsChangeDelete:
            NSLog(@"sesion change delete");
            [self.tableview deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationNone];
            
            break;
            
        default: NSLog(@"unknown sesion change");
            break;
    }
    
}



- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject

       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type

      newIndexPath:(NSIndexPath *)newIndexPath

{
    
    NSLog(@"controller did chcange object at row:%ld to row:%ld",(long)indexPath.row,(long)newIndexPath.row);
    
    UITableView *tableView = self.tableview;
    
    
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            NSLog(@"insert");
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            break;
            
            
            
        case NSFetchedResultsChangeDelete:
            NSLog(@"delete");
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            break;
            
            
            
        case NSFetchedResultsChangeUpdate:
            NSLog(@"update");
            [self.tableview cellForRowAtIndexPath:indexPath];
            
            break;
            
            
            
        case NSFetchedResultsChangeMove:
            NSLog(@"move");
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            break;
            
            
        default: NSLog(@"unknown object change");
            break;
    }
    
}



- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller

{
    
    [self.tableview endUpdates];
    
    self.userInteractionEnabled=YES;
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    //return 1;
    
    NSLog(@"number of sections:%d",[[self.fetchedResultsController sections] count]);
   return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    
    NSLog(@"number of objects in table:%lu named:%@",(unsigned long)[sectionInfo numberOfObjects],self.cardToDisplay.name);
    NSInteger numberOfObjects=[sectionInfo numberOfObjects];
    return numberOfObjects+self.shouldLoadPlaceholder;
    
    
}

-(void)refreshAction
{
    NSLog(@"task view - refresh action");
        __weak __typeof__(self) weakSelf = self;
    [[RKObjectManager sharedManager] getObjectsAtPathForRouteNamed:@"ProjectCards" object:DATAUTILS.selectedProject parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        NSLog(@"mapping result project cards:%@",mappingResult.array);
        //ProjectCards
        
        for (ProjectCards *card in mappingResult.array) {
            card.projectId=DATAUTILS.selectedProject.projectId;
        }
        
        [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext saveToPersistentStore:nil];

        [weakSelf.refreshControl endRefreshing];
        
        [weakSelf.tableview reloadData];
        
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [weakSelf.refreshControl endRefreshing];
        [DATAUTILS DisplayPopupWithTitle:@"Network error" andMessage:@"Please check your network connection and try again"];
        NSLog(@"downloading error:%@",error.description);
        
        
    }];

}
-(void)dragExited:(AtkDragAndDropManager *)manager point:(CGPoint)point
{
    NSLog(@"Project page view: drag exited from view (%@)",self.cardToDisplay.name);
     [self removePlaceholder];
    
}



-(void)dragMoved:(AtkDragAndDropManager *)manager point:(CGPoint)point
{
   
@synchronized(self.class)
    {
        //test
        

        self.tableview.bounces=NO;
        if (isPlaceholderFunctionalityEnabled && !self.tableview.isUpdating) {
            if (!self.tableview.isPlaceholerAddingLocked) {
                NSLog(@"project page view - drag moved");
                CGPoint convertedPoint=[manager.rootView convertPoint:point toView:self.tableview];
                
                NSIndexPath *index=[self.tableview indexPathForRowAtPoint:convertedPoint];
                NSLog(@"index row:%d placeholder row:%ld",index.row,(long)self.PlaceholderIndexpath.row);
                id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][0];
                NSInteger numberOfObjects=[sectionInfo numberOfObjects];
                
                
                
                
                
                if (index!=NULL &&  index.row!=self.PlaceholderIndexpath.row  ) {
                    NSLog(@"dragged on row:%ld previous placeholder row:%ld",(long)index.row,(long)self.PlaceholderIndexpath.row);
                    [self removePlaceholder];
                    self.shouldLoadPlaceholder=YES;
                    self.PlaceholderIndexpath=index;
                    self.previousPlaceholderRow=index.row;
                    
                    [self.tableview beginUpdates];
                    NSArray *indexesArray=[NSArray arrayWithObject:self.PlaceholderIndexpath];
                    [self.tableview insertRowsAtIndexPaths:indexesArray withRowAnimation:UITableViewRowAnimationNone];
                    
                    [self.tableview endUpdates];
                
                    self.shouldLoadPlaceholder=NO;
                
                }
                else if (index==NULL && numberOfObjects==0)
                {
                    NSLog(@"add placeholder on empty tableview %@",self.cardToDisplay.name);
                    [self removePlaceholder];
                    self.PlaceholderIndexpath=[NSIndexPath indexPathForRow:0 inSection:0];
                    self.previousPlaceholderRow=0;
                    self.shouldLoadPlaceholder=YES;
                    self.PlaceholderIndexpath=index;
                    
                    [self.tableview reloadData];
                    //self.shouldLoadPlaceholder=NO;
                    
                }
                else if(index==NULL && numberOfObjects!=0)
                {
                    NSLog(@"placeholder: dragged under the row");
                    
                    [self removePlaceholder];
                    NSInteger NewPlaceholderRow=[[self.fetchedResultsController fetchedObjects]count];
                    self.PlaceholderIndexpath=[NSIndexPath indexPathForRow:NewPlaceholderRow inSection:0];
                    self.previousPlaceholderRow=NewPlaceholderRow;
                    self.shouldLoadPlaceholder=YES;
                    
                    [self.tableview beginUpdates];
                    NSArray *indexesArray=[NSArray arrayWithObject:self.PlaceholderIndexpath];
                    [self.tableview insertRowsAtIndexPaths:indexesArray withRowAnimation:UITableViewRowAnimationNone];
                    
                    [self.tableview endUpdates];
                    
                    //[self.tableview setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
                    self.shouldLoadPlaceholder=NO;
                   
                    
                    

                    
                    
                }
                
                else
                {
                    NSLog(@"unknown case");
                }
                
            }
            else
            {
                NSLog(@"project page view: placeholder adding locked, remove placeholder");
           //     CGPoint convertedPoint=[manager.rootView convertPoint:point toView:self.tableview];
                
             //   NSIndexPath *index=[self.tableview indexPathForRowAtPoint:convertedPoint];
                //if (index!=self.PlaceholderIndexpath) {
                  [self removePlaceholder];
                //}
                
            }
            
            
            
          
            CGPoint tableviewMovedToPoint=[manager.rootView convertPoint:point toView:self.tableview];
            NSIndexPath *movedToRow=[self.tableview indexPathForRowAtPoint:tableviewMovedToPoint];
            id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][0];
            NSInteger numberOfObjects=[sectionInfo numberOfObjects];
            
            NSLog(@"moved to indexpath:%@  (row:%ld, section:%ld)",movedToRow,(long)movedToRow.row,(long)movedToRow.section);
            NSLog(@"number of objects:%ld",(long)numberOfObjects);
            NSLog(@"tableview content height%f",self.tableview.contentSize.height);
            NSLog(@"tableview content offset y:%f",self.tableview.contentOffset.y);
            NSLog(@"tableview frame height:%f",self.tableview.frame.size.height);
            NSLog(@"placeholder indexpath:%@",self.PlaceholderIndexpath);
            NSLog(@"Moved to point y:%f",tableviewMovedToPoint.y);
            
            if (movedToRow && movedToRow.row<=numberOfObjects) {
                [self.tableview autoScrollDragMoved:tableviewMovedToPoint];
            }
           
            

        }
        

      
        
       
        
        
    }
    

    
    
    
}
-(CGFloat)countHeightForCellAtIndexpath:(NSIndexPath *)indexPath
{
    Card *cardForRow=[[self.fetchedResultsController fetchedObjects]objectAtIndex:indexPath.row];
    
    
    NSLog(@"project page view counting height started");
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont systemFontOfSize:17], NSFontAttributeName,
                                          nil];
    
    CGFloat rowWidth=[UIScreen mainScreen].bounds.size.width-2*rowMarginLeftRight;
    
    CGFloat ret=[DATAUTILS countHeightForTextInTaskCellFrameWithWidth:rowWidth andText:cardForRow.name withAtributes:attributesDictionary ]+rowMarginTopAndBottom;
    NSLog(@"row height:%f",ret);
    NSArray *tagsForRow=cardForRow.tags;
    
    if ([cardForRow.toAssignedUsersRelationship count]>0) {
        CGFloat height=[DATAUTILS countHeightForTagsCellWithTags:tagsForRow withFontSize:tagsCellfontSize]+30;
        NSLog(@"project page view counting height finished");
        NSLog(@"Project page view - heightForRowAtIndexPath finished 1");
   
        return ret+height;
    }
    else
    {
        CGFloat height=[DATAUTILS countHeightForTagsCellWithTags:tagsForRow withFontSize:tagsCellfontSize];
        NSLog(@"project page view counting height finished");
        NSLog(@"Project page view - heightForRowAtIndexPath finished 2");

        return ret+height;
    }

}
-(ProjectPageViewCell *)createTableviewCellForIndexPath:(NSIndexPath *)indexPath
{
    Card *cardForRow=[[self.fetchedResultsController fetchedObjects]objectAtIndex:indexPath.row];
    NSLog(@"card for row should be hidden:%@",cardForRow.shouldBeHidden);
    
    if (indexPath.row==[[self.fetchedResultsController fetchedObjects]count]-1) {
        self.lastItemId=cardForRow.cardId;
    }
    NSLog(@"stage id for row:%@",cardForRow.stage_id);
    ProjectPageViewCell *cell = [self.tableview dequeueReusableCellWithIdentifier:@"ProjectPageViewCell"];
    if (cell == nil) {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ProjectPageViewCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    NSLog(@"ProjectPageView - cellForRowAtIndexPath - set cell background and text");
    [cell.contentName setText:cardForRow.name];
    [cell.contentName setTextColor:[DATAUTILS signInButtonColour]];
    
    //[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.backgroundColor=[DATAUTILS backgroundColor];
    
    cell.contentBackgroundView.layer.borderColor=[DATAUTILS borderColor].CGColor;
    cell.contentBackgroundView.layer.borderWidth=0.5f;
    
    NSLog(@"ProjectPageView - cellForRowAtIndexPath - set cell background and text finished");
    
    NSLog(@"ProjectPageView - cellForRowAtIndexPath - set cell peoples");
    if ([cardForRow.toAssignedUsersRelationship count]==0) {
        [cell.peoplesAvatarsView setHidden:YES];
        cell.avatarsViewHeight.constant=0;
    }
    else
    {
        [cell.peoplesAvatarsView setWithCard:cardForRow];
        [cell.peoplesAvatarsView setHidden:NO];
        cell.avatarsViewHeight.constant=30;
    }
    
    
    NSLog(@"ProjectPageView - cellForRowAtIndexPath - set cell peoples finished");
    cell.cardForRow=cardForRow;
    cell.projectForRow=self.selectedProject;
    
    if (indexPath.row==0) {
        cell.previousIdString=@"0";
    }
    else
    {
        NSInteger previousRow=indexPath.row-1;
        Card *previousCard=[[self.fetchedResultsController fetchedObjects]objectAtIndex:previousRow];
        cell.previousIdString=[previousCard.cardId stringValue];
    }
    NSLog(@"position for row:%@",cardForRow.position);
    
    if ([DATAUTILS checkIfTaskIsMarked:cardForRow]) {
        
        [cell.statusBackground setHidden:NO];
        
        if ([cardForRow.done boolValue]) {
            [cell.statusLabel setText:@"DONE"];
            cell.statusLabel.backgroundColor =[ColorwithHex colorWithHexString:@"ccc"];
            
        }
        else if ([cardForRow.ready boolValue])
        {
            [cell.statusLabel setText:@"READY"];
            cell.statusLabel.backgroundColor =[ColorwithHex colorWithHexString:@"4cd964"];
            
        }
        else if ([cardForRow.onhold boolValue])
        {
            [cell.statusLabel setText:@"ON HOLD"];
            cell.statusLabel.backgroundColor =[ColorwithHex colorWithHexString:@"ffcc00"];
        }
        
        else if ([cardForRow.isUnsynchronized boolValue])
        {
            [cell.statusLabel setText:@"UNSYNCHRONIZED"];
            cell.statusLabel.backgroundColor = [DATAUTILS unsynchronizedTasksStatusColor];
        }
        
        else
        {
            [cell.statusLabel setText:@"BLOCKED"];
            cell.statusLabel.backgroundColor =[ColorwithHex colorWithHexString:@"ff3b30"];
        }
        
        
        
    }
    else
    {
        
        [cell.statusBackground setHidden:YES];
    }
    NSLog(@"Project page view - cell set icons with card started");
    [cell setIconsWithCard:cardForRow andItemsArray:[DATAUTILS createIconsCollectionItemsArrayFromCard:cardForRow]];
    NSLog(@"Project page view - cell set icons with card finished");
    
    if ([cardForRow.isPlaceholderCard boolValue]) {
        cell.backgroundColor=[UIColor redColor];
    }
    else
    {
        cell.backgroundColor=[UIColor clearColor];
    }
    
    
    
    NSLog(@"ProjectPageView - cellForRowAtIndexPath finished (row:%d)",indexPath.row);
   
    return cell;
}

-(void)removePlaceholder
{
@synchronized(self.class)
    {
        if (isPlaceholderFunctionalityEnabled) {
            id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][0];
            self.previousPlaceholderRow=0;
            NSInteger numberOfObjects=[sectionInfo numberOfObjects];
            if (numberOfObjects==0) {
                NSLog(@"remove placeholder from empty table");
                self.shouldLoadPlaceholder=NO;
                [self.tableview reloadData];
            }
            else
            {
                NSLog(@"Project page view - remove placeholder (%d)",self.PlaceholderIndexpath.row);
                self.shouldLoadPlaceholder=NO;
                if (self.PlaceholderIndexpath) {
                    if (self.PlaceholderIndexpath.row<=[self.tableview numberOfRowsInSection:0]) {
                        
                        [self.tableview beginUpdates];
                        NSArray *indexesArray=[NSArray arrayWithObject:self.PlaceholderIndexpath];
                        [self.tableview deleteRowsAtIndexPaths:indexesArray withRowAnimation:UITableViewRowAnimationNone];
                        
                        [self.tableview endUpdates];
                        //[self.tableview reloadRowsAtIndexPaths:@[self.PlaceholderIndexpath] withRowAnimation:UITableViewRowAnimationNone];
                        self.PlaceholderIndexpath=nil;
                    }
                }
                
            }
            
        }
    }
    
}


-(void) scrollTableviewToTop
{
    if ([self numberOfSectionsInTableView:self.tableview] > 0)
    {
        NSIndexPath* top = [NSIndexPath indexPathForRow:NSNotFound inSection:0];
        [self.tableview scrollToRowAtIndexPath:top atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}
#pragma mark - scrollview delegate methods
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"project page view:scrollViewWillBeginDragging");
}


-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
     NSLog(@"project page view:scrollViewDidEndScrollingAnimation");
}

-(void)dealloc
{
    NSLog(@"project page view dealloc :%@",self);
    self.tableview.delegate=nil;
    self.tableview.dataSource=nil;
}
-(void)tableDidFinishLoading
{
    NSLog(@"tableview did finish loading");
    
    self.tableviewDidFinishLoading=YES;
    if ([self.delegate respondsToSelector:@selector(projectTableFinishedLoading)]) {
        [self.delegate projectTableFinishedLoading];
    }
  
}

-(void)checkIfDragWasDropped
{
    if (self.PlaceholderIndexpath) {
        
    }
    
    if (DATAUTILS.dragEndedWithADrop) {
        NSLog(@"drag was already dropped");
    }
    else
    {
        NSLog(@"drag wasn't dropped");
        DATAUTILS.dragedCard.shouldBeHidden=[[NSNumber alloc]initWithInt:0];
       [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext saveToPersistentStore:nil];
        DATAUTILS.dragEndedWithADrop=YES;
        if (self.tableviewDidFinishLoading) {
            [self.tableview reloadData];
        }
        
        
    }
}
-(CGFloat)countHeightForRowForNotPlaceholderCardAtIndexpath:(NSIndexPath *)indexPath
{
    NSLog(@"count height for not placeholder cell at row:%d",indexPath.row);
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][0];
    
    NSInteger numberOfObjects=[sectionInfo numberOfObjects];
    Card *cardForRow;

    if (indexPath.row>=numberOfObjects)
    {
        cardForRow=[[self.fetchedResultsController fetchedObjects] lastObject];
    }
    else
    {
       cardForRow=[[self.fetchedResultsController fetchedObjects]objectAtIndex:indexPath.row];
    }
    NSString *cardKey=[NSString stringWithFormat:@"card%@",cardForRow.cardId ];
    NSString *cardHeightKey=[NSString stringWithFormat:@"cardHeight%@",cardForRow.cardId ];
    
    Card *cachedCard=[self.cellsCache objectForKey:cardKey];
    NSNumber *cachedCardHeight=[self.cellsCache objectForKey:cardHeightKey];
    
    if (cardForRow == cachedCard  && [cachedCardHeight doubleValue]>0) {
        NSLog(@"heightForRow: getting cached height");
        return [cachedCardHeight doubleValue];
    }
    
    else
    {
        NSLog(@"heightForRow: getting NOT cached height");
        CGFloat height=[self countHeightForCellAtIndexpath:indexPath];
        [self.cellsCache setObject:cardForRow forKey:cardKey];
        NSNumber *heightNumber=[[NSNumber alloc]initWithFloat:height];
        [self.cellsCache setObject:heightNumber forKey:cardHeightKey];
        return height;
        
    }

}
@end
