//
//  FENavigationController+FEBackGesture.h
//  FEFramework
//
//  Created by Tom on 15/1/20.
//  Copyright (c) 2015年 liyy. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "UIViewController+add.h"

#define BackGestureOffsetXToBack 80//>80 show pre vc

@interface UINavigationController (FEBackGesture)<UIGestureRecognizerDelegate>
/*!
 *	@brief	Default is NO;
 *  @note need call this after ViewDidLoad otherwise not work;
 */
@property (assign,nonatomic) BOOL enableBackGesture;

//找出此类型的VC
-(UIViewController*)findViewControllerWithClass:(Class)viewControllserClass;
-(UIViewController*)findViewControllerWithClass:(Class)viewControllserClass identifier:(NSString*)identifier;

//移除fromVC后面的VC 并push新的VC
- (void)pushViewController:(UIViewController *)viewController fromVC:(UIViewController*)fromVC animated:(BOOL)animated;

//移除beforeVC及后面的VC 并push新的VC
- (void)pushViewController:(UIViewController *)viewController befroeVC:(UIViewController*)beforeVC animated:(BOOL)animated;

//返回到此类型的VC
- (void)popToViewControllerWithClass:(Class)viewControllserClass animated:(BOOL)animated;

//返回vc之前的VC
- (void)popToBefroeVC:(UIViewController *)vc animated:(BOOL)animated;


@end
