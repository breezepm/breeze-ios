//
//  TodoListContentCell.h
//  breeze
//
//  Created by Breeze on 29.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Todo.h"
#import "MarkTodoButton.h"

@interface TodoListContentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *todoName;
@property (weak, nonatomic) IBOutlet MarkTodoButton *todoButton;
@property (strong,atomic) Todo *cellTodo;
@property (strong,atomic) NSNumber *listIdForCell;
- (IBAction)todoButtonAction:(id)sender;
-(void)setImageWithDoneState:(BOOL)state;

@end
