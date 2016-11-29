

#import <UIKit/UIKit.h>
#import "FEPrecompile.h"
#import "UIView+add.h"

@class FEDatePicker;

@protocol FEDatePickerDelegate <NSObject>

@optional

- (void)datePicker:(FEDatePicker *)datePickerView
      selectedDate:(NSDate *)selectedDate;

- (void)cancelIndatePicker:(FEDatePicker *)datePickerView;
@end

@interface FEDatePicker : UIView
{
@private
    UIToolbar *_toolbar;
    UIDatePicker *_datePicker;
}

/**
	委托对象
 */
@property (nonatomic,weak) id<FEDatePickerDelegate> delegate;

/**
	日期值下限
 */
@property (nonatomic,strong) NSDate *minimumDate;

/**
	日期值上限
 */
@property (nonatomic,strong) NSDate *maximumDate;

/**
	选中日期
 */
@property (nonatomic,strong) NSDate *selectedDate;


//状态，YES 显示
@property (nonatomic,assign,readonly) BOOL state;


/**
    显示界面
 */
- (void)showInView:(UIView *)view;


/**
    隐藏界面
 */
- (void)hide;

@end
