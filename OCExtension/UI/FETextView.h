//
//  FETextView.h
//  Pet
//
//  Created by Tom on 15/5/13.
//  Copyright (c) 2015年 fanying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FETextView : UITextView
@property (nonatomic, assign) BOOL disableStandardEditActions;//是否禁止复制 粘贴 选择 剪切操作
@property (nonatomic, copy)   NSString       *placeholder;
@property (nonatomic, strong) UIColor        *placeholderColor;
@property (nonatomic, assign) BOOL           placeholderAlignmentCenter;//默认不是
@end
