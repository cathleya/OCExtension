//
//  FENumberSwitchButton.h
//  Pet
//
//  Created by Tom on 15/4/15.
//  Copyright (c) 2015年 fanying. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    FENumberSwitchButtonStyleDefault,        // 默认
    FENumberSwitchButtonStyleRounded,       // 按钮形状是圆形的
} FENumberSwitchButtonStyle;

@interface FENumberSwitchButton : UIControl
@property (nonatomic, assign) NSInteger minValue; //默认1
@property (nonatomic, assign) NSInteger maxValue;//默认99

@property (nonatomic, assign) NSInteger numberValue;

@property (nonatomic, assign) BOOL  canEdit;//是否能编辑

@property (nonatomic, assign) FENumberSwitchButtonStyle   style;//默认 FENumberSwitchButtonDefault

+(instancetype)numberSwitchButton;

@end
