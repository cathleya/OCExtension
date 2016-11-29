//
//  FEPageContentView.m
//  Pet
//
//  Created by Tom on 15/6/25.
//  Copyright (c) 2015年 fanying. All rights reserved.
//

#import "FEPageContentView.h"

@implementation FEPageContentView

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithFrame:frame])
    {
        _reuseIdentifier = [reuseIdentifier copy];
    }
    return self;
}

- (void)dealloc
{
}


@end
