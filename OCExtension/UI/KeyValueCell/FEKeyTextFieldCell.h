//
//  FEKeyTextFieldCell.h
//  Pet
//
//  Created by Tom on 15/4/10.
//  Copyright (c) 2015年 fanying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FETableViewCell.h"

@class FEKeyTextFieldCell;

@protocol FEKeyTextFieldCellDelegate <NSObject>
@optional
-(void)textFieldDidBeginEditing:(FEKeyTextFieldCell *)textFieldCell;
-(void)textFieldDidEndEditing:(FEKeyTextFieldCell *)textFieldCell;
-(void)textFieldDidChange:(FEKeyTextFieldCell *)textFieldCell;
-(BOOL)textFieldShouldReturn:(FEKeyTextFieldCell *)textFieldCell;
@end

@interface FEKeyTextFieldCell : FETableViewCell
<
UITextFieldDelegate
>

@property (nonatomic, strong)   UILabel         * keyLabel;
@property (nonatomic, strong)   UITextField     * textField;
@property (nonatomic, assign)   CGFloat         padding;//默认14 //key 和 value 的间距
@property (nonatomic, assign)   CGFloat         keyLabelWidth;//默认 0系统计算，如果设置了则按设置的值

@property (nonatomic, assign)   NSInteger       maxTextCount;


@property (nonatomic, assign)   BOOL            enablePhoneNumberFormat;// 是否按手机号格式显示， 默认NO
@property (nonatomic, copy)     NSString        *phoneNumber; //手机号码


@property (nonatomic, weak) id<FEKeyTextFieldCellDelegate> delegate;


@end
