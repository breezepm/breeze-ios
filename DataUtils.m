//
//  DataUtils.m
//  breeze
//
//  Created by Breeze on 05.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import "DataUtils.h"
#import "RTLabel.h"
#import "ProjectCards.h"
#import "Project.h"
#import "Card.h"
#import "Comment.h"
#import "TimeEntery.h"
#import "PDKeychainBindings.h"
#import "RTLabel.h"
#import "TagsCell.h"
#import "ColorwithHex.h"
#import "Todo.h"
#import "TodoList.h"
#import "TodoListContentCell.h"
#import "ProjectDetailedTodoListsCell.h"




@implementation DataUtils

static DataUtils *sharedInstance=nil;

+(DataUtils *)getInstance
{
    
    @synchronized(self){
        if (sharedInstance==nil) {
            sharedInstance=[[DataUtils alloc]init];
        }
        
    }
    
    return sharedInstance;
}
-(id)init
{
    if (self=[super init]) {
        self.shouldDisableTableviewScroll=NO;
        
        //self.unsuccesfullRequestsArray=[self loadUnsuccesfullRequestsArrayFromFile];
        self.offlineSyncCounter=0;
        self.offlineCommentsSyncCounter=0;
        self.isSynchronizationRunning=NO;
        self.synchronizationHasFailures=NO;
        self.unsuccesfullRequestsArray=[[NSMutableArray alloc]init];
        self.removedRequestsArray=[[NSMutableArray alloc]init];
        
        self.IconCellNib = [UINib nibWithNibName:@"DescriptionIconCell" bundle:nil];
        self.IconTodosNib = [UINib nibWithNibName:@"TodosIconCell" bundle:nil];
        self.IconDatesNib=[UINib nibWithNibName:@"DatesIconCell" bundle:nil];
        self.IconCommentsNib=[UINib nibWithNibName:@"CommentsIconCell" bundle:nil];
        self.IconTimesNib=[UINib nibWithNibName:@"TimesIconCell" bundle:nil];
        self.IconTagsNib=[UINib nibWithNibName:@"TagsIconCell" bundle:nil];
        self.IconAttachmentsNib=[UINib nibWithNibName:@"AttachmentsIconCell" bundle:nil];
        
        self.placeholderImage=[[UIImage alloc]init];
        self.dragedCell=[[UITableViewCell alloc]init];
        self.lastPlaceholderList=[[NSNumber alloc]init];
    }
    return self;
}


-(UIColor *)backgroundColor
{
    return [UIColor colorWithRed:0.9843137254902 green:0.9843137254902 blue:0.9843137254902 alpha:1.0];
    
}

-(UIColor *)signInButtonColour
{
    return [UIColor colorWithRed:0.25882352941176 green:0.54509803921569 blue:0.7921568627451 alpha:1.0];
}

-(UIColor *)taskMenuBackgroundcolor
{
    return [UIColor colorWithRed:0.89019607843137 green:0.89019607843137 blue:0.89019607843137 alpha:1.0];
}

-(UIColor *)unsynchronizedCommentsBackgroundColor
{
   return  [UIColor greenColor];
}
-(UIColor *)unsynchronizedTasksStatusColor
{
    return [UIColor greenColor];
}

-(UIColor *)whiteColor
{
    return  [UIColor whiteColor];
}

-(UIColor *)borderColor
{
    return  [UIColor grayColor];
}

-(UIColor *)blueColor
{
    return [UIColor blueColor];
}

-(NSString *)getActivityCellStringFromActivity:(Activity *)activity
{
    NSString *retString=[[NSString alloc]init];
    
    
    return retString;
}

-(NSString *)createActivityDescriptionStringFromActivity:(Activity *)activity
{
  
    User *activityUser=[[activity.toUsersRelationship allObjects]firstObject];
    NSString *retString=[NSString stringWithFormat:@"<b>%@ </b>%@",activityUser.name,activity.message ];
    
    NSLog(@"createActivityDescriptionStringFromActivity:%@",retString);
    return retString;
}

-(NSString *)getHourFromActivityTimeString:(NSString *)timeString
{
    NSLog(@"getHourFromActivityTimeString:%@",timeString);
    
    NSDateFormatter *toDateFormatter=[[NSDateFormatter alloc]init];
    [toDateFormatter setDateFormat:@"YYYY'-'MM'-'dd'T'hh':'mm':'ss'Z'"];
    NSDate *tempDate=[toDateFormatter dateFromString:timeString];
    NSLog(@"temp date:%@",tempDate);
    NSDateFormatter *toStringFormatter=[[NSDateFormatter alloc]init];
    //[toStringFormatter setDateFormat:@"HH:mm"];
    [toStringFormatter setDateStyle:NSDateFormatterNoStyle];
    [toStringFormatter setTimeStyle:NSDateFormatterShortStyle];
    
   return  [toStringFormatter stringFromDate:tempDate];
}

-(NSString *)getSectionNameFromDate:(NSString *)dateString
{
    NSDateFormatter *toDateFormatter=[[NSDateFormatter alloc]init];
    [toDateFormatter setDateFormat:@"YYYY'-'MM'-'dd"];
    NSDate *tempDate=[toDateFormatter dateFromString:dateString];
    NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:tempDate];
    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    if([today day] == [otherDay day] &&
       [today month] == [otherDay month] &&
       [today year] == [otherDay year] &&
       [today era] == [otherDay era]) {
        return @"Today";
    }
    
    else
    {
        NSLog(@"temp date:%@",tempDate);
        NSDateFormatter *toStringFormatter=[[NSDateFormatter alloc]init];
        [toStringFormatter setDateFormat:@"dd MMMM"];
        NSString *outputDateString=[toStringFormatter stringFromDate:tempDate];
        
        NSDateFormatter* theDateFormatter = [[NSDateFormatter alloc] init];
        [theDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [theDateFormatter setDateFormat:@"EEEE"];
        NSString *weekDay =  [theDateFormatter stringFromDate:tempDate];
        
        
        
        return [NSString stringWithFormat:@"%@, %@",weekDay,outputDateString];
    }
    
    
    
    
}
-(NSString *)getActivitySectionDateStringFromDateString:(NSString *)dateString
{
    return [[dateString componentsSeparatedByString:@"T"] firstObject];
}

-(NSArray *)getProjectCardsFromDatabaseForProject:(Project *)selectedProject
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ProjectCards"
                                              inManagedObjectContext:[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    [fetchRequest setEntity:entity];
    NSString * predicateString=[NSString stringWithFormat:@"projectId == %@",selectedProject.projectId ];
      NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"position"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSError *error = nil;
    
    NSArray *fetchedObjects = [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext
                               executeFetchRequest:fetchRequest error:&error];

    return fetchedObjects;
}

