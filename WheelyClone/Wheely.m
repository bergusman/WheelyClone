//
//  Wheely.m
//  WheelyClone
//
//  Created by Vitaly Berg on 18/04/15.
//  Copyright (c) 2015 Vitaly Berg. All rights reserved.
//

#import "Wheely.h"

@interface Wheely ()

@end

@implementation Wheely

- (instancetype)init {
    self = [super init];
    if (self) {
        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.wheely.com/v5"]];
    }
    return self;
}

#pragma mark - Singleton

+ (Wheely *)shared {
    static Wheely *wheely;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        wheely = [[Wheely alloc] init];
    });
    return wheely;
}

@end
