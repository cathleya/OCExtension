//
//  FEKeyValueCell.m
//  Pet
//
//  Created by Tom on 15/4/10.
//  Copyright (c) 2015年 fanying. All rights reserved.
//

#import "FEKeyValueCell.h"
#import "UIView+add.h"

#define LEFT_PADDING    15
#define LEFT_PADDING2O  20
#define RIGHT_PADDING   15
#define RIGHT_PADDING2O 20
#define PADDING         14
#define PADDING10       10
#define VALUE_LABEL_HEIGHT 30


@implementation FEKeyValueCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        _keyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _keyLabel.backgroundColor = [UIColor clearColor];
        _keyLabel.font = [UIFont systemFontOfSize:16];
        _keyLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_keyLabel];
        
        _valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _valueLabel.backgroundColor = [UIColor clearColor];
        _valueLabel.font = [UIFont systemFontOfSize:16];
        _valueLabel.textColor = [UIColor blackColor];//COLOR_999999;
        [self.contentView addSubview:_valueLabel];
        _padding = PADDING;
        
        
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(CGFloat)valueLabelLeft
{
    CGFloat left = LEFT_PADDING;
    if ([_keyLabel.text length] > 0)
    {
        left = LEFT_PADDING2O;
        [_keyLabel sizeToFit];
        left = left + _keyLabel.width + _padding;
    }
    
    return left;
}



-(void)layoutSubviews
{
    [super layoutSubviews];
    

    CGFloat leftPadding = LEFT_PADDING2O;
    CGFloat rightPadding = RIGHT_PADDING2O;
    
    CGFloat left = 0;
    if ([_keyLabel.text length] > 0)
    {
        leftPadding = LEFT_PADDING2O;
        _keyLabel.hidden = NO;
        [_keyLabel sizeToFit];
        
        CGFloat keyLabelWidth = _keyLabel.width;
        if (self.keyLabelWidth > 0)
        {
            keyLabelWidth = self.keyLabelWidth;
        }

        
        _keyLabel.frame = CGRectMake(leftPadding, (self.contentView.height - _keyLabel.height)*0.5, keyLabelWidth, _keyLabel.height);
        
        left = LEFT_PADDING2O + _keyLabel.width + _padding;
        
    }
    else
    {
        leftPadding = LEFT_PADDING;
        rightPadding = RIGHT_PADDING;
        left = leftPadding;
        _keyLabel.hidden = YES;
    }
    
    CGFloat valueWith = 0;
    if (self.showRightArrowView)
    {        
        valueWith = self.rightArrowView.left - PADDING10 - left;
    }
    else
    {
        valueWith = self.contentView.width - rightPadding - left;
    }
    
    [_valueLabel sizeToFit];
    _valueLabel.frame = CGRectMake(left, (self.contentView.height - VALUE_LABEL_HEIGHT)*0.5, valueWith, VALUE_LABEL_HEIGHT);
}



@end
