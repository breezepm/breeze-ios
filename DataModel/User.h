//
//  User.h
//  breeze
//
//  Created by Breeze on 11.06.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Activity, Card, Comment, Project;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * avatar;
@property (nonatomic, retain) id cachedAvatar;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * projectId;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSSet *toActivityRelationship;
@property (nonatomic, retain) NSSet *toCardRelationship;
@property (nonatomic, retain) Comment *toCommentRelationship;
@property (nonatomic, retain) Project *toProjectRelationship;
@property (nonatomic, retain) NSSet *toUsersAssignedCardRelationship;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addToActivityRelationshipObject:(Activity *)value;
- (void)removeToActivityRelationshipObject:(Activity *)value;
- (void)addToActivityRelationship:(NSSet *)values;
- (void)removeToActivityRelationship:(NSSet *)values;

- (void)addToCardRelationshipObject:(Card *)value;
- (void)removeToCardRelationshipObject:(Card *)value;
- (void)addToCardRelationship:(NSSet *)values;
- (void)removeToCardRelationship:(NSSet *)values;

- (void)addToUsersAssignedCardRelationshipObject:(Card *)value;
- (void)removeToUsersAssignedCardRelationshipObject:(Card *)value;
- (void)addToUsersAssignedCardRelationship:(NSSet *)values;
- (void)removeToUsersAssignedCardRelationship:(NSSet *)values;

@end
