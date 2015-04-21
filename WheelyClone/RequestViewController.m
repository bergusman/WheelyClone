//
//  RequestViewController.m
//  WheelyClone
//
//  Created by Vitaly Berg on 18/04/15.
//  Copyright (c) 2015 Vitaly Berg. All rights reserved.
//

#import "RequestViewController.h"

#import "OfferCell.h"

#import <AFNetworking/AFNetworking.h>

@interface RequestViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *offers;

@end

@implementation RequestViewController

#pragma mark - Setups

- (void)setupNavigationItem {
    self.navigationItem.title = @"New Booking";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction:)];
}

- (void)setupTableView {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[OfferCell nib] forCellReuseIdentifier:@"offer"];
}

#pragma mark - Content

- (void)loadOffers {
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.wheely.com/v5"]];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    //CLLocationCoordinate2D coordinate = self.mapView.userLocation.location.coordinate;
    
    //CLLocationCoordinate2D coordinate = self.mapView.centerCoordinate;
    
    
    //params[@"position"] = [NSString stringWithFormat:@"%.06f,%.06f", coordinate.latitude, coordinate.longitude];
    
    [manager GET:@"offers" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
  
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.offers.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - UITableViewDelegate

#pragma mark - Actions

- (void)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationItem];
    [self setupTableView];
}

@end
