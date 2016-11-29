//
//  FECircularProgressView.h
//  Pet
//
//  Created by ios on 16/5/10.
//  Copyright © 2016年 Yourpet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FECircularProgressView : UIView

@property (nonatomic, strong) UIColor *backColor; //背景色
@property (nonatomic, strong) UIColor *progressColor; //进度条颜色
@property (nonatomic, assign) CGFloat lineWidth;      //进度条线宽

@property (nonatomic, strong) UIColor *progressLabelColor;//进度文字颜色
@property (nonatomic, assign) CGFloat progressLabelFontSize;//进度文字大小

- (void)setProgress:(CGFloat)progress;

@end
