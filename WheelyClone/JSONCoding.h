//
//  JSONCoding.h
//  WheelyClone
//
//  Created by Vitaly Berg on 18/04/15.
//  Copyright (c) 2015 Vitaly Berg. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JSONCoding <NSObject>

- (instancetype)initWithJSON:(id)json;
- (id)JSON;

+ (instancetype)objectWithJSON:(id)json;
+ (NSArray *)objectsWithJSON:(id)json;

@end
