//
//  LeftController.m
//  WheelyClone
//
//  Created by Vitaly Berg on 18/04/15.
//  Copyright (c) 2015 Vitaly Berg. All rights reserved.
//

#import "LeftController.h"

@interface LeftController ()

@property (assign, nonatomic) BOOL menuShown;

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIView *menuView;

@property (strong, nonatomic) UITapGestureRecognizer *tap;
@property (strong, nonatomic) UIPanGestureRecognizer *pan;

@end

@implementation LeftController

#pragma mark - Content

- (void)showMenu {
    self.menuShown = YES;
    self.menuView.hidden = NO;
    self.contentViewController.view.userInteractionEnabled = NO;
    self.tap.enabled = YES;
    self.pan.enabled = YES;
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect r = self.contentView.frame;
        r.origin.x = 200;
        self.contentView.frame = r;
        [self setNeedsStatusBarAppearanceUpdate];
    } completion:^(BOOL finished) {
    }];
}

- (void)hideMenu {
    self.menuShown = NO;
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.contentView.frame = self.view.bounds;
        [self setNeedsStatusBarAppearanceUpdate];
    } completion:^(BOOL finished) {
        self.menuView.hidden = YES;
        self.contentViewController.view.userInteractionEnabled = YES;
        self.tap.enabled = NO;
        self.pan.enabled = NO;
    }];
}

- (void)setContentViewController:(UIViewController *)contentViewController {
    if (_contentViewController) {
        [_contentViewController willMoveToParentViewController:nil];
        [_contentViewController.view removeFromSuperview];
        [_contentViewController removeFromParentViewController];
    }
    
    _contentViewController = contentViewController;
    
    if (_contentViewController) {
        [self addChildViewController:_contentViewController];
        [self.contentView addSubview:_contentViewController.view];
        _contentViewController.view.frame = self.contentView.bounds;
        [_contentViewController didMoveToParentViewController:self];
    }
}

- (void)setMenuViewController:(UIViewController *)menuViewController {
    if (_menuViewController) {
        [_menuViewController willMoveToParentViewController:nil];
        [_menuViewController.view removeFromSuperview];
        [_menuViewController removeFromParentViewController];
    }
    
    _menuViewController = menuViewController;
    
    if (_menuViewController) {
        [self addChildViewController:_menuViewController];
        [self.menuView addSubview:_menuViewController.view];
        _menuViewController.view.frame = self.menuView.bounds;
        _menuViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [_menuViewController didMoveToParentViewController:self];
    }
}

#pragma mark - Actions

- (void)tapAction:(id)sender {
    [self hideMenu];
}

- (void)panAction:(UIPanGestureRecognizer *)pan {
    
    if (pan.state == UIGestureRecognizerStateBegan) {
    }
    else if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [pan translationInView:self.view];
        
        CGFloat x = translation.x;
        x = MAX(MIN(x, 0), -200);
        
        CGRect r = self.contentView.frame;
        r.origin.x = 200 + x;
        self.contentView.frame = r;
    }
    else if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
        //CGPoint translation = [pan translationInView:self.view];
        CGPoint velocity = [pan velocityInView:self.view];
        CGFloat distance = self.contentView.frame.origin.x;
        
        if (velocity.x < -1500) {
            CGFloat duration = (distance / fabs(velocity.x)) * 1.5;
            
            self.menuShown = NO;
            
            [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.contentView.frame = self.view.bounds;
                [self setNeedsStatusBarAppearanceUpdate];
            } completion:^(BOOL finished) {
                self.menuView.hidden = YES;
                self.contentViewController.view.userInteractionEnabled = YES;
                self.tap.enabled = NO;
                self.pan.enabled = NO;
            }];
        } else {
            if (velocity.x < 0) {
                self.menuShown = NO;
                
                [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.contentView.frame = self.view.bounds;
                    [self setNeedsStatusBarAppearanceUpdate];
                } completion:^(BOOL finished) {
                    self.menuView.hidden = YES;
                    self.contentViewController.view.userInteractionEnabled = YES;
                    self.tap.enabled = NO;
                    self.pan.enabled = NO;
                }];
            } else {
                [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    CGRect r = self.contentView.frame;
                    r.origin.x = 200;
                    self.contentView.frame = r;
                } completion:^(BOOL finished) {
                }];
            }
        }
    }
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.menuView.hidden = YES;
    self.menuView.frame = self.view.bounds;
    [self.view addSubview:self.menuView];
    
    self.contentView.frame = self.view.bounds;
    [self.view addSubview:self.contentView];
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    self.tap.enabled = NO;
    [self.contentView addGestureRecognizer:self.tap];
    
    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    self.pan.enabled = NO;
    [self.contentView addGestureRecognizer:self.pan];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGRect r;
    
    if (self.menuShown) {
        r = self.contentView.frame;
        r.size = self.view.bounds.size;
        r.origin.y = 0;
        r.origin.x = 200;
        self.contentView.frame = r;
        self.menuView.frame = self.view.bounds;
    } else {
        self.contentView.frame = self.view.bounds;
        self.menuView.frame = self.view.bounds;
    }
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    if (self.menuShown) {
        return self.menuViewController;
    } else {
        return self.contentViewController;
    }
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.menuView = [[UIView alloc] init];
        self.menuView.frame = CGRectMake(0, 0, 320, 320);
        
        self.contentView = [[UIView alloc] init];
        self.contentView.frame = CGRectMake(0, 0, 320, 320);
    }
    return self;
}

@end

@implementation UIViewController (Left)

- (LeftController *)leftController {
    UIViewController *vc = self.parentViewController;
    while (vc) {
        if ([vc isKindOfClass:[LeftController class]]) {
            return (LeftController *)vc;
        }
        vc = vc.parentViewController;
    }
    return nil;
}

@end
