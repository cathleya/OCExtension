
#import <QuartzCore/QuartzCore.h>
#import "FETipsView.h"
#import <JDStatusBarNotification/JDStatusBarNotification.h>
#import "UIView+add.h"

#define DEFAULT_TIMEOUT_SECONDS			(2.0f)
#define ANIMATION_DURATION				(0.3f)

#define MAX_WIDTH (240)

#define MIN_WIDTH (120)
#define MIN_HEIGHT (60)
#define PADDING (10)

#define LOADING_WIDTH (80)
#define LOADING_HEIGHT (80)

#define TIPS_FONT_SIZE 17

static BOOL s_statusbar_tips_enable = NO;

#pragma mark -

@implementation NSObject(FETipsView)

- (FETipsView *)presentingTips
{
	return [FETipsCenter sharedInstance].tipsAppear;
}

- (FETipsView *)presentMessageTips:(NSString *)message
{
	UIView * container = nil;
	
    [FETipsCenter sharedInstance].iTopOffset = 0;
	if ( [self isKindOfClass:[UIView class]] )
	{
		container = (UIView *)self;
	}
	else if ( [self isKindOfClass:[UIViewController class]] )
	{
		container = ((UIViewController *)self).view;
	}

	return [[FETipsCenter sharedInstance] presentMessageTips:message inView:container];
}

- (FETipsView *)presentSuccessTips:(NSString *)message
{
	UIView * container = nil;
	
    [FETipsCenter sharedInstance].iTopOffset = 0;
	if ( [self isKindOfClass:[UIView class]] )
	{
		container = (UIView *)self;
	}
	else if ( [self isKindOfClass:[UIViewController class]] )
	{
		container = ((UIViewController *)self).view;
	}
	
	return [[FETipsCenter sharedInstance] presentSuccessTips:message inView:container];
}

- (FETipsView *)presentFailureTips:(NSString *)message
{
    if ([message length] <= 0)
    {
        return nil;
    }
    
	UIView * container = nil;
	
    [FETipsCenter sharedInstance].iTopOffset = 0;
	if ( [self isKindOfClass:[UIView class]] )
	{
		container = (UIView *)self;
	}
	else if ( [self isKindOfClass:[UIViewController class]] )
	{
		container = ((UIViewController *)self).view;
	}
	
	return [[FETipsCenter sharedInstance] presentFailureTips:message inView:container];
}

- (FETipsView *)presentLoadingTips:(NSString *)message
{
	UIView * container = nil;
	
    [FETipsCenter sharedInstance].iTopOffset = 0;
	if ( [self isKindOfClass:[UIView class]] )
	{
		container = (UIView *)self;
	}
	else if ( [self isKindOfClass:[UIViewController class]] )
	{
		container = ((UIViewController *)self).view;
        if (!(((UIViewController *)self).navigationController.navigationBarHidden))
        {
            [FETipsCenter sharedInstance].iTopOffset = -44;
        }

	}
	
	return [[FETipsCenter sharedInstance] presentLoadingTips:message inView:container];	
}

- (void)dismissTips
{
	UIView * container = nil;
	
	if ( [self isKindOfClass:[UIView class]] )
	{
		container = (UIView *)self;
	}
	else if ( [self isKindOfClass:[UIViewController class]] )
	{
		container = ((UIViewController *)self).view;
	}

	return [[FETipsCenter sharedInstance] dismissTipsByOwner:container];
}

//在状态栏中提示
+(void)setStatusBarTipsEnable:(BOOL)enable
{
    s_statusbar_tips_enable = enable;
    
    if (s_statusbar_tips_enable) {
        [JDStatusBarNotification setDefaultStyle:^JDStatusBarStyle *(JDStatusBarStyle *style) {
            // setup default style
            style.barColor = [UIColor blackColor];
            style.progressBarColor = [UIColor greenColor];
            style.progressBarHeight = 1.0;
            style.progressBarPosition = JDStatusBarProgressBarPositionBottom;
            style.textColor = [UIColor whiteColor];
            style.font = [UIFont systemFontOfSize:12.0];
            style.animationType = JDStatusBarAnimationTypeFade;
            
            
            return style;
        }];
    }
}
-(void)presentStatusBarTips:(NSString*)message
{
    if (s_statusbar_tips_enable) {
        [JDStatusBarNotification showWithStatus:message dismissAfter:1.5 styleName:nil];
    }
}

