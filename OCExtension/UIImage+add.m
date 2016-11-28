//
//  UIImage+add.m
//  
//
//  Created by FE on 13-11-18.
//
//

#import "UIImage+add.h"
#import <Accelerate/Accelerate.h>
#import <float.h>

#define THUMB_SUFFIX @"_thumb"
#define SQUARE_SUFFIX @"_square"


@implementation UIImage (add)


//改变图片颜色
- (UIImage *)imageWithChangeColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)stretchableImage
{
    CGFloat w = self.size.width*0.5;
    CGFloat h = self.size.height*0.5;
    UIImage* newImage = [self resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w)];
    return newImage;
}

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
                             hPer:(CGFloat)hPer
{
    UIImage *image = [UIImage imageNamed:imageName];
    if (image)
    {
        image = [image stretchableImageWithCapWidthFraction:wPer
                                           CapHeightFraction:hPer];
    }
    return image;
}


/**
 *  图片拉伸
 *
 *  @param widthFraction  总宽几分之几处
 *  @param heightFraction 总高几分之几处
 *
 *  @return 被拉伸的图片
 */
- (UIImage *)stretchableImageWithCapWidthFraction:(CGFloat)wPer
                                CapHeightFraction:(CGFloat)hPer
{
    return [self stretchableImageWithLeftCapWidth:self.size.width * wPer
                                     topCapHeight:self.size.height * hPer];
}

- (UIImage*)blurredImage
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:self.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:10.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return returnImage;
}


- (UIImage*)resize:(CGSize)size
{
    int W = size.width;
    int H = size.height;
    
    CGImageRef   imageRef   = self.CGImage;
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    
    CGContextRef bitmap = CGBitmapContextCreate(NULL, W, H, 8, 4*W, colorSpaceInfo, kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);
    
    if(self.imageOrientation == UIImageOrientationLeft || self.imageOrientation == UIImageOrientationRight){
        W = size.height;
        H = size.width;
    }
    
    if(self.imageOrientation == UIImageOrientationLeft || self.imageOrientation == UIImageOrientationLeftMirrored){
        CGContextRotateCTM (bitmap, M_PI/2);
        CGContextTranslateCTM (bitmap, 0, -H);
    }
    else if (self.imageOrientation == UIImageOrientationRight || self.imageOrientation == UIImageOrientationRightMirrored){
        CGContextRotateCTM (bitmap, -M_PI/2);
        CGContextTranslateCTM (bitmap, -W, 0);
    }
    else if (self.imageOrientation == UIImageOrientationUp || self.imageOrientation == UIImageOrientationUpMirrored){
        // Nothing
    }
    else if (self.imageOrientation == UIImageOrientationDown || self.imageOrientation == UIImageOrientationDownMirrored){
        CGContextTranslateCTM (bitmap, W, H);
        CGContextRotateCTM (bitmap, -M_PI);
    }
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, W, H), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    return newImage;
}

- (UIImage*)aspectFit:(CGSize)size
{
    CGFloat ratio = MIN(size.width/self.size.width, size.height/self.size.height);
    return [self resize:CGSizeMake(self.size.width*ratio, self.size.height*ratio)];
}

//- (UIImage *)crop:(CGRect)rect
//{
//    CGImageRef imageRef = self.CGImage;
//    CGImageRef newImageRef = CGImageCreateWithImageInRect(imageRef, rect);
//    
//    UIGraphicsBeginImageContext(rect.size);
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextDrawImage(context, rect, newImageRef);
//    
//    UIImage * image = [UIImage imageWithCGImage:newImageRef];
//    
//    UIGraphicsEndImageContext();
//    
//    CGImageRelease(newImageRef);
//    
//    return image;
//}

- (UIImage *)imageInRect:(CGRect)rect
{
    return [self crop:rect];
}
//裁剪成正方形
- (UIImage *)imageInSquare
{
    //在此做裁剪
    UIImage * oImg = self;
    CGSize imgSize = self.size;
    if (imgSize.height > imgSize.width) {
        CGRect cutRect = (CGRect){0,ceil((imgSize.height - imgSize.width) * 0.5),imgSize.width,imgSize.width};
        oImg = [self crop:cutRect];
    }else if (imgSize.height < imgSize.width){
        CGRect cutRect = (CGRect){ceil((imgSize.width - imgSize.height) * 0.5),0,imgSize.height,imgSize.height};
        oImg = [self crop:cutRect];
    }
    return oImg;
}

- (UIColor *)patternColor
{
    return [UIColor colorWithPatternImage:self];
}


