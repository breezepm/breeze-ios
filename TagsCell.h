//
//  TagsCell.h
//  breeze
//
//  Created by Breeze on 26.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagsCell : UITableViewCell <UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *tagsCollection;
@property (strong,nonatomic) NSArray *tagsArray;

-(void)setWithTagsArray:(NSArray *)tagsArray;
@end
