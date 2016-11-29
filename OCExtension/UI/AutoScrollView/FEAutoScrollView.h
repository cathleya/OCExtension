

#import <UIKit/UIKit.h>
#import "FEImageView.h"
#import "UIView+add.h"

@class FEAutoScrollView;
@protocol FEAutoScrollViewDelegate <NSObject>

-(void)autoScrollView:(FEAutoScrollView*)autoScrollView selected:(NSInteger)index;

@end

//自动循环滚动view 用户滚动广告
//增加本地图片展示
@interface FEAutoScrollView : UIView
<UIScrollViewDelegate,
FEImageViewDelegate>

@property(nonatomic, weak) id<FEAutoScrollViewDelegate> delegate;
@property(nonatomic,assign) BOOL autoScroll; //是否自动滚动
@property(nonatomic) double autoScrollTime;//自动滚动时间 默认5秒
@property(nonatomic, strong) UIImage* defaultImage;
@property(nonatomic, strong) UIPageControl* pageControl;

//本地图片地址
- (void)setImageNameArray:(NSArray *)imageNameArray;
- (void)setImageNameArray:(NSArray *)imageNameArray titleArray:(NSArray*)titleArray;

//网络图片URL
- (void)setImageUrlArray:(NSArray *)imageUrlArray;
- (void)setImageUrlArray:(NSArray *)FEAutoScrollView titleArray:(NSArray*)titleArray;


-(void)startScrollTimer;

-(void)stopScrollTimer;


@end
