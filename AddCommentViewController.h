//
//  AddCommentViewController.h
//  breeze
//
//  Created by Breeze on 19.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"
#import "RemoteImageView.h"
//#import "GCPlaceholderTextView.h"
#import "LPlaceholderTextView.h"
@protocol AddCommentDelegate;
@interface AddCommentViewController : UIViewController <UITextViewDelegate>
- (IBAction)cancelAction:(id)sender;
- (IBAction)doneAction:(id)sender;

@property (weak, nonatomic) IBOutlet LPlaceholderTextView *commentTextView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet RemoteImageView *userAvatar;
@property (weak,nonatomic) id <AddCommentDelegate> delegate;
@property  CGRect fullTextViewRect;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentTextViewSpaceToBottom;
@property (strong) Comment *commentToEdit;
@end


@protocol AddCommentDelegate <NSObject>
@optional
-(void) newCommentAdded;

@end