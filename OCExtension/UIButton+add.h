//
//  UIButton+add.h
//  
//
//  Created by FE on 13-11-15.
//
//

#import <UIKit/UIKit.h>

typedef enum
{
    FEButtonIconSideLeft,
    FEButtonIconSideTop,
    FEButtonIconSideRight,
    FEButtonIconSideBottom
}FEButtonIconOrien;

@interface UIButton (add)



@property (nonatomic, assign) UIEdgeInsets hitTestEdgeInsets;

/**设置点击时间间隔*/
@property (nonatomic, assign) NSTimeInterval timeInterval;//默认0

- (void)setTitle:(NSString *)title;

- (void)setTitleColor:(UIColor *)color;

- (void)setImage:(UIImage *)image;

- (void)setTitle:(NSString *)title icon:(UIImage *)icon gap:(CGFloat)gap iconOrien:(FEButtonIconOrien)orien;

- (void)setBackgroundStretchableImage:(UIImage *)image;

- (void)setBackgroundStretchableImage:(UIImage *)image forState:(UIControlState)state;

- (void)addTarget:(id)target action:(SEL)action;

- (void)setIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPath;

//tup 和 标题 叠加
- (CGSize)sizeForImageView;
- (CGSize)sizeForTitleLabel;
@end