+ (UIImage *)merge:(NSArray *)images
{
    UIImage * image = nil;
    
    for ( UIImage * otherImage in images )
    {
        if ( nil == image )
        {
            image = otherImage;
        }
        else
        {
            image = [image merge:otherImage];
        }
    }
    
    return image;
}

- (UIImage *)merge:(UIImage *)image
{
    CGSize canvasSize;
    canvasSize.width = fmaxf( self.size.width, image.size.width );
    canvasSize.height = fmaxf( self.size.height, image.size.height );
    
    //	UIGraphicsBeginImageContext( canvasSize );
    UIGraphicsBeginImageContextWithOptions( canvasSize, NO, self.scale );
    
    CGPoint offset1;
    offset1.x = (canvasSize.width - self.size.width) / 2.0f;
    offset1.y = (canvasSize.height - self.size.height) / 2.0f;
    
    CGPoint offset2;
    offset2.x = (canvasSize.width - image.size.width) / 2.0f;
    offset2.y = (canvasSize.height - image.size.height) / 2.0f;
    
    [self drawAtPoint:offset1 blendMode:kCGBlendModeNormal alpha:1.0f];
    [image drawAtPoint:offset2 blendMode:kCGBlendModeNormal alpha:1.0f];
    
    UIImage * result = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return result;
}

- (UIImage *)aspectFitToSize:(CGSize)size
{
    CGFloat w = self.size.width;
    CGFloat h = self.size.height;
    
    UIImage *resultImg = nil;;
    CGFloat b = (CGFloat)size.width/w < (CGFloat)size.height/h ? (CGFloat)size.width/w : (CGFloat)size.height/h;
    CGSize itemSize = CGSizeMake(b*w, b*h);
    UIGraphicsBeginImageContext(itemSize);
    CGRect imageRect = CGRectMake(0, 0, b*w, b*h);
    [self drawInRect:imageRect];
    resultImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImg;
}

