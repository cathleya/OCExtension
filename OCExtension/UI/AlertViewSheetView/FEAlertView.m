#import "FEAlertView.h"

static NSMutableArray   *s_alertViewArray;

@interface FEAlertView()
<
UIAlertViewDelegate
, UIActionSheetDelegate
>

@end

@implementation FEAlertView
{
    UIAlertController       *_alertController;
    UIAlertView             *_alertView;
    UIActionSheet           *_actionSheet;
    
    FEAlertViewStyle        _style;
}

- (instancetype)init
{
    self = [self initWithTitle:nil message:nil];
    if (self) {
        
    }
    
    return self;
}

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
{
    return [self initWithTitle:title message:message style:FEAlertViewStyleAlert];
}

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
              style:(FEAlertViewStyle)style
{
    self = [super init];
    if (self) {
        
        _style = style;
        
        if (IOS8_OR_LATER) {
            _alertController = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:style == FEAlertViewStyleAlert ? UIAlertControllerStyleAlert : UIAlertControllerStyleActionSheet];
            
        } else {
            
            if (style == FEAlertViewStyleAlert) {
                _alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil];
            } else {
                _actionSheet = [[UIActionSheet alloc] initWithTitle:title ? title : message
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:nil];
            }
        }
    }
    
    return self;
}

+ (instancetype)alertViewWithTitle:(NSString *)title
                           message:(NSString *)message
{
    id view = [[FEAlertView alloc] initWithTitle:title message:message];
    return view;
}

+ (instancetype)actionSheetWithTitle:(NSString *)title
{
    id view = [[FEAlertView alloc] initWithTitle:title message:nil style:FEAlertViewStyleActionSheet];
    return view;
}

-(void)dealloc
{
    NSLog(@"FEAlertView dealloc");
}

- (void)show
{
    [self showInViewController:nil];
}

//显示
-(void)showInViewController:(UIViewController *)vc
{
    if (IOS8_OR_LATER) {
        UIViewController *topVC = vc;
        if (topVC == nil) {
            topVC = [UIApplication sharedApplication].keyWindow.rootViewController;
            topVC = [FEAlertView topMostViewController:topVC];
        }
        
        [topVC presentViewController:_alertController animated:YES completion:nil];
        
    } else {
        if (_alertView) {
            [_alertView show];
        } else {
            UIViewController *topVC = vc;
            if (topVC == nil) {
                topVC = [UIApplication sharedApplication].keyWindow.rootViewController;
                topVC = [FEAlertView topMostViewController:topVC];
            }
            
            [_actionSheet showInView:topVC.view];
        }
    }
    
    [FEAlertView addAlertView:self];
}

- (void)dismiss
{
    if (_alertView) {
        [_alertView dismissWithClickedButtonIndex:-1 animated:NO];
    } else if (_actionSheet) {
        [_actionSheet dismissWithClickedButtonIndex:-1 animated:NO];
    } else {
        [_alertController dismissViewControllerAnimated:NO completion:nil];
    }
    
    [FEAlertView removeAlertView:self];
}

-(void)addButtonWithTitle:(NSString *)title block:(void (^)())block
{
    if (IOS8_OR_LATER) {
        __weak typeof(self) weakSelf = self;
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [FEAlertView removeAlertView:weakSelf];
            
            if (block) {
                block();
            }
            
        }];
        
        [_alertController addAction:alertAction];
        
    } else {
        NSInteger index = -1;
        if (_alertView) {
            index = [_alertView addButtonWithTitle:title];
        } else {
            index = [_actionSheet addButtonWithTitle:title];
        }
        if (block)
        {
            if (_blockDict == nil)
            {
                _blockDict = [NSMutableDictionary dictionary];
            }
            
            [_blockDict setObject:block forKey:[NSNumber numberWithInteger:index]];
        }
    }
    
}

-(void)addCancelButtonWithTitle:(NSString*)title block:(void (^)())block
{
    if (IOS8_OR_LATER) {
        __weak typeof(self) weakSelf = self;
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [FEAlertView removeAlertView:weakSelf];
            
            if (block) {
                block();
            }
            
            
        }];
        
        [_alertController addAction:alertAction];
        
    } else {
        NSInteger index = -1;
        if (_alertView) {
            index = [_alertView addButtonWithTitle:title];
            _alertView.cancelButtonIndex = index;
        } else {
            index = [_actionSheet addButtonWithTitle:title];
            _actionSheet.cancelButtonIndex = index;
        }
        if (block)
        {
            if (_blockDict == nil)
            {
                _blockDict = [NSMutableDictionary dictionary];
            }
            
            [_blockDict setObject:block forKey:[NSNumber numberWithInteger:index]];
        }
    }
}

-(void)addDestructiveButtonWithTitle:(NSString*)title block:(void (^)())block
{
    if (IOS8_OR_LATER) {
        __weak typeof(self) weakSelf = self;
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            [FEAlertView removeAlertView:weakSelf];
            
            if (block) {
                block();
            }
        }];
        
        [_alertController addAction:alertAction];
        
    } else {
        NSInteger index = -1;
        if (_alertView) {
            index = [_alertView addButtonWithTitle:title];
        } else {
            index = [_actionSheet addButtonWithTitle:title];
            _actionSheet.destructiveButtonIndex = index;
        }
        if (block)
        {
            if (_blockDict == nil)
            {
                _blockDict = [NSMutableDictionary dictionary];
            }
            
            [_blockDict setObject:block forKey:[NSNumber numberWithInteger:index]];
        }
    }
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    id obj =[_blockDict objectForKey:[NSNumber numberWithInteger:buttonIndex]];
    
    [FEAlertView removeAlertView:self];
    
    if (obj)
    {
        ((void (^)())obj)();
    }
}

- (void)alertViewCancel:(UIAlertView *)alertView
{
    [FEAlertView removeAlertView:self];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    id obj =[_blockDict objectForKey:[NSNumber numberWithInteger:buttonIndex]];
    
    [FEAlertView removeAlertView:self];
    
    if (obj)
    {
        ((void (^)())obj)();
    }
    
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    [FEAlertView removeAlertView:self];
}

#pragma mark - 类工具方法
+ (void)addAlertView:(FEAlertView *)alertView
{
    if (s_alertViewArray == nil) {
        s_alertViewArray = [NSMutableArray arrayWithCapacity:5];
    }
    
    [s_alertViewArray addObject:alertView];
}

+ (void)removeAlertView:(FEAlertView *)alertView
{
    if (alertView) {
        [s_alertViewArray removeObject:alertView];
    }
}

+ (void)dismissAllAlertView
{
    for (FEAlertView *alertView in s_alertViewArray) {
        [alertView dismiss];
    }
    
    s_alertViewArray = nil;
}

+ (UIViewController *)topMostViewController:(UIViewController *)controller {
    BOOL isPresenting = NO;
    do {
        UIViewController *presented = [controller presentedViewController];
        isPresenting = presented != nil;
        if(presented != nil) {
            controller = presented;
        }
        
    } while (isPresenting);
    
    return controller;
}

@end
