

#import <UIKit/UIKit.h>

@class FEPickerView;

@protocol FEPickerViewDelegate <NSObject>

@optional

//取消按钮
- (void)onPickerViewCancel:(FEPickerView *)pickerView;

//确定按钮
- (void)onPickerViewSure:(FEPickerView* )pickerView;

//选择到某项
- (void)pickerView:(FEPickerView *)pickerView
         didSelectRow:(NSInteger)row
          inComponent:(NSInteger)component;

//某项的文字
- (NSString *)pickerView:(FEPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component;


@end

@interface FEPickerView : UIView<UIPickerViewDelegate,
                                UIPickerViewDataSource>
{
@private
    UIToolbar *_toolbar;
    UIPickerView *_pickerView;
    
    NSMutableDictionary* _itemsDict;
}

/**
	列表数据
 */
@property (nonatomic,strong) NSArray *itemsArray;

/**
	选中索引
 */
@property (nonatomic) NSInteger selectedIndex;

/**
	委托对象
 */
@property (nonatomic, weak) id<FEPickerViewDelegate> delegate;



/**
	显示界面
 */
- (void)showInView:(UIView *)view;


/**
	隐藏界面
 */
- (void)hide;

//设置数据源
-(void)setItemsArray:(NSArray *)itemsArray inComponent:(NSInteger)component;

- (NSInteger)selectedRowInComponent:(NSInteger)component;

- (void)reloadAllComponents;
- (void)reloadComponent:(NSInteger)component;

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;


@end
