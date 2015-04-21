//
//  Car.h
//  WheelyClone
//
//  Created by Vitaly Berg on 18/04/15.
//  Copyright (c) 2015 Vitaly Berg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "JSONCoding.h"

@interface Car : NSObject <JSONCoding>

@property (strong, nonatomic) NSString *id;
@property (assign, nonatomic) CLLocationDirection bearing;
@property (assign, nonatomic) CLLocationCoordinate2D position;
@property (strong, nonatomic) UIColor *color;

@end
