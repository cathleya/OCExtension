//
//  UIScrollView+FERefresh.m
//  Pet
//
//  Created by Tom on 15/4/9.
//  Copyright (c) 2015年 fanying. All rights reserved.
//

#import "UIScrollView+FERefresh.h"
#import "FEPrecompile.h"
#import <objc/runtime.h>

@implementation UIScrollView (FERefresh)

-(BOOL)isRefreshing
{
    BOOL headerIsRefreshing = [self isHeaderRefreshing];
    BOOL footerIsRefreshing = [self isFooterRefreshing];
    return (headerIsRefreshing || footerIsRefreshing);
}

-(BOOL)isHeaderRefreshing
{
    return [self.header isRefreshing];
}

-(BOOL)isFooterRefreshing
{
    return [self.footer isRefreshing];
}

-(void)endRefreshView
{
    [self endHeaderRefreshView];
    [self endFooterRefreshView];
}

#pragma mark header
static char FERefreshHeaderKey;
- (void)setHeader:(FERefreshHeaderView *)header
{
    if (header != self.header) {
        [self.header removeFromSuperview];
        [self willChangeValueForKey:@"header"];

        objc_setAssociatedObject(self, &FERefreshHeaderKey,
                                 header,
                                 OBJC_ASSOCIATION_ASSIGN);

        [self didChangeValueForKey:@"header"];

        [self addSubview:header];
    }
}

- (FERefreshHeaderView *)header
{
    return objc_getAssociatedObject(self, &FERefreshHeaderKey);
}

- (void)addHeaderRefreshView
{
    if (self.header)
    {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    FERefreshHeaderView *view = [[FERefreshHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.bounds.size.height, self.frame.size.width, self.bounds.size.height)];
    self.header = view;
    view.backgroundColor = RGBHEX(0xf8f8f8);

    
    view.refreshingBlock = ^{
        [weakSelf onHeaderRefreshData];
    };
}

- (void)beginHeaderRefreshView
{
    [self.header beginRefreshing];
}

- (void)endHeaderRefreshView
{
    if (self.header
        && self.header.state != FEPullRefreshNormal) {
        [self.header endRefreshing];
    }
}
- (void)removeHeaderRefreshView
{
    self.header = nil;
}

- (BOOL)hasHeaderRefreshView
{
    return self.header == nil;
}


-(void)onHeaderRefreshData
{
    if ([self.delegate respondsToSelector:@selector(onHeaderRefreshData:)])
    {
        [(id)(self.delegate) onHeaderRefreshData:self];
    }
}


#pragma mark - footer
static char FERefreshFooterKey;
- (void)setFooter:(FERefreshFooterView *)footer
{
    if (footer != self.footer) {
        [self.footer removeFromSuperview];
        [self willChangeValueForKey:@"footer"];

        objc_setAssociatedObject(self, &FERefreshFooterKey,
                                 footer,
                                 OBJC_ASSOCIATION_ASSIGN);
        
        [self didChangeValueForKey:@"footer"];

        [self addSubview:footer];
    }
}

- (FERefreshFooterView *)footer
{
    return objc_getAssociatedObject(self, &FERefreshFooterKey);
}

- (void)addFooterRefreshView
{
    if (self.footer)
    {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    
    CGRect rect = self.bounds;
    
    FERefreshFooterView* gifFooter = [[FERefreshFooterView alloc] initWithFrame:CGRectMake(0, rect.size.height, rect.size.width, rect.size.height)];
    gifFooter.backgroundColor = [UIColor clearColor];
    
    self.footer = gifFooter;
    
    gifFooter.refreshingBlock = ^{
        [weakSelf onFooterRefreshData];
    };
}

- (void)beginFooterRefreshView
{
    if (![self.footer isRefreshing]) {
        [self.footer beginRefreshing];
    }
}

- (void)endFooterRefreshView
{
    if (self.footer == nil) { //解决footer 先移除时 无法恢复的问题
        //    是否恢复 contentInset
        UIEdgeInsets contentInset = self.contentInset;
        if (contentInset.bottom != 0) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:.3];
            
            contentInset.bottom = 0;
            self.contentInset = contentInset;
            [UIView commitAnimations];
        }
        
    } else {
        if (self.footer.state != FEPullRefreshNormal) {
            [self.footer endRefreshing];
        }
    }
    
}

- (void)removeFooterRefreshView
{
    self.footer = nil;
}

- (BOOL)hasFooterRefreshView
{
    return self.footer != nil;
}

-(void)onFooterRefreshData
{
    if ([self.delegate respondsToSelector:@selector(onFooterRefreshData:)])
    {
        [(id)(self.delegate) onFooterRefreshData:self];
    }
}

+ (void)load
{
    Method method1 = class_getInstanceMethod([self class], NSSelectorFromString(@"dealloc"));
    Method method2 = class_getInstanceMethod([self class], @selector(fe_deallocSwizzle));
    method_exchangeImplementations(method1, method2);
}

- (void)fe_deallocSwizzle
{
    self.footer = nil;
    self.header = nil;
    
    [self fe_deallocSwizzle];
}

@end
