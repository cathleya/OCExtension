//
//  UIImage+QRCode.h
//  Pet
//
//  Created by Tom on 20/1/16.
//  Copyright © 2016年 Yourpet. All rights reserved.
//

#import <UIKit/UIKit.h>

//二维码
@interface UIImage (QRCode)

//生成二维码CIImage
+ (CIImage *)imageWithQRCodeText:(NSString *)codeText;

//生成特定size的UIimage
+ (UIImage *)imageFromCIImage:(CIImage *)image  withSize:(CGFloat)size;

//颜色填充
+ (UIImage *)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue;




@end
