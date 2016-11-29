//
//  FETabBarController.h
//  FEFramework
//
//  Created by Tom on 15/1/20.
//  Copyright (c) 2015年 liyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FETabBar.h"

@interface FETabBarController : UITabBarController
<
FETabBarDelegate
>

@property (nonatomic, strong) FETabBar* feTabBar;

//选择某个索引
-(void)changeToIndex:(NSInteger)index;

@end
