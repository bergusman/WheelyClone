//
//  MenuViewController.m
//  WheelyClone
//
//  Created by Vitaly Berg on 18/04/15.
//  Copyright (c) 2015 Vitaly Berg. All rights reserved.
//

#import "MenuViewController.h"

#import "WheelygramViewController.h"
#import "LeftController.h"

#import "AppDelegate.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

#pragma mark - Actions

- (IBAction)mapTouchUpInside:(id)sender {
    self.leftController.contentViewController = [AppDelegate shared].mapNavigationController;
    [self.leftController hideMenu];
}

- (IBAction)weelygramTouchUpInside:(id)sender {
    WheelygramViewController *wheelyVC = [[WheelygramViewController alloc] init];
    UINavigationController *wheelyNC = [[UINavigationController alloc] initWithRootViewController:wheelyVC];
    self.leftController.contentViewController = wheelyNC;
    [self.leftController hideMenu];
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
