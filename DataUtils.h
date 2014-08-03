//
//  DataUtils.h
//  breeze
//
//  Created by Breeze on 05.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Activity.h"
#import "User.h"
#import "Card.h"
#import "TimeEntery.h"
#import "Todo.h"
#import "TaskStatusHeader.h"
#import "Reachability.h"

#define DATAUTILS ([DataUtils getInstance])

@interface DataUtils : NSObject

@property (atomic) BOOL shouldDisableTableviewScroll;
@property (atomic) BOOL isSynchronizationRunning;
@property (atomic) BOOL synchronizationHasFailures;
@property (strong,atomic) Card *selectedCard;
@property (strong,atomic) Card *dragedCard;
@property (strong,atomic) Project *selectedProject;
@property (strong,atomic) UITableViewCell *dragedCell;
@property (strong,atomic) NSMutableArray *unsuccesfullRequestsArray;
@property (strong,atomic) NSMutableArray *removedRequestsArray;
@property (atomic) NSInteger offlineSyncCounter;
@property (atomic) NSInteger offlineCommentsSyncCounter;
@property (atomic) NSInteger synchronizationCalls;
@property (strong,atomic) NSNumber *lastPlaceholderList;
@property (strong) UINib *IconCellNib;
@property (strong) UINib *IconTodosNib;
@property (strong) UINib *IconDatesNib;
@property (strong) UINib *IconCommentsNib;
@property (strong) UINib *IconTimesNib;
@property (strong) UINib *IconTagsNib;
@property (strong) UINib *IconAttachmentsNib;
@property (atomic) BOOL dragEndedWithADrop;
//@property (atomic) BOOL isScrollMoving;



//test
//@property (strong,atomic) UIView *placeholderShadowView;
@property (strong,atomic) UIImage *placeholderImage;

//

+(DataUtils *)getInstance;

-(UIColor *)backgroundColor;
-(UIColor *)signInButtonColour;
-(UIColor *)whiteColor;
-(UIColor *)blueColor;
-(UIColor *)borderColor;
-(UIColor *)taskMenuBackgroundcolor;
-(UIColor *)unsynchronizedCommentsBackgroundColor;
-(UIColor *)unsynchronizedTasksStatusColor;

-(NSString *)createActivityDescriptionStringFromActivity:(Activity *)activity;
-(NSString *)getHourFromActivityTimeString:(NSString *)timeString;
-(NSString *)getSectionNameFromDate:(NSString *)dateString;

-(NSArray *)getProjectCardsFromDatabaseForProject:(Project *)selectedProject;
-(void)getProjectCardsForProfect:(Project *)selectedProject;
- (void)MoveCardWithId:(NSString *)listId ProjectId:(NSString *)projectId stage_id:(NSString *)StageId prev_id:(NSString *)prevId completion:(void (^)(BOOL success ,NSString  *result))completionBlock;
//- (void)MoveCardWithId:(NSString *)cardId ProjectId:(NSString *)projectId stage_id:(NSString *)StageId prev_id:(NSString *)prevId;
-(NSArray *)getProjectCardsWithStageId:(NSString *)stageid;
-(void)DisplayPopupWithTitle:(NSString *)pop_title andMessage:(NSString *)pop_message;
-(void)test;
-(NSArray *)createSectionNamesArrayFromCard:(Card *)card andCommentsArray:(NSArray *)commentsArray;
-(NSInteger)countNumberofObjectsInDetailedTaskControllerForCard:(Card *)card andSectionName:(NSString *)sectionName andCommentsArray:(NSArray *)commentsArray;

