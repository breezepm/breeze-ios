//
//  AddEditToodoViewController.h
//  breeze
//
//  Created by Breeze on 29.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Todo.h"
#import "DataUtils.h"
#import "LPlaceholderTextView.h"
@protocol AddEditTodoDelegate;
@interface AddEditToodoViewController : UIViewController <UITextViewDelegate>
- (IBAction)cancelAction:(id)sender;
- (IBAction)doneAction:(id)sender;
@property (weak, nonatomic) IBOutlet LPlaceholderTextView *textField;
@property (strong) Todo *selectedTodo;
@property (weak,nonatomic) id <AddEditTodoDelegate> delegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceToBottom;
@property (strong) NSNumber *listId;
@end

@protocol AddEditTodoDelegate <NSObject>
@optional
-(void) taskContentChanged;

@end