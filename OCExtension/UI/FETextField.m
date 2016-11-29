//
//  FETextField.m
//  Pet
//
//  Created by Tom on 15/5/6.
//  Copyright (c) 2015年 fanying. All rights reserved.
//

#import "FETextField.h"

@implementation FETextField

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }
    
    return self;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (self.disableStandardEditActions)
    {
        if (action == @selector(paste:)
            || action == @selector(select:)
            || action == @selector(selectAll:)
            || action == @selector(cut:)
            || action == @selector(copy:))
        {
            return NO;
        }
        else
        {
            return [super canPerformAction:action withSender:sender];
        }
    }
    else
    {
        return [super canPerformAction:action withSender:sender];
    }
}

@end
