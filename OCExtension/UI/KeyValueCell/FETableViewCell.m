//
//  FETableViewCell.m
//  Pet
//
//  Created by Tom on 15/4/10.
//  Copyright (c) 2015年 fanying. All rights reserved.
//

#import "FETableViewCell.h"
#import "UIView+add.h"
#import "FEPrecompile.h"

#define LEFT_PADDING 15
#define RIGHT_PADDING 20
#define PADDING 5

//分割线
#define SEPERATE_LINE_HEIGHT       (1.0f/[[UIScreen mainScreen]scale])                //分割线
#define SEPERATE_LINE_COLOR        COLOR_CCCCCC


@implementation FETableViewCell
{
    
    UIView          *_topLineview;
    UIView          *_lineView;
    UIImageView     *_rightArrowView;
    UIImageView     *_selectedFlagView;
    
    UITableViewCellSelectionStyle            _highlightedStyle;
}

+ (CGFloat)cellHeightWithData:(id)data
{
    return 180;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _rightArrowViewPadding = RIGHT_PADDING;

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _highlightedStyle = UITableViewCellSelectionStyleGray;
        
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];

        _selectedBGView = [[UIView alloc] initWithFrame:CGRectZero];
        _selectedBGView.backgroundColor = RGBHEX(0xEEEEEE);
        [self.contentView addSubview:_selectedBGView];
        _selectedBGView.hidden = YES;
        
        self.showSeperateLine = YES;
        
//        [_selectedBGView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.contentView);
//        }];
        
        [self initSelf];
    }
    
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)initSelf
{
    
}

- (CGFloat)maxContentWidth
{
    CGFloat rightContentPadding = RIGHT_PADDING;
    if (_showRightArrowView) {
        rightContentPadding = (_rightArrowViewPadding + _rightArrowView.width);
    } else if (_showSelectedFlagView) {
        rightContentPadding = (_rightArrowViewPadding + _selectedFlagView.width);
    }
    
    return self.contentView.width - rightContentPadding;
}

- (void)setSelectionStyle:(UITableViewCellSelectionStyle)selectionStyle
{
    [super setSelectionStyle:UITableViewCellSelectionStyleNone];
    _highlightedStyle = selectionStyle;
}

- (UITableViewCellSelectionStyle)selectionStyle
{
    return _highlightedStyle;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    _selectedFlagView.hidden = !selected;

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if (_highlightedStyle == UITableViewCellSelectionStyleNone) {
        _selectedBGView.hidden = YES;
    } else {
        _selectedBGView.hidden = !highlighted;
    }
}

- (void)setRightArrowViewPadding:(CGFloat)rightArrowViewPadding
{
    _rightArrowViewPadding = rightArrowViewPadding;

//    [self setNeedsUpdateConstraints];
}

- (void)setShowRightArrowView:(BOOL)showRightArrowView
{
    _showRightArrowView = showRightArrowView;
    if (_showRightArrowView)
    {
        if (_rightArrowView == nil)
        {
            _rightArrowView = [[UIImageView alloc] initWithImage: UIImageWithName(@"common_arrow_right.png")];
            [_rightArrowView sizeToFit];
        }
        
        if (_rightArrowView.superview == nil)
        {
            [self.contentView addSubview:_rightArrowView];
        }
    }
    else
    {
        [_rightArrowView removeFromSuperview];
        _rightArrowView = nil;
    }
    
//    [self setNeedsUpdateConstraints];
    
}

- (void)setShowSelectedFlagView:(BOOL)showSelectedFlagView
{
    _showSelectedFlagView = showSelectedFlagView;
    if (_showSelectedFlagView)
    {
        if (!_selectedFlagView) {
            _selectedFlagView = [[UIImageView alloc] initWithImage: UIImageWithName(@"common_cell_selected_flag.png")];
            [_selectedFlagView sizeToFit];
        }
        
        if (_selectedFlagView.superview == nil) {
            [self.contentView addSubview:_selectedFlagView];
        }
    }
    else
    {
        if (_selectedFlagView.superview != nil) {
            [_selectedFlagView removeFromSuperview];
            _selectedFlagView = nil;
        }
    }
    
    [self setNeedsUpdateConstraints];
    
}

