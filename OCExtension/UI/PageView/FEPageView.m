//
//  FEPageView.m
//  Pet
//
//  Created by Tom on 15/6/25.
//  Copyright (c) 2015年 fanying. All rights reserved.
//

#import "FEPageView.h"
#import "UIScrollView+AllowPanGestureEventPass.h"
#import "UIView+add.h"

#define PAGE_CONTENT_TAG_BASE 3000
#define PADDING 0//暂时为0, 滑动时计算分页还没处理好

@implementation FEPageView
{
    NSMutableArray          *_visiblePagesArray;
    NSMutableDictionary     *_pageContentPool;
    
    BOOL                    _bNeedReloadData;
    
    CGPoint                 _beginContentOffset;
    CGPoint                 _beginPoint;
    
    NSInteger               _numberOfPages;
    
    BOOL                    _notifyLoadMore;//是否需要通知加载更多
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _bNeedReloadData = YES;
        _notifyLoadMore = YES;
        _currentPageIndex = 0;
        _visiblePagesArray = [[NSMutableArray alloc] init];
        _pageContentPool = [[NSMutableDictionary alloc] init];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:[self frameForPagingScrollView]];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        [self addSubview:_scrollView];
    }
    return self;
}

- (void)dealloc
{
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _scrollView.frame = [self frameForPagingScrollView];
    
    _scrollView.contentSize = [self contentSizeForPagingScrollView];
    
    
    for (int i = 0; i < [_visiblePagesArray count]; i++)
    {
        FEPageContentView *contentView = [_visiblePagesArray objectAtIndex:i];
        NSInteger index = (contentView.tag - PAGE_CONTENT_TAG_BASE);
        contentView.frame = [self frameForPageAtIndex:index];
    }
}

#pragma mark - Frame Calculations

- (CGRect)frameForPagingScrollView
{
    CGRect frame = self.bounds;// [[UIScreen mainScreen] bounds];
    frame.origin.x -= PADDING;
    frame.size.width += (2 * PADDING);
    return frame;
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index
{
    CGRect bounds = _scrollView.bounds;
    CGRect pageFrame = bounds;
    pageFrame.size.width -= (2 * PADDING);
    pageFrame.origin.x = (bounds.size.width * index) + PADDING;
    return pageFrame;
}

- (CGSize)contentSizeForPagingScrollView
{
    CGRect bounds = _scrollView.bounds;
    return CGSizeMake(bounds.size.width * _numberOfPages, bounds.size.height);
}

- (CGPoint)contentOffsetForPageAtIndex:(NSUInteger)index
{
    CGFloat pageWidth = _scrollView.bounds.size.width;
    CGFloat newOffset = index * pageWidth;
    return CGPointMake(newOffset, 0);
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_bNeedReloadData)
    {
        _numberOfPages = [_dataSource pageViewNumberOfPage:self];
        
        _scrollView.contentSize = [self contentSizeForPagingScrollView];
        
        [self recoverVisiblePageContentViews];
        FEPageContentView *pageContentView = [_dataSource pageView:self
                                                  pageForIndexPath:[NSIndexPath indexPathForRow:_currentPageIndex inSection:0]];
        if (pageContentView)
        {
            pageContentView.tag = PAGE_CONTENT_TAG_BASE + _currentPageIndex;
            pageContentView.frame = [self frameForPageAtIndex:_currentPageIndex];
            
            [_scrollView insertSubview:pageContentView atIndex:0];
            [_visiblePagesArray addObject:pageContentView];
            
            if ([_delegate respondsToSelector:@selector(pageView:willDiplayPage:indexPath:)])
            {
                [_delegate pageView:self
                     willDiplayPage:pageContentView
                          indexPath:[NSIndexPath indexPathForRow:_currentPageIndex inSection:0]];
            }
            
            [self scrollToPage:_currentPageIndex animated:NO];
        }
        
        _bNeedReloadData = NO;
    }
}


- (void)setScrollEnabled:(BOOL)aScrollEnabled
{
    _scrollView.scrollEnabled = aScrollEnabled;
}

- (BOOL)scrollEnabled
{
    return _scrollView.scrollEnabled;
}

-(NSArray*)visiblePagesArray
{
    return _visiblePagesArray;
}

