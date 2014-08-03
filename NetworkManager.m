//
//  NetworkManager.m
//  breeze
//
//  Created by Breeze on 05.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import "NetworkManager.h"

@implementation NetworkManager

+ (NetworkManager *)sharedInstance
{
    static NetworkManager *sharedInstance = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[NetworkManager alloc] init];
    });
    
    return sharedInstance;
}

- (void)configureObjectManager :(RKManagedObjectStore *)managedObjectStore
{
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:BASE_URL]];
    objectManager.managedObjectStore = managedObjectStore;
   [objectManager setRequestSerializationMIMEType:RKMIMETypeJSON];
    //[RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"application/json"];
    
    [RKObjectManager setSharedManager:objectManager];
    
    //DECLARE ENTITY MAPPINGS AND ROUTES BELOW

    RKEntityMapping *UsersMapping = [RKEntityMapping mappingForEntityForName:@"User" inManagedObjectStore:managedObjectStore];
    [UsersMapping addAttributeMappingsFromDictionary:@{
                                                          
                                                          @"avatar":             @"avatar",
                                                          
                                                          @"email" :             @"email",
                                                          
                                                          @"name"   :             @"name",
                                                          
                                                          @"id"   :        @"userId",
                                                          
                                                         @"@metadata.routing.parameters.projecId" : @"projectId"
                                                          
                                                          
                                                          }];
    
    
   
    // UsersMapping.identificationAttributes = @[ @"userId"];
      RKResponseDescriptor *UsersresponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:UsersMapping method:RKRequestMethodGET pathPattern:@"/projects/:projectId/people.json" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
         RKResponseDescriptor *AssignUsersToCardresponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:UsersMapping method:RKRequestMethodPOST pathPattern:@"/projects/:projectId/cards/:cardId/people.json" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    ///projects/%@/cards/%@/people/%@.json
    RKResponseDescriptor *DeleteUsersresponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:UsersMapping method:RKRequestMethodDELETE pathPattern:@"/projects/:projectId/people/:userId.json" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
     [objectManager.router.routeSet addRoute:[RKRoute routeWithName:@"people" pathPattern:@"/projects/:projectId/people.json" method:RKRequestMethodGET]];
        [objectManager.router.routeSet addRoute:[RKRoute routeWithName:@"deletePeople" pathPattern:@"/projects/:projectId/:userId.json" method:RKRequestMethodDELETE]];
    [objectManager addResponseDescriptor:UsersresponseDescriptor];
    [objectManager addResponseDescriptor:AssignUsersToCardresponseDescriptor];
    [objectManager addResponseDescriptor:DeleteUsersresponseDescriptor];
    //projects mapping
    
    RKEntityMapping *ProjectsMapping = [RKEntityMapping mappingForEntityForName:@"Project" inManagedObjectStore:managedObjectStore];
    [ProjectsMapping addAttributeMappingsFromDictionary:@{
                                                          
                                                          @"budget_amount":             @"budget_amount",
                                                          
                                                          @"budget_hours" :             @"budget_hours",
                                                          
                                                          @"created_at"   :             @"created_at",
                                                          
                                                          @"currency_symbol"   :        @"currency_symbol",
                                                          
                                                          
                                                          @"hourly_rate"      :        @"hourly_rate",
                                                          
                                                          
                                                                @"name"   :   @"name",
                                                          
                                                          
                                                          @"description"  :  @"projectDescription",
                                                          
                                                          @"id"  :   @"projectId",
                                                          
                                                          @"star"   :    @"star",
                                                          
                                                          
                                                          @"total_planned"  :   @"total_planned",
                                                          
                                                          @"total_tracked"   :   @"total_tracked",
                                                          
                                                          @"tags"   : @"tags"
                                                          
                                                          
                                                          
                                                          }];
    
    
    ProjectsMapping.identificationAttributes = @[ @"projectId"];
    RKResponseDescriptor *ProjectsresponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:ProjectsMapping method:RKRequestMethodGET pathPattern:@"/projects.json" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
