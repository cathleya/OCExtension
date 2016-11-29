//
//  FYImageView.h
//  Pet
//
//  Created by Tom on 15/3/25.
//  Copyright (c) 2015年 fanying. All rights reserved.
//

#import "FEImageView.h"

@interface DFImageView : FEImageView

@property (nonatomic, assign) CGFloat    cornerRadius;//设置圆角
@property (nonatomic, assign) BOOL       round;//设置圆形

@property (nonatomic, assign) BOOL       autoShowVipView;//是否自动判断显示VIP;
@property (nonatomic, assign) BOOL       showAuthV;//显示认证V，默认NO
@property (nonatomic, assign) BOOL       showExpertV;//显示专家V，默认NO

//根据view尺寸加载对应缩略图
-(void)loadThumbImageWithURL:(NSString *)url;
-(void)loadThumbImageWithURL:(NSString *)url defaultImage:(UIImage*)image;

//加载原图
-(void)loadImageWithURL:(NSString *)url;
-(void)loadImageWithURL:(NSString *)url defaultImage:(UIImage*)image;



@end
