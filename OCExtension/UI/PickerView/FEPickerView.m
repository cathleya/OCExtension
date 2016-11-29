

#import "FEPickerView.h"
#import "FEPrecompile.h"
#import "UIView+add.h"

#define TOOL_BAR_HEIGHT 44.0
#define PICKER_VIEW_HEIGHT 216.0

@interface FEPickerView(Private)

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

@implementation FEPickerView

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
        _toolbar.translucent = YES;
		[_toolbar setItems:[NSArray arrayWithObjects:
                            [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                              style:UIBarButtonItemStyleBordered target:self
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
		
		_pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 
                                                                     0.0, 
                                                                     SCREEN_WIDTH,
                                                                     PICKER_VIEW_HEIGHT)];
		_pickerView.delegate = self;
		_pickerView.dataSource = self;
		_pickerView.showsSelectionIndicator = YES;
        _pickerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_pickerView];
        
        _itemsDict = [[NSMutableDictionary alloc]initWithCapacity:2];
    }
    
    return self;
}

- (void)dealloc
{
    _delegate = nil;
    _pickerView.delegate = nil;
}

- (void)setItemsArray:(NSArray *)itemsArray
{
    [_itemsDict setObject:itemsArray forKey:[NSNumber numberWithInt:0]];
    
    [_pickerView reloadAllComponents];
}

-(NSArray*)itemsArray
{
    return [_itemsDict objectForKey:[NSNumber numberWithInt:0]];
}

- (NSInteger)selectedIndex
{
    return [_pickerView selectedRowInComponent:0];
}

- (void)setSelectedIndex:(NSInteger)aSelectedIndex
{
    if (aSelectedIndex >= 0)
    {
        [_pickerView selectRow:aSelectedIndex inComponent:0 animated:YES];
    }
    else
    {
        [_pickerView selectRow:0 inComponent:0 animated:YES];
    }
}

- (void)showInView:(UIView *)view
{
    self.frame = CGRectMake(0.0, 0.0, view.width, view.height);
    
    _toolbar.frame = CGRectMake(0.0, 
                                self.height, 
                                self.width, 
                                TOOL_BAR_HEIGHT);
    _pickerView.frame = CGRectMake(0.0, 
                                   self.height + TOOL_BAR_HEIGHT, 
                                   self.width, 
                                   PICKER_VIEW_HEIGHT);
    [view addSubview:self];
    
    [UIView beginAnimations:@"showSelectionView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    
    _toolbar.frame = CGRectMake(0.0, 
                                self.height - TOOL_BAR_HEIGHT - PICKER_VIEW_HEIGHT, 
                                self.width, 
                                TOOL_BAR_HEIGHT);
    _pickerView.frame = CGRectMake(0.0, 
                                   self.height - PICKER_VIEW_HEIGHT, 
                                   self.width, 
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
    _pickerView.frame = CGRectMake(0.0, 
                                   self.height + TOOL_BAR_HEIGHT, 
                                   self.width, 
                                   PICKER_VIEW_HEIGHT);
    
    [UIView commitAnimations];
}

- (void)reloadAllComponents
{
    [_pickerView reloadAllComponents];
}
- (void)reloadComponent:(NSInteger)component
{
    [_pickerView reloadComponent:component];
}

- (NSInteger)selectedRowInComponent:(NSInteger)component
{
    return [_pickerView selectedRowInComponent:component];
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated
{
    [_pickerView selectRow:row inComponent:component animated:animated];
}

-(void)setItemsArray:(NSArray *)itemsArray inComponent:(NSInteger)component
{
    [_itemsDict setObject:itemsArray forKey:[NSNumber numberWithLong:component]];
}

#pragma mark - Private

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hide];
}

- (void)hideAnimationComplete
{
    [self removeFromSuperview];
}

- (void)cancelButtonClick:(id)sender
{
    if ([_delegate respondsToSelector:@selector(onPickerViewCancel:)])
    {
        [_delegate onPickerViewCancel:self];
    }
    
    [self hide];
}

- (void)submitButtonClick:(id)sender
{
    if ([_delegate respondsToSelector:@selector(onPickerViewSure:)])
    {
        [_delegate onPickerViewSure:self];
    }
    
    [self hide];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return [_itemsDict count];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView 
numberOfRowsInComponent:(NSInteger)component
{
     NSArray* array = [_itemsDict objectForKey:[NSNumber numberWithLong:component]];
    
    return [array count];
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([_delegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)])
    {
        [_delegate pickerView:self didSelectRow:row inComponent:component];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view
{
    NSString* strTitle = [self pickerView:pickerView titleForRow:row forComponent:component];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, 0.0f, [pickerView rowSizeForComponent:component].width-12, [pickerView rowSizeForComponent:component].height)];
    
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:18];
    [label setText:strTitle];
    [label setTextAlignment:NSTextAlignmentCenter];
    return label;

}

- (NSString *)pickerView:(UIPickerView *)pickerView 
             titleForRow:(NSInteger)row 
            forComponent:(NSInteger)component
{
    if ([_delegate respondsToSelector:@selector(pickerView:titleForRow:forComponent:)])
    {
        return [_delegate pickerView:self titleForRow:row forComponent:component];
    }
    else
    {
        NSArray* array = [_itemsDict objectForKey:[NSNumber numberWithLong:component]];
        if (row >= 0
            && row < [array count])
        {
            return [array objectAtIndex:row];
        }
        else
        {
            return @"";
        }
    }
}

@end
