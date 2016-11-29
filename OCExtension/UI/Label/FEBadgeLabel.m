//
//  FEBadgeLabel.m
//  Pet
//
//  Created by Tom on 15/5/12.
//  Copyright (c) 2015年 fanying. All rights reserved.
//

#import "FEBadgeLabel.h"
#import "UILabel+add.h"
#import "UIView+add.h"
#import "FEPrecompile.h"

#define FONT_SIZE          12
#define FONT_COLOR         RGBHEX(0xFFFFFF)
#define BG_COLOR           COLOR_MAIN

#define VIEW_HEIGHT        18
#define BADGE_WIDTH_OFFSET 10

#define MAX_BADGE_VALUE    99


@implementation FEBadgeLabel
{
    UIImageView     *_dotImageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.textColor = FONT_COLOR;
        self.font = [UIFont systemFontOfSize:FONT_SIZE];
        self.backgroundColor = [UIColor whiteColor];//BG_COLOR;
        self.maxValue = MAX_BADGE_VALUE;
        self.textAlignment = NSTextAlignmentCenter;
        self.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        self.hidden = YES;
    }
    return self;
}

- (UIImageView*)dotImageView
{
    if (_dotImageView == nil) {
        _dotImageView = [[UIImageView alloc] initWithImage:UIImageWithName(@"common_badge_dot.png")];
    }
    return _dotImageView;
}

- (void)setValue:(NSInteger)value
{
    _value = value;
    if (value > MAX_BADGE_VALUE)
    {
        [self setValueString:[NSString stringWithFormat:@"%d+", MAX_BADGE_VALUE]];
    }
    else if (value <= 0)
    {
        [self setValueString:nil];
    }
    else
    {
        [self setValueString:[NSString stringWithFormat:@"%zd", value]];
    }
}

-(void)setValueString:(NSString *)valueString
{
    _dotMode = NO;
    [_dotImageView removeFromSuperview];
    _valueString = valueString;
    if ([_valueString length] <= 0)
    {
        self.hidden = YES;
    }
    else
    {
        self.hidden = NO;
        self.backgroundColor = [UIColor whiteColor];//BG_COLOR;

        self.text = _valueString;
        
        [self sizeToFit];
        
        CGFloat width = self.width;
        if (width > VIEW_HEIGHT)
        {
            width += BADGE_WIDTH_OFFSET;
        }
        else
        {
            width = VIEW_HEIGHT;
        }
        
        _badgeSize = CGSizeMake(ceil(width), VIEW_HEIGHT);
        
        self.size = _badgeSize;
        self.layer.cornerRadius = ceil(_badgeSize.height * 0.5);
        self.layer.masksToBounds = YES;
        
        if (self.showBorder) {
            self.layer.borderColor = [UIColor whiteColor].CGColor;
            self.layer.borderWidth = 2;
        }
    }
}

-(void)setDotMode:(BOOL)dotMode
{
    _dotMode = dotMode;
    if (_dotMode) {
        self.hidden = NO;
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView* dotImageView = [self dotImageView];
        if (dotImageView.superview == nil) {
            [self addSubview:dotImageView];
        }
        self.text = nil;
        _badgeSize = dotImageView.size;
        
        [self sizeToFit];
        self.size = _badgeSize;
        self.layer.cornerRadius = 0;
        self.layer.masksToBounds = NO;
        self.layer.borderWidth = 0;

    } else {
        [self setValueString:_valueString];
    }
}


@end
