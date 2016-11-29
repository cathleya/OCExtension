

#import "FEAutoScrollView.h"
#import "FEAutoScrollViewCell.h"
#import "UIImageView+WebCache.h"
//#import "SDWebImageManager.h"
#import "FEPrecompile.h"

#define CIRCLE_TIME 5
#define CIRCLE_COUNT 1000

#define PAGE_CONTROL_HEIGHT 18
#define TITLE_VIEW_HEIGHT   40
#define TITLE_PADDING       15

@interface FEAutoScrollView()
<
UICollectionViewDataSource
, UICollectionViewDelegate
>

@property (nonatomic, weak) UICollectionView            *collectionView; // 显示图片的collectionView
@property (nonatomic, weak) UICollectionViewFlowLayout  *flowLayout;

@property(nonatomic, strong) NSArray* imageUrlArray;//网络图片URL
@property(nonatomic, strong) NSArray* titleArray;//title 数组
@property(nonatomic, assign) BOOL   isLocalResource;//本地图片

@end

@implementation FEAutoScrollView
{
    UIPageControl   *_pageControl;
    
    UIView          *_titleBgView;
    UILabel         *_titleLabel;
    
    NSTimer         *_scrollTimer;
    
    NSInteger       _totalItemsCount;
    NSInteger       _currentPageIndex;
}

-(void)dealloc
{
    [self stopScrollTimer];
    
    _defaultImage = nil;
    _imageUrlArray = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.autoScrollTime = CIRCLE_TIME;
        self.autoScroll = YES;
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupMainView];
        
        [self setupPageControl];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil) {
        [self stopScrollTimer];
    }
}


// 设置显示图片的collectionView
- (void)setupMainView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = self.size;
    _flowLayout = flowLayout;

    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    [collectionView registerClass:[FEAutoScrollViewCell class] forCellWithReuseIdentifier:@"FEAutoScrollViewCell"];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.scrollsToTop = NO;//避免点击状态栏回到顶部冲突
    [self addSubview:collectionView];
    _collectionView = collectionView;
}

- (void)setupPageControl
{
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    _pageControl.autoresizingMask = UIViewAutoresizingNone;
    _pageControl.hidesForSinglePage = YES;
    _pageControl.userInteractionEnabled = NO;
    [self addSubview:_pageControl];
}


-(void)startScrollTimer
{
    [self stopScrollTimer];
    
    if ([self.imageUrlArray count] > 1 && self.autoScroll)
    {
        _scrollTimer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTime
                                                         target:self
                                                       selector:@selector(changeAdTimerHandler:) userInfo:nil
                                                        repeats:YES];
    }
    
}


-(void)stopScrollTimer
{
    if (_scrollTimer != nil)
    {
        [_scrollTimer invalidate];
        _scrollTimer = nil;
    }
}

-(void)setImageNameArray:(NSArray *)imageNameArray
{
    [self setImageNameArray:imageNameArray titleArray:nil];
}

- (void)setImageNameArray:(NSArray *)imageNameArray titleArray:(NSArray*)titleArray
{
    [self setImageUrlArray:imageNameArray titleArray:titleArray localResource:YES];
}

-(void)setImageUrlArray:(NSArray *)imageUrlArray
{
    [self setImageUrlArray:imageUrlArray titleArray:nil];
}

- (void)setImageUrlArray:(NSArray *)imageUrlArray titleArray:(NSArray*)titleArray
{
    [self setImageUrlArray:imageUrlArray titleArray:titleArray localResource:NO];
}

- (void)setImageUrlArray:(NSArray *)imageUrlArray titleArray:(NSArray*)titleArray localResource:(BOOL)isLocalResource
{
    self.isLocalResource = isLocalResource;
    
    if ([self isSameImageArray:imageUrlArray newImageArray:_imageUrlArray]) {
        return;
    }
    
    _imageUrlArray = imageUrlArray;
    _titleArray = titleArray;
    
    if (_imageUrlArray.count > 1) {
        self.collectionView.scrollEnabled = YES;
        _totalItemsCount =  [_imageUrlArray count] * CIRCLE_COUNT;
    } else {
        self.collectionView.scrollEnabled = NO;
        _totalItemsCount = [_imageUrlArray count];
    }
    
    [self.collectionView reloadData];
    
    int midIndex = _totalItemsCount / 2; //从中间开始显示 达到左右都能滑动的效果
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:midIndex inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionNone
                                        animated:NO];
    
    
    _pageControl.numberOfPages = _imageUrlArray.count;
    
    //配置title view
    [self setupTitleView];
    
    [self updateTitle];
    
    [self startScrollTimer];
}


- (BOOL)isSameImageArray:(NSArray *)imageArray newImageArray:(NSArray *)newImageArray
{
    BOOL isSame = YES;
    if ([imageArray count] == [newImageArray count]) {
        for (NSInteger i = 0; i < [imageArray count]; ++i) {
            if (![imageArray[i] isEqualToString:newImageArray[i]]) {
                isSame = NO;
                break;
            }
        }
    } else {
        isSame = NO;
    }
    
    return isSame;
}