-(NSArray *)createCommentsArrayFromCard:(Card *)card;
-(NSArray *)createTimeEnteriesSortedArrayFromCard:(Card *)card;
-(NSString *)createTimeEnteryDateFromTimestampString:(NSString *)timestampString;
-(NSString *)createPostedByStringFromTimestamp:(NSString *)timestampString;
- (void)createCommentToProject:(NSString *)projectId CardId:(NSString *)cardId withText:(NSString *)commentText completion:(void (^)(BOOL success ,NSSet  *result))completionBlock;
- (void)editCommentToProject:(NSString *)projectId CardId:(NSString *)cardId CommentId:(NSString *)commentId withText:(NSString *)commentText completion:(void (^)(BOOL success ,NSSet  *result))completionBlock;
-(BOOL)checkIfCredentialsChangedUsername:(NSString *)username Password:(NSString *)password;
-(void)downloadUpdates;
-(CGFloat)countHeightForTextInTaskCellFrameWithWidth:(CGFloat)width andText:(NSString *)text withAtributes:(NSDictionary *)atributesDic;
-(User *)getUserFromDatabase:(NSString *)username;
- (void)createCardInProject:(NSString *)projectId withParams:(NSDictionary *)params completion:(void (^)(BOOL success ,NSString  *result))completionBlock;
- (void)updateCardInProject:(NSString *)projectId andCard:(NSString *)cardId withParams:(NSDictionary *)params completion:(void (^)(BOOL success ,NSString  *result))completionBlock;
-(NSInteger)getNumberOfActivitiesInDatabase;
-(NSString *)getActivitySectionDateStringFromDateString:(NSString *)dateString;
-(NSDate *)getDateFromTimestamp:(NSString *)timestamp;
-(User *)getUserWithIdFromDatabase:(NSNumber *)userId;
-(NSString *)getDueDateStringFromDate:(NSDate *)inpoutDate;
-(CGFloat)countHeightforText:(NSString *)text InRTLABELwithWidth:(CGFloat)width;
-(NSString *)createDuedateStringFromDate:(NSString *)timestampString;
-(CGFloat)countHeightForTagsCellWithTags:(NSArray *)tagsArray withFontSize:(int)fontsize;
-(UIColor*)toDoListHeaderBackgroundColor;
-(CGFloat)countHeigtForTodoCellInTaskControllerWithTodoListsArray:(NSArray *)todoListsArray;
-(void)addTodo:(Todo *)todoToAdd ToTodoListWithId:(NSNumber *)listId;
-(BOOL)checkIfTaskIsMarked:(Card *)selectedCard;
-(UIView *)cardStatusHeaderForCard:(Card *)selectedCard;
-(NSString *)GetTimeTrackingDateStringFromDate:(NSDate *)dateInp;
-(int)getTrackedHoursFromInterval:(NSTimeInterval)interval;
-(NSString *)createProjectCardDueDateIconStringFromTimestamp:(NSString *)timestampString;
-(NSString *)getDatesIconCellTextFromCard:(Card *)card;
-(NSArray *)createIconsCollectionItemsArrayFromCard:(Card *)card;
-(NSString *)getTimesIconCellTextFromCard:(Card *)card;
-(CGFloat)countWidthForText:(NSString *)text InLabelWithHeight:(CGFloat)labelHeight andAtributes:(NSDictionary *)atributesDic;
-(UIColor *)tagsIconTextColor;
-(UIColor *)tagsIconBackgroundColor;
-(BOOL)checkIfUserIsOwnerOfAComment:(Comment *)com;
//test
-(void)addUnsuccesfullRequest:(NSURLRequest *)request;
-(void)sendUnsuccesfullRequests;
-(void)deleteUnsynchronizedCommentsFromDatabaseWithText:(NSString *)text;
-(void)deleteAllUnsynchronizedCommentsFromDatabase;
-(void)deleteAllUnsynchronizedCardsFromDatabase;
-(void)deleteUnsynchronizedCardWithName:(NSString *)name;
-(User *)getUserForComment:(Comment *)com;
-(BOOL)checkIfUserIsOwnerOfaTimeEntery:(TimeEntery *)timeEnt;
- (void)listSubviewsOfView:(UIView *)view ;
@end





