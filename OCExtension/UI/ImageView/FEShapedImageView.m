

#import "FEShapedImageView.h"
#import "SDWebImageCompat.h"
#import "SDWebImageManager.h"
#import "objc/runtime.h"
#import "UIView+WebCacheOperation.h"
#import "FEPrecompile.h"

static char imageURLKey;

@interface FEShapedImageView()
{
    CALayer      *_contentLayer;
    CAShapeLayer *_maskLayer;
    CALayer      *_converLayer;
    
}
@end

@implementation FEShapedImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}


- (void)setup
{
    _maskLayer = [CAShapeLayer layer];
    _maskLayer.fillColor = [UIColor blackColor].CGColor;
    _maskLayer.strokeColor = [UIColor clearColor].CGColor;
    _maskLayer.frame = self.bounds;
    _maskLayer.contentsCenter = CGRectMake(0.5, 0.5, 0.1, 0.1);
    _maskLayer.contentsScale = [UIScreen mainScreen].scale;                 //非常关键设置自动拉伸的效果且不变形
    
    _contentLayer = [CALayer layer];
    _contentLayer.mask = _maskLayer;
    _contentLayer.frame = self.bounds;
//    _contentLayer.contentsCenter = CGRectMake(0.5, 0.5, 0.1, 0.1);
    _contentLayer.contentsScale = [UIScreen mainScreen].scale;
    _contentLayer.backgroundColor = RGBHEX(0xe7e7e7).CGColor;
    [self.layer addSublayer:_contentLayer];
    
    _converLayer = [CALayer layer];
    _converLayer.frame = self.bounds;
    _converLayer.contentsCenter = CGRectMake(0.5, 0.5, 0.1, 0.1);
    _converLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:_converLayer];

}

-(void)setFrame:(CGRect)frame
{
    CGSize oldFrame = self.frame.size;
    [super setFrame:frame];
    if (!CGSizeEqualToSize(frame.size, oldFrame))
    {
        _maskLayer.frame = self.bounds;
        _contentLayer.frame = self.bounds;
        _converLayer.frame = self.bounds;
    }
}



-(void)setMaskImage:(UIImage *)maskImage
{
    _maskImage = maskImage;
    _maskLayer.contents = (id)(_maskImage.CGImage);
    
}

-(void)setConverImage:(UIImage *)converImage
{
    _converImage = converImage;
    _converLayer.contents = (id)(_converImage.CGImage);
}

- (void)setImage:(UIImage *)image
{
    _contentLayer.contents = (id)image.CGImage;
}

-(void)showLoadingView
{
   
}

-(void)hideLoadingView
{
   
}

-(void)setProgress:(CGFloat)progress
{
   
}

- (void)setImageWithURL:(NSURL *)url {
    [self setImageUrl:url placeholderImage:nil options:0 progress:nil completed:nil];
}

- (void)setImageUrl:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    [self setImageUrl:url placeholderImage:placeholder options:0 progress:nil completed:nil];
}

- (void)setImageUrl:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDExternalCompletionBlock)completedBlock
{
    [self cancelCurrentImageLoad];
    objc_setAssociatedObject(self, &imageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (!(options & SDWebImageDelayPlaceholder)) {
        self.image = placeholder;
    }
    
    if (url)
    {
        __weak typeof(self) wself = self;
        
        [wself setProgress:0];
        [wself showLoadingView];
    
        
        
        id <SDWebImageOperation> operation =  [[[SDWebImageManager sharedManager] imageDownloader] downloadImageWithURL:url options:options progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            if (!wself) return;
            dispatch_main_sync_safe(^{
                if (!wself) return;
                CGFloat progress = (receivedSize * 1.0) / expectedSize;
                [wself setProgress:progress];
            });
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            if (!wself) return;
            dispatch_main_sync_safe(^{
                if (!wself) return;
                
                [self hideLoadingView];
                
                if (image) {
                    wself.image = image;
                    [wself setNeedsLayout];
                } else {
                    if ((options & SDWebImageDelayPlaceholder)) {
                        wself.image = placeholder;
                        [wself setNeedsLayout];
                    }
                }
                
                if (completedBlock && finished) {
                    completedBlock(image, error, nil,url);
                }
                
                
            });
        }];
        
        /*
        id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadImageWithURL:url options:options progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            if (!wself) return;
            dispatch_main_sync_safe(^{
                if (!wself) return;
                CGFloat progress = (receivedSize * 1.0) / expectedSize;
                [wself setProgress:progress];
            });
        }  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
        {
            if (!wself) return;
            dispatch_main_sync_safe(^{
                if (!wself) return;
                
                [self hideLoadingView];
                
                if (image) {
                    wself.image = image;
                    [wself setNeedsLayout];
                } else {
                    if ((options & SDWebImageDelayPlaceholder)) {
                        wself.image = placeholder;
                        [wself setNeedsLayout];
                    }
                }

                if (completedBlock && finished) {
                    completedBlock(image, error, cacheType, url);
                }
                

            });
        }];
         */
        [self sd_setImageLoadOperation:operation forKey:@"UIImageViewImageLoad"];
    }
    else
    {
        
        
        dispatch_main_async_safe(^{
            
            NSError *error = [NSError errorWithDomain:@"SDWebImageErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
            if (completedBlock) {
                completedBlock(nil, error, SDImageCacheTypeNone, url);
            }

        });
    }
}

- (void)cancelCurrentImageLoad {
    [self sd_cancelImageLoadOperationWithKey:@"UIImageViewImageLoad"];
}

- (void)cancelCurrentAnimationImagesLoad {
    [self sd_cancelImageLoadOperationWithKey:@"UIImageViewAnimationImages"];
}



@end
