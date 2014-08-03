//
//  Activity.h
//  breeze
//
//  Created by Breeze on 11.06.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Card, Item, Project, Stage, User;

@interface Activity : NSManagedObject

@property (nonatomic, retain) NSString * action;
@property (nonatomic, retain) NSNumber * activityId;
@property (nonatomic, retain) NSString * created_at;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSString * sectionString;
@property (nonatomic, retain) Card *toCardRelationship;
@property (nonatomic, retain) NSSet *toItemRelationship;
@property (nonatomic, retain) NSSet *toProjectRelationship;
@property (nonatomic, retain) Stage *toStageRelationship;
@property (nonatomic, retain) NSSet *toUsersRelationship;
@end

@interface Activity (CoreDataGeneratedAccessors)

- (void)addToItemRelationshipObject:(Item *)value;
- (void)removeToItemRelationshipObject:(Item *)value;
- (void)addToItemRelationship:(NSSet *)values;
- (void)removeToItemRelationship:(NSSet *)values;

- (void)addToProjectRelationshipObject:(Project *)value;
- (void)removeToProjectRelationshipObject:(Project *)value;
- (void)addToProjectRelationship:(NSSet *)values;
- (void)removeToProjectRelationship:(NSSet *)values;

- (void)addToUsersRelationshipObject:(User *)value;
- (void)removeToUsersRelationshipObject:(User *)value;
- (void)addToUsersRelationship:(NSSet *)values;
- (void)removeToUsersRelationship:(NSSet *)values;

@end