-(NSArray *)getProjectCardsWithStageId:(NSString *)stageid
{
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Card" inManagedObjectContext:[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext];
    NSLog(@"set predicate with cardsid:%@",stageid);
   NSString * predicateString=[NSString stringWithFormat:@"stage_id == %@",stageid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
   [fetchRequest setPredicate:predicate];
    
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    
    NSArray *fetchedObjects = [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext
                               executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
}

-(void)getProjectCardsForProfect:(Project *)selectedProject
{
    NSLog(@"get project cards for project with id:%@",selectedProject.projectId);
    [[RKObjectManager sharedManager] getObjectsAtPathForRouteNamed:@"ProjectCards" object:selectedProject parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"download project cards (count):%d",[mappingResult.array count]);
        NSLog(@"mapping result project cards:%@",mappingResult.array);
        //ProjectCards
    
        
        NSError *error;
        //[[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext saveToPersistentStore:&error];
        
        if (error) {
            NSLog(@"error:%@",error.description);
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
        NSLog(@"downloading error:%@",error.description);
        
        
    }];
    
    
}


- (void)MoveCardWithId:(NSString *)cardId ProjectId:(NSString *)projectId stage_id:(NSString *)StageId prev_id:(NSString *)prevId completion:(void (^)(BOOL success ,NSString  *result))completionBlock

{
    NSLog(@"move card: %@ project id:%@ stageId:%@ prev_id:%@",cardId,projectId,StageId,prevId);
    NSLog(@"Draged card before move:%@",DATAUTILS.dragedCard);
    
    NSNumber *previousPosition=[DATAUTILS.dragedCard.position copy];
    NSNumber *previousStage=[DATAUTILS.dragedCard.stage_id copy];
    
    NSArray *objectsArray=[NSArray arrayWithObjects:StageId,prevId, nil];
   // NSArray *objectsArray=[NSArray arrayWithObjects:[[NSDecimalNumber alloc]initWithString:StageId],[[NSDecimalNumber alloc]initWithString:prevId], nil];

    NSArray *keysArray=[NSArray arrayWithObjects:@"stage_id",@"prev_id", nil];
    NSDictionary *params=[NSDictionary dictionaryWithObjects:objectsArray forKeys:keysArray];
  

    NSString *path=[NSString stringWithFormat:@"/projects/%@/cards/%@/move",projectId,cardId ];
    
    [[RKObjectManager sharedManager]postObject:nil path:path parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"Card moved sucesfully: %@",mappingResult.array);
        if ([previousStage integerValue]!=[DATAUTILS.dragedCard.stage_id integerValue]) {
            for (Card *card in mappingResult.array) {
                NSLog(@"AFTER MOVE:%@",card);
                card.projectId=_selectedProject.projectId;
            }
            
            NSArray *previousListCards=[self getCardsFromList:previousStage];
            int pos=1;
            for (Card *cardToMove in previousListCards) {
                NSLog(@"PREVIOUS LIST CARD:%@ POSITION:%@",cardToMove.name,cardToMove.position);
                if ([cardToMove.cardId integerValue]!=[DATAUTILS.dragedCard.cardId integerValue]) {
                    cardToMove.position=[[NSNumber alloc]initWithInteger:pos];
                    pos++;
                }
                
            }
            [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext saveToPersistentStore:nil];
            int j=0;
            int dragedCardPos=[DATAUTILS.dragedCard.position intValue];
            NSArray *destinationListCards=[self getCardsFromList:DATAUTILS.dragedCard.stage_id];
            for (Card *cardOnList in destinationListCards) {
                if ([cardOnList.cardId integerValue]!=[DATAUTILS.dragedCard.cardId integerValue]) {
                    if ([cardOnList.position intValue]>=dragedCardPos) {
                        j++;
                        cardOnList.position=[[NSNumber alloc]initWithInt:dragedCardPos+j];
                    }
                }
                
            }
            
            DATAUTILS.dragedCard.shouldBeHidden=[[NSNumber alloc]initWithInt:0];
            [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext saveToPersistentStore:nil];
            
            completionBlock(YES,@"card moved succesfully");

        }
    else
    {
        int j=0;
        int dragedCardPos=[DATAUTILS.dragedCard.position intValue];
        NSArray *destinationListCards=[self getCardsFromList:DATAUTILS.dragedCard.stage_id];
        for (Card *cardOnList in destinationListCards) {
            if ([cardOnList.cardId integerValue]!=[DATAUTILS.dragedCard.cardId integerValue]) {
                if ([cardOnList.position intValue]>=dragedCardPos) {
                    j++;
                    cardOnList.position=[[NSNumber alloc]initWithInt:dragedCardPos+j];
                }
            }
            
        }
        
        DATAUTILS.dragedCard.shouldBeHidden=[[NSNumber alloc]initWithInt:0];
        [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext saveToPersistentStore:nil];
        
        completionBlock(YES,@"card moved succesfully");

    }
        

        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"erorr while moving the card:%@", operation.HTTPRequestOperation.responseString);
         completionBlock(NO,error.description);
    }];
    
    

    
    
    
}

- (void)MoveCardWithId:(NSString *)cardId ProjectId:(NSString *)projectId stage_id:(NSString *)StageId prev_id:(NSString *)prevId
{
    NSLog(@"Move card with id:%@ project id:%@ stage_id:%@ prev_id:%@",cardId,projectId,StageId,prevId);
    
    
    
    [self MoveCardWithId:cardId ProjectId:projectId stage_id:StageId prev_id:prevId completion:^(BOOL success, NSString *result) {
        if (success) {
            NSLog(@"card moved succesfully");
            NSLog(@"result:%@",result);
            
            
            


          
            
            
        
        }
        else
        {
            NSLog(@"moving card error");
            NSLog(@"result:%@",result);
            [DATAUTILS DisplayPopupWithTitle:@"Network error" andMessage:@"Can't move the task, please try again later"];
        }
    }];
}

-(void)test
{
    NSArray *ProjectCardsArray=[self getProjectCardsFromDatabaseForProject:self.selectedProject];
    for (ProjectCards *pCards in ProjectCardsArray) {
        
        NSArray *CardArray=[self getProjectCardsWithStageId:[pCards.projectId stringValue]];
        NSLog(@"card array count:%lu",(unsigned long)[CardArray count]);
        for (Card *c in CardArray) {
            NSLog(@"c name:%@",c.name);
            NSLog(@"c stageid:%@",c.stage_id);
        }
        for (Card *cPr in [pCards.toCardsRelationship allObjects]) {
            NSLog(@"cpr name:%@",cPr.name);
            NSLog(@"cpr stageid:%@",cPr.stage_id);
        }
        
    }
    
}

