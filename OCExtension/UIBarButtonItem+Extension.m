//
//  UIBarButtonItem+Extension.m
//  
//
//  Created by FE on 13-9-28.
//
//

#import "UIBarButtonItem+Extension.h"

#define DEFAULT_ITEM_PADDING 15 //默认间距

@implementation UIBarButtonItem (Extension)

+(id)barButtonItemWithTitle:(NSString *)title
                     target:(id)target
                     action:(SEL)selector
{
    return [UIBarButtonItem barButtonItemWithTitle:title fontSize:15 target:target action:selector];
}

+(id)barButtonItemWithTitle:(NSString *)title
                   fontSize:(CGFloat)fontSize
                     target:(id)target
                     action:(SEL)selector
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    btn.titleLabel.backgroundColor =[UIColor clearColor];
//    [btn setTitleColor:RGBAHEX(0xFFFFFF, 0.6) forState:UIControlStateDisabled];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [btn sizeToFit];

    btn.titleEdgeInsets = UIEdgeInsetsMake(-15, -20, -15, -20);
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    return backItem;
}

+(id)barButtonItemWithImage:(UIImage *)img
                     target:(id)target
                     action:(SEL)selector
{

	UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
    btn.backgroundColor = [UIColor clearColor];
	[btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:img forState:UIControlStateNormal];
    [btn sizeToFit];
    
    btn.titleEdgeInsets = UIEdgeInsetsMake(-15, -20, -15, -20);
    
	UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
	
	return backItem;
}

+(NSArray<UIBarButtonItem *> *)barButtonItemWithButtonArray:(NSArray*)buttonArray
                                                     target:(id)target
                                                     action:(SEL)selector
{
   return  [UIBarButtonItem barButtonItemWithButtonArray:buttonArray padding:DEFAULT_ITEM_PADDING target:target action:selector];
}

+(NSArray<UIBarButtonItem *> *)barButtonItemWithButtonArray:(NSArray*)buttonArray
                                                    padding:(CGFloat)padding
                                                     target:(id)target
                                                     action:(SEL)selector
{

    NSInteger count = [buttonArray count];
    NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:count];
    UIBarButtonItem *buttomItem = nil;
    for (NSInteger i = 0; i < count; ++i) {
        UIButton* btn = buttonArray[i];
        btn.tag = i;
        [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
        btn.titleEdgeInsets = UIEdgeInsetsMake(-15, -10, -15, -10);
        
        buttomItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [itemArray addObject:buttomItem];
        
        if (i < count) {
            buttomItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                       target:nil
                                                                       action:nil];
            buttomItem.width = padding;
            [itemArray addObject:buttomItem];
        }
    }
    
    return itemArray;
}

@end
