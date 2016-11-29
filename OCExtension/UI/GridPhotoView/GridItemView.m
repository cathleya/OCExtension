//
//  GridItemView.m
//  Pet
//
//  Created by Tom on 15/4/21.
//  Copyright (c) 2015年 fanying. All rights reserved.
//

#import "GridItemView.h"
#import "FEPrecompile.h"

@implementation GridItemView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.cornerRadius = 8;
    }
    
    return self;
}

-(id)data
{
    return _photoItem;
}

-(void)setData:(id)data
{
    _photoItem = data;
    
    if ([_photoItem.imagePath length] > 0)
    {
        self.image = [UIImage imageWithContentsOfFile:_photoItem.imagePath];
    }
    else
    {
        [self loadThumbImageWithURL:_photoItem.imageUrl defaultImage:UIImageWithName(@"")];
    }
}

@end


#pragma mark -
@implementation GridPhotoItem

@end