-(void)DisplayPopupWithTitle:(NSString *)pop_title andMessage:(NSString *)pop_message
{
    UIAlertView *popup_alert = [[UIAlertView alloc] initWithTitle:pop_title
                                                          message:pop_message
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
    [popup_alert show];
    
}

-(NSArray *)createSectionNamesArrayFromCard:(Card *)card andCommentsArray:(NSArray *)commentsArray
{
    NSLog(@"card todolist:%@",[card.toToDoListsRelationship allObjects]);
    NSArray *tagsArray=card.tags;
    NSLog(@"create section names array from card");
    NSMutableArray *retArray=[[NSMutableArray alloc]init];
    [retArray addObject:@"name"];
    if (card.cardDescription!=nil  || [card.cardDescription length]!=0) {
        [retArray addObject:@"description"];
    }
    if ([[card.toToDoListsRelationship allObjects] count]!=0) {
        [retArray addObject:@"todo"];
    }
    if ([card.startdate length]!=0 || [card.duedate length]!=0) {
        [retArray addObject:@"Dates"];
    }
    
    if ([card.toTimeEnteriesRelationship count]!=0) {
        [retArray addObject:@"Time Tracking"];
    }
    if ([tagsArray count]!=0) {
        [retArray addObject:@"Tags"];
    }
    if ([commentsArray  count]!=0) {
        [retArray addObject:@"Discussion"];
    }
   
//
    [retArray addObject:@"button"];
    NSLog(@"sections:%@",retArray);
    return retArray;
    
}

-(NSInteger)countNumberofObjectsInDetailedTaskControllerForCard:(Card *)card andSectionName:(NSString *)sectionName andCommentsArray:(NSArray *)commentsArray
{
    if ([sectionName isEqualToString:@"name"] || [sectionName isEqualToString:@"description"] || [sectionName isEqualToString:@"button"] || [sectionName isEqualToString:@"Dates"]) {
        if ([sectionName isEqualToString:@"description"] && [card.cardDescription length]==0) {
            return 0;
        }
        
        else
        {
            return 1;
 
        }
        }
    else if([sectionName isEqualToString:@"Time Tracking"])
    {
        return [card.toTimeEnteriesRelationship count];
    }
    else if ([sectionName isEqualToString:@"Tags"])
    {
       // NSArray *tagsArray=card.tags;
        return 1;
    }
    else if ([sectionName isEqualToString:@"todo"])
    {
        return 1;
    }
    else
    {
       return  [commentsArray count];
    }
    
}
-(NSArray *)createCommentsArrayFromCard:(Card *)card
{
    NSLog(@"create comments array");
  //  return [card.toCommentsRelationship allObjects];
  
   NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"created_at" ascending:YES];
    NSArray *sortDescriptors=[[NSArray alloc]init];
    sortDescriptors = @[sortDescriptor];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Comment" inManagedObjectContext:[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext];
    
    NSString * predicateString=[NSString stringWithFormat:@"card_id ==%@",card.cardId];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    
    NSArray *fetchedObjects = [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext
                               executeFetchRequest:fetchRequest error:&error];
    NSLog(@"fetched %lu comments",(unsigned long)[fetchedObjects count]);
   // retArray=[fetchedObjects sortedArrayUsingDescriptors:sortDescriptors];
   // retArray=[[card.toCommentsRelationship allObjects]sortedArrayUsingDescriptors:sortDescriptors];
    NSLog(@"comments array created");
    return fetchedObjects;
}
-(NSArray *)createTimeEnteriesSortedArrayFromCard:(Card *)card
{

    return [card.toTimeEnteriesRelationship allObjects];
}

-(NSString *)createTimeEnteryDateFromTimestampString:(NSString *)timestampString
{
    if ([timestampString length]>0) {
        NSDateFormatter *toDateFormatter=[[NSDateFormatter alloc]init];
        [toDateFormatter setDateFormat:@"YYYY'-'MM'-'dd"];
        NSDate *tempDate=[toDateFormatter dateFromString:timestampString];
        NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:tempDate];
        NSDateComponents *today = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
        if([today day] == [otherDay day] &&
           [today month] == [otherDay month] &&
           [today year] == [otherDay year] &&
           [today era] == [otherDay era]) {
            return @"Today";
        }
        
        else if(tempDate!=NULL)
        {
            NSLog(@"temp date:%@",tempDate);
            NSDateFormatter *toStringFormatter=[[NSDateFormatter alloc]init];
            [toStringFormatter setDateFormat:@"dd MMMM"];
            NSString *outputDateString=[toStringFormatter stringFromDate:tempDate];
           
            return outputDateString;
        }
        else
        {
            return @"";
        }
    }

    else
    {
        return @"";
    }
    

}

-(NSString *)createPostedByStringFromTimestamp:(NSString *)timestampString
{
    
    if ([timestampString length]>0) {
        NSString *toConvertString=[[timestampString componentsSeparatedByString:@"T"]firstObject];
        NSString *retString=[self createTimeEnteryDateFromTimestampString:toConvertString];
        
        if ([retString isEqualToString:@"Today"]) {
            return @"Today";
        }
        else
        {
            return [NSString stringWithFormat:@"on %@",retString ];
        }

    }
    
    else
    {
        return @" ";
    }
    
}

- (void)createCommentToProject:(NSString *)projectId CardId:(NSString *)cardId withText:(NSString *)commentText completion:(void (^)(BOOL success ,NSSet   *result))completionBlock

{
    NSLog(@"Add comment:%@ to project:%@ in card:%@",commentText,projectId,cardId);
    
    if ([commentText length]>0) {
        
        
        
        NSArray *objectsArray=[NSArray arrayWithObjects:commentText, nil];
        // NSArray *objectsArray=[NSArray arrayWithObjects:[[NSDecimalNumber alloc]initWithString:StageId],[[NSDecimalNumber alloc]initWithString:prevId], nil];
        
        NSArray *keysArray=[NSArray arrayWithObjects:@"comment", nil];
        NSDictionary *params=[NSDictionary dictionaryWithObjects:objectsArray forKeys:keysArray];
        AFHTTPClient *client =[[RKObjectManager sharedManager]HTTPClient];
        
        NSString *path=[NSString stringWithFormat:@"/projects/%@/cards/%@/comments.json",projectId,cardId ];
        NSURLRequest *request = [client requestWithMethod:@"POST" path:path parameters:params];
        
        NSLog(@"params:%@",params);
        NSLog(@"path:%@",path);
        [[RKObjectManager sharedManager]postObject:nil path:path parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            NSLog(@"comment added:%@",mappingResult.array);
            for (Comment *c in mappingResult.array) {
                
                c.card_id=DATAUTILS.selectedCard.cardId;
                NSLog(@"comment:cardid:%@",c.card_id);
            }
            
            
            NSError *error;
            int commentCountTemp=[DATAUTILS.selectedCard.comments_count integerValue];
            commentCountTemp++;
            DATAUTILS.selectedCard.comments_count=[[NSNumber alloc]initWithInt:commentCountTemp];
            [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext saveToPersistentStore:&error];
            

              completionBlock(YES, [mappingResult set]);
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"error while adding a comment:%@",error.description);
            if (error.code==-1009) {
                [DATAUTILS DisplayPopupWithTitle:@"Synchronization" andMessage:@"Changes will be synchronized later"];
                [DATAUTILS addUnsuccesfullRequest:request];
                
               // Comment *unsynchronizedComment=[[Comment alloc]init];
                
               Comment *unsynchronizedComment = [NSEntityDescription
                                                insertNewObjectForEntityForName:@"Comment"
                                                inManagedObjectContext:[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext];
                unsynchronizedComment.isUnSynchronized =[[NSNumber alloc]initWithInt:1];
                //unsynchronizedComment.commentId=[[NSNumber alloc]initWithInt:123457890];
                unsynchronizedComment.card_id=DATAUTILS.selectedCard.cardId;
                unsynchronizedComment.comment=commentText;
                unsynchronizedComment.created_at=[DATAUTILS getDueDateStringFromDate:[NSDate date]];
                int commentCountTemp=[DATAUTILS.selectedCard.comments_count integerValue];
                commentCountTemp++;
                DATAUTILS.selectedCard.comments_count=[[NSNumber alloc]initWithInt:commentCountTemp];
                NSError *error;
                [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext saveToPersistentStore:&error];
                if (error) {
                    NSLog(@"Error while saving unsynced comment:%@",error.description);
                }
                
                else
                {
                    NSLog(@"unsynchronized comment saved:%@",unsynchronizedComment);
                }
                
                  completionBlock(YES, nil);
            }
            else
            {
                
                [DATAUTILS DisplayPopupWithTitle:@"Network error" andMessage:error.description];
                completionBlock(NO, nil);

            }
            
        }];
        
        
        

    }
    
    
    
    
}

