//
//  FETabBar.h
//  FEFramework
//
//  Created by Tom on 15/1/20.
//  Copyright (c) 2015年 liyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FETabBarItem.h"

@class FETabBar;

@protocol FETabBarDelegate <NSObject>
@optional
- (void)tabBar:(FETabBar *)tabBar selectedFrom:(NSInteger)from to:(NSInteger)to;
- (void)tabBar:(FETabBar *)tabBar shortcutsButtonTouched:(UIButton*)button;
- (void)tabBar:(FETabBar *)tabBar doubleSelected:(NSInteger)index;

@end

@interface FETabBar : UIView

@property(nonatomic, weak) id<FETabBarDelegate> delegate;

@property (nonatomic, strong) UIColor* titleColor;
@property (nonatomic, strong) UIColor* titleSelectedColor;
@property (nonatomic, assign) NSInteger selectedIndex;


-(FETabBarItem *)addButtonWithTitle:(NSString*)title image:(NSString *)image selectedImage:(NSString *) selectedImage;
-(UIButton *)addShortcutsButtonWithTitle:(NSString*)title image:(UIImage *)image selectedImage:(UIImage *) selectedImage;

//设置提示数字
-(void)setBadgeValue:(NSInteger)badgeValue index:(NSInteger)index;

@end
