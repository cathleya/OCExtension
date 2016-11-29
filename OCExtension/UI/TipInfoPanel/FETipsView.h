

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FEPrecompile.h"

#pragma mark -

@class FETipsView;

@interface NSObject(FETipsView)

- (FETipsView *)presentingTips;

- (FETipsView *)presentMessageTips:(NSString *)message;
- (FETipsView *)presentSuccessTips:(NSString *)message;
- (FETipsView *)presentFailureTips:(NSString *)message;
- (FETipsView *)presentLoadingTips:(NSString *)message;

- (void)dismissTips;


//在状态栏中提示
+(void)setStatusBarTipsEnable:(BOOL)enable;
-(void)presentStatusBarTips:(NSString*)message;


@end

#pragma mark -

@interface FETipsView : UIView
{
	NSTimeInterval	_timerSeconds;
	NSTimer *		_timer;
    BOOL            _timeLimit;
}

@property (nonatomic, assign) NSTimeInterval	timerSeconds;
@property (nonatomic, assign) BOOL	timeLimit;

- (void)present;
- (void)presentInView:(UIView *)view;
- (void)dismiss;

@end

#pragma mark -

@interface FEMessageTipsView : FETipsView
{
	UILabel *			_labelView;
}

@property (nonatomic, retain) UILabel *				labelView;

@end

#pragma mark -

@interface FELoadingTipsView : FETipsView
{
	UIActivityIndicatorView *	_indicator;
	UILabel *					_labelView;
}

@property (nonatomic, retain) UIActivityIndicatorView *	indicator;
@property (nonatomic, retain) UILabel *					labelView;

@end


#pragma mark -

@interface FETipsCenter : NSObject
{
	FETipsView *		_tipsAppear;
	FETipsView *		_tipsDisappear;
    
    NSInteger           _iTopOffset;
}

@property (nonatomic, retain) FETipsView *    tipsAppear;
@property (nonatomic, retain) FETipsView *      tipsDisappear;
@property (nonatomic) NSInteger iTopOffset;
@property (nonatomic) BOOL  keyboardIsVisible;

AS_SINGLETON( FETipsCenter )

- (void)dismissTips;

- (void)dismissTipsByOwner:(UIView *)parentView;

- (FETipsView *)presentMessageTips:(NSString *)message inView:(UIView *)view;
- (FETipsView *)presentSuccessTips:(NSString *)message inView:(UIView *)view;
- (FETipsView *)presentFailureTips:(NSString *)message inView:(UIView *)view;
- (FETipsView *)presentLoadingTips:(NSString *)message inView:(UIView *)view;

@end
