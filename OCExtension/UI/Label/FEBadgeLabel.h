//
//  FEBadgeLabel.h
//  Pet
//
//  Created by Tom on 15/5/12.
//  Copyright (c) 2015年 fanying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FEBadgeLabel : UILabel

@property (nonatomic, assign) NSInteger value;// 设置提示数据
@property (nonatomic, copy)   NSString  *valueString;//或者设置提示内容

@property (nonatomic, assign) BOOL dotMode;//设置为圆点提示模式
@property (nonatomic, assign) BOOL showBorder;//是否显示边

@property (nonatomic, assign) NSInteger maxValue;//最大值， 默认999
@property (nonatomic, assign, readonly) CGSize badgeSize;

@end
