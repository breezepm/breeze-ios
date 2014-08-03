//
//  ProjectPageViewController.m
//  breeze
//
//  Created by Breeze on 13.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import "ProjectPageViewController.h"
#import "asymptotikDrag/AtkDropZoneProtocol.h"
#import "DataUtils.h"
#import "DetailedTaskController.h"
#import "ProjectPageView.h"
#import "Card.h"
#import "AddEditTaskViewController.h"
#import "projectPageNavigationBar.h"
#import "SuProgress.h"
//#import "NavigationBarTitleWithSubtitleView.h"

#import "User.h"
#import "Comment.h"
#import "projectPageNavigationBar.h"


@interface ProjectPageViewController ()

@end

@implementation ProjectPageViewController

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
    NSLog(@"Project page:view did load");
    
    NSLog(@"scroll height constraint :%f",self.scrollHeightConstraint.constant);
  
    self.view.backgroundColor=[DATAUTILS backgroundColor];
    self.dragAndDropManager = [[AtkDragAndDropManager alloc] init] ;
    self.dragAndDropManager.delegate = self;

    NSLog(@"project page view controller view did load");
    
    ProjectCards *firstCard=[self.pageContentsArray firstObject];

    __weak __typeof__(self) weakSelf = self;
    
  weakSelf.navBar=[[[NSBundle mainBundle] loadNibNamed:@"ProjectPageNavigationBar" owner:nil options:nil] objectAtIndex:0];
    
    [weakSelf.navBar setWithTitle:DATAUTILS.selectedProject.name andSubtitle:firstCard.name onView:self.view];
    
    [self.titleBar setTitleView:_navBar];
    
    
    
    [self.scroll setWithCardsArray:self.pageContentsArray];
    self.pageControll.numberOfPages = [self.pageContentsArray count];
    self.pageControll.currentPage = 0;
    self.scroll.delegate=self;
    
    for(ProjectPageView *page in self.scroll.viewsArray)
    {
        page.delegate=self;
    }
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"project page: view will apear");
    [DATAUTILS addObserver:self forKeyPath:@"offlineSyncCounter" options:NSKeyValueObservingOptionNew context:nil];
    NSInteger currentPage=self.pageControll.currentPage;
    
    ProjectPageView *pageToReload=[self.scroll.viewsArray objectAtIndex:currentPage];
    if (pageToReload.tableviewDidFinishLoading && !self.scroll.noNeedToReloadContent) {
        NSLog(@"tableview did finish loading, reloading");
        [pageToReload.tableview reloadData];
    }
    else
    {
        NSLog(@"project page view controller: tableview not ready");
    }
    self.scroll.noNeedToReloadContent=NO;
    
    
    NSLog(@"---subviews of ProjectPageViewController---");
    NSLog(@"self view:%@",self.view.layer);
    [DATAUTILS listSubviewsOfView:self.view];
    NSLog(@"---subviews of ProjectPageViewController end---");
    
   
}


-(void) projectTable:(UITableView *)tableView didSelectCard:(Card *)ip
{
    NSLog(@"tableview did select card:%@",ip.cardId);
    NSLog(@"selected card stage id:%@",ip.stage_id);
   
    self.view.userInteractionEnabled=NO;
   
    
    
    NSURLRequest *request = [[RKObjectManager sharedManager] requestWithPathForRouteNamed:@"getCommentsForCard" object:DATAUTILS.selectedCard parameters:nil];
        __weak __typeof__(self) weakSelf = self;
    RKManagedObjectRequestOperation *operation = [[RKObjectManager sharedManager] managedObjectRequestOperationWithRequest:request managedObjectContext:[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
       
        
        DATAUTILS.selectedCard.toCommentsRelationship=[mappingResult set];
          [weakSelf performSegueWithIdentifier:@"goToDetailedTaskController" sender:self];
        [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext saveToPersistentStore:nil];
     
        weakSelf.view.userInteractionEnabled=YES;
       
        
        
        
        for (Comment  *c in mappingResult.array) {
            NSLog(@"comment:user:%@",c.toUsersRelationship);
            
            
        }
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        weakSelf.view.userInteractionEnabled=YES;
        NSLog(@"Error while downloading comments:%@",error.description);
        [weakSelf performSegueWithIdentifier:@"goToDetailedTaskController" sender:self];
   
    }];
    
    
    [weakSelf SuProgressForAFHTTPRequestOperation:operation.HTTPRequestOperation];
    [[RKObjectManager sharedManager].operationQueue addOperation:operation];
    
    

   

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.scroll.frame.size.width;
    float fractionalPage = self.scroll.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    self.pageControll.currentPage = page;
    ProjectCards *currentCard=[self.pageContentsArray objectAtIndex:page];
    __weak __typeof__(self) weakSelf = self;
    [weakSelf.navBar setWithTitle:DATAUTILS.selectedProject.name andSubtitle:currentCard.name onView:self.view];
  
}






