//
//  TasksTableView.m
//  breeze
//
//  Created by Breeze on 26.06.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import "TasksTableView.h"

@implementation TasksTableView
static double lockTime=1.5;
static double updateLockTime=1.0;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSLog(@"Tasks tableview init");
        self.previousContentOffsetY=0;
    }
    return self;
}

-(void)setContentOffset:(CGPoint)contentOffset
{
  //  NSLog(@"TasksTableview:set contentOffset:(%f,%f)",contentOffset.x,contentOffset.y);
    
    if (contentOffset.y>0  && self.isTableviewDragged && self.previousContentOffsetY!=contentOffset.y) { 
        NSLog(@"tasks tableview: need to lock placeholders");
        self.previousContentOffsetY=contentOffset.y;
        [self lockPlaceholders];
    }
    
    [super setContentOffset:contentOffset]; 
}
-(void)startPlaceholdersLockTimer
{
    NSLog(@"Tasks Tableview: start placeholders lock timer");
    self.placeholderLockTimer=[NSTimer scheduledTimerWithTimeInterval:lockTime
                                                               target:self
                                                             selector:@selector(unlockPlaceholdersAdding)
                                                             userInfo:nil
                                                              repeats:NO];
}
-(void)stopPlaceholderLockTimer
{
    NSLog(@"Tasks Tableview: stop placeholders lock timer");
    [self.placeholderLockTimer invalidate];
    self.placeholderLockTimer=nil;
    
}
-(void)lockPlaceholders
{
    NSLog(@"Tasks Tableview: lock placeholders");
    [self stopPlaceholderLockTimer];
    self.isPlaceholerAddingLocked=YES;
    [self startPlaceholdersLockTimer];
}
-(void)unlockPlaceholdersAdding
{
    NSLog(@"Tasks Tableview unlock placeholders");
  
         self.isPlaceholerAddingLocked=NO;
  
   
}
-(void)beginUpdates
{
    NSLog(@"tasks tableview is updating");
    self.isUpdating=YES;
    [super beginUpdates];
}
-(void)endUpdates
{
    NSLog(@"tasks tableview - finished updating");
 
    [super endUpdates];
    [NSTimer scheduledTimerWithTimeInterval:updateLockTime target:self selector:@selector(afterUpdate) userInfo:nil repeats:NO];
    
}
-(void)afterUpdate
{
    self.isUpdating=NO;

}
@end
