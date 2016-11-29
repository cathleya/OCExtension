
#import <UIKit/UIKit.h>

@interface FEShapedImageView : UIView

@property (nonatomic, strong) UIImage *image;// 要显示的图片
@property (nonatomic, strong) UIImage *maskImage;//掩码图 可以是不规则的
@property (nonatomic, strong) UIImage *converImage;//遮盖图

-(void)setImageWithURL:(NSURL*)url;
- (void)setImageUrl:(NSURL *)url placeholderImage:(UIImage *)placeholder;

-(void)showLoadingView;
-(void)hideLoadingView;
-(void)setProgress:(CGFloat)progress;

@end
