
#import <UIKit/UIKit.h>
#import "FEPrecompile.h"

/**
 *  支持block的 alertview
 */

typedef NS_ENUM(NSInteger, FEAlertViewStyle) {
    FEAlertViewStyleActionSheet = 0, //action sheet
    FEAlertViewStyleAlert           //alert view
};

@interface FEAlertView : NSObject
{
    NSMutableDictionary *_blockDict;
}

//默认 FEAlertViewStyleAlert
- (instancetype)initWithTitle:(NSString *)title
            message:(NSString *)message;

- (instancetype)initWithTitle:(NSString *)title
            message:(NSString *)message
              style:(FEAlertViewStyle)style;

//alert view
+ (instancetype)alertViewWithTitle:(NSString *)title
                           message:(NSString *)message;

//action Sheet
+ (instancetype)actionSheetWithTitle:(NSString *)title;

//设置单个button的处理block
-(void)addButtonWithTitle:(NSString*)title block:(void (^)())block;

-(void)addCancelButtonWithTitle:(NSString*)title block:(void (^)())block;

-(void)addDestructiveButtonWithTitle:(NSString*)title block:(void (^)())block;


//显示
-(void)show;

//显示
-(void)showInViewController:(UIViewController *)vc;

//隐藏 此方法只用于非用户操作时隐藏用。
- (void)dismiss;

//移除队列中alertView 用于应用强制退出后 导致队列中的alertView残留的问题
+ (void)dismissAllAlertView;


@end
