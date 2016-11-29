//
//  FERefreshFooterView.m
//  FERefresh
//
//  Created by Tom on 15/6/2.
//  Copyright (c) 2015年 liyy. All rights reserved.
//

#import "FERefreshFooterView.h"
#import "UIScrollView+FERefresh.h"
#import "UIView+add.h"
#import "FEPrecompile.h"


#define PADDING 5


@implementation FERefreshFooterView
{
    __weak UIScrollView     *_scrollView;
    
    
    UILabel                 *_tipsLabel;
    
    UIActivityIndicatorView *_indicatorView;
    UILabel                 *_loadingLabel;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        
        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipsLabel.backgroundColor = [UIColor clearColor];
        _tipsLabel.text = @"加载更多";
        _tipsLabel.font = [UIFont systemFontOfSize:14];
        _tipsLabel.textColor = RGBHEX(0x999999);
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        [_tipsLabel sizeToFit];
        [self addSubview:_tipsLabel];
        _tipsLabel.hidden = NO;
        
        
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.color = RGBHEX(0x999999);
        [self addSubview:_indicatorView];
        _indicatorView.hidden = YES;
        
        _loadingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _loadingLabel.backgroundColor = [UIColor clearColor];
        _loadingLabel.text = @"正在加载...";
        _loadingLabel.font = [UIFont systemFontOfSize:14];
        _loadingLabel.textColor = RGBHEX(0x999999);
        _loadingLabel.textAlignment = NSTextAlignmentCenter;
        [_loadingLabel sizeToFit];
        [self addSubview:_loadingLabel];
        _loadingLabel.hidden = YES;
        
        [self setState:FEPullRefreshNormal];
        
    }
    
    return self;
    
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    // 旧的父控件
    [self.superview removeObserver:self forKeyPath:FERefreshContentOffset context:nil];
    [self.superview removeObserver:self forKeyPath:FERefreshDragging context:nil];
    [self.superview removeObserver:self forKeyPath:FERefreshContentSize context:nil];

//    UIEdgeInsets contentInset = _scrollView.contentInset;
//    contentInset.bottom = 0;
//    _scrollView.contentInset = contentInset;
    
    if (newSuperview) { // 新的父控件
        [newSuperview addObserver:self forKeyPath:FERefreshContentOffset options:NSKeyValueObservingOptionNew context:nil];
        
        [newSuperview addObserver:self forKeyPath:FERefreshDragging options:NSKeyValueObservingOptionNew context:nil];
        [newSuperview addObserver:self forKeyPath:FERefreshContentSize options:NSKeyValueObservingOptionNew context:nil];
        
        
        // 记录UIScrollView
        _scrollView = (UIScrollView *)newSuperview;
        // 设置永远支持垂直弹簧效果
        _scrollView.alwaysBounceVertical = YES;
        
        [self refreshViewFrame];
    }
}

#pragma mark -
- (void)beginRefreshing
{
    self.state = FEPullRefreshLoading;
    CGFloat contentOffsetY = _scrollView.contentOffset.y + FOOTER_REFRESH_REGION_HEIGHT;
    [_scrollView setContentOffset:CGPointMake(0, contentOffsetY)];
    
    __weak typeof(self) weakSelf = self;

    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
        // 增加滚动区域
        UIEdgeInsets contentInset = _scrollView.contentInset;
        contentInset.bottom = FOOTER_REFRESH_REGION_HEIGHT;
        _scrollView.contentInset = contentInset;
        
    } completion:^(BOOL finished) {
        // 回调
        if (weakSelf.refreshingBlock) {
            weakSelf.refreshingBlock();
        }
    }];
}

- (void)endRefreshing
{
    [self setState:FEPullRefreshNormal];
 
//    是否恢复 contentInset
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    
    UIEdgeInsets contentInset = _scrollView.contentInset;
    contentInset.bottom = 0;
    _scrollView.contentInset = contentInset;
    
    [UIView commitAnimations];
}

- (BOOL)isRefreshing
{
    return self.state == FEPullRefreshLoading;
}


