//
//  FEPageView.h
//  Pet
//
//  Created by Tom on 15/6/25.
//  Copyright (c) 2015年 fanying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FEPageContentView.h"


@class FEPageView;

@protocol FEPageViewDataSource <NSObject>

@required
/**
	返回页面数量
	@param pageView 页面视图
	@returns 页面数量
 */
- (NSInteger)pageViewNumberOfPage:(FEPageView *)pageView;

/**
	返回分页内容
	@param pageView 页面视图
	@param indexPath 索引位置
	@returns 页面内容
 */
- (FEPageContentView *)pageView:(FEPageView *)pageView pageForIndexPath:(NSIndexPath *)indexPath;

@end

@protocol FEPageViewDelegate <NSObject>

@optional

/**
	页面将要显示
	@param pageView 页面视图
	@param contentView 页面内容视图
	@param indexPath 索引位置
 */
- (void)pageView:(FEPageView *)pageView
  willDiplayPage:(FEPageContentView *)contentView
       indexPath:(NSIndexPath *)indexPath;

/**
	页面显示
	@param pageView 页面视图
	@param contentView 页面内容视图
	@param indexPath 索引位置
 */
- (void)pageView:(FEPageView *)pageView
     didShowPage:(FEPageContentView *)contentView
       indexPath:(NSIndexPath *)indexPath;

- (void)pageView:(FEPageView *)pageView
     didHidePage:(FEPageContentView *)contentView
       indexPath:(NSIndexPath *)indexPath;

/**
 *  加载更多
 *
 *  @param pageView 
 */
- (void)pageViewLoadMore:(FEPageView *)pageView;


/**
	视图滚动
	@param pageView 页面视图
 @param point 点击位置
 */
- (void)pageViewDidScroll:(FEPageView *)pageView point:(CGPoint)point;

/**
	视图减速移动结束
	@param pageView 页面视图
 @param point 点击位置
 */
- (void)pageViewDidEndDecelerating:(FEPageView *)pageView point:(CGPoint)point;

/**
	视图开始拖动
	@param pageView 页面视图
 @param point 点击位置
 */
- (void)pageViewWillBeginDragging:(FEPageView *)pageView point:(CGPoint)point;

/**
	视图结束拖动
	@param pageView 页面视图
	@param decelerate 减速移动标识
 @param point 点击位置
 */
- (void)pageViewDidEndDragging:(FEPageView *)pageView willDecelerate:(BOOL)decelerate point:(CGPoint)point;

/**
	页面变更
	@param pageView 页面视图
	@param pageIndex 页面索引
 */
- (void)pageView:(FEPageView *)pageView pageChanged:(NSInteger)pageIndex;

@end

@interface FEPageView : UIView <UIScrollViewDelegate>

@property (nonatomic,weak) id<FEPageViewDataSource> dataSource;
@property (nonatomic,weak) id<FEPageViewDelegate> delegate;

@property (nonatomic, readonly) UIScrollView    *scrollView;
@property (nonatomic, readonly) NSArray     *visiblePagesArray;
@property (nonatomic,readonly) NSInteger currentPageIndex;
@property (nonatomic,assign) BOOL scrollEnabled;

//	根据标识值获取可用的页面视图
- (FEPageContentView *)dequeueReusablePageWithIdentifier:(NSString *)identifier;

-(FEPageContentView*)currentContentView;

//滚动到指定页
- (void)scrollToPage:(NSUInteger)pageIndex animated:(BOOL)animated;


/**
	重新加载数据
 */
- (void)reloadData;


@end
