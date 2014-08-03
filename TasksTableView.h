//
//  TasksTableView.h
//  breeze
//
//  Created by Breeze on 26.06.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <UIKit/UIKit.h>
//#define placeholdersLockTime 0.3
@interface TasksTableView : UITableView


@property (strong,atomic) NSTimer *placeholderLockTimer; //TO LOCK PLACEHOLDERS WHEN SCROLLING, BECAUSE SCROLL ANIMATION GOES TOO FAST
@property  (atomic) BOOL isPlaceholerAddingLocked;
@property (atomic) BOOL isTableviewDragged; //TRUE WHEN DRAG STARTED

@property (atomic) BOOL isUpdating; //FOR PLACEHOLDERS - TO LOCK DRAG MOVED WHEN INSERT PLACEHOLDER
@property (atomic) CGFloat previousContentOffsetY;

@end
