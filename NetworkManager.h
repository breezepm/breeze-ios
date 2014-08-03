//
//  NetworkManager.h
//  breeze
//
//  Created by Breeze on 05.05.2014.
//  Copyright (c) 2014 Breeze. All rights reserved.
//

#import <Foundation/Foundation.h>
//#define BASE_URL @"http://api.breeze.pm"
#define BASE_URL @"https://bmapi.herokuapp.com"

@interface NetworkManager : NSObject

+ (NetworkManager *)sharedInstance;
- (void)configureObjectManager :(RKManagedObjectStore *)managedObjectStore;

@end
