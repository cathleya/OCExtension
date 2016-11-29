//
//  FETabBarController.m
//  FEFramework
//
//  Created by Tom on 15/1/20.
//  Copyright (c) 2015年 liyy. All rights reserved.
//

#import "FETabBarController.h"
#import "NSObject+GCD.h"

@interface FETabBarController ()
{
}
@end

@implementation FETabBarController

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupFETabBar];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.feTabBar.frame = self.tabBar.bounds;
    [self removeSystemTabbarItem];
}

-(void)setupFETabBar
{
    UITabBar* tabbar = self.tabBar;
    tabbar.backgroundColor = [UIColor clearColor];

    self.feTabBar = [[FETabBar alloc] initWithFrame:tabbar.bounds];
    
    self.feTabBar.delegate = self;
    
    [self.tabBar addSubview:self.feTabBar];
}


- (void)removeSystemTabbarItem
{
    UITabBar* tabbar = self.tabBar;
    tabbar.backgroundColor = [UIColor clearColor];
    //去掉系统按钮， 去掉默认分割线
    for (UIView* view in tabbar.subviews)
    {
        if ([view isKindOfClass:[FETabBar class]])
        {
            continue;
        }
        
        [view removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.feTabBar.frame = self.tabBar.bounds;
    [self removeSystemTabbarItem];
}


#pragma mark -
-(void)changeToIndex:(NSInteger)index
{
    UIViewController* selectedViewController = self.selectedViewController;
    if ([selectedViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController* nav = (UINavigationController*)selectedViewController;
        [nav popToRootViewControllerAnimated:NO];
    }
    
    __weak typeof(self) weakSelf = self;
    
    
    [self performAfter:0.01 block:^{ //延时处理 防止pop动画未处理完导致崩溃
        weakSelf.selectedIndex = index;
        weakSelf.feTabBar.selectedIndex = index;
    }];

}



#pragma mark FETabBarDelegate
- (void) tabBar:(FETabBar *)tabBar selectedFrom:(NSInteger)from to:(NSInteger)to
{
    self.selectedIndex = to;
}

- (void) tabBar:(FETabBar *)tabBar shortcutsButtonTouched:(UIButton*)button
{
    
}

@end
