//
//  ProjectPageViewCell.h
//  breeze
//
//  Created by Breeze on 13.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AtkDragAndDrop.h"
#import "RemoteImageView.h"
#import "Card.h"
#import "Project.h"
#import "PeoplesAvatasView.h"
#import <UICollectionViewLeftAlignedLayout.h>




@interface ProjectPageViewCell : UITableViewCell <AtkDragSourceProtocol,AtkDropZoneProtocol,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateLeftAlignedLayout>
@property (weak, nonatomic) IBOutlet UILabel *contentName;
@property (weak, nonatomic) IBOutlet UIView *contentBackgroundView;

@property (strong) Card *cardForRow;
@property (strong) Project *projectForRow;

@property (strong) NSString *previousIdString;
@property (weak, nonatomic) IBOutlet UIView *statusBackground;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong,atomic) NSArray *collectionViewItemsArray;
@property (strong,atomic) NSArray *cardTagsArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusHeaderHeight;

@property (strong, nonatomic) IBOutlet UICollectionView *iconsCollection;
-(void)setIconsWithCard:(Card *)card andItemsArray:(NSArray *)it;
@property (weak, nonatomic) IBOutlet PeoplesAvatasView *peoplesAvatarsView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarsViewHeight;

@property (strong,atomic) Card *selectedCard;

@property (atomic) BOOL noNeedToRegisterNibs;

@end


