//
//  User.m
//  breeze
//
//  Created by Breeze on 11.06.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import "User.h"
#import "Activity.h"
#import "Card.h"
#import "Comment.h"
#import "Project.h"


@implementation User

@dynamic avatar;
@dynamic cachedAvatar;
@dynamic email;
@dynamic name;
@dynamic projectId;
@dynamic userId;
@dynamic toActivityRelationship;
@dynamic toCardRelationship;
@dynamic toCommentRelationship;
@dynamic toProjectRelationship;
@dynamic toUsersAssignedCardRelationship;

@end
