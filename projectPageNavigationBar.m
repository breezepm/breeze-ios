//
//  projectPageNavigationBar.m
//  breeze
//
//  Created by Breeze on 22.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import "projectPageNavigationBar.h"
#import "DataUtils.h"

@implementation projectPageNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)setWithTitle:(NSString *)title andSubtitle:(NSString *)subtitle onView:(UIView *)destinationView
{
   // NSLog(@"Nav bar - set title started");
   // NSLog(@"Navigation bar:set with title:%@ and subtitle:%@",title,subtitle);
    
    self.titleLabel.text=title;
    self.subtitleLabel.text=subtitle;
    
    
    [self.titleLabel sizeToFit];
    [self.subtitleLabel sizeToFit];
    
    CGFloat maxWidth=MAX(self.titleLabel.frame.size.width, self.subtitleLabel.frame.size.width);
   // CGFloat frameDifference=ABS(self.titleLabel.frame.size.width-self.subtitleLabel.frame.size.width);
    self.titleLabel.textAlignment=NSTextAlignmentLeft;
    self.subtitleLabel.textAlignment=NSTextAlignmentLeft;
    
  //  NSLog(@"navbar max width:%f",maxWidth);
    self.frame=CGRectMake(0, 0, maxWidth, 44);
    if (maxWidth==self.titleLabel.frame.size.width) {
       // CGRect tempFrame=self.subtitleLabel.frame;
       // tempFrame.size.width=maxWidth;
       // self.subtitleLabel.frame=tempFrame;
        self.subtitleLabel.textAlignment=NSTextAlignmentCenter;
        
    }
    else
    {
       // CGRect tempFrame=self.titleLabel.frame;
      //  tempFrame.size.width=maxWidth;
       // self.titleLabel.frame=tempFrame;
              self.titleLabel.textAlignment=NSTextAlignmentCenter;
    }
    //NSLog(@"nav bar - set title finished");
}



@end
