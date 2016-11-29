

#import "FETouchableView.h"

@implementation FETouchableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_delegate
        &&[_delegate respondsToSelector:@selector(viewTouchesEnded:)])
    {
        [_delegate viewTouchesEnded:self];
    }
}


//#pragma mark - < 重写 > -
//
///**
// *  自动收起键盘
// *
// *  @param point 点击事件的位置
// *  @param event 点击事件
// *
// *  @return 处理点击事件的视图
// */
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    UIView * result = [super hitTest:point withEvent:event];
//    if (![result isKindOfClass:[UITextField class]] && //自动收起键盘，排除UITextField，UITextView，UISearchBar
//        ![result isKindOfClass:[UITextView class]] &&
//        ![result isKindOfClass:[UISearchBar class]]) {
//        [self endEditing:YES];
//    }
//    return result;
//}

@end