#pragma mark - 私有方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:FERefreshContentOffset]) {
        [self adjustStateWithContentOffset];
    } else if ([keyPath isEqualToString:FERefreshDragging]) {
        if (_scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded){
            [self scrollViewDidEndDragging:_scrollView];
        }
    } else if ([keyPath isEqualToString:FERefreshContentSize]){
        [self refreshViewFrame];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark 根据contentOffset调整state
- (void)adjustStateWithContentOffset
{
    float offY          = _scrollView.contentOffset.y;
    float contentHeight = _scrollView.contentSize.height;
    float boundsHeight  = _scrollView.bounds.size.height;
    
    contentHeight = MAX(contentHeight, boundsHeight);

    
    if (_state == FEPullRefreshLoading) {
        
//        NSLog(@"FERefreshFooterView === RefreshLoading");

        UIEdgeInsets contentInet = _scrollView.contentInset;
        contentInet.bottom = FOOTER_REFRESH_REGION_HEIGHT;
        _scrollView.contentInset = contentInet;

        
    } else if (_scrollView.isDragging) {
        
//        NSLog(@"FERefreshFooterView === isDragging");
        
        if (_scrollView.isHeaderRefreshing) {
            self.hidden = YES;
            return;
        } else {
            self.hidden = NO;
        }
        
        BOOL loading = [self isRefreshing];
        
        if (_state == FEPullRefreshPulling
            && ((offY + boundsHeight) < (contentHeight + FOOTER_REFRESH_REGION_HEIGHT))
            && offY > 0
            && !loading)
        {
            [self setState:FEPullRefreshNormal];
        }
        else if (_state == FEPullRefreshNormal
                 && (offY + boundsHeight) > (contentHeight + FOOTER_REFRESH_REGION_HEIGHT)
                 && !loading)
        {
            [self setState:FEPullRefreshPulling];
        }
        
        if (_scrollView.contentInset.bottom != 0) {
            UIEdgeInsets contentInet = _scrollView.contentInset;
            contentInet.bottom = 0;
            _scrollView.contentInset = contentInet;
            
        }
        
    }
    
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
{
    BOOL loading = [scrollView isRefreshing];
    float offY = scrollView.contentOffset.y;
    float contentHeight = scrollView.contentSize.height;
    float boundsHeight = scrollView.bounds.size.height;
    
    contentHeight = MAX(contentHeight, boundsHeight);
    
    if ((offY + boundsHeight) > (contentHeight)
        && !loading)
    {
//        NSLog(@"FERefreshFooterView === EndDragging");

        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (weakSelf.refreshingBlock) {
                weakSelf.refreshingBlock();
            }
        });

        
        [self setState:FEPullRefreshLoading];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.2];
            UIEdgeInsets contentInet = scrollView.contentInset;
            contentInet.bottom = FOOTER_REFRESH_REGION_HEIGHT;
            scrollView.contentInset = contentInet;
            [UIView commitAnimations];
            
        });
    }
    
}

-(void)refreshViewFrame
{
    //如果contentsize的高度比表的高度小，那么就需要把刷新视图放在表的bounds的下面
    int height = MAX(_scrollView.bounds.size.height, _scrollView.contentSize.height);
    self.frame =CGRectMake(0.0f, height, _scrollView.frame.size.width, _scrollView.bounds.size.height);
    
    CGFloat top = 0;
    
    _tipsLabel.frame = CGRectMake((MID(self.width - _tipsLabel.width)), top + MID(FOOTER_REFRESH_REGION_HEIGHT - _tipsLabel.height), _tipsLabel.width, _tipsLabel.height);
    
    CGFloat left = MID(self.width - _indicatorView.width - PADDING - _loadingLabel.width);
    
    _indicatorView.frame = CGRectMake(left, top + MID(FOOTER_REFRESH_REGION_HEIGHT - _indicatorView.height), _indicatorView.width, _indicatorView.height);
    
    _loadingLabel.frame = CGRectMake(_indicatorView.right + PADDING, top + MID(FOOTER_REFRESH_REGION_HEIGHT - _loadingLabel.height), _loadingLabel.width, _loadingLabel.height);
}


#pragma mark -
#pragma mark Setters
- (void)setState:(FEPullRefreshState)aState{
    
    switch (aState) {
        case FEPullRefreshPulling:
            _tipsLabel.text = @"加载更多";
            _indicatorView.hidden = YES;
            _loadingLabel.hidden = YES;
            _tipsLabel.hidden = NO;
            [_indicatorView stopAnimating];

            break;
        case FEPullRefreshNormal:
            _tipsLabel.text = @"加载更多";
            _indicatorView.hidden = YES;
            _loadingLabel.hidden = YES;
            _tipsLabel.hidden = NO;
            [_indicatorView stopAnimating];

            break;
        case FEPullRefreshLoading:
            _indicatorView.hidden = NO;
            _loadingLabel.hidden = NO;
            _tipsLabel.hidden = YES;
            [_indicatorView startAnimating];
            break;
        default:
            break;
    }
    
    _state = aState;
}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
}


@end
