//
//  TodoListContentCell.m
//  breeze
//
//  Created by Breeze on 29.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import "TodoListContentCell.h"
#import "DataUtils.h"
#import "Project.h"
#import "Card.h"
#import "ProjectCards.h"

@implementation TodoListContentCell

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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)todoButtonAction:(id)sender {
    MarkTodoButton *button=sender;
    [self setImageWithDoneState:![button.todoToMark.done boolValue]];
    NSLog(@"todo to mark:%@",button.todoToMark);
    
    NSString *path=[NSString stringWithFormat:@"/projects/%@/cards/%@/todo_lists/%@/todos/%@",DATAUTILS.selectedProject.projectId,DATAUTILS.selectedCard.cardId,self.listIdForCell,button.todoToMark.todoId ];
    
    NSArray *keysArray=[NSArray arrayWithObjects:@"name",@"done", nil];
    NSString *key;
    
    if ([button.todoToMark.done boolValue]) {
        key=@"false";
    }
    else
    {
        key=@"true";
    }
    NSArray *objectsArray=[NSArray arrayWithObjects:button.todoToMark.name,key, nil];
   
    NSDictionary *params=[NSDictionary dictionaryWithObjects:objectsArray forKeys:keysArray];
    
    [[RKObjectManager sharedManager]putObject:nil path:path parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"succesfully changed todo:%@",mappingResult.array);
        NSLog(@"response string:%@",operation.HTTPRequestOperation.responseString);
        Todo *output=[[mappingResult array]firstObject];
        button.todoToMark=output;
        if ([output.done boolValue]) {
            NSInteger temp=[DATAUTILS.selectedCard.done_todos integerValue];
            temp++;
            DATAUTILS.selectedCard.done_todos=[[NSNumber alloc]initWithInteger:temp];
        }
        else
        {
            NSInteger temp=[DATAUTILS.selectedCard.done_todos integerValue];
            temp--;
            DATAUTILS.selectedCard.done_todos=[[NSNumber alloc]initWithInteger:temp];
        }
        [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext saveToPersistentStore:nil];
        
        
        
        
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"error while changing todo:%@",error.description);
        NSLog(@"response string:%@",operation.HTTPRequestOperation.responseString);
        [DATAUTILS DisplayPopupWithTitle:@"Network error" andMessage:@"Error while changing todo status"];
        
        if (error.code==-1009) {
            [DATAUTILS DisplayPopupWithTitle:@"Synchronization" andMessage:@"Changes will be synchronized later"];
            [DATAUTILS addUnsuccesfullRequest:operation.HTTPRequestOperation.request];
            if ([button.todoToMark.done boolValue]) {
                button.todoToMark.done=[[NSNumber alloc]initWithInt:0];
                
            }
            else
            {
                button.todoToMark.done=[[NSNumber alloc]initWithInt:1];
            }
            
            
             [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext saveToPersistentStore:&error];
        }
        
    }];
    
    
    
}

-(void)setImageWithDoneState:(BOOL)state
{
    if (state) {
        [self.todoButton setImage: [UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        [self.todoButton setImage: [UIImage imageNamed:@"check"] forState:UIControlStateSelected];
    }
    else
    {
        [self.todoButton setImage: [UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
        [self.todoButton setImage: [UIImage imageNamed:@"uncheck"] forState:UIControlStateSelected];
    }
}
@end
