//
//  List.h
//  breeze
//
//  Created by Breeze on 11.06.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface List : NSManagedObject

@property (nonatomic, retain) NSString * created_at;
@property (nonatomic, retain) NSNumber * listId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * position;
@property (nonatomic, retain) NSNumber * projectId;

@end
