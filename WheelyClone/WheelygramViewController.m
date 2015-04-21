//
//  WheelygramViewController.m
//  WheelyClone
//
//  Created by Vitaly Berg on 18/04/15.
//  Copyright (c) 2015 Vitaly Berg. All rights reserved.
//

#import "WheelygramViewController.h"

#import "LeftController.h"

#import "PhotoCell.h"

#import "Wheely.h"

@interface WheelygramViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *photos;

@end

@implementation WheelygramViewController

#pragma mark - Setups

- (void)setupNavigationItem {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IconMenu"] style:UIBarButtonItemStylePlain target:self action:@selector(menuAction:)];
    self.navigationItem.title = @"#wheelygram";
}

- (void)setupTableView {
    [self.tableView registerNib:[PhotoCell nib] forCellReuseIdentifier:@"photo"];
}

#pragma mark - Content

- (void)loadPhotos {
    [[Wheely shared].manager GET:@"wheelygram" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        self.photos = responseObject[@"posts"];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark - Actions

- (void)menuAction:(id)sender {
    [self.leftController showMenu];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.photos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photo" forIndexPath:indexPath];
    id photo = self.photos[indexPath.row];
    [cell fillPhoto:photo];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id photo = self.photos[indexPath.row];
    
    CGFloat w = [photo[@"image"][@"width"] doubleValue];
    w -= [photo[@"image"][@"insets"][@"l"] doubleValue];
    w -= [photo[@"image"][@"insets"][@"r"] doubleValue];
    
    
    CGFloat h = [photo[@"image"][@"height"] doubleValue];
    h -= [photo[@"image"][@"insets"][@"t"] doubleValue];
    h -= [photo[@"image"][@"insets"][@"b"] doubleValue];
    
    CGFloat c = w / h;
    
    CGFloat height = tableView.bounds.size.width / c;
    return floor(height);
    
    /*
    CGFloat height = [photo[@"image"][@"height"] doubleValue];
    CGFloat temp = height;
    temp -= [photo[@"image"][@"insets"][@"t"] doubleValue];
    temp -= [photo[@"image"][@"insets"][@"b"] doubleValue];
    CGFloat p = temp / height;
    height = p * tableView.bounds.size.width;
    height = ceil(height);
    return height;
     */
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id photo = self.photos[indexPath.row];
    NSLog(@"%@", photo);
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationItem];
    [self setupTableView];
    [self loadPhotos];
}

@end
