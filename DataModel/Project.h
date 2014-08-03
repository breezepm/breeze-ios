//
//  Project.h
//  breeze
//
//  Created by Breeze on 11.06.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Activity, User;

@interface Project : NSManagedObject

@property (nonatomic, retain) NSNumber * budget_amount;
@property (nonatomic, retain) NSNumber * budget_hours;
@property (nonatomic, retain) NSString * created_at;
@property (nonatomic, retain) NSString * currency_symbol;
@property (nonatomic, retain) NSNumber * hourly_rate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * projectDescription;
@property (nonatomic, retain) NSNumber * projectId;
@property (nonatomic, retain) NSNumber * star;
@property (nonatomic, retain) id tags;
@property (nonatomic, retain) NSNumber * total_planned;
@property (nonatomic, retain) NSNumber * total_tracked;
@property (nonatomic, retain) NSSet *toActivityRelationship;
@property (nonatomic, retain) NSSet *toUsersRelationship;
@end

@interface Project (CoreDataGeneratedAccessors)

- (void)addToActivityRelationshipObject:(Activity *)value;
- (void)removeToActivityRelationshipObject:(Activity *)value;
- (void)addToActivityRelationship:(NSSet *)values;
- (void)removeToActivityRelationship:(NSSet *)values;

- (void)addToUsersRelationshipObject:(User *)value;
- (void)removeToUsersRelationshipObject:(User *)value;
- (void)addToUsersRelationship:(NSSet *)values;
- (void)removeToUsersRelationship:(NSSet *)values;

@end
