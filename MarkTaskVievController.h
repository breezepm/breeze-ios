//
//  MarkTaskVievController.h
//  breeze
//
//  Created by Breeze on 22.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MarkTaskDelegate;
@interface MarkTaskVievController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *contentTableview;
@property (strong,nonatomic) NSArray *itemsArray;
@property   NSInteger startupMark;

@property (weak,nonatomic) id <MarkTaskDelegate> delegate;
@end

@protocol MarkTaskDelegate <NSObject>
@optional
-(void) taskContentChanged;

@end