//    RKResponseDescriptor *DeleteTagsresponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:ProjectsMapping method:RKRequestMethodDELETE pathPattern:@"/projects/:projectId/cards/:cardId/tags" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
//    [objectManager.router.routeSet addRoute:[RKRoute routeWithName:@"DeleteTags" pathPattern:@"/projects/:projectId/cards/:cardId/tags" method:RKRequestMethodDELETE]];
    
    [ProjectsMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"users" toKeyPath:@"toUsersRelationship" withMapping:UsersMapping ]];
    
    [objectManager addResponseDescriptor:ProjectsresponseDescriptor];
   // [objectManager addResponseDescriptor:DeleteTagsresponseDescriptor];
    
    RKResponseDescriptor *SingleProjectresponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:ProjectsMapping method:RKRequestMethodGET pathPattern:@"/projects/:projectId.json" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    
    [objectManager addResponseDescriptor:SingleProjectresponseDescriptor];
    //comments mapping
    
    
    RKEntityMapping *CommentsMapping = [RKEntityMapping mappingForEntityForName:@"Comment" inManagedObjectStore:managedObjectStore];
    [CommentsMapping addAttributeMappingsFromDictionary:@{
                                                          
                                                          @"card":             @"card_id",
                                                          
                                                          @"comment" :             @"comment",
                                                          
                                                          @"id"   :             @"commentId",
                                                          
                                                          @"created_at"   :        @"created_at",
                                                          
                                                          
                                                          @"updated_at"      :        @"updated_at",
                                                          
                                                          
                                                          @"user_id"   :   @"user_id"
                                                          
                                                          
                                                          
                                                          
                                                          }];

    CommentsMapping .identificationAttributes = @[ @"commentId"];
    [CommentsMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user" toKeyPath:@"toUsersRelationship" withMapping:UsersMapping ]];
    
    RKResponseDescriptor *getCommentsresponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:CommentsMapping method:RKRequestMethodPOST pathPattern:@"/projects/:projectId/cards/:cardId/comments.json" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    RKResponseDescriptor *AddCommentsresponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:CommentsMapping method:RKRequestMethodPOST pathPattern:@"/projects/:projectId/cards/:cardId/comments.json" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    RKResponseDescriptor *EditCommentsresponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:CommentsMapping method:RKRequestMethodPUT pathPattern:@"/projects/:projectId/cards/:cardId/comments/:commentId.json" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];

     [objectManager.router.routeSet addRoute:[RKRoute routeWithName:@"getCommentsForCard" pathPattern:@"/projects/:projectId/cards/:cardId/comments.json" method:RKRequestMethodGET]];
    [objectManager.router.routeSet addRoute:[RKRoute routeWithName:@"addCommentsForCard" pathPattern:@"/projects/:projectId/cards/:cardId/comments.json" method:RKRequestMethodPOST]];
    [objectManager.router.routeSet addRoute:[RKRoute routeWithName:@"editCommentsForCard" pathPattern:@"/projects/:projectId/cards/:cardId/comments/:commentId.json" method:RKRequestMethodPUT]];
    
    [objectManager addResponseDescriptor:AddCommentsresponseDescriptor];
    [objectManager addResponseDescriptor:getCommentsresponseDescriptor];
    [objectManager addResponseDescriptor:EditCommentsresponseDescriptor];
    
    
    
    //Time Entery mapping
    
    RKEntityMapping *TimeEnteryMapping = [RKEntityMapping mappingForEntityForName:@"TimeEntery" inManagedObjectStore:managedObjectStore];
    [TimeEnteryMapping addAttributeMappingsFromDictionary:@{
                                                          
                                                          @"tracked":             @"tracked",
                                                          
                                                          @"user_email" :             @"user_email",
                                                          
                                                          @"user_id"   :             @"user_id",
                                                          
                                                          @"user_name"   :        @"user_name",
                                                          
                                                          @"logged_date"  :  @"logged_date",
                                                          
                                                          @"desc"   :  @"enteryDescription",
                                                          
                                                          
                                                          @"id"   :   @"enteryId"
                                                         
                                                          
                                                          
                                                          
                                                          }];
    
    TimeEnteryMapping.identificationAttributes=@[ @"enteryId"];
    RKResponseDescriptor *AddTimeEnteryResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:TimeEnteryMapping method:RKRequestMethodPOST pathPattern:@"/projects/:projectId/cards/:cardId/time_entry" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    RKResponseDescriptor *ChangeTimeEnteryResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:TimeEnteryMapping method:RKRequestMethodPUT pathPattern:@"/projects/:projectId/cards/:cardId/time_entry/:enteryId" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];

    
    [objectManager addResponseDescriptor:ChangeTimeEnteryResponseDescriptor];
    [objectManager addResponseDescriptor:AddTimeEnteryResponseDescriptor];