- (void)setupTitleView
{
    if ([_titleArray count] > 0) {
        
        if (_titleBgView == nil) {
            _titleBgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - TITLE_VIEW_HEIGHT, self.width, TITLE_VIEW_HEIGHT)];
            _titleBgView.backgroundColor = RGBAHEX(0x000000, 0.6);
            _titleBgView.userInteractionEnabled = NO;
            [self addSubview:_titleBgView];
        }

        CGSize size = [_pageControl sizeForNumberOfPages:_pageControl.numberOfPages];
        _pageControl.frame = CGRectMake(self.width - size.width - TITLE_PADDING
                                        , _titleBgView.top + MID(TITLE_VIEW_HEIGHT - PAGE_CONTROL_HEIGHT)
                                        , size.width
                                        , PAGE_CONTROL_HEIGHT);
        [self bringSubviewToFront:_pageControl];
        
        if (_titleLabel == nil) {
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            _titleLabel.backgroundColor = [UIColor clearColor];
            _titleLabel.font = [UIFont systemFontOfSize:16];
            _titleLabel.textColor = RGBHEX(0xFFFFFF);
            [_titleBgView addSubview:_titleLabel];
        }

        
        CGFloat width = self.width - TITLE_PADDING * 2 - _pageControl.width - TITLE_PADDING;
        _titleLabel.frame = CGRectMake(TITLE_PADDING, 0, width, _titleBgView.height);
        
        
    } else {
        [_titleBgView removeFromSuperview];
        _titleBgView = nil;
        
        [_titleLabel removeFromSuperview];
        _titleLabel = nil;
        [_pageControl sizeToFit];
        _pageControl.frame = CGRectMake(MID(self.width - _pageControl.width)
                                        , self.height - PAGE_CONTROL_HEIGHT
                                        , _pageControl.width
                                        , PAGE_CONTROL_HEIGHT);
    }
}

- (void)updateTitle
{
    if (_currentPageIndex >= 0
        && _currentPageIndex < [_titleArray count]) {
        NSString *title = _titleArray[_currentPageIndex];
        _titleLabel.text = title;
    }
}

#pragma mark - 换图片
- (void) changeAdTimerHandler:(NSTimer *) timer
{
    if (_totalItemsCount == 0) {
        return;
    }
    
    int currentIndex = self.collectionView.contentOffset.x / _flowLayout.itemSize.width;
    int targetIndex = currentIndex + 1;
    if (targetIndex == _totalItemsCount) { //自动滑动到最后一个
        targetIndex = _totalItemsCount / 2; //从中间开始显示 达到左右都能滑动的效果
    }
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _totalItemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FEAutoScrollViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FEAutoScrollViewCell" forIndexPath:indexPath];
    
    long itemIndex = indexPath.item % self.imageUrlArray.count;
    
    NSString *urlString = self.imageUrlArray[itemIndex];
    
    if (self.isLocalResource) {//本地图片资源
        UIImage *image = [UIImage imageNamed:urlString];
        if (image == nil) {
            image = self.defaultImage;
        }

        cell.imageView.image = image;
        
    } else {
        if ([urlString length] > 0) {
            
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:self.defaultImage];
        }
        
        //预加载
        [self preloadImageWithIndex:itemIndex + 1];
        [self preloadImageWithIndex:itemIndex - 1];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(autoScrollView:selected:)])
    {
        NSInteger index = indexPath.item % self.imageUrlArray.count;
        [self.delegate autoScrollView:self selected:index];
    }
}


#pragma mark -  UIScrollViewDelegate Methods
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopScrollTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_totalItemsCount <= 0) {
        return;
    }
    
    int itemIndex = (scrollView.contentOffset.x + self.collectionView.width * 0.5) / self.collectionView.width;
    _currentPageIndex = itemIndex % self.imageUrlArray.count;

    _pageControl.currentPage = _currentPageIndex;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updateTitle];
    [self startScrollTimer];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self updateTitle];
}

#pragma mark - 预加载图片
- (void)preloadImageWithIndex:(NSInteger)index
{
    NSInteger count = self.imageUrlArray.count;
    NSString *urlString = nil;
    if (index <= 0) {
        urlString = [self.imageUrlArray lastObject];
    } else if (index >= count) {
        urlString = [self.imageUrlArray firstObject];
    } else {
        urlString = self.imageUrlArray[index];
    }
    
    if ([urlString length] > 0) {
        NSURL *url = [NSURL URLWithString:urlString];
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager cachedImageExistsForURL:url completion:^(BOOL isCache){
            if (!isCache) {
                [[manager imageDownloader] downloadImageWithURL:url options:SDWebImageDownloaderProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                    
                } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                    
                }];
            }
            
        }];
        
        
        
//        BOOL hasCache = [[SDWebImageManager sharedManager] cachedImageExistsForURL:url];
//        if (!hasCache) {
//            [[SDWebImageManager sharedManager] downloadImageWithURL:url options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//                
//            }];
//        }
        
        
    }

}

@end
