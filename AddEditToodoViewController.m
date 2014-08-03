//
//  AddEditToodoViewController.m
//  breeze
//
//  Created by Breeze on 29.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import "AddEditToodoViewController.h"
#import "Project.h"
#import "Card.h"
#import "ProjectCards.h"

@interface AddEditToodoViewController ()

@end

@implementation AddEditToodoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"add todo view did load");
    self.textField.placeholderText=@"Todo name...";
    self.view.backgroundColor=[DATAUTILS backgroundColor];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];

    if (self.selectedTodo) {
        self.title=@"Edit todo";
        self.textField.text=self.selectedTodo.name;
    }
    else
    {
        self.title=@"Add a todo";
       // self.textField.text=@"";
    }
    self.textField.delegate=self;
    
    // Do any additional setup after loading the view.
    
    [self.textField becomeFirstResponder];
    NSLog(@"subviews of add edit todo");
    [DATAUTILS listSubviewsOfView:self.view];
    NSLog(@"subviews of add edit todo end");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)cancelAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneAction:(id)sender {
    if (self.selectedTodo) {
        
    
    
    NSString *path=[NSString stringWithFormat:@"/projects/%@/cards/%@/todo_lists/%@/todos/%@",DATAUTILS.selectedProject.projectId,DATAUTILS.selectedCard.cardId,self.listId,self.selectedTodo.todoId];
    
    NSArray *keysArray=[NSArray arrayWithObjects:@"name",@"done", nil];
    NSString *key;
    
    if (self.selectedTodo  && [self.selectedTodo.done boolValue]) {
        key=@"true";
    }
    else
    {
        key=@"false";
    }
    NSArray *objectsArray=[NSArray arrayWithObjects:self.textField.text,key, nil];
    
    NSDictionary *params=[NSDictionary dictionaryWithObjects:objectsArray forKeys:keysArray];
        __weak __typeof__(self) weakSelf = self;
    [[RKObjectManager sharedManager]putObject:nil path:path parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"succesfully changed todo:%@",mappingResult.array);
        NSLog(@"response string:%@",operation.HTTPRequestOperation.responseString);
        Todo *output=[[mappingResult array]firstObject];
        weakSelf.selectedTodo=output;
        [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext saveToPersistentStore:nil];
        
        if ([weakSelf.delegate respondsToSelector:@selector(taskContentChanged)]) {
            [weakSelf.delegate taskContentChanged];
        }
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
        
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"error while changing todo:%@",error.description);
        NSLog(@"response string:%@",operation.HTTPRequestOperation.responseString);
        [DATAUTILS DisplayPopupWithTitle:@"Network error" andMessage:@"Error while changing todo"];
        
        
        
        
        
        
        
        
    }];
    }
    else
    {
         NSString *path=[NSString stringWithFormat:@"/projects/%@/cards/%@/todo_lists/%@/todos",DATAUTILS.selectedProject.projectId,DATAUTILS.selectedCard.cardId,self.listId];
         NSArray *keysArray=[NSArray arrayWithObjects:@"name",@"done", nil];
         NSArray *objectsArray=[NSArray arrayWithObjects:self.textField.text,@"false", nil];
         NSDictionary *params=[NSDictionary dictionaryWithObjects:objectsArray forKeys:keysArray];
            __weak __typeof__(self) weakSelf = self;
        [[RKObjectManager sharedManager]postObject:nil path:path parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            NSLog(@"succesfully created toodo:%@",mappingResult.array);
            for (Todo *todoToAdd in mappingResult.array) {
                  [DATAUTILS addTodo:todoToAdd ToTodoListWithId:self.listId];
            }
            
            
          
            
            if ([weakSelf.delegate respondsToSelector:@selector(taskContentChanged)]) {
                [weakSelf.delegate taskContentChanged];
            }
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
            
            
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"error while creating todo:%@",error.description);
            NSLog(@"operation response:%@",operation.HTTPRequestOperation.responseString);
            [DATAUTILS DisplayPopupWithTitle:@"Network error" andMessage:@"Error while creating todo"];
        }];
    }

}
- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSLog(@"keyboard was shown");
 
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    NSLog(@"keyboard height:%f",kbSize.height);
    

//    self.commentTextView.frame=textViewRect;
//    if(!self.commentToEdit) {
//        self.commentTextView.selectedRange= NSMakeRange(0, 0);
//    }
    
    // self.commentTextView.tintColor=[UIColor blueColor];
    self.spaceToBottom.constant=kbSize.height+5;
}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    // restore the scroll position
    NSLog(@"keyboard will be hidden");
    self.spaceToBottom.constant=0;
    
}
@end