- (void)setShowTopSeperateLine:(BOOL)showTopSeperateLine
{
    _showTopSeperateLine = showTopSeperateLine;
    if (_showTopSeperateLine)
    {
        if (_topLineview == nil)
        {
            _topLineview = [[UIView alloc] initWithFrame:CGRectZero];
            _topLineview.backgroundColor = [UIColor whiteColor];//SEPERATE_LINE_COLOR;
        }
        
        if (_topLineview.superview == nil)
        {
            [self addSubview:_topLineview];
        }
    }
    else
    {
        [_topLineview removeFromSuperview];
    }
    
//    [self setNeedsUpdateConstraints];
}

- (void)setShowSeperateLine:(BOOL)showSeperateLine
{
    _showSeperateLine = showSeperateLine;
    if (_showSeperateLine)
    {
        if (_lineView == nil)
        {
            _lineView = [[UIView alloc] initWithFrame:CGRectZero];
            _lineView.backgroundColor = [UIColor whiteColor];//SEPERATE_LINE_COLOR;
        }
        
        if (_lineView.superview == nil)
        {
            [self addSubview:_lineView];
        }
    }
    else
    {
        [_lineView removeFromSuperview];
    }
    
//    [self setNeedsUpdateConstraints];
}

//- (void)updateConstraints
//{
//    if (_showSeperateLine)
//    {
//        CGFloat indentationWidth = [self seperateLineIndentationWidth];
//        [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(@(indentationWidth));
//            make.bottom.equalTo(self.mas_bottom).offset(-SEPERATE_LINE_HEIGHT);
//            make.height.equalTo(@(SEPERATE_LINE_HEIGHT));
//            make.width.equalTo(self.mas_width);
//        }];
//    }
//    
//    if (_showTopSeperateLine) {
//        [_topLineview mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.width.equalTo(self);
//            make.top.equalTo(self.mas_top);
//            make.height.equalTo(@(SEPERATE_LINE_HEIGHT));
//        }];
//    }
//    
//    if (_showRightArrowView) {
//        [_rightArrowView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.contentView).offset(-RIGHT_PADDING);
//            make.centerY.equalTo(self.contentView.mas_centerY);
//        }];
//    } else if (_showSelectedFlagView) {
//        [_selectedFlagView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.contentView).offset(-_rightArrowViewPadding);
//            make.centerY.equalTo(self.contentView.mas_centerY);
//        }];
//    }
//    
//    [super updateConstraints];
//}


- (void)layoutSubviews
{
    [super layoutSubviews];

    _selectedBGView.frame = self.contentView.bounds;
    
    //如果显示选择标识 则不现实右箭头
    if (_showSelectedFlagView)
    {
        _rightArrowView.hidden = YES;
        if (_selectedFlagView)
        {
            _selectedFlagView.frame = CGRectMake(self.contentView.width - RIGHT_PADDING - _selectedFlagView.width
                                               , (self.contentView.height - _selectedFlagView.height)*0.5
                                               , _selectedFlagView.width
                                               , _selectedFlagView.height);
        }
    }
    else
    {
        if (_rightArrowView)
        {
            _rightArrowView.hidden = NO;
            _rightArrowView.frame = CGRectMake(self.contentView.width - _rightArrowViewPadding - _rightArrowView.width
                                               , (self.contentView.height - _rightArrowView.height)*0.5
                                               , _rightArrowView.width
                                               , _rightArrowView.height);
        }
    }
    
    if (_showSeperateLine)
    {
        CGFloat indentationWidth = [self seperateLineIndentationWidth];
        _lineView.frame = CGRectMake(indentationWidth, self.height - SEPERATE_LINE_HEIGHT, self.width-indentationWidth, SEPERATE_LINE_HEIGHT);
    }
    
    if (_showTopSeperateLine)
    {
        _topLineview.frame = CGRectMake(0, 0, self.width, SEPERATE_LINE_HEIGHT);
    }
}

- (CGFloat)seperateLineIndentationWidth
{
    return 0;
}

//更新cell
- (void)updateCellWithData:(id)data
{
    
}

@end
