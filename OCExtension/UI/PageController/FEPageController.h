//
//  FEPageController.h
//  
//
//  Created by ios on 15/11/9.
//
//

#import <UIKit/UIKit.h>
#import "FEPageMenuView.h"
#import "FEViewController.h"

@class FEPageController;

@protocol FEPageControllerDataSource <NSObject>
@required
- (NSInteger)numberOfPagesInPageController:(FEPageController *)pageController;
- (UIViewController *)pageController:(FEPageController *)pageController viewControllerAtIndex:(NSInteger)index;

@optional
//菜单名称
- (NSString *)pageController:(FEPageController *)pageController titleForMenuAtIndex:(NSInteger)index;
//扩展view
- (UIView *)extendViewForMenu:(FEPageController *)pageController viewHeight:(CGFloat)height;

@end

@protocol FEPageControllerDelegate <NSObject>
@optional
- (void)pageController:(FEPageController *)pageController selectedIndex:(NSInteger)index;
- (void)pageController:(FEPageController *)pageController slideProgress:(CGFloat)progress;
- (void)pageController:(FEPageController *)pageController selectedSameIndex:(NSInteger)index;
@end

@interface FEPageController : FEViewController
{
@public
    NSInteger           _selectIndex;
}


@property (nonatomic, weak)     id <FEPageControllerDataSource>     dataSource;
@property (nonatomic, weak)     id <FEPageControllerDelegate>       delegate;

@property (nonatomic, assign)   NSInteger selectIndex; //设置选中几号 item
@property (nonatomic, strong, readonly) UIViewController *currentViewController; //当前选中的VC

@property (nonatomic, weak)     UIScrollView *scrollView; //内部容器
@property (nonatomic, assign)   BOOL pageAnimatable;    //点击相邻的 MenuItem 是否触发翻页动画 (当当前选中与点击Item相差大于1是不触发)
@property (nonatomic, assign)   BOOL postNotification; //是否发送在创建控制器或者视图完全展现在用户眼前时通知观察者，默认为不开启，如需利用通知请开启

@property (nonatomic, assign)   BOOL showMenu;              //是否显示menu
@property (nonatomic, weak)     FEPageMenuView *menuView;   //顶部导航栏
@property (nonatomic, strong)   UIColor *menuBGColor;       //导航栏背景色
@property (nonatomic, assign)   CGFloat titleSizeSelected;  //非选中时的标题尺寸
@property (nonatomic, assign)   CGFloat titleSizeNormal;    //非选中时的标题尺寸
@property (nonatomic, strong)   UIColor *titleColorSelected; //标题选中时的颜色, 颜色是可动画的.
@property (nonatomic, strong)   UIColor *titleColorNormal;      //标题非选择时的颜色, 颜色是可动画的.
@property (nonatomic, copy)     NSString *titleFontName;        //标题的字体名字
@property (nonatomic, assign)   CGFloat menuHeight;             //导航栏高度
@property (nonatomic, assign)   CGFloat itemMargin;             //menu间隔

@property (nonatomic, assign)   FEPageMenuViewStyle menuViewStyle; //Menu view 的样式，默认为无下划线
@property (nonatomic, strong)   UIColor *progressColor;         //进度条的颜色，默认和选中颜色一致(如果 style 为 Default，则该属性无用)
@property (nonatomic, assign)   CGFloat progressHeight;         //下划线进度条的高度

- (void)setSelectIndex:(NSInteger)selectIndex animated:(BOOL)animated;

- (void)reloadData;


@end
