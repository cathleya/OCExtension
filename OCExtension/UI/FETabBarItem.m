//
//  FETabBarItem.m
//  FEFramework
//
//  Created by Tom on 15/1/20.
//  Copyright (c) 2015年 liyy. All rights reserved.
//

#import "FETabBarItem.h"

#define CONTENT_OFFSET 5

@implementation FETabBarItem
{
    CGFloat _titleHeight;
    CGFloat _imageHeight;
    CGFloat _imageWidth;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        _imageTopOffset = CONTENT_OFFSET;
        _titleButtomOffset = CONTENT_OFFSET;
    }
    
    return self;
}


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        _imageTopOffset = CONTENT_OFFSET;
        _titleButtomOffset = CONTENT_OFFSET;
    }
    
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    //禁止 highlighted 状态
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
}


-(void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    
    CGSize size =  [title sizeWithFont:self.titleLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _titleHeight = ceilf(size.height);
}

-(void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:state];
    
    _imageWidth = image.size.width;
    _imageHeight = image.size.height;
}


- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGSize size = contentRect.size;
    
    return CGRectMake((size.width - _imageWidth)*0.5, _imageTopOffset, _imageWidth, _imageHeight);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGSize size = contentRect.size;
    return CGRectMake(0, size.height - _titleButtomOffset - _titleHeight, size.width, _titleHeight);
}


@end