@end

#pragma mark -

@interface FETipsCenter(Private)
- (void)presentTips:(FETipsView *)tips inView:(UIView *)view;
- (void)dismissTips;
- (void)dismissTipsByOwner:(UIView *)parentView;
- (void)dismissTipsLoading;
- (void)performDismissTips;
- (void)didAppearingAnimationDone;
- (void)didDisappearingAnimationDone;
@end

@interface FETipsView(Private)
- (void)internalWillAppear;
- (void)internalDidAppear;
- (void)internalWillDisappear;
- (void)internalRelayout:(UIView *)parentView;
@end

#pragma mark -

@implementation FETipsCenter

DEF_SINGLETON( FETipsCenter )

- (id)init
{
	self = [super init];
	if ( self )
	{
		_tipsAppear = nil;
		_tipsDisappear = nil;
        self.keyboardIsVisible = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShowHandler:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHideHandler:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
	}
	
	return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)presentTipsView:(FETipsView *)tips inView:(UIView *)view
{
	if ( nil != _tipsAppear )
	{
		if ( tips == _tipsAppear )
			return;
	}
	
	if ( nil == view )
    {
        view = [UIApplication sharedApplication].keyWindow;
    }
	
	[tips internalRelayout:view];
	self.tipsDisappear = self.tipsAppear;
	self.tipsAppear = tips;
    
	[view addSubview:_tipsAppear];
	[view bringSubviewToFront:_tipsAppear];

// animation 1
	
	_tipsAppear.alpha = 0.0f;

	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:ANIMATION_DURATION];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(didAppearingAnimationDone)];

	_tipsAppear.alpha = 1.0f;
	_tipsDisappear.alpha = 0.0f;

	[UIView commitAnimations];
    
	[_tipsAppear internalWillAppear];
	[_tipsDisappear internalWillDisappear];
}

- (void)didAppearingAnimationDone
{
	[_tipsDisappear removeFromSuperview];
	_tipsDisappear = nil;
	
	[_tipsAppear internalDidAppear];
}

- (void)dismissTips
{
	[self performDismissTips];
}

- (void)dismissTipsByOwner:(UIView *)parentView
{
	if ( _tipsAppear && _tipsAppear.superview == parentView )
	{
		[self performDismissTips];
	}
}

- (void)performDismissTips
{
	if ( nil == _tipsAppear )
		return;

	self.tipsDisappear = self.tipsAppear;
	self.tipsAppear = nil;

	[UIView beginAnimations:nil context:NULL];		
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(didDisappearingAnimationDone)];

	_tipsDisappear.alpha = 0.0f;
	
	[UIView commitAnimations];
	
	[_tipsAppear internalWillAppear];
	[_tipsDisappear internalWillDisappear];
}

- (void)didDisappearingAnimationDone
{
	
	[_tipsDisappear removeFromSuperview];
	_tipsDisappear = nil;
	
	[_tipsAppear internalDidAppear];
}

- (FETipsView *)presentMessageTips:(NSString *)message inView:(UIView *)view
{
	FEMessageTipsView * tips = [[FEMessageTipsView alloc] init];
    tips.labelView.text = message;
//	tips.labelView.text = [NSString stringWithFormat:@"%@%@", [@"%F0%9F%98%94" stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding], message];
	[tips presentInView:view];
	return tips;
}

- (FETipsView *)presentSuccessTips:(NSString *)message inView:(UIView *)view
{
	FEMessageTipsView * tips = [[FEMessageTipsView alloc] init];
    tips.labelView.text = message;
//	tips.labelView.text = [NSString stringWithFormat:@"%@%@", [@"%F0%9F%98%84" stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding], message];
	[tips presentInView:view];
	return tips;
}

