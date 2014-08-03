//
//  TimesIconCell.h
//  breeze
//
//  Created by Breeze on 09.06.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"
#import "DataUtils.h"

@interface TimesIconCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *clockImage;
@property (weak, nonatomic) IBOutlet UILabel *timesTextLabel;

-(void)setWithCard:(Card *)card;
@end
