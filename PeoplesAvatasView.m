//
//  PeoplesAvatasView.m
//  breeze
//
//  Created by Breeze on 10.06.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import "PeoplesAvatasView.h"
#import "User.h"
#import "RemoteImageView.h"

@implementation PeoplesAvatasView
static CGFloat avatarWidth=25;
static CGFloat avatarHeight=25;
static CGFloat distanceBetweenItems=15;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setWithCard:(Card *)selectedCard
{
    NSLog(@"set icons with card started");
    CGFloat StartWidth=self.frame.size.width-avatarWidth;
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    
    self.viewsArray=[[NSMutableArray alloc]init];
    [self.viewsArray removeAllObjects];
    NSArray *assignedUsersArray=[selectedCard.toAssignedUsersRelationship allObjects];
    for (int i=0; i<[assignedUsersArray count]; i++) {
        RemoteImageView *avatar=[[RemoteImageView alloc]initWithFrame:CGRectMake(StartWidth-(i*distanceBetweenItems), 0, avatarWidth, avatarHeight)];
        User *u=[assignedUsersArray objectAtIndex:i];
        
         avatar.imageURL=[NSURL URLWithString:u.avatar];
         avatar.cacheMode=RIDiskCacheMode;
         avatar.showActivityIndicator=YES;
         avatar.layer.cornerRadius = avatar.frame.size.height /2;
         avatar.layer.masksToBounds = YES;
         avatar.layer.borderWidth = 0;
        
        [self.viewsArray addObject:avatar];
        [self addSubview:avatar];
        
        
    }
    NSLog(@"set icons with card finished");
}


@end
