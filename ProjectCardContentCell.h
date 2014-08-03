//
//  ProjectCardContentCell.h
//  breeze
//
//  Created by Breeze on 12.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AtkDragAndDrop.h"

@interface ProjectCardContentCell : UITableViewCell <AtkDragSourceProtocol>
@property (weak, nonatomic) IBOutlet UILabel *contentName;

@end
