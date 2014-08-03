//
//  projectPageNavigationBar.h
//  breeze
//
//  Created by Breeze on 22.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface projectPageNavigationBar : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
-(void)setWithTitle:(NSString *)title andSubtitle:(NSString *)subtitle onView:(UIView *)destinationView;
@end
