//
//  DatesIconCell.h
//  breeze
//
//  Created by Breeze on 09.06.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"

@interface DatesIconCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *calendarImage;
@property (weak, nonatomic) IBOutlet UILabel *datesTextlabel;
-(void)setWithCard:(Card *)card;
@end
