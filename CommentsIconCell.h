//
//  CommentsIconCell.h
//  breeze
//
//  Created by Breeze on 09.06.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"

@interface CommentsIconCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *commentImage;
@property (weak, nonatomic) IBOutlet UILabel *commentTextLabel;

-(void)setWithCard:(Card *)card;
@end
