//
//  AppDelegate.m
//  breeze
//
//  Created by Breeze on 05.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import "AppDelegate.h"
#import "NetworkManager.h"
#import "DataUtils.h"
#import <NewRelicAgent/NewRelic.h>




@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [NewRelicAgent startWithApplicationToken:@"AA39a7c3443c2fba79a3fd64c97c6421dad4815cfd"];

    
    NSError *error = nil;
    NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"DataModel" ofType:@"momd"]];
    NSLog(@"searching for model");
    NSLog(@"model path:%@",[modelURL absoluteString]);
    NSManagedObjectModel *managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL] mutableCopy];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    
    // Initialize the Core Data stack
    [managedObjectStore createPersistentStoreCoordinator];
    
    

    NSArray * searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentPath = [searchPaths objectAtIndex:0];
    NSDictionary *options = @{  NSMigratePersistentStoresAutomaticallyOption: @(YES),
                                NSInferMappingModelAutomaticallyOption: @(YES) };
    
    NSPersistentStore * persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:[NSString stringWithFormat:@"%@/CoreData.sqlite", documentPath] fromSeedDatabaseAtPath:nil withConfiguration:nil options:options error:&error];
    
    if(!persistentStore){
        NSLog(@"Failed to add persistent store: %@", error);
    }
    else
    {
        
        NSLog(@"persistent store created succesfully");
    }
    
    [managedObjectStore createManagedObjectContexts];
    
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"application/json"];
    [[NetworkManager sharedInstance] configureObjectManager:managedObjectStore];
    
    self.networkReachability=[Reachability reachabilityForInternetConnection];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
   
   [self sendAction];
    
    [self.networkReachability startNotifier];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"Application did enter foreground, try to send unsuccesfull requests");
    [self sendAction];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)reachabilityChanged:(NetworkStatus *)reach
{
     NSLog(@"NETWORK:Reachability changed ");
    if (reach==NotReachable) {
        NSLog(@"network not rechable");
        
    }
    else
    {
        NSLog(@"network reachable");
        
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(sendAction) userInfo:nil repeats:NO];
        
    }
    
   
}
-(void)sendAction
{
    NSLog(@"send action");
 
    [DATAUTILS sendUnsuccesfullRequests];
}


@end