- (FETipsView *)presentFailureTips:(NSString *)message inView:(UIView *)view
{
	FEMessageTipsView * tips = [[FEMessageTipsView alloc] init];
    tips.labelView.text = message;

//	tips.labelView.text = [NSString stringWithFormat:@"%@%@", [@"%F0%9F%98%93" stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding], message];
	[tips presentInView:view];
	return tips;
}

- (FETipsView *)presentLoadingTips:(NSString *)message inView:(UIView *)view
{
	FELoadingTipsView * tips = [[FELoadingTipsView alloc] init];
	tips.labelView.text = message;
	[tips presentInView:view];
	[tips.indicator startAnimating];
	return tips;
}

-(void)keyboardWillShowHandler:(NSNotification*)notif
{
    self.keyboardIsVisible = YES;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.2f];
    [_tipsAppear internalRelayout:_tipsAppear.superview];
    [_tipsDisappear internalRelayout:_tipsDisappear.superview];
    [UIView commitAnimations];
}

-(void)keyboardWillHideHandler:(NSNotification*)notif
{
    self.keyboardIsVisible = NO;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.2f];
    [_tipsAppear internalRelayout:_tipsAppear.superview];
    [_tipsDisappear internalRelayout:_tipsDisappear.superview];
    [UIView commitAnimations];
}


@end

#pragma mark -

@implementation FETipsView

@synthesize timerSeconds = _timerSeconds;

- (id)init
{
	self = [super initWithFrame:CGRectZero];
	if ( self )
	{
		self.backgroundColor = RGBAHEX(0x000000, 0.75);
		self.layer.cornerRadius = 8;
		self.layer.masksToBounds = YES;
        
		self.timerSeconds = DEFAULT_TIMEOUT_SECONDS;
	}
	
	return self;
}

- (void)dealloc
{	
	[_timer invalidate];
	_timer = nil;
}

- (void)internalWillAppear
{	
	[_timer invalidate];
	_timer = nil;
}

- (void)internalDidAppear
{	
	[_timer invalidate];
	_timer = nil;

	if ( _timeLimit )
	{
		_timer = [NSTimer scheduledTimerWithTimeInterval:self.timerSeconds
												  target:self
												selector:@selector(dismiss)
												userInfo:nil
												 repeats:NO];		
	}	
}

- (void)internalWillDisappear
{
	[_timer invalidate];
	_timer = nil;
}


- (void)internalRelayout:(UIView *)parentView
{
}

- (void)presentInView:(UIView *)view
{
	[[FETipsCenter sharedInstance] presentTipsView:self inView:view];
}

- (void)present
{
	[[FETipsCenter sharedInstance] presentTipsView:self inView:nil];
}

- (void)dismiss
{
	[_timer invalidate];
	_timer = nil;

	[[FETipsCenter sharedInstance] dismissTips];
}

@end

#pragma mark -

@implementation FEMessageTipsView

@synthesize labelView = _labelView;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.timeLimit = YES;
		self.timerSeconds = DEFAULT_TIMEOUT_SECONDS;

		_labelView = [[UILabel alloc] initWithFrame:CGRectZero];
        _labelView.font = [UIFont boldSystemFontOfSize:TIPS_FONT_SIZE];
        _labelView.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _labelView.textAlignment = NSTextAlignmentLeft;
		_labelView.textColor = [UIColor whiteColor];
        _labelView.backgroundColor = [UIColor clearColor];
        _labelView.lineBreakMode = NSLineBreakByClipping;
		_labelView.numberOfLines = 0;
        [self addSubview:_labelView];
	}
	
	return self;
}

- (void)dealloc
{
}