- (void)editCommentToProject:(NSString *)projectId CardId:(NSString *)cardId CommentId:(NSString *)commentId withText:(NSString *)commentText completion:(void (^)(BOOL success ,NSSet  *result))completionBlock

{
    NSLog(@"Add comment:%@ to project:%@ in card:%@ with CommentID:%@",commentText,projectId,cardId,commentId);
    
    if ([commentText length]>0) {
        
        
        
        NSArray *objectsArray=[NSArray arrayWithObjects:commentText, nil];
        // NSArray *objectsArray=[NSArray arrayWithObjects:[[NSDecimalNumber alloc]initWithString:StageId],[[NSDecimalNumber alloc]initWithString:prevId], nil];
        
        NSArray *keysArray=[NSArray arrayWithObjects:@"comment", nil];
        NSDictionary *params=[NSDictionary dictionaryWithObjects:objectsArray forKeys:keysArray];
        
        NSString *path=[NSString stringWithFormat:@"/projects/%@/cards/%@/comments/%@.json",projectId,cardId,commentId ];
        
           NSLog(@"params:%@",params);
              NSLog(@"path:%@",path);
        
        [[RKObjectManager sharedManager]putObject:nil path:path parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            NSLog(@"mapping result comments %@",mappingResult.array);
            for (Comment *c in mappingResult.array) {
                c.card_id=DATAUTILS.selectedCard.cardId;
            }
            
            NSError *error;
       
            [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext saveToPersistentStore:&error];
            

            completionBlock(YES, [mappingResult set]);
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"error while adding a comment:%@",error.description);
//            if (error.code==-1009) {
//                [DATAUTILS DisplayPopupWithTitle:@"Synchronization" andMessage:@"Changes will be synchronized later"];
//                [DATAUTILS addUnsuccesfullRequest:request];
//            }
             [DATAUTILS DisplayPopupWithTitle:@"Network error" andMessage:error.description];
            completionBlock(NO,nil);
        }];
        


    }
    
    
    
    
}

-(BOOL)checkIfCredentialsChangedUsername:(NSString *)username Password:(NSString *)password
{
    
    NSLog(@"check if credentials changed with ");
    PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
    //[bindings setObject:self.usernameTextField.text forKey:@"username"];
    //[bindings setObject:self.passwordTextField.text forKey:@"password"];
    
    if ([[bindings objectForKey:@"username"]isEqualToString:username] && [[bindings objectForKey:@"password"]isEqualToString:password] ) {
        NSLog(@"NO");
        return NO;
    }
    else
    {
        NSLog(@"YES");
        return YES;
    }
    
}

-(void)downloadActivityListUpdate
{
   
    
    [[RKObjectManager sharedManager] getObjectsAtPathForRouteNamed:@"GetAllActivities" object:nil parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        NSLog(@"mapping result:%@",mappingResult.array);
        
        for (Activity *a in mappingResult.array) {
            a.sectionString=[DATAUTILS getActivitySectionDateStringFromDateString:a.created_at];
            
        }
        
        NSError *error;
        [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext saveToPersistentStore:&error];
        
 
        
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
        NSLog(@"downloading error:%@",error.description);
        //[DATAUTILS DisplayPopupWithTitle:@"Login error" andMessage:@"Please check your credentials"];
        
    }];
}

-(void)downloadProjectListUpdate
{
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/projects.json" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"downloaded");
        
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
        NSLog(@"downloading error");
    }];

}

-(void)downloadUpdates
{
    [self downloadActivityListUpdate];
    [self downloadProjectListUpdate];
    
}
-(CGFloat)countHeightForTextInTaskCellFrameWithWidth:(CGFloat)width andText:(NSString *)text withAtributes:(NSDictionary *)atributesDic
{
  //  NSLog(@"count height for text in cell:%@",text);
    NSLog(@"countHeightForTextInTaskCellFrameWithWidth started");
    NSString *textCoppy=[text copy];
    CGRect retFrame =[textCoppy boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:atributesDic context:nil];
    NSLog(@"result:%f",retFrame.size.height);
    NSLog(@"countHeightForTextInTaskCellFrameWithWidth finished");
    return retFrame.size.height;
    //return 72;
}
-(User *)getUserFromDatabase:(NSString *)username
{
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext];

    NSString * predicateString=[NSString stringWithFormat:@"email ==[c] '%@'",username];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    
    NSArray *fetchedObjects = [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext
                               executeFetchRequest:fetchRequest error:&error];
    
    
    for (User *u in fetchedObjects) {
        if ([u.avatar length]!=0) {
            return u;
        }
    }
    
    
    User *retUser=[fetchedObjects firstObject];
    return retUser;

}

-(User *)getUserWithIdFromDatabase:(NSNumber *)userId
{
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext];
    
    NSString * predicateString=[NSString stringWithFormat:@"userId ==[c] '%@'",userId];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    
    NSArray *fetchedObjects = [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext
                               executeFetchRequest:fetchRequest error:&error];
    
    
    
    for (User *u in fetchedObjects) {
        if ([u.avatar length]!=0) {
            return u;
        }
    }

    User *retUser=[fetchedObjects firstObject];
    return retUser;
    
}



- (void)createCardInProject:(NSString *)projectId withParams:(NSDictionary *)params completion:(void (^)(BOOL success ,NSString  *result))completionBlock

