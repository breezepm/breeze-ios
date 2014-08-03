//
//  ProjectDetailedTodoListsCell.h
//  breeze
//
//  Created by Breeze on 29.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodoListHeader.h"
#import "Todo.h"
#import "TodoList.h"

@protocol todoListDelegate;
@interface ProjectDetailedTodoListsCell : UITableViewCell  <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *contentTableview;
@property (strong) NSArray *toDoListsArray;
@property (weak,nonatomic) id delegate;
-(void)setWithListArray:(NSArray *)toDoListsArray;
@end
@protocol todoListDelegate <NSObject>

-(void)addNewTodoOnList:(NSNumber *)listId;
-(void)editTodo:(Todo *)todo onList:(NSNumber *)list;

@end