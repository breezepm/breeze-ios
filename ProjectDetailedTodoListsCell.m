//
//  ProjectDetailedTodoListsCell.m
//  breeze
//
//  Created by Breeze on 29.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import "ProjectDetailedTodoListsCell.h"
#import "TodoListHeader.h"
#import "TodoListContentCell.h"
#import "DataUtils.h"
#import "PlusButton.h"

@implementation ProjectDetailedTodoListsCell
static CGFloat headerHeight=25;
static CGFloat rowHeight=25;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    self.toDoListsArray=[[NSArray alloc]init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setWithListArray:(NSArray *)toDoListsArray
{
    self.toDoListsArray=[[NSArray alloc]init];
    
    self.toDoListsArray=toDoListsArray;
    self.contentTableview.delegate=self;
    self.contentTableview.dataSource=self;
    self.contentTableview.scrollEnabled=NO;
    self.contentTableview.bounces=NO;
    [self.contentTableview reloadData ];
}
#pragma mark -tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.toDoListsArray count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    TodoList *list=[self.toDoListsArray objectAtIndex:section];
    return [list.todos count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return headerHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc]init];
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    TodoListHeader *header=[[[NSBundle mainBundle] loadNibNamed:@"TodoListHeader" owner:nil options:nil] objectAtIndex:0];
    TodoList *list=[self.toDoListsArray objectAtIndex:section];
    header.listNameLabel.text=list.name;
    header.backgroundColor=[DATAUTILS toDoListHeaderBackgroundColor];
    [header.plusButton addTarget:self
                 action:@selector(addNewToodoOnList:)
       forControlEvents:UIControlEventTouchUpInside];
    header.plusButton.listId=list.listId;
    return header;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TodoList *list=[self.toDoListsArray objectAtIndex:indexPath.section];
    Todo *todoForRow=[list.todos objectAtIndex:indexPath.row];
    TodoListContentCell *cell=[tableView dequeueReusableCellWithIdentifier:@"TodoListContentCell"];
    [cell.todoName setText:todoForRow.name];
    
//    if ([todoForRow.done boolValue]) {
//        [cell.todoButton setImage: [UIImage imageNamed:@"check"] forState:UIControlStateNormal];
//        [cell.todoButton setImage: [UIImage imageNamed:@"check"] forState:UIControlStateSelected];
//    }
//    else
//    {
//        [cell.todoButton setImage: [UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
//        [cell.todoButton setImage: [UIImage imageNamed:@"uncheck"] forState:UIControlStateSelected];
//    }
    [cell setImageWithDoneState:[todoForRow.done boolValue]];
    cell.cellTodo=todoForRow;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.todoButton.todoToMark=todoForRow;
    cell.listIdForCell=list.listId;
    
    return cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TodoList *list=[self.toDoListsArray objectAtIndex:indexPath.section];
    Todo *todoForRow=[list.todos objectAtIndex:indexPath.row];

    if ([self.delegate respondsToSelector:@selector(editTodo:onList:)])
    {
        
        [self.delegate editTodo:todoForRow onList:list.listId];
    }
   

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return rowHeight;
}

-(void)addNewToodoOnList:(id)sender
{
    PlusButton *button=sender;
  
    if ([self.delegate respondsToSelector:@selector(editTodo:onList:)]) {
        [self.delegate editTodo:nil onList:button.listId];
    }
    
}
-(void)dealloc
{
    NSLog(@"todo list dealoc");
    self.delegate=nil;
    self.contentTableview.delegate=nil;
    self.contentTableview.dataSource=nil;
}
@end