{
    
    

    AFHTTPClient *client =[[RKObjectManager sharedManager]HTTPClient];
    
    NSString *path=[NSString stringWithFormat:@"/projects/%@/card_add.json",projectId ];
    NSURLRequest *request = [client requestWithMethod:@"POST" path:path parameters:params];
    
    NSLog(@"add a card params:%@",params);
    NSLog(@"add a card path:%@",path);
    
    
//    NSURLRequest *request = [[RKObjectManager sharedManager] requestWithPathForRouteNamed:@"AddACard" object:DATAUTILS.selectedProject parameters:params];
//    
    RKManagedObjectRequestOperation *operation = [[RKObjectManager sharedManager] managedObjectRequestOperationWithRequest:request managedObjectContext:[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        
    
             for (Card *card in mappingResult.array) {
                  card.projectId=DATAUTILS.selectedProject.projectId;
                  NSLog(@"card projectid:%@",card.projectId);
                 
                 
                 PDKeychainBindings *bindings=[PDKeychainBindings sharedKeychainBindings];
                 NSString *userName=[bindings objectForKey:@"username"];
                 User *currentUser=[DATAUTILS getUserFromDatabase:userName];
                 
                 if ([card.toUsersRelationship count]==0) {
                     card.toUsersRelationship=[NSSet setWithObject:currentUser];
                 }
                 
                 //  NSLog(@"card cardId:%@",card.cardsId);
                // NSLog(@"card relation:%@",card.toCardsRelationship);
                }
        
                [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext saveToPersistentStore:nil];
        NSLog(@"adding a card mapping result:%@",mappingResult.array);
        completionBlock(YES, @"added a card");

       
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                    if (error.code==-1009) {
                        [DATAUTILS DisplayPopupWithTitle:@"Synchronization" andMessage:@"Changes will be synchronized later"];
                        [DATAUTILS addUnsuccesfullRequest:request];
                        
                        if (params) {
                            NSNumber *stageId=[params objectForKey:@"stage_id"];
                            NSDictionary *cardDictionary=[params objectForKey:@"card"];
                            if (cardDictionary) {
                                NSString *cardName=[cardDictionary objectForKey:@"name"];
                                NSString *carddescription=[cardDictionary objectForKey:@"description"];
                                
                                Card *newCard=[NSEntityDescription
                                               insertNewObjectForEntityForName:@"Card"
                                               inManagedObjectContext:[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext];
                                newCard.projectId=DATAUTILS.selectedProject.projectId;
                                newCard.stage_id=stageId;
                                newCard.name=cardName;
                                newCard.cardDescription=carddescription;
                                newCard.isUnsynchronized=[[NSNumber alloc]initWithInt:1];
                                PDKeychainBindings *bindings=[PDKeychainBindings sharedKeychainBindings];
                                NSString *userName=[bindings objectForKey:@"username"];
                                User *currentUser=[DATAUTILS getUserFromDatabase:userName];
                                newCard.toUsersRelationship=[NSSet setWithObject:currentUser];
                                 [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext saveToPersistentStore:nil];
                                NSLog(@"Created unsynchronized card:%@",newCard);
                                
                                
                            }
                        }
                       
                    }

             NSLog(@"error while adding a card:%@",error.description);
                 completionBlock(NO, @"error while adding a card");
    }];
    
   
    
    [[RKObjectManager sharedManager].operationQueue addOperation:operation];
    
 
    
    
    
    
}


- (void)updateCardInProject:(NSString *)projectId andCard:(NSString *)cardId withParams:(NSDictionary *)params completion:(void (^)(BOOL success ,NSString  *result))completionBlock

{
    
    
    
  
    
    NSString *path=[NSString stringWithFormat:@"/projects/%@/cards/%@.json",projectId,cardId ];
  //  NSURLRequest *request = [client requestWithMethod:@"PUT" path:path parameters:params];

   
    
    [[RKObjectManager sharedManager]putObject:nil path:path parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"edit card mapping result:%@",mappingResult.array);
        
        for (Card *c in mappingResult.array) {
            NSLog(@"edited card name:%@",c.name);
            NSLog(@"edited card project id:%@",c.projectId);
            NSLog(@"edited card stage id:%@",c.stage_id);
            c.projectId=DATAUTILS.selectedProject.projectId;
        }
        [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext saveToPersistentStore:nil];
        completionBlock(YES, @"succesfully edited a card");
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"error while updating a card:%@",error.description);
        completionBlock(NO,@"error while editing the card");
    }];
    
    
    
    
}
-(NSInteger)getNumberOfActivitiesInDatabase
{
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Activity" inManagedObjectContext:[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext];
    
    
    
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    
    NSArray *fetchedObjects = [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext
                               executeFetchRequest:fetchRequest error:&error];
    
    return [fetchedObjects count];
}
-(NSDate *)getDateFromTimestamp:(NSString *)timestamp
{
    NSDateFormatter *toDateFormatter=[[NSDateFormatter alloc]init];
    [toDateFormatter setDateFormat:@"YYYY'-'MM'-'dd"];
    NSDate *tempDate=[toDateFormatter dateFromString:timestamp];
    NSLog(@"get date from timestamp:%@ result:%@",timestamp,tempDate);
    return tempDate;
}
-(NSString *)getDueDateStringFromDate:(NSDate *)inpoutDate
{
    
    NSDateFormatter *toStringFormatter=[[NSDateFormatter alloc]init];
    [toStringFormatter setDateFormat:@"YYYY'-'MM'-'dd"];
    return [toStringFormatter stringFromDate:inpoutDate];

}
-(CGFloat)countHeightforText:(NSString *)text InRTLABELwithWidth:(CGFloat)width
{
    
       RTLabel *tempLabel=[[RTLabel alloc]initWithFrame:CGRectMake(0, 0, width, 999)];
    [tempLabel setText:text];
    CGFloat retHeight=[tempLabel optimumSize].height;
    //NSLog(@"description row height:%f",retHeight);
    return retHeight;
}
-(NSString *)createDuedateStringFromDate:(NSString *)timestampString
{
    NSDateFormatter *toDateFormatter=[[NSDateFormatter alloc]init];
    [toDateFormatter setDateFormat:@"YYYY'-'MM'-'dd"];
    NSDate *tempDate=[toDateFormatter dateFromString:timestampString];
    if (tempDate) {
        NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:tempDate];
        NSDateComponents *today = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
        if([today day] == [otherDay day] &&
           [today month] == [otherDay month] &&
           [today year] == [otherDay year] &&
           [today era] == [otherDay era]) {
            return @"Today";
        }
        else
        {
            NSDateFormatter *toStringFormatter =[[NSDateFormatter alloc]init];
            [toStringFormatter setDateFormat:@"dd, MMM YYYY"];
            return [toStringFormatter stringFromDate:tempDate];
        }
    }
 
    else return @"";

}
-(NSString *)createProjectCardDueDateIconStringFromTimestamp:(NSString *)timestampString
{
    NSDateFormatter *toDateFormatter=[[NSDateFormatter alloc]init];
    [toDateFormatter setDateFormat:@"YYYY'-'MM'-'dd"];
    NSDate *tempDate=[toDateFormatter dateFromString:timestampString];
    if (tempDate) {
        NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:tempDate];
        NSDateComponents *today = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
        if([today day] == [otherDay day] &&
           [today month] == [otherDay month] &&
           [today year] == [otherDay year] &&
           [today era] == [otherDay era]) {
            return @"Today";
        }
        else
        {
            NSDateFormatter *toStringFormatter =[[NSDateFormatter alloc]init];
            [toStringFormatter setDateFormat:@"MMM dd"];
            return [toStringFormatter stringFromDate:tempDate];
        }
    }
    
    else return @"";

}