- (FEPageContentView *)dequeueReusablePageWithIdentifier:(NSString *)identifier
{
    NSMutableArray *viewArray = [_pageContentPool objectForKey:identifier];
    if (viewArray)
    {
        if ([viewArray count] > 0)
        {
            FEPageContentView *view = [viewArray lastObject];
            [viewArray removeLastObject];
            return view;
        }
    }
    
    return nil;
}

-(FEPageContentView*)currentContentView
{
    FEPageContentView *contentView = (FEPageContentView *)[_scrollView viewWithTag:PAGE_CONTENT_TAG_BASE + _currentPageIndex];
    
    return contentView;
}

- (void)reloadData
{
    _bNeedReloadData = YES;
    [self setNeedsLayout];
}

- (void)scrollToPage:(NSUInteger)pageIndex animated:(BOOL)animated
{
    _currentPageIndex = pageIndex;
 
    CGRect frame = [self frameForPageAtIndex:_currentPageIndex];
    [_scrollView scrollRectToVisible:frame animated:animated];
    
    if (!animated) {
        if ([_delegate respondsToSelector:@selector(pageView:didShowPage:indexPath:)])
        {
            FEPageContentView *contentView = (FEPageContentView *)[_scrollView viewWithTag:PAGE_CONTENT_TAG_BASE + _currentPageIndex];
            [_delegate pageView:self
                    didShowPage:contentView
                      indexPath:[NSIndexPath indexPathForRow:_currentPageIndex inSection:0]];
        }
    }
}

#pragma mark - Private

- (void)recoverVisiblePageContentViews
{
    for (int i = 0; i < [_visiblePagesArray count]; i++)
    {
        FEPageContentView *contentView = [_visiblePagesArray objectAtIndex:i];
        [self recoverVisiblePageContentView:contentView];
    }
    [_visiblePagesArray removeAllObjects];
}