- (void)internalRelayout:(UIView *)parentView
{
    CGRect bound = parentView.bounds;
    
    bound.size.height += [FETipsCenter sharedInstance].iTopOffset;
    
    if ([FETipsCenter sharedInstance].keyboardIsVisible)
    {
        bound.size.height -= 260;
    }
    
    CGRect rect = CGRectMake(0, 0, MAX_WIDTH, MAXFLOAT);
    
    rect = [_labelView textRectForBounds:rect limitedToNumberOfLines:0];
    
    if (CGRectGetHeight(rect) < MIN_HEIGHT)
    {
        rect.size.height = MIN_HEIGHT;
    }
    
    if (CGRectGetWidth(rect) < MIN_WIDTH)
    {
        rect.size.width = MIN_WIDTH;
        _labelView.textAlignment = NSTextAlignmentCenter;
    }
    else
    {
        _labelView.textAlignment = NSTextAlignmentLeft;
    }
    
    CGRect frame = rect;
    
    frame.size.width += PADDING*2;
    frame.size.height += PADDING*2;
    
    self.frame = CGRectMake((bound.size.width-frame.size.width)/2, (bound.size.height-frame.size.height)/2, frame.size.width, frame.size.height);
    
    _labelView.frame = CGRectMake((frame.size.width-rect.size.width)/2, (frame.size.height-rect.size.height)/2, rect.size.width, rect.size.height);
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
	
	[self dismiss];
}

@end

#pragma mark -

@implementation FELoadingTipsView

@synthesize labelView = _labelView;
@synthesize indicator = _indicator;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.timeLimit = NO;
		
		_indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		_indicator.backgroundColor = [UIColor clearColor];
        [_indicator sizeToFit];
		[self addSubview:_indicator];

		_labelView = [[UILabel alloc] initWithFrame:CGRectZero];
        _labelView.font = [UIFont boldSystemFontOfSize:TIPS_FONT_SIZE];
        _labelView.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _labelView.textAlignment = NSTextAlignmentCenter;
		_labelView.textColor = [UIColor whiteColor];
        _labelView.backgroundColor = [UIColor clearColor];
        _labelView.lineBreakMode = NSLineBreakByClipping;
        _labelView.numberOfLines = 0;
        [self addSubview:_labelView];
	}

	return self;
}

- (void)dealloc
{
}

- (void)internalRelayout:(UIView *)parentView
{
    CGRect bound = parentView.bounds;
    bound.size.height += [FETipsCenter sharedInstance].iTopOffset;
    
    if ([FETipsCenter sharedInstance].keyboardIsVisible)
    {
        bound.size.height -= 260;
    }
    
    if ([_labelView.text length] > 0)
    {
        CGRect rect = CGRectMake(0, 0, MAX_WIDTH, MAXFLOAT);
        
        rect = [_labelView textRectForBounds:rect limitedToNumberOfLines:0];
        
        
        if (CGRectGetWidth(rect) < MIN_WIDTH)
        {
            rect.size.width = MIN_WIDTH;
            _labelView.textAlignment = NSTextAlignmentCenter;
        }
        else
        {
            _labelView.textAlignment = NSTextAlignmentLeft;
        }
        
        
        CGRect frame = rect;
        frame.size.width += PADDING*2;
        frame.size.height += _indicator.height+PADDING*5;
        
        
        self.frame = CGRectMake((bound.size.width-frame.size.width)/2, (bound.size.height-frame.size.height)/2, frame.size.width, frame.size.height);
        
        _indicator.frame = CGRectMake((frame.size.width - _indicator.width)/2, PADDING*2, _indicator.width, _indicator.height);
        
        _labelView.frame = CGRectMake((frame.size.width-rect.size.width)/2, PADDING*3+_indicator.height, rect.size.width, rect.size.height);
    }
    else
    {
        CGRect frame = CGRectMake((bound.size.width-LOADING_WIDTH)/2, (bound.size.height-LOADING_HEIGHT)/2, LOADING_WIDTH, LOADING_HEIGHT);
        
        self.frame = frame;
        
        _indicator.frame = CGRectMake((frame.size.width - _indicator.width)/2, (frame.size.height-_indicator.height)/2, _indicator.width, _indicator.height);
        
    }
}

@end
