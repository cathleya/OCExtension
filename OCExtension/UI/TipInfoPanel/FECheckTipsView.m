//
//  FECheckTipsView.m
//  Pet
//
//  Created by Tom on 15/5/5.
//  Copyright (c) 2015年 fanying. All rights reserved.
//

#import "FECheckTipsView.h"
#import "UIView+add.h"
#import <OCExtension/FEPrecompile.h>

#define  VIEW_HEIGHT 30

#define AnimateDuration 0.25


@interface FECheckTipsView()
@end
@implementation FECheckTipsView
{
    UILabel         *_tipsLabel;
    UIView          *_bgView;
}

+(instancetype)checkTipsView
{
    FECheckTipsView* tipsView = [[FECheckTipsView alloc] initWithFrame:CGRectZero];
    return tipsView;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT)];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        _bgView = [[UIView alloc] initWithFrame:self.bounds];
        _bgView.backgroundColor = RGBAHEX(0x000000, 0.7);
        [self addSubview:_bgView];
        
        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipsLabel.backgroundColor = [UIColor clearColor];
        _tipsLabel.font = [UIFont systemFontOfSize:13];
        _tipsLabel.textColor = RGBHEX(0xFFFFFF);
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.frame = self.bounds;
        [self addSubview:_tipsLabel];
    }
    
    return self;
}

-(void)showMessageTips:(NSString *)message inView:(UIView *)view
{
    
    _tipsLabel.text = message;
    
    if (self.superview == nil)
    {
        self.frame = CGRectMake(0, -self.height, self.width, self.height);
        [view addSubview:self];
        
        [UIView animateWithDuration:AnimateDuration animations:^{
            self.frame = CGRectMake(0, 0, self.width, self.height);
        } completion:^(BOOL finished) {
            
        }];
    }

}

-(void)hiddenTips
{
    [UIView animateWithDuration:AnimateDuration animations:^{
        self.frame = CGRectMake(0, -self.height, self.width, self.height);
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}


@end

