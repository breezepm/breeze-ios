//
//  ProjectPageScroll.h
//  breeze
//
//  Created by Breeze on 13.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"
#import "ProjectCards.h"
#import "ProjectPageView.h"
#import "AtkDragAndDrop.h"




@interface ProjectPageScroll : UIScrollView <AtkDropZoneProtocol>
@property (strong) NSMutableArray *viewsArray;

-(void)setWithCardsArray:(NSArray *)projectCardsArrayToSort;


@property (atomic) BOOL isScrollBusy;
@property (atomic) BOOL isScrollMoving;
@property (atomic) BOOL noNeedToReloadContent;
@end

