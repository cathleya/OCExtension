//
//  UITextField+add.m
//  
//
//  Created by FE on 14-3-7.
//
//

#import "UITextField+add.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
// your override code......
#pragma clang diagnostic pop

@implementation UITextField (add)

#pragma mark - 为了解决IOS6系统下 内容不居中的问题
+(UITextField*)textFieldWithFrame:(CGRect)frame{
    UITextField* textField = [[UITextField alloc] initWithFrame:frame];
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    return textField;
}

#pragma mark - IOS6系统有bug，没办法。
- (void)setTextAndKeepCursor:(NSString *)text{
    UITextRange *range = self.selectedTextRange;
    self.text = text;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending){
        self.selectedTextRange = range;
    }
}


#pragma mark - 控制placeHolder的位置
 -(CGRect)placeholderRectForBounds:(CGRect)bounds{
     return CGRectMake(bounds.origin.x + 10, bounds.origin.y, bounds.size.width - 10, bounds.size.height);//更好理解些
 }

#pragma mark - 控制显示文本的位置
-(CGRect)textRectForBounds:(CGRect)bounds{
    //return CGRectInset(bounds, 50, 0);
    return CGRectMake(bounds.origin.x + 10, bounds.origin.y, bounds.size.width - 10, bounds.size.height);//更好理解些
}

#pragma mark - 控制编辑文本的位置
-(CGRect)editingRectForBounds:(CGRect)bounds{
    //return CGRectInset( bounds, 10 , 0 );
    return CGRectMake(bounds.origin.x + 10, bounds.origin.y, bounds.size.width - 10, bounds.size.height);
}

#pragma mark - 控制placeHolder的字体颜色
-(UIColor*)placeHolderColor{
    return self.placeHolderColor;
}
-(void)setPlaceHolderColor:(UIColor *)placeHolderColor{
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder
                                                                    attributes:@{NSForegroundColorAttributeName: placeHolderColor
                                                                                 }];
}

@end
