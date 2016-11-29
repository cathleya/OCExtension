//
//  FEKeyTextFieldCell.m
//  Pet
//
//  Created by Tom on 15/4/10.
//  Copyright (c) 2015年 fanying. All rights reserved.
//

#import "FEKeyTextFieldCell.h"
#import "FEPhoneNumberFormatTextField.h"
#import "UIView+add.h"
#import "UITextField+add.h"

#define LEFT_PADDING    15
#define LEFT_PADDING2O  20
#define RIGHT_PADDING   15
#define RIGHT_PADDING2O 20
#define PADDING         14
#define PADDING10       10


#define TEXT_FIELD_HEIGHT 40.0


@implementation FEKeyTextFieldCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.contentView.backgroundColor = [UIColor whiteColor];
        _keyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _keyLabel.backgroundColor = [UIColor clearColor];
        _keyLabel.font = [UIFont systemFontOfSize:16];
        _keyLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_keyLabel];
        
        _padding = PADDING;
        
    }
    
    return self;
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    // Initialization code
}

-(UITextField*)textField
{
    if (_textField == nil) {
        if (_enablePhoneNumberFormat) {
            _textField = [[FEPhoneNumberFormatTextField alloc] initWithFrame:CGRectZero];
            _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            _textField.keyboardType = UIKeyboardTypeNumberPad;

        } else {
            _textField = [UITextField textFieldWithFrame:CGRectZero];
            
        }
        
        _textField.backgroundColor = [UIColor clearColor];
        _textField.font = [UIFont systemFontOfSize:16];
        _textField.textColor = [UIColor blackColor];//COLOR_999999;
        _textField.delegate = self;
        _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textField.autocorrectionType = UITextAutocorrectionTypeNo;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.enablesReturnKeyAutomatically = YES;
        _textField.returnKeyType = UIReturnKeyDone;
        [self.contentView addSubview:_textField];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFiedlDidChange:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:_textField];
    }
    
    return _textField;
}

-(void)setPhoneNumber:(NSString *)phoneNumber
{
    UITextField* textField = [self textField];
    if ([textField isKindOfClass:[FEPhoneNumberFormatTextField class]]) {
        [(FEPhoneNumberFormatTextField*)textField setPhoneNumber:phoneNumber];
    }
}

-(NSString*)phoneNumber
{
    UITextField* textField = [self textField];
    if ([textField isKindOfClass:[FEPhoneNumberFormatTextField class]]) {
        return [(FEPhoneNumberFormatTextField*)textField phoneNumber];
    } else {
        return textField.text;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    UITextField* textField = [self textField];
    
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
    
    
    CGFloat fieldWith = 0;
    if (self.showRightArrowView)
    {
        fieldWith = self.rightArrowView.left - PADDING10 - left;
    }
    else
    {
        fieldWith = self.contentView.width - rightPadding - left;
    }
    
    textField.frame = CGRectMake(left, (self.contentView.height - TEXT_FIELD_HEIGHT)*0.5, fieldWith, TEXT_FIELD_HEIGHT);
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(textFieldDidBeginEditing:)])
    {
        [self.delegate textFieldDidBeginEditing:self];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(textFieldDidEndEditing:)])
    {
        [self.delegate textFieldDidEndEditing:self];
    }
}

-(void)textFiedlDidChange:(NSNotification *)notif
{
    UITextField* textField = [self textField];
    if ([notif object] == textField)
    {
        UITextRange *markRange = textField.markedTextRange;
        NSInteger pos = [textField offsetFromPosition:markRange.start toPosition:markRange.end];
        if (pos==0) //代表英文字符已输入或者中文输入联想已选中联想词
        {
            //需要限制长度
            if (self.maxTextCount > 0)
            {
                NSInteger len = 0;
                
                NSUInteger targetCursorPosition =
                [textField offsetFromPosition:textField.beginningOfDocument
                                   toPosition:textField.selectedTextRange.start];
                
                textField.text = textField.text;
                
                if (targetCursorPosition < [textField.text length]) {
                    UITextPosition *targetPosition = [textField positionFromPosition:[textField beginningOfDocument]
                                                                               offset:targetCursorPosition];
                    
                    [textField setSelectedTextRange: [textField textRangeFromPosition:targetPosition toPosition:targetPosition]];
                }

                
                NSLog(@"textFiedlDidChange: len:%zd/%zd", len, self.maxTextCount);

            }
            
            if ([self.delegate respondsToSelector:@selector(textFieldDidChange:)])
            {
                [self.delegate textFieldDidChange:self];
            }
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    BOOL flag = YES;
    if ([_delegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        [_delegate textFieldShouldReturn:self];
    }
    return flag;
}

@end
