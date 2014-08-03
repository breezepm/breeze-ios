//
//  AttachmentsIconCell.h
//  breeze
//
//  Created by Breeze on 10.06.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"
#import "DataUtils.h"

@interface AttachmentsIconCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *attachmentImage;
@property (weak, nonatomic) IBOutlet UILabel *attachmentTextLabel;

-(void)setWithCard:(Card *)card;
@end