//ToDo mapping
    
    RKEntityMapping *ToDoMapping = [RKEntityMapping mappingForEntityForName:@"Todo" inManagedObjectStore:managedObjectStore];
    [ToDoMapping addAttributeMappingsFromDictionary:@{
                                                            
                                                            @"done":             @"done",
                                                            
                                                            @"name" :             @"name",
                                                            
                                                            @"id"   :             @"todoId",
                                                            
                                                            
                                                            
                                                            
                                                          
                                                            
                                                            
                                                            
                                                            
                                                            }];
    
    
    ToDoMapping.identificationAttributes=@[ @"todoId"];
    
    
    RKResponseDescriptor *AddToDoInList = [RKResponseDescriptor responseDescriptorWithMapping:ToDoMapping method:RKRequestMethodPOST pathPattern:@"/projects/:projectId/cards/:cardId/todo_lists/:listId/todos"keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    
    RKResponseDescriptor *UpdateToDoInList = [RKResponseDescriptor responseDescriptorWithMapping:ToDoMapping method:RKRequestMethodPUT pathPattern:@"/projects/:projectId/cards/:cardId/todo_lists/:listId/todos/:todoId"keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];

    
    [objectManager addResponseDescriptor:AddToDoInList];
    [objectManager addResponseDescriptor:UpdateToDoInList];
    
    
//TodoList Mapping
    
    RKEntityMapping *ToDoListMapping = [RKEntityMapping mappingForEntityForName:@"TodoList" inManagedObjectStore:managedObjectStore];
    [ToDoListMapping addAttributeMappingsFromDictionary:@{
                                                            
                                                            
                                                            
                                                            @"name" : @"name",
                                                            
                                                            @"id"  :  @"listId"
                                                            
                                                            
                                                            
                                                            
                                                            
                                                            
                                                            
                                                            
                                                            
                                                            }];
    
    
    ToDoListMapping.identificationAttributes=@[ @"listId"];

     [ToDoListMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"todos" toKeyPath:@"todos" withMapping:ToDoMapping ]];
    
    
    
//cardMapping
    


    
    
    RKEntityMapping *CardMapping = [RKEntityMapping mappingForEntityForName:@"Card" inManagedObjectStore:managedObjectStore];
    [CardMapping addAttributeMappingsFromDictionary:@{
                                                            
                                                            @"description":             @"cardDescription",
                                                            
                                                            @"id" :             @"cardId",
                                                            
                                                            @"name"   :             @"name",
                                                            
                                                            
                                                            
                                                            @"position":             @"position",
                                                            
                                                            @"color" :             @"color",
                                                            
                                                            @"duedate"   :             @"duedate",
                                                            
                                                            
                                                            @"startdate" :             @"startdate",
                                                            
                                                            @"planned_time"   :             @"planned_time",
                                                            
                                                            
                                                            
                                                            @"done_todos":             @"done_todos",
                                                            
                                                            @"todos_count"  :          @"todos_count",
                                                            
                                                            
                                                            @"created_at"   :             @"created_at",
                                                            
                                                            
                                                            
                                                            @"updated_at":             @"updated_at",
                                                            
                                                            @"stage_id" :    @"stage_id",
                                                            
                                                            @"total_tracked" : @"total_tracked",
                                                            
                                                            
                                                            @"tags"   : @"tags",
                                                            
                                                            @"done" : @"done",
                                                            
                                                            @"hidden" : @"hidden",
                                                            
                                                            @"blocked" :  @"blocked",
                                                            
                                                            @"onhold"  : @"onhold",
                                                            
                                                            @"ready"  :  @"ready",
                                                            
                                                            
                                                            @"comments_count" : @"comments_count",
                                                            
                                                            
                                                            @"attachments_count" :  @"attachments_count"
                                                            

                                                            
                                                            
                                                            }];
    CardMapping.identificationAttributes = @[ @"cardId"];
    [CardMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"users" toKeyPath:@"toAssignedUsersRelationship" withMapping:UsersMapping ]];
    [CardMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user" toKeyPath:@"toUsersRelationship" withMapping:UsersMapping ]];
     [CardMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"time_entries" toKeyPath:@"toTimeEnteriesRelationship" withMapping:TimeEnteryMapping ]];
    [CardMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"todo_lists" toKeyPath:@"toToDoListsRelationship" withMapping:ToDoListMapping ]];

         [objectManager.router.routeSet addRoute:[RKRoute routeWithName:@"SingleCard" pathPattern:@"/projects/:projectId/cards/:cardId.json" method:RKRequestMethodPOST]];
      RKResponseDescriptor *CardresponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:CardMapping method:RKRequestMethodPOST pathPattern:@"/projects/:projectId/cards/:cardId.json"keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    
    RKResponseDescriptor *UpdateCardresponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:CardMapping method:RKRequestMethodPUT pathPattern:@"/projects/:projectId/cards/:cardId.json"keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];

    
    RKResponseDescriptor *AddCardresponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:CardMapping method:RKRequestMethodPOST pathPattern:@"/projects/:projectId/card_add.json"keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    RKResponseDescriptor *MoveCardresponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:CardMapping method:RKRequestMethodPOST pathPattern:@"/projects/:projectId/cards/:cardId/move"keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];

    [objectManager.router.routeSet addRoute:[RKRoute routeWithName:@"AddACard" pathPattern:@"/projects/:projectId/card_add.json" method:RKRequestMethodPOST]];
    
      [objectManager addResponseDescriptor:CardresponseDescriptor];
    [objectManager addResponseDescriptor:AddCardresponseDescriptor];
    [objectManager addResponseDescriptor:UpdateCardresponseDescriptor];
    [objectManager addResponseDescriptor:MoveCardresponseDescriptor];
 //Project Cards Mapping
    
    RKEntityMapping *ProjectCardsMapping = [RKEntityMapping mappingForEntityForName:@"ProjectCards" inManagedObjectStore:managedObjectStore];
    [ProjectCardsMapping addAttributeMappingsFromDictionary:@{
                                                            
                                                            @"id":             @"cardsId",
                                                            
                                                            @"name" :             @"name",
                                                            
                                                            @"position" :    @"position"
            
                                                            
                                                            }];

    
    
        ProjectCardsMapping.identificationAttributes = @[ @"cardsId"];
    [ProjectCardsMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"cards" toKeyPath:@"toCardsRelationship" withMapping:CardMapping ]];
    
    [objectManager.router.routeSet addRoute:[RKRoute routeWithName:@"ProjectCards" pathPattern:@"/projects/:projectId/cards.json" method:RKRequestMethodGET]];
    RKResponseDescriptor *ProjectCardsresponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:ProjectCardsMapping method:RKRequestMethodGET pathPattern:@"/projects/:projectId/cards.json"keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
   
    [objectManager addResponseDescriptor:ProjectCardsresponseDescriptor];

    
