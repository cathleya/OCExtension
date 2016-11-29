//
//  FETabBarControllerProtocol.h
//  
//
//  Created by ios on 15/11/6.
//
//

#import <Foundation/Foundation.h>

@protocol FETabBarControllerProtocol <NSObject>
@optional
- (void)tabBarController:(UITabBarController *)tabBarController didSelectVC:(UIViewController *)vc;
- (void)tabBarController:(UITabBarController *)tabBarController didDoubleSelectVC:(UIViewController *)vc;

@end
