

#import <UIKit/UIKit.h>
#define UI_LABLE_DEFAULT_BADEG_WIDTH_MAX 30
@interface UILabel (add)

- (void)sizeFitWithConstraintSize:(CGSize)constraintSize;

//设置label行间距
- (void)setLabelLineSpace:(CGFloat)space;


@end
