//
//  ProjectPageView.h
//  breeze
//
//  Created by Breeze on 13.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectCards.h"
#import "Card.h"
#import "Project.h"
#import "AtkDragAndDrop.h"
#import "AddEditTaskViewController.h"
#import "ProjectPageViewCell.h"
#import "TasksTableView.h"


@protocol ProjectTableDelegate;


@interface ProjectPageView : UIView <UITableViewDataSource,UITableViewDelegate,AtkDropZoneProtocol,NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet TasksTableView *tableview;
@property (strong) UIRefreshControl *refreshControl;

@property (weak,nonatomic) id <ProjectTableDelegate> delegate;

@property (strong) ProjectCards *cardToDisplay;
@property (strong) Project *selectedProject;
@property (strong) NSArray *itemsArray;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong,atomic) NSIndexPath *PlaceholderIndexpath;
@property (atomic,strong) NSNumber *lastItemId;
@property (strong) NSCache *cellsCache;
@property NSInteger previousPlaceholderRow;
@property (strong) UINib *cellNib;
@property (strong) UINib *placeholderCellNib;

-(void)setWithCard;
@property (atomic) BOOL tableviewDidFinishLoading;

@property (atomic) BOOL shouldLoadPlaceholder;

-(void)removePlaceholder;
-(void) scrollTableviewToTop;
@end

@protocol ProjectTableDelegate <NSObject>
@optional
-(void) projectTable:(UITableView *)tableView didSelectCard:(Card *) ip;
-(void) projectTableFinishedLoading;
-(void) projectTableIsLoading;


@end

