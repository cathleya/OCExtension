

#import <UIKit/UIKit.h>
#import "FEMenuButton.h"

@class FEGridMenuView;
@protocol FEGridMenuViewDelegate <NSObject>
@optional
-(void)gridMenuView:(FEGridMenuView*)gridMenuView itemSelected:(NSInteger)index;
@end

@interface FEGridMenuView : UIView
{
    NSMutableArray      *_menuItemArray;
    CGSize              _itemSize;
    NSInteger           _iColumnCount;//列数
}

@property(nonatomic, weak) id<FEGridMenuViewDelegate> delegate;
@property(nonatomic) NSInteger iColumnCount;//列数
@property(nonatomic, assign) CGFloat rowPadding;//行间距 默认20

- (id)initWithFrame:(CGRect)frame itemSize:(CGSize)size;

-(FEMenuButton *)addMenuIcon:(UIImage*)image title:(NSString*)title;
-(void)removeMenuAtIndex:(NSInteger)index;
-(void)setItemEnable:(BOOL)bEnable index:(NSInteger)index;
-(void)updateLayout;
@end
