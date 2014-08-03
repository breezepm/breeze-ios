//
//  ProjectCards.h
//  breeze
//
//  Created by Breeze on 11.06.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Card;

@interface ProjectCards : NSManagedObject

@property (nonatomic, retain) NSNumber * cardsId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * position;
@property (nonatomic, retain) NSNumber * projectId;
@property (nonatomic, retain) NSSet *toCardsRelationship;
@end

@interface ProjectCards (CoreDataGeneratedAccessors)

- (void)addToCardsRelationshipObject:(Card *)value;
- (void)removeToCardsRelationshipObject:(Card *)value;
- (void)addToCardsRelationship:(NSSet *)values;
- (void)removeToCardsRelationship:(NSSet *)values;

@end
