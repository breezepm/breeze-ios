//
//  Card.m
//  breeze
//
//  Created by Breeze on 30.06.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import "Card.h"
#import "Comment.h"
#import "ProjectCards.h"
#import "TimeEntery.h"
#import "TodoList.h"
#import "User.h"


@implementation Card

@dynamic attachments_count;
@dynamic blocked;
@dynamic cardDescription;
@dynamic cardId;
@dynamic color;
@dynamic comments_count;
@dynamic created_at;
@dynamic done;
@dynamic done_todos;
@dynamic duedate;
@dynamic hidden;
@dynamic isPlaceholderCard;
@dynamic isUnsynchronized;
@dynamic name;
@dynamic onhold;
@dynamic planned_time;
@dynamic position;
@dynamic projectId;
@dynamic ready;
@dynamic shouldBeHidden;
@dynamic stage_id;
@dynamic startdate;
@dynamic tags;
@dynamic todos_count;
@dynamic total_tracked;
@dynamic updated_at;
@dynamic toAssignedUsersRelationship;
@dynamic toCommentsRelationship;
@dynamic toProjectCardsRelationship;
@dynamic toTimeEnteriesRelationship;
@dynamic toToDoListsRelationship;
@dynamic toUsersRelationship;

@end
