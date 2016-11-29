//
//  FEPhoneNumberFormatTextField.h
//  Pet
//
//  Created by Tom on 15/05/06.
//  Copyright (c) 2015年 fanying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FETextField.h"

//输入时 格式化手机号
@interface FEPhoneNumberFormatTextField : FETextField

@property (nonatomic, copy) NSString* phoneNumber; //手机号

@end
