//
//  ProjectPageScroll.m
//  breeze
//
//  Created by Breeze on 13.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import "ProjectPageScroll.h"
#import "AtkDragAndDropManager.h"

@implementation ProjectPageScroll
static int padding=103;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



-(void)setWithCardsArray:(NSArray *)projectCardsArray
{
    self.isScrollBusy=NO;
    self.noNeedToReloadContent=YES;
   
    self.bounces=NO;
    self.viewsArray=[[NSMutableArray alloc]init];
    NSLog(@"scroll frame:x=%f, y=%f, width=%f height=%f",self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height);
    self.scrollEnabled=YES;
    self.pagingEnabled=YES;
    [self setShowsHorizontalScrollIndicator:NO];
    [self setShowsVerticalScrollIndicator:NO];
    CGFloat scrHeight=[[UIScreen mainScreen] bounds].size.height;
    self.contentSize=CGSizeMake([projectCardsArray count]*self.frame.size.width, scrHeight-padding);
    NSLog(@"scroll content size width=%f height=%f",self.contentSize.width,self.contentSize.height);
    int i=0;
    for (ProjectCards *card in projectCardsArray) {
    // need to configure tableview here
        NSLog(@"set with card name:%@",card.name);
        NSLog(@"and position:%@",card.position);
      
        
        ProjectPageView *pageToAdd=[[[NSBundle mainBundle] loadNibNamed:@"ProjectPageViewTableView" owner:nil options:nil] objectAtIndex:0];
        pageToAdd.frame=CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        pageToAdd.cardToDisplay=card;
        [pageToAdd setWithCard];
        
        [self.viewsArray addObject:pageToAdd];
        
        
        i++;
    }
    
    
    for (ProjectPageView *addedView in self.viewsArray) {
        NSLog(@"view x=%f y=%f width=%f height=%f",addedView.frame.origin.x,addedView.frame.origin.y,addedView.tableview.frame.size.width,addedView.tableview.frame.size.height);
       
        [self addSubview:addedView];
    }
    
}


- (BOOL)shouldDragStart:(AtkDragAndDropManager *)manager
{
    return YES;
}

- (void)dragStarted:(AtkDragAndDropManager *)manager
{
    //NSLog(@"AtkSampleOneDropZoneScrollView.dragStarted");
    [self autoScrollDragStarted];
}

- (BOOL)isInterested:(AtkDragAndDropManager *)manager
{
    //NSLog(@"AtkSampleOneDropZoneScrollView.isInterested");
    return YES;
}

- (void)dragEnded:(AtkDragAndDropManager *)manager
{
    //NSLog(@"AtkSampleOneDropZoneScrollView.dragEnded");
    
    
    [self autoScrollDragEnded];
    CGFloat currentX=self.contentOffset.x;
    NSInteger page=currentX/320;
    [self setContentOffset:CGPointMake(page*320, self.contentOffset.y)];
    NSLog(@"drag ended with offset:(%f,%f)",self.contentOffset.x,self.contentOffset.y);
}

- (void)dragEntered:(AtkDragAndDropManager *)manager point:(CGPoint)point
{
    
    NSLog(@"scroll drag entered manager %@",manager);
}

- (void)dragExited:(AtkDragAndDropManager *)manager point:(CGPoint)point
{
    NSLog(@"drag exited manager");
}

- (void)dragMoved:(AtkDragAndDropManager *)manager point:(CGPoint)point
{
 
    CGPoint movedToPoint=[manager.rootView convertPoint:point toView:self];
    CGPoint newPoint=CGPointMake(movedToPoint.x - self.contentOffset.x, movedToPoint.y - self.contentOffset.y);
    NSLog(@"Scroll Drag moved");
    NSLog(@"point:(%f,%f)",point.x,point.y);
    NSLog(@"moved point:(%f,%f)",movedToPoint.x,movedToPoint.y);
    NSLog(@"new point:(%f,%f)",newPoint.x,newPoint.y);
    NSLog(@"drag tapped at point:(%f,%f)",manager.dragTappedAtPoint.x,manager.dragTappedAtPoint.y);

    CGFloat edgeXLocation=newPoint.x-manager.dragTappedAtPoint.x;
    CGFloat edgeYLocation=newPoint.y+manager.dragTappedAtPoint.y;
    NSLog(@"edge x location:%f",edgeXLocation);
    NSLog(@"edge y location:%f",edgeYLocation);
    if (edgeXLocation>15) {
        NSLog(@"edge reaches right corner, should go to the next page");
        [self scrollToNextPage];
    }
    else if (edgeXLocation<-15)
    {
        NSLog(@"edge reaches left corner, should go to previous page");
        [self scrollToPreviousPage];
    }
    else
    {
        NSLog(@"moved without page change");
     //   movedToPoint.x=self.contentOffset.x;
     //  [self autoScrollDragMoved:movedToPoint];
    }
    //[self autoScrollDragMoved:movedToPoint];
    
    

    
   
    
   
  
    
}

- (void)dragDropped:(AtkDragAndDropManager *)manager point:(CGPoint)point
{
 
    NSLog(@"drag dropped");
    
    
    CGFloat currentX=self.contentOffset.x;
    NSInteger page=currentX/320;
    [self setContentOffset:CGPointMake(page*320, self.contentOffset.y)];
    
    
}




-(void)scrollToNextPage
{
     if (!self.isScrollBusy) {
    CGFloat frameWidth=self.frame.size.width;
    CGFloat contentOffsexX=self.contentOffset.x;
    if (contentOffsexX+2*frameWidth<=self.contentSize.width) {
        self.isScrollBusy=YES;
    
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(unlockScroll) userInfo:nil repeats:NO];
        
        
       [self setContentOffset:CGPointMake(contentOffsexX+frameWidth, 0) animated:YES];
    
        
    }
    else
    {
        NSLog(@"next page is too far");
    }
     }
}
-(void)scrollToPreviousPage
{
    if (!self.isScrollBusy) {
        
    
    CGFloat frameWidth=self.frame.size.width;
    CGFloat contentOffsexX=self.contentOffset.x;
    if (contentOffsexX-frameWidth>=0) {
        self.isScrollBusy=YES;
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(unlockScroll) userInfo:nil repeats:NO];
    
        [self setContentOffset:CGPointMake(contentOffsexX-frameWidth, 0) animated:YES];
       
        }
        else
            {
            NSLog(@"previous page is too far");
            }
        }
}
-(void)unlockScroll
{
    NSLog(@"unock scroll");
    if (self.isScrollMoving) {
         [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(unlockScroll) userInfo:nil repeats:NO];
    }
    else
    {
         self.isScrollBusy=NO;
    }
   
}
-(void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated
{
    NSLog(@"set scroll moving");
    self.isScrollMoving=YES;

    [super setContentOffset:contentOffset animated:animated];
    self.isScrollMoving=NO;
   
}
@end
