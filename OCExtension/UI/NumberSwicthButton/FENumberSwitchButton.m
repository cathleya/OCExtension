//
//  FENumberSwitchButton.m
//  Pet
//
//  Created by Tom on 15/4/15.
//  Copyright (c) 2015年 fanying. All rights reserved.
//

#import "FENumberSwitchButton.h"
#import "UIImage+add.h"
#import "UIView+add.h"
#import "UIButton+add.h"
#import "FEPrecompile.h"

#define VIEW_WIDTH 90
#define VIEW_HEIGHT 25
#define FONT_SIZE 11

#define VIEW_HEIGHT_2 23
#define VIEW_WIDTH_2  79

#define FONT_SIZE_2 12

@interface FENumberSwitchButton()
<
UITextFieldDelegate
>
@end

@implementation FENumberSwitchButton
{
    UIImageView     *_bgImageView;
    UIButton        *_leftButton;
    UIButton        *_rightButton;
    UITextField     *_valueField;
    
}

+(instancetype)numberSwitchButton
{
    FENumberSwitchButton* button = [[FENumberSwitchButton alloc] initWithFrame:CGRectZero];
    return button;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectZero];
    if (self)
    {
        _style = FENumberSwitchButtonStyleDefault;
        
        _maxValue = 99;
        _minValue = 1;
        _canEdit = YES;
        
        _bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _bgImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_bgImageView];
        
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton addTarget:self action:@selector(leftButtonTouched:)];
        [self addSubview:_leftButton];
        
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton addTarget:self action:@selector(rightButtonTouched:)];
        [self addSubview:_rightButton];


        _valueField = [[UITextField alloc] initWithFrame:CGRectZero];
        _valueField.delegate = self;
        _valueField.backgroundColor = [UIColor clearColor];
        _valueField.enabled = _canEdit;
        _valueField.textColor = [UIColor blackColor];//COLOR_507DAF;
        _valueField.textAlignment = NSTextAlignmentCenter;
        _valueField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _valueField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _valueField.keyboardType = UIKeyboardTypeNumberPad;
        [self addSubview:_valueField];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldTextDidChange:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:_valueField];

        self.numberValue = 1;
        
        [self updateViewWithStyle:_style];
        
    }
    
    return self;
}

- (void)setStyle:(FENumberSwitchButtonStyle)style
{
    _style = style;
    
    [self updateViewWithStyle:_style];
}

