//
//  TagsCell.m
//  breeze
//
//  Created by Breeze on 26.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import "TagsCell.h"
#import "TagsCollectionViewCell.h"
#import "DataUtils.h"

@implementation TagsCell
static CGFloat collectionItemHeight=21;

static CGFloat collectionItemPadding=5;
static double collectionItemFontsize=17;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    self.tagsArray=[[NSArray alloc]init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setWithTagsArray:(NSArray *)tagsArray
{
    
     
    
    self.tagsArray=[[NSArray alloc]init];
    self.tagsArray=tagsArray;
    
    
    self.tagsCollection.delegate=self;
    self.tagsCollection.dataSource=self;
     
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TagsCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"TagsCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor=[DATAUTILS backgroundColor];
    [cell.contentLabel setText:[self.tagsArray objectAtIndex:indexPath.item]];
    
    
    cell.contentLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.contentLabel.layer.borderWidth = 1.0;
    return cell;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *text=[self.tagsArray objectAtIndex:indexPath.item];
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont systemFontOfSize:collectionItemFontsize], NSFontAttributeName,
                                          nil];
    
    CGRect retFrame =[text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, collectionItemHeight) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributesDictionary context:nil];
    return CGSizeMake(retFrame.size.width+collectionItemPadding, collectionItemHeight+collectionItemPadding);
  
}

//- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(collectionItemPadding, collectionItemPadding, collectionItemPadding, collectionItemPadding); // top, left, bottom, right
//}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.tagsArray count];
}
-(void)dealloc
{
    NSLog(@"tags cell dealloc:%@",self);
    self.tagsCollection.delegate=nil;
    self.tagsCollection.dataSource=nil;
    self.tagsCollection=nil;
}
@end
