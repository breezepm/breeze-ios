//
//  AddCommentViewController.m
//  breeze
//
//  Created by Breeze on 19.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import "AddCommentViewController.h"
#import "DataUtils.h"
#import "PDKeychainBindings.h"
#import "Comment.h"
#import "LPlaceholderTextView.h"

@interface AddCommentViewController ()

@end

@implementation AddCommentViewController

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
    // Do any additional setup after loading the view.
    self.commentTextView.placeholderText=@"Add comment...";
    //self.commentTextView.placeholderText=@"Add comment...";
    //self.commentTextView.realTextColor=[UIColor blackColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
  
    if (self.commentToEdit) {
        self.title=@"Edit comment";
        self.commentTextView.delegate=self;
        NSLog(@"user id:%@",self.commentToEdit.user_id);
        
        User *commentCreator=self.commentToEdit.toUsersRelationship;
//        if (commentCreator==nil) {
//            commentCreator=[DATAUTILS getUserWithIdFromDatabase:self.commentToEdit.user_id];
//        }
        if(commentCreator.userId==0)
        {
            PDKeychainBindings *bindings=[PDKeychainBindings sharedKeychainBindings];
            NSString *userName=[bindings objectForKey:@"username"];
          commentCreator=[DATAUTILS getUserFromDatabase:userName];
        }
        
        //User *
        [self.usernameLabel setText:commentCreator.name];
        
        [self.commentTextView setText:self.commentToEdit.comment];
        [self.commentTextView setTextColor:[UIColor blackColor]];
        self.userAvatar.imageURL= [NSURL URLWithString:commentCreator.avatar];
        self.userAvatar.cacheMode=RIDiskCacheMode;
        self.userAvatar.showActivityIndicator=YES;
        self.userAvatar.layer.cornerRadius = self.userAvatar.frame.size.height /2;
        self.userAvatar.layer.masksToBounds = YES;
        self.userAvatar.layer.borderWidth = 0;

    }
    
    else
    {
        self.title=@"Add comment";
        self.commentTextView.delegate=self;
        PDKeychainBindings *bindings=[PDKeychainBindings sharedKeychainBindings];
        NSString *userName=[bindings objectForKey:@"username"];
        User *currentUser=[DATAUTILS getUserFromDatabase:userName];
        //[self.usernameLabel setText:userName];
        
//        [self.commentTextView setText:@"Add a comment..."];
//        [self.commentTextView setTextColor:[UIColor lightGrayColor]];
        
        if (currentUser) {
            [self.usernameLabel setText:currentUser.name];
            self.userAvatar.imageURL= [NSURL URLWithString:currentUser.avatar];
            self.userAvatar.cacheMode=RIDiskCacheMode;
            self.userAvatar.showActivityIndicator=YES;
            self.userAvatar.layer.cornerRadius = self.userAvatar.frame.size.height /2;
            self.userAvatar.layer.masksToBounds = YES;
            self.userAvatar.layer.borderWidth = 0;
        }
        else
        {
            NSLog(@"can't find data about the user:%@",userName);
        }
    }
    [self.commentTextView becomeFirstResponder];

   // self.commentTextView.tintColor=[UIColor greenColor];
    NSLog(@"subviews of add comment viewcontroller");
    [DATAUTILS listSubviewsOfView:self.view];
    NSLog(@"subviews of add comment viewcontroller end");
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
    
    if (self.commentToEdit) {
        NSLog(@"edit comment action");
        [DATAUTILS editCommentToProject:[DATAUTILS.selectedCard.projectId stringValue] CardId:[DATAUTILS.selectedCard.cardId stringValue] CommentId:[self.commentToEdit.commentId stringValue] withText:self.commentTextView.text completion:^(BOOL success, NSSet *result) {
            if (success) {
                NSLog(@"edited added %@",result );
                if([self.delegate respondsToSelector:@selector(newCommentAdded)])
                {
                                      [self.delegate newCommentAdded];
                    
                }
                else
                {
                    NSLog(@"delegate error");
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                NSLog(@"error while editing comment:%@",result);
              //  [DATAUTILS DisplayPopupWithTitle:@"Network error" andMessage:@"Error while editing comment. Please try again later"];
              
                
            }
            
        }];
    }
    else
    {
        [DATAUTILS createCommentToProject:[DATAUTILS.selectedCard.projectId stringValue] CardId:[DATAUTILS.selectedCard.cardId stringValue] withText:self.commentTextView.text completion:^(BOOL success, NSSet *result) {
            if (success) {
                NSLog(@"comment added %@",result );
                if([self.delegate respondsToSelector:@selector(newCommentAdded)])
                {
                                        [self.delegate newCommentAdded];
                    
                }
                else
                {
                    NSLog(@"delegate error");
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                NSLog(@"error while adding comment:%@",result);
               // [DATAUTILS DisplayPopupWithTitle:@"Network error" andMessage:@"Error while adding comment. Please try again later"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];

    }
    
}


-(void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"textview did end editing");
    [textView resignFirstResponder];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //hides keyboard when another part of layout was touched
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
   
    return YES;
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSLog(@"keyboard was shown");
    //self.fullTextViewRect=self.commentTextView.frame;
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    NSLog(@"keyboard height:%f",kbSize.height);
    
    self.commentTextViewSpaceToBottom.constant=kbSize.height+10;
//    CGRect textViewRect=self.commentTextView.frame;
//    textViewRect.size.height=self.fullTextViewRect.size.height-kbSize.height;
//    self.commentTextView.frame=textViewRect;
    
    
}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    // restore the scroll position
    NSLog(@"keyboard will be hidden");
   // self.commentTextView.frame=self.fullTextViewRect;
    self.commentTextViewSpaceToBottom.constant=0;
}
-(void)viewWillDisappear:(BOOL)animated
{

    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}

@end
