//
//  Stage.h
//  breeze
//
//  Created by Breeze on 11.06.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Activity;

@interface Stage : NSManagedObject

@property (nonatomic, retain) NSString * created_at;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * stageId;
@property (nonatomic, retain) NSString * updated_at;
@property (nonatomic, retain) Activity *toActivityRelationship;

@end
