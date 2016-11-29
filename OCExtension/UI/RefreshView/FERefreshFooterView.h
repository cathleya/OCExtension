//
//  FERefreshFooterView.h
//  FERefresh
//
//  Created by Tom on 15/6/2.
//  Copyright (c) 2015年 liyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FERefreshDefine.h"

@interface FERefreshFooterView : UIView

@property (nonatomic, assign) FEPullRefreshState state;
@property (copy, nonatomic) void (^refreshingBlock)();

/** 进入刷新状态 */
- (void)beginRefreshing;
/** 结束刷新状态 */
- (void)endRefreshing;
/** 是否正在刷新 */
- (BOOL)isRefreshing;

@end
