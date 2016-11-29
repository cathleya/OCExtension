//
//  FYImageView.m
//  Pet
//
//  Created by Tom on 15/3/25.
//  Copyright (c) 2015年 fanying. All rights reserved.
//

#import "DFImageView.h"
#import "UIView+add.h"
#import "UIImage+add.h"
#import "FEPrecompile.h"
#import <SDWebImage/UIImageView+WebCache.h>


#define VIP_VIEW_SCALE              0.4
#define VIP_VIEW_CENTER_SCALE       0.85
#define MAX_VIP_WIDTH               15
#define MIN_VIP_WIDTH               10

@implementation DFImageView
{
    UIImage     *_originalImage;
    BOOL         _needLayout;
    
    UIImageView *_authVImgView;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _autoShowVipView = YES;
    }
    
    return self;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        _autoShowVipView = YES;
    }
    
    return self;
}

-(void)loadImageWithURL:(NSString *)url
{
    NSString* defaultImageName = @"";
    [self loadImageWithURL:url defaultImage:UIImageWithName(defaultImageName)];
}

-(void)loadImageWithURL:(NSString *)url defaultImage:(UIImage*)image
{
    
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:image options:SDWebImageRetryFailed];
    
}

-(void)loadThumbImageWithURL:(NSString *)url
{
    NSString* thumbUrl = @"";
    NSString* defaultImageName = @"";
    [self sd_setImageWithURL:[NSURL URLWithString:thumbUrl] placeholderImage:UIImageWithName(defaultImageName) options:SDWebImageRetryFailed];
}

-(void)loadThumbImageWithURL:(NSString *)url defaultImage:(UIImage*)image
{
    NSString* thumbUrl = @"";
    [self sd_setImageWithURL:[NSURL URLWithString:thumbUrl] placeholderImage:image options:SDWebImageRetryFailed];
}

-(void)setImage:(UIImage *)image
{
    _originalImage = image;
    _needLayout = YES;
    [self setNeedsLayout];

}


- (void)setShowAuthV:(BOOL)showAuthV
{
    _showAuthV = showAuthV;
    if (_showAuthV)
    {
        if (_authVImgView == nil)
        {
            _authVImgView = [[UIImageView alloc] initWithImage:nil];
        }
        
        _authVImgView.image = UIImageWithName(@"auth_v_64.png");
        
        if (_authVImgView.superview == nil)
        {
            [self addSubview:_authVImgView];
        }
        
        _authVImgView.hidden = NO;
    }
    else
    {
        _authVImgView.hidden = YES;
    }
    
    if (self.selectedBackgroundView) {
        [self bringSubviewToFront:self.selectedBackgroundView];
    }
}

- (void)setShowExpertV:(BOOL)showExpertV
{
    _showExpertV = showExpertV;
    if (_showExpertV)
    {
        if (_authVImgView == nil)
        {
            _authVImgView = [[UIImageView alloc] initWithImage:nil];
        }
        
        _authVImgView.image = UIImageWithName(@"expert_v_64.png");
        if (_authVImgView.superview == nil)
        {
            [self addSubview:_authVImgView];
        }
        _authVImgView.hidden = NO;
    }
    else
    {
        _authVImgView.hidden = YES;
    }
    
    if (self.selectedBackgroundView) {
        [self bringSubviewToFront:self.selectedBackgroundView];
    }
}


-(UIImage*)roundImage:(UIImage*)image cornerRadius:(CGFloat)cornerRadius
{
    UIImage* newImage = nil;
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:self.bounds
                                cornerRadius:cornerRadius] addClip];
    // Draw your image
    [image drawInRect:self.bounds];
    
    // Get the image, here setting the UIImageView image
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(UIImage*)cropImage:(UIImage*)image
{
    if (self.bounds.size.width / self.bounds.size.height != image.size.width/image.size.height)
    {
        CGRect clipRect = [self getClipImageRect:image];
        return [UIImage clipImage:image rect:clipRect];
    }
    else
    {
        return image;
    }
}

- (CGRect)getClipImageRect:(UIImage *)image
{
    if (image == nil)
    {
        return CGRectZero;
    }
    
    CGFloat vw = self.bounds.size.width;
    CGFloat vh = self.bounds.size.height;
    CGFloat w = image.size.width;
    CGFloat h = image.size.height;
    
    CGFloat scale = w/vw < h/vh ? w/vw : h/vh;
    
    vw = vw * scale;
    vh = vh * scale;
    
    return CGRectMake((w - vw) / 2, (h - vh) / 2, vw, vh);

}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_needLayout)
    {
        _needLayout = NO;
        
        if (_showExpertV || _showAuthV) {
            
            CGFloat size = self.width * VIP_VIEW_SCALE;
            if (size > MAX_VIP_WIDTH) {
                size = MAX_VIP_WIDTH;
            } else if (size < MIN_VIP_WIDTH) {
                size = MIN_VIP_WIDTH;
            }
            
            CGFloat center = self.width * VIP_VIEW_CENTER_SCALE;
            _authVImgView.frame = CGRectMake(0, 0, size, size);
            _authVImgView.center = CGPointMake(center, center);
        }
        
        UIImage* newImage = nil;
        if (self.round)
        {
            newImage = [self roundImage:_originalImage cornerRadius:self.bounds.size.width*0.5];
            if (self.selectedBackgroundView) {
                self.selectedBackgroundView.layer.cornerRadius = MID(self.bounds.size.width);
            }
        }
        else if (self.cornerRadius > 0)
        {
            newImage = [self roundImage:[self cropImage:_originalImage] cornerRadius:self.cornerRadius];
            
            if (self.selectedBackgroundView) {
                self.selectedBackgroundView.layer.cornerRadius = self.cornerRadius;
            }
        }
        else
        {
            newImage = _originalImage;
            if (self.selectedBackgroundView) {
                self.selectedBackgroundView.layer.cornerRadius = self.cornerRadius;
            }
        }

        [super setImage:newImage];
        _originalImage = nil;
    }
}


@end
