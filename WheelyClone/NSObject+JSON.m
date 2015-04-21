//
//  NSObject+JSON.m
//  WheelyClone
//
//  Created by Vitaly Berg on 18/04/15.
//  Copyright (c) 2015 Vitaly Berg. All rights reserved.
//

#import "NSObject+JSON.h"
#import "JSONCoding.h"

@implementation NSObject (JSON)

- (BOOL)json_isNull {
    return [self isKindOfClass:[NSNull class]];
}

- (BOOL)json_isNumber {
    return [self isKindOfClass:[NSNumber class]];
}

- (BOOL)json_isString {
    return [self isKindOfClass:[NSString class]];
}

- (BOOL)json_isArray {
    return [self isKindOfClass:[NSArray class]];
}

- (BOOL)json_isDictionary {
    return [self isKindOfClass:[NSDictionary class]];
}

- (NSNumber *)json_number {
    if ([self json_isNumber]) {
        return (NSNumber *)self;
    } else if ([self json_isString]) {
        return @([(NSString *)self doubleValue]);
    }
    return nil;
}

- (NSString *)json_string {
    if ([self json_isString]) {
        return (NSString *)self;
    } else if ([self json_isNumber]) {
        return [(NSNumber *)self stringValue];
    }
    return nil;
}

- (NSArray *)json_array {
    if ([self json_isArray]) {
        return (NSArray *)self;
    }
    return nil;
}

- (NSDictionary *)json_dictionary {
    if ([self json_isDictionary]) {
        return (NSDictionary *)self;
    }
    return nil;
}

- (NSDate *)json_timestamp {
    if ([self json_isNumber]) {
        return [NSDate dateWithTimeIntervalSince1970:[[self json_number] doubleValue]];
    }
    return nil;
}

+ (NSArray *)json_objectsWithJSON:(id)json {
    if (![json json_isArray]) {
        return nil;
    }
    
    NSMutableArray *objects = [NSMutableArray array];
    for (id jsonItem in json) {
        id object = [(id<JSONCoding>)self objectWithJSON:jsonItem];
        [objects addObject:object];
    }
    return objects;
}

@end
