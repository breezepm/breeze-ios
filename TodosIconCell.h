//
//  TodosIconCell.h
//  breeze
//
//  Created by Breeze on 09.06.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"



@interface TodosIconCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *todosTextLabel;

-(void)setWithCard:(Card *)card;
@end
