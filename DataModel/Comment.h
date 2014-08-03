//
//  Comment.h
//  breeze
//
//  Created by Breeze on 11.06.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Comment : NSManagedObject

@property (nonatomic, retain) NSNumber * card_id;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSNumber * commentId;
@property (nonatomic, retain) NSString * created_at;
@property (nonatomic, retain) NSNumber * isUnSynchronized;
@property (nonatomic, retain) NSString * updated_at;
@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) User *toUsersRelationship;

@end
