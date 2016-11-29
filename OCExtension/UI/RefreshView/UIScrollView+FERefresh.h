//
//  UIScrollView+FERefresh.h
//  Pet
//
//  Created by Tom on 15/4/9.
//  Copyright (c) 2015年 fanying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FERefreshHeaderView.h"
#import "FERefreshFooterView.h"

@protocol UIScrollViewRefreshDelegate <UIScrollViewDelegate>
@optional
-(void)onHeaderRefreshData:(UIScrollView*)scrollView;
-(void)onFooterRefreshData:(UIScrollView*)scrollView;

@end

@interface UIScrollView (FERefresh)

@property (nonatomic, strong, readonly) FERefreshHeaderView     *header;
@property (nonatomic, strong, readonly) FERefreshFooterView     *footer;

//正在上拉或者下拉刷新
-(BOOL)isRefreshing;

-(BOOL)isHeaderRefreshing;

-(BOOL)isFooterRefreshing;

//是否有header
- (BOOL)hasHeaderRefreshView;

//停止下拉和上拉
-(void)endRefreshView;


#pragma mark 下拉刷新
//添加下拉刷新
- (void)addHeaderRefreshView;

//主动下拉刷新
- (void)beginHeaderRefreshView;

//停止下拉刷新
- (void)endHeaderRefreshView;

//移除下拉刷新
- (void)removeHeaderRefreshView;

#pragma mark -
#pragma mark 上拉加载更多
//添加上拉加载更多
- (void)addFooterRefreshView;

//主动开始上拉
- (void)beginFooterRefreshView;

//结束上拉
- (void)endFooterRefreshView;

//移除上拉
- (void)removeFooterRefreshView;

//是否有footer
- (BOOL)hasFooterRefreshView;


@end
