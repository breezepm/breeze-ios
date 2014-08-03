//
//  PeoplesAvatasView.h
//  breeze
//
//  Created by Breeze on 10.06.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"
#import "DataUtils.h"

@interface PeoplesAvatasView : UIView
@property (strong,atomic) NSMutableArray *viewsArray;
-(void)setWithCard:(Card *)selectedCard;
@end
