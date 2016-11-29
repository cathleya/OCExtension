
#import "FEDatePicker.h"

#define TOOL_BAR_HEIGHT 44.0
#define PICKER_VIEW_HEIGHT 216.0

@interface FEDatePicker(Private)

/**
    取消按钮点击事件
    @param sender 事件对象
 */
- (void)cancelButtonClick:(id)sender;

/**
    提交按钮点击事件
    @param sender 事件对象
 */
- (void)submitButtonClick:(id)sender;


/**
    隐藏动画完成
 */
- (void)hideAnimationComplete;


@end

@implementation FEDatePicker

@synthesize delegate = _delegate;
@synthesize minimumDate;
@synthesize maximumDate;
@synthesize selectedDate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        self.backgroundColor = [UIColor clearColor];
        
        _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 
                                                               0.0, 
                                                               SCREEN_WIDTH,
                                                               TOOL_BAR_HEIGHT)];
        
//        _toolbar.barStyle = UIBarStyleBlackTranslucent;
        _toolbar.translucent = YES;
		[_toolbar setItems:[NSArray arrayWithObjects:
                            [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                              style:UIBarButtonItemStyleBordered
                                                            target:self
                                                             action:@selector(cancelButtonClick:)],
							[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:nil 
                                                                           action:nil],
							[[UIBarButtonItem alloc] initWithTitle:@"确认"
                                                              style:UIBarButtonItemStyleBordered 
                                                             target:self 
                                                             action:@selector(submitButtonClick:)],
							nil]];
        [self addSubview:_toolbar];
		
		_datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 
                                                                     0.0, 
                                                                     SCREEN_WIDTH,
                                                                     PICKER_VIEW_HEIGHT)];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.backgroundColor = [UIColor whiteColor];
        [self addSubview:_datePicker];
    }
    return self;
}



- (void)showInView:(UIView *)view
{
    self.frame = CGRectMake(0.0, 0.0, view.width, view.height);
    
    _toolbar.frame = CGRectMake(0.0, 
                                self.height, 
                                self.width, 
                                TOOL_BAR_HEIGHT);
    _datePicker.frame = CGRectMake(0.0, 
                                   self.height + TOOL_BAR_HEIGHT, 
                                   self.width, 
                                   PICKER_VIEW_HEIGHT);
    [view addSubview:self];
    
    [UIView beginAnimations:@"showSelectionView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(showAnimationComplete)];

    _toolbar.frame = CGRectMake(0.0,
                                self.height - TOOL_BAR_HEIGHT - PICKER_VIEW_HEIGHT, 
                                SCREEN_WIDTH, 
                                TOOL_BAR_HEIGHT);
    _datePicker.frame = CGRectMake(0.0, 
                                   self.height - PICKER_VIEW_HEIGHT, 
                                   SCREEN_WIDTH,
                                   PICKER_VIEW_HEIGHT);
    
    [UIView commitAnimations];
}

- (void)hide
{
    [UIView beginAnimations:@"hideSelectionView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(hideAnimationComplete)];
    
    _toolbar.frame = CGRectMake(0.0, 
                                self.height, 
                                self.width, 
                                TOOL_BAR_HEIGHT);
    _datePicker.frame = CGRectMake(0.0, 
                                   self.height + TOOL_BAR_HEIGHT, 
                                   self.width, 
                                   PICKER_VIEW_HEIGHT);
    
    [UIView commitAnimations];
}

- (NSDate *)minimumDate
{
    return _datePicker.minimumDate;
}
- (void)setMinimumDate:(NSDate *)aMinimumDate
{
    _datePicker.minimumDate = aMinimumDate;
}

- (NSDate *)maximumDate
{
    return _datePicker.maximumDate;
}
- (void)setMaximumDate:(NSDate *)aMaximumDate
{
    _datePicker.maximumDate = aMaximumDate;
}

- (NSDate *)selectedDate
{
    return _datePicker.date;
}
- (void)setSelectedDate:(NSDate *)aSelectedDate
{
    if (aSelectedDate) 
    {
        _datePicker.date = aSelectedDate;
    }
}

- (void)updateState:(BOOL)state
{
    [self willChangeValueForKey:@"state"];
    _state = state;
    [self didChangeValueForKey:@"state"];
}

#pragma mark - Private

- (void)showAnimationComplete
{
    [self updateState:YES];
}

- (void)hideAnimationComplete
{
    [self updateState:NO];
    [self removeFromSuperview];
}

- (void)cancelButtonClick:(id)sender
{
    if ([_delegate respondsToSelector:@selector(cancelIndatePicker:)])
    {
        [_delegate cancelIndatePicker:self];
    }
    
    [self hide];
}

- (void)submitButtonClick:(id)sender
{
    if ([_delegate respondsToSelector:@selector(datePicker:selectedDate:)])
    {
        [_delegate datePicker:self
                 selectedDate:[_datePicker date]];
    }
    
    [self hide];
}

@end
