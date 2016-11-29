

#import "FEPageControl.h"
#import "UIView+add.h"

#define DEF_DOT_GAP 20.0f

@implementation FEPageControl
{
    NSMutableArray *_normalDotImgArr;
    NSMutableArray *_highligntDotImgArr;

    NSMutableArray *_dotArr;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initSelf];
    }
    return self;
}

- (void)initSelf
{
    self.userInteractionEnabled = NO;
    _normalDotImgArr = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"pagecontrol_dot.png"], nil];
    _highligntDotImgArr = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"pagecontrol_dot_s.png"], nil];
    _dotArr = [[NSMutableArray alloc] init];

    _dotGap = DEF_DOT_GAP;
}

- (void)setNumberOfPages:(NSInteger)numberOfPages
{
    _numberOfPages = numberOfPages;

    if (numberOfPages == 0)
    {
        _currentPage = 0;
    }

    [self makeDotArr];

    [self setNeedsLayout];
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    _currentPage = currentPage;

    [self setNeedsLayout];
}

- (void)setDotGap:(CGFloat)dotGap
{
    _dotGap = dotGap;

    [self setNeedsLayout];
}

- (void)setDotNormalImg:(UIImage *)normalImg highlightImg:(UIImage *)highlightImg
{
    NSArray *normalImgArr = normalImg ? [NSArray arrayWithObject:normalImg] : nil;
    NSArray *highlightImgArr = highlightImg ? [NSArray arrayWithObject:highlightImg] : nil;

    [self setDotNormalImgArr:normalImgArr highlightImgArr:highlightImgArr];
}

- (void)setDotNormalImgArr:(NSArray *)normalImgArr highlightImgArr:(NSArray *)highlightImgArr
{
    [_normalDotImgArr removeAllObjects];
    if (normalImgArr)
    {
        [_normalDotImgArr addObjectsFromArray:normalImgArr];
    }

    [_highligntDotImgArr removeAllObjects];
    if (highlightImgArr)
    {
        [_highligntDotImgArr addObjectsFromArray:highlightImgArr];
    }

    if (_normalDotImgArr.count != _highligntDotImgArr.count)
    {
        @throw ([NSException exceptionWithName:@"SHPageControl:normalImgArr and highlightImgArr count are not the same"
                                        reason:[NSString stringWithFormat:@"normalImgArr count:%lu and highlightImgArr count:%lu", (unsigned long)_normalDotImgArr.count, (unsigned long)_highligntDotImgArr.count]
                                      userInfo:nil]);
    }

    [self makeDotArr];

    [self setNeedsLayout];
}

#pragma mark - Private
- (void)clearDotView
{
    for (UIView *dotView in _dotArr)
    {
        [dotView removeFromSuperview];
    }

    [_dotArr removeAllObjects];
}

- (void)makeDotArr
{
    [self clearDotView];

    int count = _normalDotImgArr.count;
    for (int i = 0; i < _numberOfPages; i ++)
    {
        int imgIndex = (i >= count) ? count - 1 : i;
        UIImage *normalImg = [_normalDotImgArr objectAtIndex:imgIndex];
        UIImage *selectImg = [_highligntDotImgArr objectAtIndex:imgIndex];

        CGSize imgSize = CGSizeMake(MAX(normalImg.size.width, selectImg.size.width), MAX(normalImg.size.height, selectImg.size.height));
        UIImageView *dotImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgSize.width, imgSize.height)];
        dotImgView.contentMode = UIViewContentModeCenter;

        dotImgView.image = normalImg;
        dotImgView.highlightedImage = selectImg;

        [self addSubview:dotImgView];

        [_dotArr addObject:dotImgView];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    if (_numberOfPages == 1)
    {
        UIImageView *dotView = [_dotArr objectAtIndex:0];
        dotView.hidden = YES;
    }
    else
    {
        float totalW = (_numberOfPages - 1) * _dotGap;
        float startX = (self.width - totalW) * 0.5f;

        float centerH = self.height * 0.5f;
        float centerX = startX;

        for (int i = 0; i < _numberOfPages; i ++)
        {
            UIImageView *dotView = [_dotArr objectAtIndex:i];
            dotView.center = CGPointMake(centerX + (i * _dotGap), centerH);
            dotView.highlighted = (i == _currentPage);
            dotView.hidden = NO;
        }
    }
}

@end
