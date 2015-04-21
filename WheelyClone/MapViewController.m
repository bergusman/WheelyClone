//
//  MapViewController.m
//  WheelyClone
//
//  Created by Vitaly Berg on 18/04/15.
//  Copyright (c) 2015 Vitaly Berg. All rights reserved.
//

#import "MapViewController.h"

#import "LeftController.h"

#import <MapKit/MapKit.h>

#import <AFNetworking/AFNetworking.h>

#import "CarAnnotationView.h"
#import "CarAnnotation.h"

#import "RequestViewController.h"

@interface MapViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (assign, nonatomic) BOOL firstUserLocation;

@property (strong, nonatomic) NSMutableArray *annotations;
@property (strong, nonatomic) NSMutableDictionary *annotationsByIds;

@property (strong, nonatomic) NSMutableSet *newsCardHack;

@property (weak, nonatomic) IBOutlet UIView *pinView;

@property (weak, nonatomic) IBOutlet UIImageView *pinLoadingView;

@end

@implementation MapViewController

#pragma mark - Setups

- (void)setupNavigationItem {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IconMenu"] style:UIBarButtonItemStylePlain target:self action:@selector(menuAction:)];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LogoNavigationBar"]];
}

#pragma mark - Content

- (void)beginLoading {
    if ([self.pinLoadingView.layer animationForKey:@"rotation"]) {
        return;
    }
    
    [self.pinLoadingView.layer removeAllAnimations];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    animation.duration = 1;
    animation.cumulative = YES;
    animation.repeatCount = CGFLOAT_MAX;
    [self.pinLoadingView.layer addAnimation:animation forKey:@"rotation"];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.pinLoadingView.alpha = 1;
    }];
}

- (void)endLoading {
    [UIView animateWithDuration:0.4 animations:^{
        self.pinLoadingView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.pinLoadingView.layer removeAllAnimations];
    }];
}

- (void)updateCars {
    
    [self beginLoading];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.wheely.com/v5"]];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    //CLLocationCoordinate2D coordinate = self.mapView.userLocation.location.coordinate;
    
    CLLocationCoordinate2D coordinate = self.mapView.centerCoordinate;
    
    
    params[@"position"] = [NSString stringWithFormat:@"%.06f,%.06f", coordinate.latitude, coordinate.longitude];
    
    [manager GET:@"cars" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        [self endLoading];

        NSMutableSet *existCars = [NSMutableSet setWithArray:[self.annotationsByIds allKeys]];
        
        NSMutableSet *serverCars = [NSMutableSet set];
        
        
        NSMutableDictionary *serverCarsByIds = [NSMutableDictionary dictionary];
        
        for (id car in responseObject[@"cars"]) {
            [serverCars addObject:car[@"id"]];
            serverCarsByIds[car[@"id"]] = car;
        }
        
        NSMutableSet *updatedCars = [existCars mutableCopy];
        [updatedCars intersectSet:serverCars];
        
        NSMutableSet *newCars = [serverCars mutableCopy];
        [newCars minusSet:existCars];
        
        NSMutableSet *deletedCars = [existCars mutableCopy];
        [deletedCars minusSet:serverCars];
        
        
        for (id carId in newCars) {
            id car = serverCarsByIds[carId];
            
            CarAnnotation *annotation = [[CarAnnotation alloc] init];
            annotation.car = car;
            id position = car[@"position"];
            annotation.coordinate = CLLocationCoordinate2DMake([position[0] doubleValue], [position[1] doubleValue]);
            
            [self.annotations addObject:annotation];
            self.annotationsByIds[carId] = annotation;
            
            [self.mapView addAnnotation:annotation];
            
            

            
        }
        
        self.newsCardHack = newCars;
        
        for (id carId in deletedCars) {
            CarAnnotation *annotation = self.annotationsByIds[carId];
            
            [self.annotations removeObject:annotation];
            [self.annotationsByIds removeObjectForKey:carId];
            
            CarAnnotationView *annotationView = [self.mapView viewForAnnotation:annotation];
            
            [UIView animateWithDuration:0.2 animations:^{
                annotationView.alpha = 0;
            } completion:^(BOOL finished) {
                [self.mapView removeAnnotation:annotation];
            }];
        
        }
        
        for (id carId in updatedCars) {
            CarAnnotation *annotation = self.annotationsByIds[carId];
            id car = serverCarsByIds[carId];
            
            annotation.car = car;
            
            id position = car[@"position"];
            
            
            CarAnnotationView *annotationView = [self.mapView viewForAnnotation:annotation];
            
            [UIView animateWithDuration:0.2 animations:^{
                annotation.coordinate = CLLocationCoordinate2DMake([position[0] doubleValue], [position[1] doubleValue]);
                
                [annotationView update];
            }];
            
            
            
        }
        
        
        

        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark - Actions

- (void)menuAction:(id)sender {
    [self.leftController showMenu];
}

- (IBAction)requestTouchUpInside:(id)sender {
    RequestViewController *requestVC = [[RequestViewController alloc] init];
    UINavigationController *requestNC = [[UINavigationController alloc] initWithRootViewController:requestVC];
    //requestNC.navigationBar.barStyle = UIBarStyleBlack;
    requestNC.navigationBar.barTintColor = [UIColor blackColor];
    requestNC.navigationBar.tintColor = [UIColor whiteColor];
    [self presentViewController:requestNC animated:YES completion:nil];
}


#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if (!self.firstUserLocation) {
        self.firstUserLocation = YES;
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 2000, 2000);
        [self.mapView setRegion:region animated:YES];
        [self updateCars];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    CarAnnotationView *annotationView = (CarAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"car"];
    if (!annotationView) {
        annotationView = [[CarAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"car"];
    }
    
    id car = ((CarAnnotation *)annotation).car;
    
    if ([self.newsCardHack containsObject:car[@"id"]]) {
        [self.newsCardHack removeObject:car[@"id"]];
        annotationView.alpha = 0;
        [UIView animateWithDuration:0.2 animations:^{
            annotationView.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    [self updateCars];
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationItem];
    
    self.annotations = [NSMutableArray array];
    self.annotationsByIds = [NSMutableDictionary dictionary];
    
    self.mapView.showsUserLocation = YES;
    self.mapView.showsBuildings = YES;
    self.mapView.mapType = MKMapTypeStandard;
    
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];
}

@end
