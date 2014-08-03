//
//  TagViewController.h
//  breeze
//
//  Created by Breeze on 22.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol EditTagsDelegate;
@interface TagViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tagsTableview;
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *tagButton;

@property (strong,atomic) NSMutableArray *itemsArray;
@property (strong,atomic) NSMutableArray *selectedTags;
@property (strong,atomic) NSMutableArray *cardTagsArray;

@property (weak,nonatomic) id <EditTagsDelegate> delegate;
@end


@protocol EditTagsDelegate <NSObject>
@optional
-(void) tagRemoved:(NSArray *)removedTag;

@end
