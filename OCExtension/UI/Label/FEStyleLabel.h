

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "UIView+add.h"

//不同颜色 不同大小 设置下划线 的字体
@interface FEStyleLabel : UILabel

- (void)setTextColor:(UIColor *)textColor range:(NSRange)range;
- (void)setFont:(UIFont *)font range:(NSRange)range;
- (void)setStrokeWidth:(CGFloat)width;
- (void)setStrokeWidth:(CGFloat)width range:(NSRange)range;
- (void)setStrokeColor:(UIColor *)color;
- (void)setStrokeColor:(UIColor *)color range:(NSRange)range;
- (void)setTextKern:(CGFloat)kern;
- (void)setTextKern:(CGFloat)kern range:(NSRange)range;
- (void)setUnderlineStyle:(CTUnderlineStyle)style;

@end
