
#import <UIKit/UIKit.h>
//#import "UIImageView+WebCache.h"

@class FEImageView;
@protocol FEImageViewDelegate <NSObject>
@optional
- (void)onTouchUpInside:(FEImageView *)sender;
@end


@interface FEImageView : UIImageView

@property (nonatomic, weak)          id<FEImageViewDelegate> delegate;

@property (nonatomic, assign)        BOOL enableSelectedSytle;//是否有选中效果， 默认无；
@property (nonatomic, strong)        UIView *selectedBackgroundView;//选中时高亮 默认nil enableSelectedSytle==YES时创建

@property (nonatomic, assign)       UIEdgeInsets hitTestEdgeInsets; //默认UIEdgeInsetsMake(-5, -5, -5, -5)

@end