- (UIImage *)fixOrientation
{
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+(UIImage*)imageFromView:(UIView*)view
{
    if (view == nil)
    {
        return nil;
    }
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

+(UIImage*)imageFromColor:(UIColor*)color cornerRadius:(CGFloat)radius
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    view.backgroundColor = color;
    if (radius > 0)
    {
        view.layer.cornerRadius = radius;
        view.clipsToBounds = YES;
    }
    
    return [UIImage imageFromView:view];
}

+ (UIImage *)imageWithColor:(UIColor *)color rectSize:(CGRect)imageSize {
    CGRect rect = imageSize;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark- Clipping

- (UIImage*)crop:(CGRect)rect
{
    CGPoint origin = CGPointMake(-rect.origin.x, -rect.origin.y);
    
    UIImage *img = nil;
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, self.scale);
    [self drawAtPoint:origin];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

+ (UIImage *)clipImage:(UIImage *)image rect:(CGRect)rect
{
    if (image == nil)
    {
        return nil;
    }
    
    switch (image.imageOrientation)
    {
        case UIImageOrientationLeft:
            rect = CGRectMake(rect.origin.y,
                              rect.origin.x,
                              rect.size.height,
                              rect.size.width);
            break;
        case UIImageOrientationRight:
            rect = CGRectMake(rect.origin.y,
                              image.size.width - rect.size.width - rect.origin.x,
                              rect.size.height,
                              rect.size.width);
            break;
        case UIImageOrientationDown:
            rect = CGRectMake(image.size.width - rect.size.width - rect.origin.x,
                              image.size.height - rect.size.height - rect.origin.y,
                              rect.size.width,
                              rect.size.height);
            break;
        default:
            break;
    }
    
    CGImageRef clipImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    CGRect clipBounds = CGRectMake(0, 0, CGImageGetWidth(clipImageRef), CGImageGetHeight(clipImageRef));
    
    UIGraphicsBeginImageContext(clipBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, clipBounds, clipImageRef);
    UIGraphicsEndImageContext();
    
    
    UIImage* clipImage = [UIImage imageWithCGImage:clipImageRef
                                             scale:image.scale
                                       orientation:image.imageOrientation];
    CGImageRelease(clipImageRef);
    
    return clipImage;
}


//保存照片到临时目录
+(NSString *)saveJpegImageToTmpDirectory:(UIImage *)image
{
    NSString *tmpPath=[NSString stringWithFormat:@"%@/tmp/upload/",NSHomeDirectory()];
    if (![[NSFileManager defaultManager] fileExistsAtPath:tmpPath] ) {
        [[NSFileManager defaultManager] createDirectoryAtPath:tmpPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return [UIImage saveImage:image toPath:tmpPath];
}

+(NSString *)saveImage:(UIImage*)image toPath:(NSString*)path
{
    return [UIImage saveImage:image toPath:path needThumb:NO];
}

+(NSString *)saveImage:(UIImage*)image toPath:(NSString*)path needThumb:(BOOL)needThumb
{
    NSData *imgData = UIImageJPEGRepresentation(image, 0.8);
        //生成唯一文件名
    CFUUIDRef uuidObj=CFUUIDCreate(nil);
    NSString *uuidStr=(NSString *)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    
    NSString *tmpFileName = [path stringByAppendingPathComponent:uuidStr];
    
    BOOL rtn = [[NSFileManager defaultManager] createFileAtPath:tmpFileName contents:imgData attributes:nil];
    if (!rtn) {
        return nil;
    }
    
    if (needThumb)
    {
        UIImage* thumbImage = [image aspectFitToSize:CGSizeMake(480, 480)];
        NSData *thumbData = UIImageJPEGRepresentation(thumbImage, 1);
    
        NSString* thumbPath = [tmpFileName stringByAppendingString:THUMB_SUFFIX];
        [[NSFileManager defaultManager] createFileAtPath:thumbPath contents:thumbData attributes:nil];
    }
    
    return tmpFileName;
}

+(NSString*)localThumbImagePath:(NSString*)imagePath
{
    return [imagePath stringByAppendingString:THUMB_SUFFIX];
}



- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage
{
    // Check pre-conditions.
    if (self.size.width < 1 || self.size.height < 1) {
        NSLog (@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", self.size.width, self.size.height, self);
        return nil;
    }
    if (!self.CGImage) {
        NSLog (@"*** error: image must be backed by a CGImage: %@", self);
        return nil;
    }
    if (maskImage && !maskImage.CGImage) {
        NSLog (@"*** error: maskImage must be backed by a CGImage: %@", maskImage);
        return nil;
    }
    
    CGRect imageRect = { CGPointZero, self.size };
    UIImage *effectImage = self;
    
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
    if (hasBlur || hasSaturationChange) {
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext, 1.0, -1.0);
        CGContextTranslateCTM(effectInContext, 0, -self.size.height);
        CGContextDrawImage(effectInContext, imageRect, self.CGImage);
        
        vImage_Buffer effectInBuffer;
        effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
        
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
        
        if (hasBlur) {
            // A description of how to compute the box kernel width from the Gaussian
            // radius (aka standard deviation) appears in the SVG spec:
            // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
            //
            // For larger values of 's' (s >= 2.0), an approximation can be used: Three
            // successive box-blurs build a piece-wise quadratic convolution kernel, which
            // approximates the Gaussian kernel to within roughly 3%.
            //
            // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
            //
            // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
            //
            CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
            NSUInteger radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
            if (radius % 2 != 1) {
                radius += 1; // force radius to be odd so that the three box-blur methodology works.
            }
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
        }
        BOOL effectImageBuffersAreSwapped = NO;
        if (hasSaturationChange) {
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[] = {
                0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                0,                    0,                    0,  1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
            }
            if (hasBlur) {
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                effectImageBuffersAreSwapped = YES;
            }
            else {
                vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        if (!effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if (effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    // Set up output context.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -self.size.height);
    
    // Draw base image.
    CGContextDrawImage(outputContext, imageRect, self.CGImage);
    
    // Draw effect image.
    if (hasBlur) {
        CGContextSaveGState(outputContext);
        if (maskImage) {
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }
    
    // Add in color tint.
    if (tintColor) {
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }
    
    // Output image is ready.
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}

+ (UIImage *)getAccelerateBlurWithImage:(UIImage *)image blurLevel:(CGFloat)blur
{
    image = [UIImage imageWithData:UIImageJPEGRepresentation(image, 0.4)];
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 200);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    //create vImage_Buffer with data from CGImageRef
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //create vImage_Buffer for output
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    // Create a third buffer for intermediate processing
    void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    vImage_Buffer outBuffer2;
    outBuffer2.data = pixelBuffer2;
    outBuffer2.width = CGImageGetWidth(img);
    outBuffer2.height = CGImageGetHeight(img);
    outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
    
    //perform convolution
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    free(pixelBuffer2);
    CFRelease(inBitmapData);
    CGImageRelease(imageRef);
    
    return returnImage;
    
}

@end
