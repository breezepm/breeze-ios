//
//  ProjectPageViewCell.m
//  breeze
//
//  Created by Breeze on 13.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import "ProjectPageViewCell.h"
#import "DataUtils.h"
#import "DescriptionIconCell.h"
#import "DatesIconCell.h"
#import "TodosIconCell.h"
#import "CommentsIconCell.h"
#import "TimesIconCell.h"
#import "TagsIconCell.h"
#import "AttachmentsIconCell.h"
#import "UIView+AtkImage.h"
#import <UICollectionViewLeftAlignedLayout.h>

@implementation ProjectPageViewCell
static CGFloat descriptionIconWidth=20;
static CGFloat todosIconWidth=60;


static CGFloat attachmentsIconWidth=60;

static CGFloat defaultIconHeight=20;
static CGFloat defaultIconImageSpaceWidth=20;
static CGFloat tagsCollectionItemHeight=20;

static CGFloat tagsCollectionItemPadding=5;
static double tagsCollectionItemFontsize=10;
- (void)awakeFromNib
{
    // Initialization code
    self.collectionViewItemsArray=[[NSArray alloc]init];
    self.cardTagsArray=[[NSArray alloc]init];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (BOOL)shouldDragStart:(AtkDragAndDropManager *)manager
{
    return YES;
}

- (void)dragWillStart:(AtkDragAndDropManager *)manager
{
    
    DATAUTILS.dragedCard=self.cardForRow;
    manager.pasteboard.string = [NSString stringWithFormat:@"val-%ld", (long)self.tag];
    DATAUTILS.dragedCell=self;
    DATAUTILS.placeholderImage=[self imageFromView];
    
    
  
}
- (BOOL)isInterested:(AtkDragAndDropManager *)manager
{

    BOOL ret = NO;
    UIPasteboard *pastebaord = manager.pasteboard;
    NSString *interestedInString =
    [NSString stringWithFormat:@"val-%ld", (long)self.tag];
    if([interestedInString isEqualToString:pastebaord.string])
        ret = YES;
    
    return ret;
}





-(void)setIconsWithCard:(Card *)card andItemsArray:(NSArray *)it
{
    NSLog(@"Set icons with card %@",card.name);
    NSLog(@"items array:%@",it);
    
   @synchronized(self.class)
    {
        
    
    
    self.collectionViewItemsArray=[it copy];
    self.iconsCollection.backgroundColor=[UIColor clearColor];
    self.selectedCard=card;
    self.cardTagsArray=card.tags;
    self.iconsCollection.userInteractionEnabled=NO;
    

        NSLog(@"need to register nibs");
        self.noNeedToRegisterNibs=YES;
        NSDate *startup=[NSDate date];

        NSLog(@"Icons loading time:%f",[startup timeIntervalSinceNow]);
        NSDate *registerTime=[NSDate date];
    [self.iconsCollection registerNib:DATAUTILS.IconCellNib forCellWithReuseIdentifier:@"DescriptionIconCell"];
    [self.iconsCollection registerNib:DATAUTILS.IconTodosNib forCellWithReuseIdentifier:@"TodosIconCell"];
    [self.iconsCollection registerNib:DATAUTILS.IconDatesNib forCellWithReuseIdentifier:@"DatesIconCell"];
    [self.iconsCollection registerNib:DATAUTILS.IconCommentsNib forCellWithReuseIdentifier:@"CommentsIconCell"];
    [self.iconsCollection registerNib:DATAUTILS.IconTimesNib forCellWithReuseIdentifier:@"TimesIconCell"];
    [self.iconsCollection registerNib:DATAUTILS.IconTagsNib forCellWithReuseIdentifier:@"TagsIconCell"];
    [self.iconsCollection registerNib:DATAUTILS.IconAttachmentsNib forCellWithReuseIdentifier:@"AttachmentsIconCell"];
        NSLog(@"Icons registering time:%f",[registerTime timeIntervalSinceNow]);
  
    self.iconsCollection.delegate=self;
    self.iconsCollection.dataSource=self;
        NSDate *lodaingTime=[NSDate date];
    [self.iconsCollection reloadData];
    
        NSLog(@"Icons loading time:%f",[lodaingTime timeIntervalSinceNow]);
        }
}
#pragma mark -UICollectionview data source
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSArray *tagsArray=self.selectedCard.tags;
    if ([tagsArray count]>0) {
        return 2;
    }
    else
    {
        return 1;
    }
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section==0) {
        return [self.collectionViewItemsArray count];
    }
    else
    {
        return [self.cardTagsArray count];
    }
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Icons collection - cell for item started for item%d",indexPath.item);
    
    if (indexPath.section==0) {
        
   
    
    
    if ([[self.collectionViewItemsArray objectAtIndex:indexPath.item] isEqualToString:@"description"]) {
        DescriptionIconCell *descriptionIconCell=[collectionView dequeueReusableCellWithReuseIdentifier:@"DescriptionIconCell" forIndexPath:indexPath];
         NSLog(@"Icons collection - cell for item finished (description)");
        return descriptionIconCell;
    }
    else if ([[self.collectionViewItemsArray objectAtIndex:indexPath.item] isEqualToString:@"attachments"])
    {
        AttachmentsIconCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"AttachmentsIconCell" forIndexPath:indexPath];
        [cell setWithCard:self.selectedCard];
        NSLog(@"Icons collection - cell for item finished (attachments)");
        return cell;
    }
        
    else if ([[self.collectionViewItemsArray objectAtIndex:indexPath.item] isEqualToString:@"dates"])
    {
            DatesIconCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"DatesIconCell" forIndexPath:indexPath];
            [cell setWithCard:self.selectedCard];
            NSLog(@"Icons collection - cell for item finished(dates)");
            return cell;
    }
    else if ([[self.collectionViewItemsArray objectAtIndex:indexPath.item] isEqualToString:@"todos"])
    {
          TodosIconCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"TodosIconCell" forIndexPath:indexPath];
            [cell setWithCard:self.selectedCard];
            NSLog(@"Icons collection - cell for item finished (todos)");
           return cell;

    }
    else if ([[self.collectionViewItemsArray objectAtIndex:indexPath.item] isEqualToString:@"time"])
    {
        TimesIconCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"TimesIconCell" forIndexPath:indexPath];
        [cell setWithCard:self.selectedCard];
        NSLog(@"Icons collection - cell for item finished(times)");
        return cell;
    }
    
    else //comments
    {
          CommentsIconCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"CommentsIconCell" forIndexPath:indexPath];
          [cell setWithCard:self.selectedCard];
            NSLog(@"Icons collection - cell for item finished(comments)");
           return cell;
    }
    

 }
