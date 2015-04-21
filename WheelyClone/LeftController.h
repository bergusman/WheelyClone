//
//  LeftController.h
//  WheelyClone
//
//  Created by Vitaly Berg on 18/04/15.
//  Copyright (c) 2015 Vitaly Berg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftController : UIViewController

@property (strong, nonatomic) UIViewController *menuViewController;
@property (strong, nonatomic) UIViewController *contentViewController;

- (void)showMenu;
- (void)hideMenu;

@end

@interface UIViewController (Left)

@property (strong, nonatomic, readonly) LeftController *leftController;

@end