-(CGFloat)countHeightForTagsCellWithTags:(NSArray *)tagsArray withFontSize:(int)fontsize
{
    NSLog(@"countHeightForTagsCellWithTags started");
    CGFloat xInLine=20;
    int lineNumber=0;
    CGFloat paddingBetweenLines=20;
    CGFloat paddingBetweenItems=20;
    CGFloat labelHeight=25;
    CGFloat cellWidth=300;
    if ([tagsArray count]>0) {
    
        for (NSString *text in tagsArray) {
            NSLog(@"text: %@",text);
            NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [UIFont systemFontOfSize:fontsize], NSFontAttributeName,
                                              nil];
        
            CGRect retFrame =[text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, labelHeight) options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:attributesDictionary context:nil];
            xInLine=xInLine+paddingBetweenItems+retFrame.size.width;
        
            if (xInLine>=cellWidth) {
                lineNumber++;
                xInLine=20+retFrame.size.width;
            }
        
        }
        lineNumber++;
    
        CGFloat retHeight=lineNumber*(paddingBetweenLines+labelHeight);
        NSLog(@"TAGS RET HEIGHT=%f",retHeight);
        
        NSLog(@"countHeightForTagsCellWithTags finished");
        if (retHeight==0) {
            return (2*paddingBetweenLines+labelHeight);
        }
        else
        {
            return retHeight+labelHeight+paddingBetweenLines;
        }
    }
    else
    {
        NSLog(@"tags count = 0");
        return 2*labelHeight;
    }
}
-(UIColor*)toDoListHeaderBackgroundColor
{
    return [UIColor colorWithRed:0.97254901960784 green:0.97254901960784 blue:0.97254901960784 alpha:1.0];
}
-(CGFloat)countHeigtForTodoCellInTaskControllerWithTodoListsArray:(NSArray *)todoListsArray
{
    CGFloat headerHeight=25;
    CGFloat rowHeight=25;
    
    
    CGFloat ret=[todoListsArray count]*headerHeight;
    
    for (TodoList *list in todoListsArray) {
        ret=ret+[list.todos count]*rowHeight;
        
    }
    return ret;
        
}
-(void)addTodo:(Todo *)todoToAdd ToTodoListWithId:(NSNumber *)listId
{
    NSLog(@"add todo on list");
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TodoList" inManagedObjectContext:[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext];
    
    NSString * predicateString=[NSString stringWithFormat:@"listId == %@",listId];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    
    NSArray *fetchedObjects = [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext
                               executeFetchRequest:fetchRequest error:&error];
    TodoList *list=[fetchedObjects firstObject];
    if (list) {
        
        NSLog(@"found list");
        NSMutableOrderedSet *todos=[list.todos mutableCopy];
        [todos addObject:todoToAdd];
        list.todos=todos;
        [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext saveToPersistentStore:&error];
        NSLog(@"added todo");
    }
}
-(BOOL)checkIfTaskIsMarked:(Card *)selectedCard
{
    if ([selectedCard.ready boolValue] || [selectedCard.done boolValue] || [selectedCard.blocked boolValue] || [selectedCard.onhold boolValue] || [selectedCard.isUnsynchronized boolValue]) {
        return YES;
    }
    else
    {
        return NO;
    }
}
-(UIView *)cardStatusHeaderForCard:(Card *)selectedCard
{
     TaskStatusHeader *header=[[[NSBundle mainBundle] loadNibNamed:@"TaskStatusHeader" owner:nil options:nil] objectAtIndex:0];
    [header.statusLabel setTextColor:[ColorwithHex colorWithHexString:@"333333"]];
    if ([selectedCard.done boolValue]) {
        [header.statusLabel setText:@"DONE"];
        header.backgroundColor =[ColorwithHex colorWithHexString:@"eeeeee"];
        
    }
    else if ([selectedCard.ready boolValue])
    {
        [header.statusLabel setText:@"READY"];
        header.backgroundColor =[ColorwithHex colorWithHexString:@"4cd964"];

    }
    else if ([selectedCard.onhold boolValue])
    {
        [header.statusLabel setText:@"ON HOLD"];
         header.backgroundColor =[ColorwithHex colorWithHexString:@"ffcc00"];
    }
    
    else
    {
        [header.statusLabel setText:@"BLOCKED"];
         header.backgroundColor =[ColorwithHex colorWithHexString:@"ff3b30"];
    }
    
    return header;
    
}
-(NSString *)GetTimeTrackingDateStringFromDate:(NSDate *)dateInp
{
    if (dateInp) {
        NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:dateInp];
        NSDateComponents *today = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
        if([today day] == [otherDay day] &&
           [today month] == [otherDay month] &&
           [today year] == [otherDay year] &&
           [today era] == [otherDay era]) {
            return @"Today";
        }
        else
        {
            NSDateFormatter *toStringFormatter =[[NSDateFormatter alloc]init];
            [toStringFormatter setDateFormat:@"dd, MMM YYYY"];
            return [toStringFormatter stringFromDate:dateInp];
        }
    }
    else
    {
        return @"";
    }
}
-(int)getTrackedHoursFromInterval:(NSTimeInterval)interval
{
    return interval/3600;
}

-(NSArray *)getProjectPageCollectionViewSectionsArrayFromCard:(Card *)card
{
    NSMutableArray *retArray=[[NSMutableArray alloc]init];
    [retArray addObject:@"Task Description"];
    if ([[card.toToDoListsRelationship allObjects]count]!=0) {
        [retArray addObject:@"Todos"];
    }
    if ([card.duedate length]>0 || [card.startdate length]>0) {
        [retArray addObject:@"Dates"];
    }
    if ([card.toCommentsRelationship count]>0) {
        [retArray addObject:@"Comments"];
        
    }
    if (card.planned_time!=nil || card.total_tracked!=nil) {
        [retArray addObject:@"Planed Time"];
    }
    
    
    return retArray;
}

-(NSMutableArray *)loadUnsuccesfullRequestsArrayFromFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    
    NSString *fileName = [NSString stringWithFormat:@"%@/requests.data",
                          documentsDirectory];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
        NSLog(@" requests file exists, loading");
        NSMutableArray *ret=[NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
        return ret;
        
    }
    else
    {
        NSLog(@"requests file not found");
        return [[NSMutableArray alloc]init];
    }
}


-(void)addUnsuccesfullRequest:(NSURLRequest *)request
{
  @synchronized(self)
    {
        NSLog(@"add unsuccesfull request:%@",request);
        if (request!=nil) {
            NSLog(@"adding");
            
            [self.unsuccesfullRequestsArray addObject:request];


            
        }
        else
        {
            NSLog(@"nil request");
            
        }
        
    }
}

