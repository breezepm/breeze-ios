//
//  TodoList.h
//  breeze
//
//  Created by Breeze on 11.06.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Card, Todo;

@interface TodoList : NSManagedObject

@property (nonatomic, retain) NSNumber * listId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Card *toCardRelationship;
@property (nonatomic, retain) NSOrderedSet *todos;
@end

@interface TodoList (CoreDataGeneratedAccessors)

- (void)insertObject:(Todo *)value inTodosAtIndex:(NSUInteger)idx;
- (void)removeObjectFromTodosAtIndex:(NSUInteger)idx;
- (void)insertTodos:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeTodosAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInTodosAtIndex:(NSUInteger)idx withObject:(Todo *)value;
- (void)replaceTodosAtIndexes:(NSIndexSet *)indexes withTodos:(NSArray *)values;
- (void)addTodosObject:(Todo *)value;
- (void)removeTodosObject:(Todo *)value;
- (void)addTodos:(NSOrderedSet *)values;
- (void)removeTodos:(NSOrderedSet *)values;
@end
