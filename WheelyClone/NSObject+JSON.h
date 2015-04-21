//
//  NSObject+JSON.h
//  WheelyClone
//
//  Created by Vitaly Berg on 18/04/15.
//  Copyright (c) 2015 Vitaly Berg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JSON)

- (BOOL)json_isNull;
- (BOOL)json_isNumber;
- (BOOL)json_isString;
- (BOOL)json_isArray;
- (BOOL)json_isDictionary;

- (NSNumber *)json_number;
- (NSString *)json_string;
- (NSArray *)json_array;
- (NSDictionary *)json_dictionary;

- (NSDate *)json_timestamp;

+ (NSArray *)json_objectsWithJSON:(id)json;

@end