-(void)sendUnsuccesfullRequests
{
    
    @synchronized(self)
    {
        if (!self.isSynchronizationRunning) {
            
       
     //   Reachability *reachability=[Reachability reachabilityForInternetConnection];
        [self.unsuccesfullRequestsArray removeObjectsInArray:self.removedRequestsArray];
        //NSMutableArray *toRemoveRequestsArray=[[NSMutableArray alloc]init];
               if ([self.unsuccesfullRequestsArray count]>0) {
                   self.isSynchronizationRunning=YES;
                  __block int finalCallbackCounter=[self.unsuccesfullRequestsArray count];
                  __block int currentCallbackCounter=0;
                   
            for (NSURLRequest *oldRequest in self.unsuccesfullRequestsArray) {
                NSLog(@"Sending old request:%@",oldRequest);
                RKManagedObjectRequestOperation *operation = [[RKObjectManager sharedManager] managedObjectRequestOperationWithRequest:oldRequest managedObjectContext:[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                    
                    NSLog(@"sending old request success:%@ DELETING",mappingResult.array);
                    [self.removedRequestsArray addObject:oldRequest];
                    NSLog(@"ADD TO REMOVE:%@",oldRequest);
                    for (id object in mappingResult.array) {
                        if ([object isKindOfClass:[Card class]]) {
                            Card *card=object;
                            PDKeychainBindings *bindings=[PDKeychainBindings sharedKeychainBindings];
                            NSString *userName=[bindings objectForKey:@"username"];
                            User *currentUser=[DATAUTILS getUserFromDatabase:userName];
                            
                            if ([card.toUsersRelationship count]==0) {
                                card.toUsersRelationship=[NSSet setWithObject:currentUser];
                            }
                            
                            self.offlineSyncCounter++;
                       
                            [self deleteUnsynchronizedCardWithName:card.name];
                            [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext saveToPersistentStore:nil];
                        }
                        
                        else if ([object isKindOfClass:[Comment class]])
                        {
                            Comment *comment=object;
                            NSString *urlString=[oldRequest.URL absoluteString];
                            NSString *splited=[[urlString componentsSeparatedByString:@"/comments.json"]firstObject];
                            NSString *idString=[[splited componentsSeparatedByString:@"/"]lastObject];
                            
                            NSNumber *cardId=[[NSNumber alloc]initWithInt:[idString integerValue]];
                            comment.card_id=cardId;
                            NSLog(@"card id for comment:%@",cardId);
                            [DATAUTILS deleteUnsynchronizedCommentsFromDatabaseWithText:comment.comment];
                            [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext saveToPersistentStore:nil];
                            self.offlineCommentsSyncCounter++;
                            
                            NSLog(@"offline comment sync counter changed");
                        }
                        
                        else if ([object isKindOfClass:[Todo class]])
                        {
                            NSLog(@"Succesfully synced todo:%@",mappingResult.array);
                        }
                        
                        else
                        {
                            NSLog(@"success, but unrecognized object:%@",mappingResult.array);
                        }
                    }
                    
                    currentCallbackCounter++;
                    if (currentCallbackCounter==finalCallbackCounter) {
                        self.isSynchronizationRunning=NO;
                    }
                    
                } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                    NSLog(@"Can not send unsuccesfull request:%@ DELETING",error.description);
                    
                    if (error.code!=-1009) {
                        NSLog(@"ADD TO REMOVE:%@",oldRequest);
                        [self.removedRequestsArray addObject:oldRequest];
                    }
                    
                    currentCallbackCounter++;
                    
                    if (currentCallbackCounter==finalCallbackCounter) {
                        self.isSynchronizationRunning=NO;
                    }
                }];
                
                [[RKObjectManager sharedManager].operationQueue addOperation:operation];
            }
        }
        else
        {
            [self deleteAllUnsynchronizedCommentsFromDatabase];
            [self deleteAllUnsynchronizedCardsFromDatabase];
        }
        

        
        [self.unsuccesfullRequestsArray removeObjectsInArray:self.removedRequestsArray];
        [self.removedRequestsArray removeAllObjects];

    }
        else
        {
            NSLog(@"synchronization is busy");
        }
    }
  
}