//item mapping
    
    RKEntityMapping *ItemMapping = [RKEntityMapping mappingForEntityForName:@"Item" inManagedObjectStore:managedObjectStore];
    [ItemMapping addAttributeMappingsFromDictionary:@{
                                                          
                                                          @"changed":             @"changed",
                                                          
                                                          
                                                          @"item_old":             @"item_old"
                                                          
                                                         
                                                          
                                                          
                                                          }];

  
    RKEntityMapping *StageMapping = [RKEntityMapping mappingForEntityForName:@"Stage" inManagedObjectStore:managedObjectStore];
    [StageMapping addAttributeMappingsFromDictionary:@{
                                                      
                                                      @"created_at":             @"created_at",
                                                      
                                                      
                                                      @"name":             @"name",
                                                      
                                                      
                                                      @"updated_at":             @"updated_at",
                                                      
                                                      
                                                      @"id":             @"stageId"
                                                      
                                                      
                                                      
                                                      
                                                      }];

    
    
    
//Activity mapping
    
    RKEntityMapping *ActivityMapping = [RKEntityMapping mappingForEntityForName:@"Activity" inManagedObjectStore:managedObjectStore];
    [ActivityMapping addAttributeMappingsFromDictionary:@{
                                                              
                                                              @"id":             @"activityId",
                                
                                                              
                                                              @"created_at":             @"created_at",
                                                              
                                                              @"action" :             @"action",
                                                              
                                                              @"message" :  @"message"
                                                              
                                                              
                                                              }];
    
    ActivityMapping.identificationAttributes = @[ @"activityId"];
    [ActivityMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"item" toKeyPath:@"toItemRelationship" withMapping:ItemMapping ]];
    [ActivityMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"stage" toKeyPath:@"toStageRelationship" withMapping: StageMapping]];
    
   [ActivityMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"card" toKeyPath:@"toCardRelationship" withMapping:CardMapping ]];
    
    [ActivityMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"project" toKeyPath:@"toProjectRelationship" withMapping:ProjectsMapping ]];
    
    
     [ActivityMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user" toKeyPath:@"toUsersRelationship" withMapping:UsersMapping ]];
    
    
    [objectManager.router.routeSet addRoute:[RKRoute routeWithName:@"GetAllActivities" pathPattern:@"/activities.json" method:RKRequestMethodGET]];
    RKResponseDescriptor *AllActivitiesresponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:ActivityMapping method:RKRequestMethodGET pathPattern:@"/activities.json"keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [objectManager addResponseDescriptor:AllActivitiesresponseDescriptor];
    
    

    
}



@end
