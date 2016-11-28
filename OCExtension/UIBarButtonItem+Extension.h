//
//  UIBarButtonItem+Extension.h
//  
//
//  Created by FE on 13-9-28.
//
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

+(id)barButtonItemWithTitle:(NSString *)title
                     target:(id)target
                     action:(SEL)selector;

+(id)barButtonItemWithTitle:(NSString *)title
                   fontSize:(CGFloat)fontSize
                     target:(id)target
                     action:(SEL)selector;

+(id)barButtonItemWithImage:(UIImage *)img
                     target:(id)target
                     action:(SEL)selector;

//左导航按钮 buttonArray 是从左到右排序显示
//右导航按钮 buttonArray 是从右到左排序显示
+(NSArray<UIBarButtonItem *> *)barButtonItemWithButtonArray:(NSArray*)buttonArray
                                                     target:(id)target
                                                     action:(SEL)selector;

+(NSArray<UIBarButtonItem *> *)barButtonItemWithButtonArray:(NSArray*)buttonArray
                                                    padding:(CGFloat)padding
                                                     target:(id)target
                                                     action:(SEL)selector;

@end

