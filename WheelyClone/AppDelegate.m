//
//  AppDelegate.m
//  WheelyClone
//
//  Created by Vitaly Berg on 18/04/15.
//  Copyright (c) 2015 Vitaly Berg. All rights reserved.
//

#import "AppDelegate.h"

#import "LeftController.h"
#import "MenuViewController.h"
#import "MapViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - Setups

- (void)setupAppearance {
    [UINavigationBar appearance].barStyle = UIBarStyleBlack;
    [UINavigationBar appearance].barTintColor = [UIColor blackColor];
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
}

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupAppearance];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    LeftController *leftVC = [[LeftController alloc] init];
    
    MapViewController *mapVC = [[MapViewController alloc] init];
    UINavigationController *mapNC = [[UINavigationController alloc] initWithRootViewController:mapVC];

    MenuViewController *menuVC = [[MenuViewController alloc] init];
    
    
    leftVC.menuViewController = menuVC;
    leftVC.contentViewController = mapNC;
    self.window.rootViewController = leftVC;
    
    self.mapNavigationController = mapNC;
    
    return YES;
}

#pragma mark - Singleton

+ (AppDelegate *)shared {
    return [UIApplication sharedApplication].delegate;
}

@end
