//
//  Wheely.h
//  WheelyClone
//
//  Created by Vitaly Berg on 18/04/15.
//  Copyright (c) 2015 Vitaly Berg. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AFNetworking/AFNetworking.h>

@interface Wheely : NSObject

@property (strong, nonatomic) AFHTTPSessionManager *manager;

+ (Wheely *)shared;

@end
