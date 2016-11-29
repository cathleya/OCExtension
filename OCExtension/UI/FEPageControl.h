

#import <UIKit/UIKit.h>

@interface FEPageControl : UIView

@property (nonatomic) NSInteger numberOfPages;
@property (nonatomic) NSInteger currentPage;

@property (nonatomic) CGFloat dotGap;

- (void)setDotNormalImg:(UIImage *)normalImg highlightImg:(UIImage *)highlightImg;
- (void)setDotNormalImgArr:(NSArray *)normalImgArr highlightImgArr:(NSArray *)highlightImgArr;

@end
