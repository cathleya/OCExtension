//
//  FEAutoScrollViewCell.m
//  Pet
//
//  Created by ios on 16/2/23.
//  Copyright © 2016年 Yourpet. All rights reserved.
//

#import "FEAutoScrollViewCell.h"

@implementation FEAutoScrollViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupImageView];
    }
    
    return self;
}


- (void)setupImageView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView = imageView;
    [self addSubview:imageView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _imageView.frame = self.bounds;
}

@end
