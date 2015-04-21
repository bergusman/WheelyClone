//
//  CarAnnotationView.m
//  WheelyClone
//
//  Created by Vitaly Berg on 18/04/15.
//  Copyright (c) 2015 Vitaly Berg. All rights reserved.
//

#import "CarAnnotationView.h"

#import "CarAnnotation.h"

#import <HexColors/HexColor.h>

@interface CarAnnotationView ()

@property (strong, nonatomic) UIView *rotateView;

@property (strong, nonatomic) UIImageView *maskImage;
@property (strong, nonatomic) UIImageView *overlayImage;
@property (strong, nonatomic) UIImageView *whiteImage;

@end

@implementation CarAnnotationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(0, 0, 70, 70)];
    if (self) {
        self.rotateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
        [self addSubview:self.rotateView];
        
        self.maskImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
        self.maskImage.image = [[UIImage imageNamed:@"PinCarMask"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.maskImage.contentMode = UIViewContentModeCenter;
        [self.rotateView addSubview:self.maskImage];
        
        self.overlayImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
        self.overlayImage.image = [UIImage imageNamed:@"PinCarOverlayDark"];
        self.overlayImage.contentMode = UIViewContentModeCenter;
        [self.rotateView addSubview:self.overlayImage];
        
        self.whiteImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
        self.whiteImage.image = [UIImage imageNamed:@"PinCarOverlayLight"];
        self.whiteImage.contentMode = UIViewContentModeCenter;
        [self.rotateView addSubview:self.whiteImage];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.alpha = 1;
    [self.rotateView.layer removeAllAnimations];
}

- (void)update {
    CarAnnotation *carAnnotation = (CarAnnotation *)self.annotation;
    id car = carAnnotation.car;
    
    if ([car[@"bearing"] isKindOfClass:[NSNumber class]]) {
        CGFloat bearing = [car[@"bearing"] doubleValue];
        self.rotateView.transform = CGAffineTransformMakeRotation(bearing * M_PI / 180.0 + M_PI_2 + M_PI);
    }
    
    if ([[car[@"color"] uppercaseString] isEqualToString:@"FFFFFF"]) {
        self.maskImage.hidden = YES;
        self.overlayImage.hidden = YES;
        self.whiteImage.hidden = NO;
    } else {
        self.maskImage.hidden = NO;
        self.overlayImage.hidden = NO;
        self.whiteImage.hidden = YES;
        self.maskImage.tintColor = [UIColor colorWithHexString:car[@"color"]];
    }
}

- (void)setAnnotation:(id<MKAnnotation>)annotation {
    [super setAnnotation:annotation];
    [self update];
}

@end
