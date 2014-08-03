//
//  Todo.h
//  breeze
//
//  Created by Breeze on 11.06.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TodoList;

@interface Todo : NSManagedObject

@property (nonatomic, retain) NSNumber * done;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * todoId;
@property (nonatomic, retain) NSOrderedSet *toTodoList;
@end

@interface Todo (CoreDataGeneratedAccessors)

- (void)insertObject:(TodoList *)value inToTodoListAtIndex:(NSUInteger)idx;
- (void)removeObjectFromToTodoListAtIndex:(NSUInteger)idx;
- (void)insertToTodoList:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeToTodoListAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInToTodoListAtIndex:(NSUInteger)idx withObject:(TodoList *)value;
- (void)replaceToTodoListAtIndexes:(NSIndexSet *)indexes withToTodoList:(NSArray *)values;
- (void)addToTodoListObject:(TodoList *)value;
- (void)removeToTodoListObject:(TodoList *)value;
- (void)addToTodoList:(NSOrderedSet *)values;
- (void)removeToTodoList:(NSOrderedSet *)values;
@end
