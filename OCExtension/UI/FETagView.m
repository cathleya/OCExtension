//
//  FETagView.m
//  Pet
//
//  Created by Tom on 15/3/19.
//  Copyright (c) 2015年 fanying. All rights reserved.
//

#import "FETagView.h"
#import "UIView+add.h"
#import "FEPrecompile.h"

@implementation FETagView
{
    CGFloat _titleHeight;
    CGFloat _titleWidth;
    CGFloat _imageWidth;
    CGFloat _imageHeight;
}

+(instancetype)tagView
{
    FETagView* tagView = [FETagView buttonWithType:UIButtonTypeCustom];
    
    return tagView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _padding = 5;
        _imageStyle = FETagViewImageStyleLeft;
        
        self.backgroundColor = [UIColor clearColor];
        self.adjustsImageWhenHighlighted = NO;
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        [self setTitleColor:RGBHEX(0x999999) forState:UIControlStateNormal];
        self.clipsToBounds = YES;
    }
    
    return self;
}

-(void)setImage:(UIImage *)image forState:(UIControlState)state
{
    _imageHeight = image.size.height;
    _imageWidth = image.size.width;
    
    [super setImage:image forState:state];
}

-(void)setTitle:(NSString *)title forState:(UIControlState)state
{
    
    CGSize size =  [title sizeWithFont:self.titleLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _titleHeight = ceilf(size.height);
    _titleWidth = ceilf(size.width);
    
    [super setTitle:title forState:state];
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGRect rect = CGRectZero;
    switch (_imageStyle) {
            
        case FETagViewImageStyleLeft:
        {
            rect = CGRectMake(contentRect.size.width - _titleWidth, (contentRect.size.height - _titleHeight)*0.5, _titleWidth, _titleHeight);
            break;
        }
        case FETagViewImageStyleRight:
        {
            rect = CGRectMake(0, (contentRect.size.height - _titleHeight)*0.5, _titleWidth, _titleHeight);
            break;
        }
        case FETagViewImageStyleUp:
        {
            rect = CGRectMake(MID(contentRect.size.width - _titleWidth), contentRect.size.height - _titleHeight, _titleWidth, _titleHeight);
            break;
        }
        case FETagViewImageStyleDown:
        {
            rect = CGRectMake(MID(contentRect.size.width - _titleWidth), 0, _titleWidth, _titleHeight);
            break;
        }
        default:
        {
            break;
        }
    }
    
    return rect;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGRect rect = CGRectZero;
    switch (_imageStyle) {
            
        case FETagViewImageStyleLeft:
        {
            rect = CGRectMake(0, (contentRect.size.height - _imageHeight)*0.5, _imageWidth, _imageHeight);
            break;
        }
        case FETagViewImageStyleRight:
        {
            rect = CGRectMake(contentRect.size.width - _imageWidth, (contentRect.size.height - _imageHeight)*0.5, _imageWidth, _imageHeight);
            break;
        }
        case FETagViewImageStyleUp:
        {
            rect = CGRectMake(MID(contentRect.size.width - _imageWidth), 0, _imageWidth, _imageHeight);
            break;
        }
        case FETagViewImageStyleDown:
        {
            rect = CGRectMake(MID(contentRect.size.width - _imageWidth), contentRect.size.height - _imageHeight, _imageWidth, _imageHeight);
            break;
        }
        default:
        {
            break;
        }
    }
    
    return rect;
}


-(void)sizeToFit
{
    [self updateLayout];
}


-(void)updateLayout
{
    switch (_imageStyle) {
            
        case FETagViewImageStyleLeft:
        case FETagViewImageStyleRight:
        {
            self.size = CGSizeMake((_imageWidth + _titleWidth + _padding), MAX(_imageHeight, _titleHeight));
            break;
        }
        case FETagViewImageStyleUp:
        case FETagViewImageStyleDown:
        {
            self.size = CGSizeMake(MAX(_imageWidth, _titleWidth), (_imageHeight + _padding + _titleHeight));
            break;
        }
        default:
        {
            self.frame = CGRectZero;
            break;
        }
    }
}

@end
