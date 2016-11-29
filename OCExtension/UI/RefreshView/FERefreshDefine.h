//
//  FERefreshDefine.h
//  FERefresh
//
//  Created by Tom on 15/6/2.
//  Copyright (c) 2015年 liyy. All rights reserved.
//

#ifndef FERefresh_FERefreshDefine_h
#define FERefresh_FERefreshDefine_h

typedef enum{
    FEPullRefreshPulling = 0,
    FEPullRefreshNormal,
    FEPullRefreshLoading,
    
} FEPullRefreshState;

static NSString *const FERefreshContentOffset = @"contentOffset";
static NSString *const FERefreshDragging = @"pan.state";
static NSString *const FERefreshContentSize = @"contentSize";



#define REFRESH_REGION_HEIGHT           60.0f
#define FOOTER_REFRESH_REGION_HEIGHT    45.0f

#endif