- (void)viewDidAppear:(BOOL)animated
{
   [super viewDidAppear:animated];

    
     [self.dragAndDropManager start:[[UIApplication sharedApplication] keyWindow] recognizerClass:[UILongPressGestureRecognizer class]];
}
-(void)dragWillStart:(AtkDragAndDropManager *)manager
{
    self.scroll.userInteractionEnabled=NO;
}


-(void)dragEnded:(AtkDragAndDropManager *)manager
{
    NSLog(@"Project page view controller - drag ended");
    self.scroll.userInteractionEnabled=YES;
   
    
    

    
}
- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"view will disapear");
    [DATAUTILS removeObserver:self forKeyPath:@"offlineSyncCounter"];
    [self.dragAndDropManager stop];
    NSLog(@"---subviews of ProjectPageViewController---");
    NSLog(@"self view:%@",self.view.layer);
    [DATAUTILS listSubviewsOfView:self.view];
    NSLog(@"---subviews of ProjectPageViewController end---");
    [super viewWillDisappear:animated];
   
}
-(void)handleDropOnX:(CGFloat)xpoint andY:(CGFloat)ypoint andXOffset:(CGFloat )xOffset
{
    NSLog(@"handle drop on x=%f y=%f with offset:%f",xpoint,ypoint,xOffset);
    NSInteger pageNumber=xOffset/self.scroll.frame.size.width;
    NSLog(@"(page %d)",pageNumber);
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"goToDetailedTaskController"]) {
        DetailedTaskController *destination=segue.destinationViewController;
        destination.selectedCard=self.selectedCard;

    }
    if ([segue.identifier isEqualToString:@"goToAddEditTaskController"]) {
        AddEditTaskViewController *destination=segue.destinationViewController;
        destination.isNewTask=YES;
        destination.delegate=self;
        NSLog(@"go to add task from list on page:%ld",(long)self.pageControll.currentPage);
        ProjectCards *visivleList=[self.pageContentsArray objectAtIndex:self.pageControll.currentPage];
        destination.currentListId=visivleList.cardsId;
    
    }
    
}

-(void)taskContentChanged
{
    

}


- (IBAction)AddButton:(id)sender {
    [self performSegueWithIdentifier:@"goToAddEditTaskController" sender:self];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (DATAUTILS.offlineSyncCounter!=0) {
        
        NSLog(@"RELOAD AFTER OFFLINE SYNC");
        NSInteger currentPage=self.pageControll.currentPage;
        
        ProjectPageView *pageToReload=[self.scroll.viewsArray objectAtIndex:currentPage];
        [pageToReload.tableview reloadData];
    }
}
-(void)projectTableIsLoading
{
    NSLog(@"project table is loading");
    self.navigationItem.leftBarButtonItem.enabled=NO;
    
    self.navigationItem.backBarButtonItem.enabled=NO;
    
}
-(void)projectTableFinishedLoading
{
    NSLog(@"project table finished loading");
    self.navigationItem.leftBarButtonItem.enabled=YES;
    
    self.navigationItem.backBarButtonItem.enabled=YES;
}
@end
