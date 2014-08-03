//
//  TagViewController.m
//  breeze
//
//  Created by Breeze on 22.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import "TagViewController.h"
#import "DataUtils.h"
#import "Project.h"
#import "TagCell.h"

@interface TagViewController ()

@end

@implementation TagViewController
static CGFloat headerHeight=50;
static CGFloat footerHeight=20;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.itemsArray=[[NSMutableArray alloc]init];
    self.itemsArray=[DATAUTILS.selectedProject.tags copy];
    self.view.backgroundColor=[DATAUTILS backgroundColor];
    self.tagsTableview.backgroundColor=[UIColor clearColor];
    self.tagsTableview.allowsMultipleSelection=YES;
    self.selectedTags=[[NSMutableArray alloc]init];
    self.cardTagsArray=[[NSMutableArray alloc]init];
    self.tagsTableview.delegate=self;
    self.tagsTableview.dataSource=self;
    self.cardTagsArray=DATAUTILS.selectedCard.tags;
   // [self.tagsTableview reloadData];
    NSLog(@"---subviews of TagViewController---");
    NSLog(@"self view:%@",self.view.layer);
    [DATAUTILS listSubviewsOfView:self.view];
    NSLog(@"---subviews of TagViewController end---");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return headerHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return footerHeight;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header=[[UIView alloc]init];
    header.backgroundColor=[DATAUTILS backgroundColor];
    return header;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer=[[UIView alloc]init];
    footer.backgroundColor=[DATAUTILS backgroundColor];
    return footer;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.itemsArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"creating row:%ld",(long)indexPath.row);
    TagCell *cell= [tableView dequeueReusableCellWithIdentifier:@"TagCell"];
    [cell.tagLabel setText:[self.itemsArray objectAtIndex:indexPath.row]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if ([self.cardTagsArray containsObject:[self.itemsArray objectAtIndex:indexPath.row]]) {
         cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
                cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"tag selected");
    TagCell *cell=(TagCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType==UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self updateCardWithTag:cell.tagLabel.text delete:NO];
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self updateCardWithTag:cell.tagLabel.text delete:YES];
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
-(void)updateCardWithTag:(NSString *)cardtag delete:(BOOL)shouldDelete
{
    
    if (shouldDelete) {
        NSLog(@"delete");
    }
    else
    {
        NSLog(@"add");
    }
    
    if ([cardtag length]>0) {
        
    
    DATAUTILS.selectedCard.projectId=DATAUTILS.selectedProject.projectId;
    NSString *path=[NSString stringWithFormat:@"/projects/%@/cards/%@/tags",DATAUTILS.selectedProject.projectId,DATAUTILS.selectedCard.cardId ];
        NSDictionary *params;
    
        
        
        NSURLRequest *request;
        if (shouldDelete) {
            params=[NSDictionary dictionaryWithObject:cardtag forKey:@"tag"];
            request = [[RKObjectManager sharedManager] requestWithObject:nil method:RKRequestMethodDELETE path:path parameters:params];
         
            NSLog(@"delete dictionary:%@",params);
        }
        else
        {
            
           
           params=[NSDictionary dictionaryWithObject: cardtag forKey:@"tags"];
            
            request = [[RKObjectManager sharedManager] requestWithObject:nil method:RKRequestMethodPOST path:path parameters:params];
            
           
            NSLog(@"add dictionary:%@",params);
            
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params
                                                               options:NSJSONWritingPrettyPrinted error:nil];

            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"params printed:%@",jsonString);
            
        }
        __weak __typeof__(self) weakSelf = self;
    RKManagedObjectRequestOperation *operation = [[RKObjectManager sharedManager] managedObjectRequestOperationWithRequest:request managedObjectContext:[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"tagging success, mapping result:%@",mappingResult.array);
        if ([weakSelf.selectedTags containsObject:cardtag]) {
            [weakSelf.selectedTags removeObject:cardtag];
        }
        else
        {
            [weakSelf.selectedTags addObject:cardtag];
        }
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error.description);
        [DATAUTILS DisplayPopupWithTitle:@"Network error" andMessage:@"Error while changing the tag"];
        weakSelf.view.userInteractionEnabled=YES;
    }];
    [[RKObjectManager sharedManager].operationQueue addOperation:operation];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    if([self.delegate respondsToSelector:@selector(tagRemoved:)])
    {
        NSLog(@"delegate responds to selector");
        
        
        [self.delegate tagRemoved:self.selectedTags];
    }

}
-(void)dealloc
{
    NSLog(@"tag viewcontroller dealloc");
    self.tagsTableview.delegate=nil;
    self.tagsTableview.dataSource=nil;
}
@end