- (void)recoverVisiblePageContentView:(FEPageContentView *)pageContentView
{
    NSMutableArray *array = [_pageContentPool objectForKey:pageContentView.reuseIdentifier];
    if (array == nil)
    {
        array = [NSMutableArray array];
        [_pageContentPool setObject:array forKey:pageContentView.reuseIdentifier];
    }
    [array addObject:pageContentView];
    [pageContentView removeFromSuperview];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_scrollView.contentOffset.x > (_scrollView.contentSize.width - _scrollView.width)) {
        if (_notifyLoadMore) {
            _notifyLoadMore = NO;
            if ([_delegate respondsToSelector:@selector(pageViewLoadMore:)]) {
                [_delegate pageViewLoadMore:self];
            }
        }
    }
    
    NSInteger startPageIndex = floor(scrollView.contentOffset.x / scrollView.width);
    if (startPageIndex < 0)
    {
        startPageIndex = 0;
    }
    
    NSInteger endPageIndex = startPageIndex;
    if (startPageIndex * scrollView.width < scrollView.contentOffset.x &&
        startPageIndex + 1 < _numberOfPages)
    {
        endPageIndex ++;
    }
    
    //检测是否需要生成显示页面
    for (NSInteger i = startPageIndex; i <= endPageIndex; i++)
    {
        BOOL bHasExists = NO;
        for (int j = 0; j < [_visiblePagesArray count]; j++)
        {
            FEPageContentView *contentView = (FEPageContentView *)[_visiblePagesArray objectAtIndex:j];
            if (contentView.tag - PAGE_CONTENT_TAG_BASE == i)
            {
                bHasExists = YES;
                break;
            }
        }
        
        if (!bHasExists)
        {
            FEPageContentView *pageContentView = [_dataSource pageView:self pageForIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if (pageContentView)
            {
                pageContentView.tag = PAGE_CONTENT_TAG_BASE + i;
    
                pageContentView.frame = [self frameForPageAtIndex:i];
                [_scrollView insertSubview:pageContentView atIndex:0];
                [_visiblePagesArray addObject:pageContentView];
                
                if ([_delegate respondsToSelector:@selector(pageView:willDiplayPage:indexPath:)])
                {
                    [_delegate pageView:self willDiplayPage:pageContentView indexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                }
            }
        }
    }
    
    //检测是否有需要回收页面
    for (int i = 0; i < [_visiblePagesArray count]; i++)
    {
        FEPageContentView *pageContentView = [_visiblePagesArray objectAtIndex:i];
        NSInteger pageIndex = pageContentView.tag - PAGE_CONTENT_TAG_BASE;
        if (pageIndex < startPageIndex || pageIndex > endPageIndex)
        {
            if ([_delegate respondsToSelector:@selector(pageView:didHidePage:indexPath:)])
            {
                [_delegate pageView:self
                        didHidePage:pageContentView
                          indexPath:[NSIndexPath indexPathForRow:_currentPageIndex inSection:0]];
            }
            
            //回收页面
            [self recoverVisiblePageContentView:pageContentView];
            [_visiblePagesArray removeObject:pageContentView];
        }
    }
    
    //判断当前页码
    CGFloat pageOffsetX = _currentPageIndex * self.width;
    CGFloat dx = pageOffsetX - scrollView.contentOffset.x;
    if (dx < 0)
    {
        if (startPageIndex != _currentPageIndex)
        {
            _currentPageIndex = startPageIndex;
            
            FEPageContentView *contentView = (FEPageContentView *)[_scrollView viewWithTag:PAGE_CONTENT_TAG_BASE + _currentPageIndex];
            
            if ([_delegate respondsToSelector:@selector(pageView:didShowPage:indexPath:)])
            {
                [_delegate pageView:self
                        didShowPage:contentView
                          indexPath:[NSIndexPath indexPathForRow:_currentPageIndex inSection:0]];
            }
        }
    }
    else if (dx > 0)
    {
        if (endPageIndex != _currentPageIndex)
        {
            _currentPageIndex = endPageIndex;
            
            FEPageContentView *contentView = (FEPageContentView *)[_scrollView viewWithTag:PAGE_CONTENT_TAG_BASE + _currentPageIndex];
            
            if ([_delegate respondsToSelector:@selector(pageView:didShowPage:indexPath:)])
            {
                [_delegate pageView:self
                        didShowPage:contentView
                          indexPath:[NSIndexPath indexPathForRow:_currentPageIndex inSection:0]];
            }
        }
    }
    
    
    if ([_delegate respondsToSelector:@selector(pageViewDidScroll:point:)])
    {
        CGPoint point = CGPointMake(_beginPoint.x - (_scrollView.contentOffset.x - _beginContentOffset.x), _beginPoint.y);
        
        [_delegate pageViewDidScroll:self point:point];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _notifyLoadMore = YES;

    if ([_delegate respondsToSelector:@selector(pageViewDidEndDecelerating:point:)])
    {
        CGPoint point = point = CGPointMake(_beginPoint.x - (_scrollView.contentOffset.x - _beginContentOffset.x), _beginPoint.y);
        
        [_delegate pageViewDidEndDecelerating:self point:point];
    }
    
    if ([_delegate respondsToSelector:@selector(pageView:pageChanged:)]) {
        [_delegate pageView:self pageChanged:_currentPageIndex];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSInteger pageIndex = round(scrollView.contentOffset.x / self.width);
    if (pageIndex != _currentPageIndex)
    {
        _currentPageIndex = pageIndex;
        
        if ([_delegate respondsToSelector:@selector(pageView:didShowPage:indexPath:)])
        {
            FEPageContentView *contentView = (FEPageContentView *)[_scrollView viewWithTag:PAGE_CONTENT_TAG_BASE + _currentPageIndex];
            [_delegate pageView:self
                    didShowPage:contentView
                      indexPath:[NSIndexPath indexPathForRow:_currentPageIndex inSection:0]];
        }
    }
        
    if ([_delegate respondsToSelector:@selector(pageViewWillBeginDragging:point:)])
    {
        _beginContentOffset = _scrollView.contentOffset;
        _beginPoint = [_scrollView.panGestureRecognizer locationInView:self];
        [_delegate pageViewWillBeginDragging:self point:_beginPoint];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        _notifyLoadMore = YES;
    }
    
    if ([_delegate respondsToSelector:@selector(pageViewDidEndDragging:willDecelerate:point:)])
    {
        CGPoint point = CGPointMake(_beginPoint.x - (_scrollView.contentOffset.x - _beginContentOffset.x), _beginPoint.y);
        
        [_delegate pageViewDidEndDragging:self willDecelerate:decelerate point:point];
    }
}


@end
