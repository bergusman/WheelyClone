//
//  Car.m
//  WheelyClone
//
//  Created by Vitaly Berg on 18/04/15.
//  Copyright (c) 2015 Vitaly Berg. All rights reserved.
//

#import "Car.h"
#import "NSObject+JSON.h"
#import <HexColors/HexColor.h>

@implementation Car

#pragma mark - JSONCoding

- (instancetype)initWithJSON:(id)json {
    if (![json json_isDictionary]) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        _id = [json[@"id"] json_string];
        _bearing = [[json[@"bearing"] json_number] doubleValue];
        
        if ([json[@"position"] json_isArray]) {
            NSArray *position = [json[@"position"] json_array];
            if (position.count >= 2) {
                double lat = [[position[0] json_number] doubleValue];
                double lng = [[position[0] json_number] doubleValue];
                _position = CLLocationCoordinate2DMake(lat, lng);
            }
        }
        
        _color = [UIColor colorWithHexString:[json[@"color"] json_string]];
    }
    return self;
}

- (id)JSON {
    return [NSDictionary dictionary];
}

+ (instancetype)objectWithJSON:(id)json {
    return [[self alloc] initWithJSON:json];
}

+ (NSArray *)objectsWithJSON:(id)json {
    return [self json_objectsWithJSON:json];
}

@end
