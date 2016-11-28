//
//  UIImage+add.h
//  
//
//  Created by FE on 13-11-18.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (add)

//改变图片颜色
- (UIImage *)imageWithChangeColor:(UIColor *)color;

- (UIImage *)stretchableImage;
/**
 *  图片拉伸
 *
 *  @ param widthFraction  总宽几分之几处
 *  @ param heightFraction 总高几分之几处
 *
 *  @return 被拉伸的图片
 */
- (UIImage *)stretchableImageWithCapWidthFraction:(CGFloat)wPer
                                CapHeightFraction:(CGFloat)hPer;
/**
 *  图片拉伸
 *
 *  @param imageName  图片名称
 *  @param wPer  总宽几分之几处
 *  @param hPer  总高几分之几处
 *
 *  @return 被拉伸的图片
 */
+ (UIImage *)stretchableImageName:(NSString *)imageName
                             wPer:(CGFloat)wPer
                             hPer:(CGFloat)hPer;

- (UIImage*)blurredImage;

- (UIImage *)resize:(CGSize)size;
- (UIImage*)aspectFit:(CGSize)size;
- (UIImage*)crop:(CGRect)rect;

//裁剪
+ (UIImage *)clipImage:(UIImage *)image rect:(CGRect)rect;
- (UIImage *)imageInRect:(CGRect)rect;
//裁剪成正方形
- (UIImage *)imageInSquare;

//等比缩放
- (UIImage *)aspectFitToSize:(CGSize)size;

//合并
+ (UIImage *)merge:(NSArray *)images;
- (UIImage *)merge:(UIImage *)image;
- (UIImage *)fixOrientation;

//view 转换成image
+(UIImage*)imageFromView:(UIView*)view;
+(UIImage*)imageFromColor:(UIColor*)color cornerRadius:(CGFloat)radius;
+(UIImage *)imageWithColor:(UIColor *)color rectSize:(CGRect)imageSize;

+(NSString *)saveJpegImageToTmpDirectory:(UIImage *)image;
+(NSString *)saveImage:(UIImage*)image toPath:(NSString*)path;
+(NSString *)saveImage:(UIImage*)image toPath:(NSString*)path needThumb:(BOOL)needThumb;
//获取本地文件缩略图路径
+(NSString*)localThumbImagePath:(NSString*)imagePath;


//图片模糊
- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius
                       tintColor:(UIColor *)tintColor
           saturationDeltaFactor:(CGFloat)saturationDeltaFactor
                       maskImage:(UIImage *)maskImage;

+ (UIImage *)getAccelerateBlurWithImage:(UIImage *)image blurLevel:(CGFloat)blur;

@end
