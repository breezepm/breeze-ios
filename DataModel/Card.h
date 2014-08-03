//
//  Card.h
//  breeze
//
//  Created by Breeze on 30.06.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Comment, ProjectCards, TimeEntery, TodoList, User;

@interface Card : NSManagedObject

@property (nonatomic, retain) NSNumber * attachments_count;
@property (nonatomic, retain) NSNumber * blocked;
@property (nonatomic, retain) NSString * cardDescription;
@property (nonatomic, retain) NSNumber * cardId;
@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSNumber * comments_count;
@property (nonatomic, retain) NSString * created_at;
@property (nonatomic, retain) NSNumber * done;
@property (nonatomic, retain) NSNumber * done_todos;
@property (nonatomic, retain) NSString * duedate;
@property (nonatomic, retain) NSNumber * hidden;
@property (nonatomic, retain) NSNumber * isPlaceholderCard;
@property (nonatomic, retain) NSNumber * isUnsynchronized;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * onhold;
@property (nonatomic, retain) NSNumber * planned_time;
@property (nonatomic, retain) NSNumber * position;
@property (nonatomic, retain) NSNumber * projectId;
@property (nonatomic, retain) NSNumber * ready;
@property (nonatomic, retain) NSNumber * shouldBeHidden;
@property (nonatomic, retain) NSNumber * stage_id;
@property (nonatomic, retain) NSString * startdate;
@property (nonatomic, retain) id tags;
@property (nonatomic, retain) NSNumber * todos_count;
@property (nonatomic, retain) NSNumber * total_tracked;
@property (nonatomic, retain) NSString * updated_at;
@property (nonatomic, retain) NSSet *toAssignedUsersRelationship;
@property (nonatomic, retain) NSSet *toCommentsRelationship;
@property (nonatomic, retain) NSSet *toProjectCardsRelationship;
@property (nonatomic, retain) NSSet *toTimeEnteriesRelationship;
@property (nonatomic, retain) NSSet *toToDoListsRelationship;
@property (nonatomic, retain) NSSet *toUsersRelationship;
@end

@interface Card (CoreDataGeneratedAccessors)

- (void)addToAssignedUsersRelationshipObject:(User *)value;
- (void)removeToAssignedUsersRelationshipObject:(User *)value;
- (void)addToAssignedUsersRelationship:(NSSet *)values;
- (void)removeToAssignedUsersRelationship:(NSSet *)values;

- (void)addToCommentsRelationshipObject:(Comment *)value;
- (void)removeToCommentsRelationshipObject:(Comment *)value;
- (void)addToCommentsRelationship:(NSSet *)values;
- (void)removeToCommentsRelationship:(NSSet *)values;

- (void)addToProjectCardsRelationshipObject:(ProjectCards *)value;
- (void)removeToProjectCardsRelationshipObject:(ProjectCards *)value;
- (void)addToProjectCardsRelationship:(NSSet *)values;
- (void)removeToProjectCardsRelationship:(NSSet *)values;

- (void)addToTimeEnteriesRelationshipObject:(TimeEntery *)value;
- (void)removeToTimeEnteriesRelationshipObject:(TimeEntery *)value;
- (void)addToTimeEnteriesRelationship:(NSSet *)values;
- (void)removeToTimeEnteriesRelationship:(NSSet *)values;

- (void)addToToDoListsRelationshipObject:(TodoList *)value;
- (void)removeToToDoListsRelationshipObject:(TodoList *)value;
- (void)addToToDoListsRelationship:(NSSet *)values;
- (void)removeToToDoListsRelationship:(NSSet *)values;

- (void)addToUsersRelationshipObject:(User *)value;
- (void)removeToUsersRelationshipObject:(User *)value;
- (void)addToUsersRelationship:(NSSet *)values;
- (void)removeToUsersRelationship:(NSSet *)values;

@end
