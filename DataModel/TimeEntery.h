//
//  TimeEntery.h
//  breeze
//
//  Created by Breeze on 11.06.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Card;

@interface TimeEntery : NSManagedObject

@property (nonatomic, retain) NSString * enteryDescription;
@property (nonatomic, retain) NSNumber * enteryId;
@property (nonatomic, retain) NSString * logged_date;
@property (nonatomic, retain) NSNumber * tracked;
@property (nonatomic, retain) NSString * user_email;
@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) NSString * user_name;
@property (nonatomic, retain) NSSet *toCardRelationship;
@end

@interface TimeEntery (CoreDataGeneratedAccessors)

- (void)addToCardRelationshipObject:(Card *)value;
- (void)removeToCardRelationshipObject:(Card *)value;
- (void)addToCardRelationship:(NSSet *)values;
- (void)removeToCardRelationship:(NSSet *)values;

@end
