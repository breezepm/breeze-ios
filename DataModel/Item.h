//
//  Item.h
//  breeze
//
//  Created by Breeze on 11.06.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Activity;

@interface Item : NSManagedObject

@property (nonatomic, retain) NSString * changed;
@property (nonatomic, retain) NSString * item_old;
@property (nonatomic, retain) NSSet *toActivityRelationship;
@end

@interface Item (CoreDataGeneratedAccessors)

- (void)addToActivityRelationshipObject:(Activity *)value;
- (void)removeToActivityRelationshipObject:(Activity *)value;
- (void)addToActivityRelationship:(NSSet *)values;
- (void)removeToActivityRelationship:(NSSet *)values;

@end