else
{
    TagsIconCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"TagsIconCell" forIndexPath:indexPath];
    
    [cell.tagLabel setText:[self.cardTagsArray objectAtIndex:indexPath.item]];
    
    
    [cell.tagLabel setBackgroundColor:[DATAUTILS tagsIconBackgroundColor]];
    [cell.tagLabel setTextColor:[DATAUTILS tagsIconTextColor]];
    NSLog(@"Icons collection - cell for item finished(tags)");
    return cell;
    
}
    

    
   
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Icons cell layout for item:%d in section :%d started",indexPath.item,indexPath.section);
//  return CGSizeMake(30, 30);
    if (indexPath.section==0) {
        
        if ([[self.collectionViewItemsArray objectAtIndex:indexPath.item] isEqualToString:@"description"]) {
            NSLog(@"Icons cell layout finished (desctiption)");
            return  CGSizeMake(descriptionIconWidth, defaultIconHeight);
        }
        else if ([[self.collectionViewItemsArray objectAtIndex:indexPath.item] isEqualToString:@"dates"])
        {
            NSString *text=[DATAUTILS getDatesIconCellTextFromCard:self.selectedCard];
            NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  [UIFont systemFontOfSize:9], NSFontAttributeName,
                                                  nil];
            
            CGFloat width=[DATAUTILS countWidthForText:text InLabelWithHeight:tagsCollectionItemHeight andAtributes:attributesDictionary];
            NSLog(@"Icons cell layout finished (dates)");
            return CGSizeMake(width+defaultIconImageSpaceWidth+5, defaultIconHeight);
            
            //return  CGSizeMake(datesIconWidth, defaultIconHeight);
        }
        else if ([[self.collectionViewItemsArray objectAtIndex:indexPath.item] isEqualToString:@"todos"])
        {
            NSLog(@"Icons cell layout finished (todos)");
            return  CGSizeMake(todosIconWidth, defaultIconHeight);
        }
        else if ([[self.collectionViewItemsArray objectAtIndex:indexPath.item] isEqualToString:@"time"])
        {
            NSLog(@"counting height for time cell in project page");
            NSString *text=[DATAUTILS getTimesIconCellTextFromCard:self.selectedCard];
            NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  [UIFont systemFontOfSize:10], NSFontAttributeName,
                                                  nil];

            CGFloat width=[DATAUTILS countWidthForText:text InLabelWithHeight:tagsCollectionItemHeight andAtributes:attributesDictionary];
            NSLog(@"count height for time cell in project page end");
            NSLog(@"Icons cell layout finished (time)");
            return CGSizeMake(width+defaultIconImageSpaceWidth+5, defaultIconHeight);
            
                      // return  CGSizeMake(timesIconWith, defaultIconHeight);
        }
        else if ([[self.collectionViewItemsArray objectAtIndex:indexPath.item] isEqualToString:@"attachments"])
        {
            NSLog(@"Icons cell layout finished (attachments)");
            return  CGSizeMake(attachmentsIconWidth, defaultIconHeight);
        }
        
        else  //comments
        {
            
            NSString *text=[self.selectedCard.comments_count stringValue];
            NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  [UIFont systemFontOfSize:10], NSFontAttributeName,
                                                  nil];
            
            CGFloat width=[DATAUTILS countWidthForText:text InLabelWithHeight:tagsCollectionItemHeight andAtributes:attributesDictionary];
            NSLog(@"Icons cell layout finished (comments)");
            return CGSizeMake(width+defaultIconImageSpaceWidth+5, defaultIconHeight);

            //return  CGSizeMake(commentsIconWidth, defaultIconHeight);
        }

    }
    else
    {
        NSString *text=[self.cardTagsArray objectAtIndex:indexPath.item];
        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [UIFont systemFontOfSize:tagsCollectionItemFontsize], NSFontAttributeName,
                                              nil];
        
        CGRect retFrame =[text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, tagsCollectionItemHeight) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributesDictionary context:nil];
        NSLog(@"Icons cell layout finished (tags)");
        return CGSizeMake(retFrame.size.width+tagsCollectionItemPadding, tagsCollectionItemHeight+2*tagsCollectionItemPadding);
    }
    
}

-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        NSLog(@"icons collectionView didEndDisplayingCell:with item:%ld in section %ld",(long)indexPath.item,(long)indexPath.section);
        NSLog(@"icons collection items array:%@",self.collectionViewItemsArray);
        NSLog(@"cell:%@",cell);
    }
    else
    {
        NSLog(@"icons collectionView didEndDisplayingCell: tags cell");
    }
}
-(void)layoutSubviews
{
    if(self)
    {
        [super layoutSubviews];
    }
    
}

-(void)dealloc
{
    NSLog(@"project page view cell dealloc:%@",self);
    self.iconsCollection.delegate=nil;
    self.iconsCollection.dataSource=nil;
    self.iconsCollection=nil;
}

@end