-(void)deleteUnsynchronizedCommentsFromDatabaseWithText:(NSString *)text
{
    NSLog(@"Delete unsuccesfull comments from database");
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Comment"
                                              inManagedObjectContext:[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    [fetchRequest setEntity:entity];
    NSString * predicateString=[NSString stringWithFormat:@"comment ==[c] '%@'",text ];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
    [fetchRequest setPredicate:predicate];
    
    
    NSArray *fetchedObjects = [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext
                               executeFetchRequest:fetchRequest error:nil];
    
    NSLog(@"Unsynchronized comments to delete:%@",fetchedObjects);
    
    for (Comment *c in fetchedObjects) {
        
      //  Comment *comment=c;
        if ([c.isUnSynchronized boolValue]) {
           [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext deleteObject:c];
        }
        
        
    }
    [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext saveToPersistentStore:nil];
}
-(void)deleteAllUnsynchronizedCommentsFromDatabase
{
    NSLog(@"Delete all unsuccesfull comments from database");
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Comment"
                                              inManagedObjectContext:[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    [fetchRequest setEntity:entity];
    NSString * predicateString=[NSString stringWithFormat:@"isUnSynchronized == 1" ];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
    [fetchRequest setPredicate:predicate];
    
    
    NSArray *fetchedObjects = [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext
                               executeFetchRequest:fetchRequest error:nil];
    
    NSLog(@"Unsynchronized comments to delete:%@",fetchedObjects);
    
    for (NSManagedObject *c in fetchedObjects) {
        
      
            [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext deleteObject:c];
        
        
        
    }
    [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext saveToPersistentStore:nil];
}
-(void)deleteAllUnsynchronizedCardsFromDatabase
{
    NSLog(@"Delete all unsuccesfull cards from database");
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Card"
                                              inManagedObjectContext:[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    [fetchRequest setEntity:entity];
    NSString * predicateString=[NSString stringWithFormat:@"isUnsynchronized == 1" ];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
    [fetchRequest setPredicate:predicate];
    
    
    NSArray *fetchedObjects = [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext
                               executeFetchRequest:fetchRequest error:nil];
    
    NSLog(@"Unsynchronized cards to delete:%@",fetchedObjects);
    
    for (NSManagedObject *c in fetchedObjects) {
        
        
        [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext deleteObject:c];
        
        
        
    }
    [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext saveToPersistentStore:nil];
}

-(void)deleteUnsynchronizedCardWithName:(NSString *)name
{
    NSLog(@"Delete unsuccesfull comments from database");
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Card"
                                              inManagedObjectContext:[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    [fetchRequest setEntity:entity];
    NSString * predicateString=[NSString stringWithFormat:@"name ==[c] '%@'",name ];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
    [fetchRequest setPredicate:predicate];
    
    
    NSArray *fetchedObjects = [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext
                               executeFetchRequest:fetchRequest error:nil];
    
    NSLog(@"Unsynchronized comments to delete:%@",fetchedObjects);
    
    for (Card *c in fetchedObjects) {
        
        //  Comment *comment=c;
        if ([c.isUnsynchronized boolValue]) {
            [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext deleteObject:c];
        }
        
        
    }
    
    [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext saveToPersistentStore:nil];
}
-(NSArray *)createIconsCollectionItemsArrayFromCard:(Card *)card
{
    NSMutableArray *retArray=[[NSMutableArray alloc]init];
    if (card.cardDescription && [card.cardDescription length]>0) {
        [retArray addObject:@"description"];
    }
    if ([card.startdate length]>0 || [card.duedate length]>0) {
        [retArray addObject:@"dates"];
    }
    if ([card.todos_count integerValue]!=0 || [card.done_todos integerValue]!=0) {
        [retArray addObject:@"todos"];
    }
    if ([card.planned_time integerValue]!=0 || [card.total_tracked integerValue]!=0) {
        [retArray addObject:@"time"];
    }
    if ([card.comments_count integerValue]>0) {
        [retArray addObject:@"comments"];
    }
    if ([card.attachments_count integerValue]>0) {
        [retArray addObject:@"attachments"];
    }
    return retArray;
}
-(UIColor *)tagsIconTextColor
{
    return   [ColorwithHex colorWithHexString:@"888888"];
}
-(UIColor *)tagsIconBackgroundColor
{
    return   [ColorwithHex colorWithHexString:@"eeeeee"];
}
-(NSString *)getDatesIconCellTextFromCard:(Card *)card
{
    NSString *startDateString=[[NSString alloc]init];
    NSString *dueDateString=[[NSString alloc]init];
    startDateString=[DATAUTILS createProjectCardDueDateIconStringFromTimestamp:card.startdate];
    dueDateString=[DATAUTILS createProjectCardDueDateIconStringFromTimestamp:card.duedate];
    
    if ([startDateString length]>0 && [dueDateString length]>0 ) {
       return [NSString stringWithFormat:@"%@ - %@",startDateString,dueDateString];
        
    }
    else if ([startDateString length]>0)
    {
       return  startDateString;
        
    }
    else if ([dueDateString length]>0)
    {
        return dueDateString;
        
    }
    else
    {
        return @"";
    }

}
-(NSString *)getTimesIconCellTextFromCard:(Card *)card
{
    int planedHours=[card.planned_time integerValue]/60;
    int planedMins=[card.planned_time integerValue]-(planedHours*60);
    int trackedHours=[card.total_tracked integerValue]/60;
    int trackedMins=[card.total_tracked integerValue]-(trackedHours*60);
    NSLog(@"planed hours:%d",planedHours);
    NSLog(@"planed mins:%d",planedMins);
    NSLog(@"tracked hours:%d",trackedHours);
    NSLog(@"tracked mins:%d",trackedMins);
    
    NSString *planedHoursString=[[NSString alloc]init];
    NSString *planedMinsString=[[NSString alloc]init];
    NSString *trackedHoursString=[[NSString alloc]init];
    NSString *trackedMinsString=[[NSString alloc]init];
    
    
    if (planedHours>0) {
        planedHoursString=[NSString stringWithFormat:@"%dh",planedHours ];
    }
    else
    {
        planedHoursString=@"";
    }
    if (planedMins>0) {
        planedMinsString=[NSString stringWithFormat:@"%dm",planedMins ];
    }
    else
    {
        planedMinsString=@"";
    }
    if (trackedHours>0) {
        trackedHoursString=[NSString stringWithFormat:@"%dh",trackedHours ];
    }
    else
    {
        trackedHoursString=@"";
    }
    if (trackedMins>0) {
        trackedMinsString=[NSString stringWithFormat:@"%dm",trackedMins ];
    }
    else
    {
        trackedMinsString=@"";
    }
    
    if ([card.planned_time integerValue]!=0 && [card.total_tracked integerValue]!=0) {
        return [NSString stringWithFormat:@"%@ %@ / %@ %@",planedHoursString,planedMinsString,trackedHoursString,trackedMinsString ];
        }
    else if ([card.planned_time integerValue]!=0)
    {
        return [NSString stringWithFormat:@"%@ %@",planedHoursString,planedMinsString];
        
    }
    else if ([card.total_tracked integerValue]!=0)
    {
        return [NSString stringWithFormat:@"%@ %@",trackedHoursString,trackedMinsString];
    
        
    }
    else
    {
        return @"";
    }

}

-(CGFloat)countWidthForText:(NSString *)text InLabelWithHeight:(CGFloat)labelHeight andAtributes:(NSDictionary *)atributesDic
{
    NSLog(@"count width for text in cell:%@",text);
    
    CGRect retFrame =[text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, labelHeight) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:atributesDic context:nil];
    NSLog(@"result:%f",retFrame.size.height);
    return retFrame.size.width;

}
-(BOOL)checkIfUserIsOwnerOfAComment:(Comment *)com
{
    PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];

    NSString *email=[bindings objectForKey:@"username"];
    NSLog(@"check if user is owner of a comment checking:%@ with:%@",email,com.toUsersRelationship.email);
  
    if (  [[com.toUsersRelationship.email lowercaseString] isEqualToString:[email lowercaseString]] || [com.toUsersRelationship.email length]==0) {
        return YES;
    }
    else
    {
        return NO;
    }
}
-(BOOL)checkIfUserIsOwnerOfaTimeEntery:(TimeEntery *)timeEnt
{
    PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
    
    NSString *email=[bindings objectForKey:@"username"];
    NSLog(@"check if user %@ is owner of a time entery with email:%@",email,timeEnt.user_email);
    if ([[email lowercaseString] isEqualToString:[timeEnt.user_email lowercaseString]]) {
        return YES;
    }
    else
    {
        if ([timeEnt.user_email length]==0) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    

}
-(User *)getUserForComment:(Comment *)com
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User"
                                              inManagedObjectContext:[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    [fetchRequest setEntity:entity];
    NSString * predicateString=[NSString stringWithFormat:@"toCommentRelationship.commentId == %@",com.commentId ];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"position"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSError *error = nil;
    
    NSArray *fetchedObjects = [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext
                               executeFetchRequest:fetchRequest error:&error];
    
    return [fetchedObjects firstObject];

}
- (void)listSubviewsOfView:(UIView *)view {
    
    // Get the subviews of the view
    NSArray *subviews = [view subviews];
    
    // Return if there are no subviews
   // if ([subviews count] == 0) return; // COUNT CHECK LINE
    
    for (UIView *subview in subviews) {
        
        // Do what you want to do with the subview
        NSLog(@"subview: %@ class:%@ layer class:%@", subview.layer,[subview class],subview.layer.class);
        [subview setExclusiveTouch:YES];
        // List the subviews of subview
        [self listSubviewsOfView:subview];
    }
}
-(NSArray *)getCardsFromList:(NSNumber *)listId
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Edit the entity name as appropriate.
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Card" inManagedObjectContext:[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext];
    
    NSString * predicateString=[NSString stringWithFormat:@"stage_id == %@",listId ];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
       [fetchRequest setPredicate:predicate];
    
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"position" ascending:YES];
    //  NSSortDescriptor *placeHolderSortDescriptor=[[NSSortDescriptor alloc] initWithKey:@"isPlaceholderCard" ascending:YES];
    
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSArray *fetchedObjects = [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext
                               executeFetchRequest:fetchRequest error:&error];

    
    return fetchedObjects;
}
@end
