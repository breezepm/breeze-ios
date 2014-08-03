//
//  ProjectCardContentCell.m
//  breeze
//
//  Created by Breeze on 12.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import "ProjectCardContentCell.h"
#import "DataUtils.h"

@implementation ProjectCardContentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)shouldDragStart:(AtkDragAndDropManager *)manager
{
    // Yes, consider me for drags. Returning true here only
    // ensures that isInterested, dragStarted, and dragEnded will
    // be called.
    NSLog(@"should drag start");
    return YES;
}

//- (BOOL)isInterested:(AtkDragAndDropManager *)manager
//{
//    // If we return true here then dragEntered, dragExited, dragMoved and
//    // dragDropped can be called.
//    // So, let's see if we are interested in what's on the pasteboard.
//    // For the example this is if the pastbaord string matches
//    // a string made up from the views tag property.
//    NSLog(@"drag:is interested?");
//    BOOL ret = NO;
//    UIPasteboard *pastebaord = manager.pasteboard;
//    NSString *interestedInString =
//    [NSString stringWithFormat:@"val-%ld", (long)self.tag];
//    if([interestedInString isEqualToString:pastebaord.string])
//        ret = YES;
//    NSLog(@"%hhd",ret);
//    return ret;
//}


- (void)dragWillStart:(AtkDragAndDropManager *)manager
{
    // This is called before any call to AtkDropZoneProtocol shouldDragStart.
    // It's a good place to setup data for that method to examine.
    NSLog(@"drag will start");
   // if (!DATAUTILS.shouldDisableTableviewScroll) {
          DATAUTILS.shouldDisableTableviewScroll=YES; 
   // }
 
    manager.pasteboard.string = [NSString stringWithFormat:@"val-%ld", (long)self.tag];

}


@end
