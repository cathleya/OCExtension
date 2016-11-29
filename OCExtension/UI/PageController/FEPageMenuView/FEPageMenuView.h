//
//  FEPageMenuView.h
//
//
//  Created by ios on 15/11/9.
//
//

#import <UIKit/UIKit.h>
@class FEPageMenuView;
@class FEPageMenuItem;

typedef enum {
    FEPageMenuViewStyleDefault,     // 默认
    FEPageMenuViewStyleLine,        // 带下划线 (若要选中字体大小不变，设置选中和非选中大小一样即可)
    FEPageMenuViewStyleFoold,       // 涌入效果 (填充)
    FEPageMenuViewStyleFooldHollow, // 涌入效果 (空心的)
} FEPageMenuViewStyle;


@protocol FEPageMenuViewDataSource <NSObject>
@optional
- (NSInteger)numberOfMenusInMenuView:(FEPageMenuView *)menu;
- (NSString *)menuView:(FEPageMenuView *)menu titleForMenuAtIndex:(NSInteger)index;
- (UIView *)extendViewForMenu;
@end

@protocol FEPageMenuViewDelegate <NSObject>
@optional
- (void)menuView:(FEPageMenuView *)menu didSelesctedIndex:(NSInteger)index currentIndex:(NSInteger)currentIndex;
- (void)menuView:(FEPageMenuView *)menu didSelectedSameIndex:(NSInteger)index;

@end

@interface FEPageMenuView : UIView

@property (nonatomic, weak)     id<FEPageMenuViewDelegate>      delegate;
@property (nonatomic, weak)     id<FEPageMenuViewDataSource>    dataSource;


@property (nonatomic, assign)   FEPageMenuViewStyle     style;

@property (nonatomic, assign)   CGFloat     progressHeight;
@property (nonatomic, strong)   UIColor     *lineColor;
@property (nonatomic, copy)     NSString    *fontName;
@property (nonatomic, assign)   NSInteger   menuCount;
@property (nonatomic, assign)   CGFloat     itemMargin;


- (instancetype)initWithFrame:(CGRect)frame
              backgroundColor:(UIColor *)bgColor
                      norSize:(CGFloat)norSize
                      selSize:(CGFloat)selSize
                     norColor:(UIColor *)norColor
                     selColor:(UIColor *)selColor;

- (void)slideMenuAtProgress:(CGFloat)progress;
- (void)selectItemAtIndex:(NSInteger)index;
- (void)selectItemAtIndex:(NSInteger)index animated:(BOOL)animated;

- (void)reloadData;

@end
