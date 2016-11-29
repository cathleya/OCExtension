//
//  FERefreshHeaderView.h
//  Pet
//
//  Created by Tom on 15/4/9.
//  Copyright (c) 2015年 fanying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "FERefreshDefine.h"



@interface FERefreshHeaderView : UIView {
	
}

@property (nonatomic, assign) FEPullRefreshState state;
@property (nonatomic, readonly) UILabel *finshedLabel;
@property (nonatomic, readonly) UIImageView *finshedImageView;

@property (copy, nonatomic) void (^refreshingBlock)();
@property (nonatomic, assign) BOOL  showRefreshFinishedStatus;//显示刷新完成状态

/** 进入刷新状态 */
- (void)beginRefreshing;
/** 结束刷新状态 */
- (void)endRefreshing;
/** 是否正在刷新 */
- (BOOL)isRefreshing;

@end
