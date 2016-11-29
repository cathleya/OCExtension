//
//  FEMenuButton.m
//  Pet
//
//  Created by Tom on 15/2/5.
//  Copyright (c) 2015年 fanying. All rights reserved.
//

#import "FEMenuButton.h"

@implementation FEMenuButton

{
    CGFloat _titleHeight;
    CGFloat _imageHeight;
    CGFloat _imageWidth;
}

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return self;
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
    CGFloat topOffset = 0;
    if (self.contentOffset <= 0)
    {
        topOffset = ceilf((size.height - _imageHeight - _titleHeight)*0.3);
    }
    else
    {
        topOffset = ceilf((size.height - _imageHeight - _titleHeight - self.contentOffset)*0.5);
    }
    
    return CGRectMake((size.width - _imageWidth)*0.5, topOffset, _imageWidth, _imageHeight);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGSize size = contentRect.size;
    CGFloat buttomOffset = 0;
    if (self.contentOffset <= 0)
    {
        buttomOffset = ceilf((size.height - _imageHeight - _titleHeight)*0.3);
    }
    else
    {
        buttomOffset = ceilf((size.height - _imageHeight - _titleHeight - self.contentOffset)*0.5);
    }
    
    return CGRectMake(0, size.height - buttomOffset - _titleHeight, size.width, _titleHeight);
}


@end