- (void)updateViewWithStyle:(FENumberSwitchButtonStyle)style
{
    CGFloat fontSize = 0;
    CGFloat viewWidth = 0;
    CGFloat viewHeight = 0;
    CGFloat offset = 0;
    if (style == FENumberSwitchButtonStyleDefault) {
        
        viewWidth = VIEW_WIDTH;
        viewHeight = VIEW_HEIGHT;
        
        _bgImageView.backgroundColor = [UIColor clearColor];
        _bgImageView.layer.cornerRadius = 0;
        _bgImageView.layer.masksToBounds = YES;
        
        UIImage* image = UIImageWithName(@"number_swith_del.png");
        UIImage* imageSel = UIImageWithName(@"number_swith_del_disable.png");
        UIImage* imageBG = UIImageWithName(@"number_swith_left.png");
        
        [_leftButton setImage:image forState:UIControlStateNormal];
        [_leftButton setImage:imageSel forState:UIControlStateDisabled];
        [_leftButton setBackgroundImage:imageBG forState:UIControlStateNormal];
        [_leftButton setBackgroundImage:imageBG forState:UIControlStateDisabled];
        
        image = UIImageWithName(@"number_swith_add.png");
        imageSel = UIImageWithName(@"number_swith_add_disable.png");
        imageBG = UIImageWithName(@"number_swith_right.png");
        
        [_rightButton setImage:image forState:UIControlStateNormal];
        [_rightButton setImage:imageSel forState:UIControlStateDisabled];
        [_rightButton setBackgroundImage:imageBG forState:UIControlStateNormal];
        [_rightButton setBackgroundImage:imageBG forState:UIControlStateDisabled];
        
        
        image = UIImageWithName(@"number_swith_middle.png");
        image = [image stretchableImage];
        _valueField.background = image;
        
        fontSize = FONT_SIZE;
        
    } else {
        
        viewWidth = VIEW_WIDTH_2;
        viewHeight = VIEW_HEIGHT_2;
        offset = 1;

        _bgImageView.backgroundColor = RGBHEX(0xD8F1EE);
        _bgImageView.layer.cornerRadius = MID(viewHeight);
        _bgImageView.layer.masksToBounds = YES;

        UIImage* image = UIImageWithName(@"number_swith_del_2.png");
        UIImage* imageSel = UIImageWithName(@"number_swith_del_disable_2.png");
        
        [_leftButton setImage:nil forState:UIControlStateNormal];
        [_leftButton setImage:nil forState:UIControlStateDisabled];
        [_leftButton setBackgroundImage:image forState:UIControlStateNormal];
        [_leftButton setBackgroundImage:imageSel forState:UIControlStateDisabled];
        
        image = UIImageWithName(@"number_swith_add_2.png");
        imageSel = UIImageWithName(@"number_swith_add_disable_2.png");
        
        [_rightButton setImage:nil forState:UIControlStateNormal];
        [_rightButton setImage:nil forState:UIControlStateDisabled];
        [_rightButton setBackgroundImage:image forState:UIControlStateNormal];
        [_rightButton setBackgroundImage:imageSel forState:UIControlStateDisabled];
        
        _valueField.background = nil;
        
        fontSize = FONT_SIZE_2;

    }
    
    _valueField.font = [UIFont systemFontOfSize:fontSize];

    [_leftButton sizeToFit];
    [_rightButton sizeToFit];
    
    self.size = CGSizeMake(viewWidth, viewHeight);
    _bgImageView.frame = self.bounds;
    
    _leftButton.origin = CGPointMake(offset
                                     , MID(self.height - _leftButton.height));
    
    _rightButton.origin = CGPointMake(self.width - _rightButton.width - offset
                                      , MID(self.height - _rightButton.height));
    
    _valueField.frame = CGRectMake(_leftButton.right
                                   , 0
                                   , self.width - _leftButton.width - _rightButton.width - offset * 2
                                   , self.height);
    
}

-(void)setMinValue:(NSInteger)minValue
{
    _minValue = minValue;
    
    _leftButton.enabled = (_numberValue > _minValue);
}

-(void)setMaxValue:(NSInteger)maxValue
{
    _maxValue = maxValue;
    
    _rightButton.enabled = (_numberValue < _maxValue);
}

- (void)setCanEdit:(BOOL)canEdit
{
    _canEdit = canEdit;
    _valueField.enabled = _canEdit;
}


-(void)leftButtonTouched:(UIButton*)sender
{
    NSInteger newValue = _numberValue - 1;
    if (newValue >= _minValue)
    {
        self.numberValue = newValue;
    }
}

-(void)rightButtonTouched:(UIButton*)sender
{
    NSInteger newValue = _numberValue + 1;
    if (newValue <= _maxValue)
    {
        self.numberValue = newValue;
    }
}

-(void)setNumberValue:(NSInteger)numberValue
{
    if (numberValue == _numberValue) {
        return;
    }
    
    _numberValue = numberValue;
    if (_numberValue == 0) {
        _valueField.text = @"";
    } else {
        _valueField.text = [NSString stringWithFormat:@"%ld", (long)_numberValue];
    }
    
    _leftButton.enabled = (_numberValue > _minValue);
    _rightButton.enabled = (_numberValue < _maxValue);
    
    [self sendActionsForControlEvents:UIControlEventValueChanged]; 
}


#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string length] == 0) {//删除
        return YES;
    }
    
    NSMutableString *valueString = [NSMutableString stringWithString:textField.text];
    [valueString replaceCharactersInRange:range withString:string];
    NSInteger value = [valueString integerValue];
    if (value >= _minValue && value <= _maxValue) {
        return YES;
    } else {
        return NO;
    }
}

- (void)textFieldTextDidChange:(NSNotification *)notif
{
    UITextField *textField = notif.object;
    if (textField == _valueField) {
        NSInteger value = [textField.text integerValue];
        self.numberValue = value;
    }
}

@end
