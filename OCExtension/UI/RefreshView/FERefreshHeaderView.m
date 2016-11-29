//
//  FERefreshFooterView.h
//  Pet
//
//  Created by Tom on 15/4/9.
//  Copyright (c) 2015年 fanying. All rights reserved.
//

#import "FERefreshHeaderView.h"
#import "UIScrollView+FERefresh.h"
#import "UIView+add.h"
#import "FEPrecompile.h"

#define PADDING 5

@implementation FERefreshHeaderView
{
    __weak UIScrollView     *_scrollView;
    UIImageView             *_gifView;
    UILabel                 *_finshedLabel;
    UIImageView             *_finshedImageView;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor clearColor];
        
        _gifView = [[UIImageView alloc] initWithFrame:CGRectZero];
        NSMutableArray *idleImages = [NSMutableArray array];
        for (NSUInteger i = 1; i<=11; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh%zd", i]];
            [idleImages addObject:image];
        }
        
        _gifView.animationImages = idleImages;
        _gifView.image = idleImages[0];
        [_gifView sizeToFit];
        [self addSubview:_gifView];
        
        _gifView.frame = CGRectMake((self.frame.size.width - _gifView.frame.size.width)*0.5, frame.size.height - _gifView.frame.size.height, _gifView.frame.size.width, _gifView.frame.size.height);
        
        _gifView.animationDuration = idleImages.count * 0.1;
        
        _finshedLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _finshedLabel.backgroundColor = [UIColor clearColor];
        _finshedLabel.text = @"刷新完成";
        _finshedLabel.font = [UIFont systemFontOfSize:14];
        _finshedLabel.textColor = RGBHEX(0x999999);
        _finshedLabel.textAlignment = NSTextAlignmentCenter;
        [_finshedLabel sizeToFit];
        [self addSubview:_finshedLabel];
        _finshedLabel.hidden = YES;
        
        _finshedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refresh_finished_flag.png"]];
        [_finshedImageView sizeToFit];
        [self addSubview:_finshedImageView];
        _finshedImageView.hidden = YES;
        
        
        CGFloat width = _finshedLabel.width + PADDING + _finshedImageView.width;
        CGFloat top = _gifView.top;
        NSInteger left = (frame.size.width - width)*0.5;
        
        _finshedImageView.frame = CGRectMake(left, top + (_gifView.height - _finshedImageView.height)*0.5, _finshedImageView.width, _finshedImageView.height);
        
        NSInteger labelLeft = _finshedImageView.right + PADDING;
        _finshedLabel.frame = CGRectMake(labelLeft, top + (_gifView.height - _finshedLabel.height)*0.5, _finshedLabel.frame.size.width, _finshedLabel.frame.size.height);
		
		[self setState:FEPullRefreshNormal];
        
        _showRefreshFinishedStatus = YES;
		
    }
	
    return self;
	
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    // 旧的父控件
    [self.superview removeObserver:self forKeyPath:FERefreshContentOffset context:nil];
    [self.superview removeObserver:self forKeyPath:FERefreshDragging context:nil];
    
    if (newSuperview) { // 新的父控件
        [newSuperview addObserver:self forKeyPath:FERefreshContentOffset options:NSKeyValueObservingOptionNew context:nil];
        
        [newSuperview addObserver:self forKeyPath:FERefreshDragging options:NSKeyValueObservingOptionNew context:nil];

        
        // 记录UIScrollView
        _scrollView = (UIScrollView *)newSuperview;
        // 设置永远支持垂直弹簧效果
        _scrollView.alwaysBounceVertical = YES;
    }
}

#pragma mark -
- (void)beginRefreshing
{
    self.state = FEPullRefreshLoading;
    [_scrollView setContentOffset:CGPointMake(0.0f, -REFRESH_REGION_HEIGHT)];

    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
        // 增加滚动区域
        UIEdgeInsets contentInset = _scrollView.contentInset;
        contentInset.top = 60;
        _scrollView.contentInset = contentInset;

    } completion:^(BOOL finished) {
        // 回调
        if (self.refreshingBlock) {
            self.refreshingBlock();
        }
    }];
}

- (void)endRefreshing
{
    if (_showRefreshFinishedStatus) {
        [self refreshFinished];
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        UIEdgeInsets contentInset = _scrollView.contentInset;
        contentInset.top = 0;
        _scrollView.contentInset = contentInset;
        [UIView commitAnimations];
        
        [weakSelf setState:FEPullRefreshNormal];
        
    });
    

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
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark 根据contentOffset调整state
- (void)adjustStateWithContentOffset
{
    if (_state == FEPullRefreshLoading) {
        
//        NSLog(@"FERefreshHeaderView ======  RefreshLoading");
        CGFloat offset = MAX(_scrollView.contentOffset.y * -1, 0);
        offset = MIN(offset, 60);
        UIEdgeInsets contentInet = _scrollView.contentInset;
        contentInet.top = offset;
        _scrollView.contentInset = contentInet;
        
    } else if (_scrollView.isDragging) {
        
//        NSLog(@"FERefreshHeaderView ======  scrollView.isDragging");
        
        if (_scrollView.isFooterRefreshing) {
            self.hidden = YES;
            return;
        } else {
            self.hidden = NO;
        }
        
        BOOL loading = [self isRefreshing];
        _gifView.hidden = NO;
        _finshedImageView.hidden = YES;
        _finshedLabel.hidden = YES;
        if (_state == FEPullRefreshPulling && _scrollView.contentOffset.y > -REFRESH_REGION_HEIGHT && _scrollView.contentOffset.y < 0.0f && !loading) {
            [self setState:FEPullRefreshNormal];
        } else if (_state == FEPullRefreshNormal && _scrollView.contentOffset.y < -REFRESH_REGION_HEIGHT && !loading) {
            [self setState:FEPullRefreshPulling];
        }
        
        if (_scrollView.contentInset.top != 0) {
            
            UIEdgeInsets contentInet = _scrollView.contentInset;
            contentInet.top = 0;
            _scrollView.contentInset = contentInet;
        }
        
    }

}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
{
    
    BOOL loading = [scrollView isRefreshing];
    if (scrollView.contentOffset.y <= - REFRESH_REGION_HEIGHT && !loading) {
        
//        NSLog(@"FERefreshHeaderView ======  EndDragging");

        
        if (self.refreshingBlock) {
            self.refreshingBlock();
        }
        
        [self setState:FEPullRefreshLoading];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.2];
            UIEdgeInsets contentInet = _scrollView.contentInset;
            contentInet.top = 60;
            scrollView.contentInset = contentInet;
            [UIView commitAnimations];
        });
        
    }
    
}


#pragma mark -
#pragma mark Setters
- (void)setState:(FEPullRefreshState)aState{
	
	switch (aState) {
		case FEPullRefreshPulling:
            [_gifView startAnimating];
			break;
		case FEPullRefreshNormal:
            [_gifView stopAnimating];
			break;
		case FEPullRefreshLoading:
            [_gifView startAnimating];

			break;
		default:
			break;
	}
	
	_state = aState;
}

-(void)refreshFinished
{
    [_gifView stopAnimating];
    [UIView animateWithDuration:0.1 animations:^{
        _finshedLabel.hidden = NO;
        _finshedImageView.hidden = NO;
        _gifView.hidden = YES;
    }];
}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {

}


@end
