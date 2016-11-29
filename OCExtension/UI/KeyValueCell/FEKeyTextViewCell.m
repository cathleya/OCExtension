//
//  FEKeyTextViewCell.m
//  Pet
//
//  Created by Tom on 15/4/10.
//  Copyright (c) 2015年 fanying. All rights reserved.
//

#import "FEKeyTextViewCell.h"
#import "UIView+add.h"
//#import "FEPrecompile.h"

#define LEFT_PADDING    15
#define LEFT_PADDING2O  20
#define RIGHT_PADDING   15
#define RIGHT_PADDING2O 20
#define PADDING         14
#define PADDING10       10

#define TOP_PADDING 10
#define BUTTOM_PADDING 10

#define TEXT_CONENT_OFFSET 5

@implementation FEKeyTextViewCell

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
        
        
        //解决中文输入 上下抖动 ，IOS7.0之后
        NSTextStorage* textStorage = [[NSTextStorage alloc] init];
        NSLayoutManager* layoutManager = [NSLayoutManager new];
        [textStorage addLayoutManager:layoutManager];
        NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:self.contentView.bounds.size];
        [layoutManager addTextContainer:textContainer];
        _textView = [[FETextView alloc] initWithFrame:CGRectZero  textContainer:textContainer];
        
        _textView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
        _textView.backgroundColor = [UIColor clearColor];
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.textColor = [UIColor blackColor];//COLOR_999999;
        _textView.delegate = self;
        _textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textView.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.contentView addSubview:_textView];
        
        _padding = PADDING;
        
    }
    
    return self;
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
    
    CGFloat textViewWidth = 0;
    CGFloat textViewHieght = 0;
    if (self.showRightArrowView)
    {
        textViewWidth = self.rightArrowView.left - PADDING10 - left;
    }
    else
    {
        textViewWidth = self.contentView.width - rightPadding - left;
    }
    
    textViewHieght = self.contentView.height - TOP_PADDING - BUTTOM_PADDING;
    
    _textView.frame = CGRectMake(left-TEXT_CONENT_OFFSET, TOP_PADDING, textViewWidth+TEXT_CONENT_OFFSET*2, textViewHieght);
    _textView.placeholder = _textView.placeholder;
}

#pragma mark - 移除表情 -


- (void)insertEmoji:(NSString *)text
{
    if (text == nil)
    {
        return;
    }
    
    UITextView *contentView = _textView;
    NSUInteger cursorLocation = _textView.selectedRange.location;
    cursorLocation = cursorLocation == NSNotFound ? 0 : cursorLocation;
    
    NSMutableString *str = [NSMutableString stringWithString:contentView.text];
    
    [str insertString:text atIndex:cursorLocation];
    
    contentView.text = str;
    
    [self restrictionTextViewLength:_textView];
    
    [self setCursorPosition:cursorLocation + text.length];
}

-(void)deleteEmoji
{
    NSUInteger cursorLocation = _textView.selectedRange.location;
    cursorLocation = cursorLocation == NSNotFound ? 0 : cursorLocation;
    if (cursorLocation == 0)
    {
        return;
    }
    
    if ([self deletePetEmoji:_textView.text location:cursorLocation]) {
        if ([self.delegate respondsToSelector:@selector(textViewDidChange:)])
        {
            [self.delegate textViewDidChange:self];
        }
        return;
    } else {
        [_textView deleteBackward];
    }
}

-(BOOL)deletePetEmoji:(NSString*)contentStr location:(NSInteger)iInputLocation
{
    if (iInputLocation < 1)
    {
        return NO;
    }
    
    if ([contentStr length] < iInputLocation)
    {
        iInputLocation = [contentStr length];
    }
    
    NSMutableString *strContent = [NSMutableString stringWithString:contentStr];
    
    
    NSRange range = [strContent rangeOfString:@"["
                                      options:NSBackwardsSearch
                                        range:NSMakeRange(0, iInputLocation)];
    
    NSString* subString = [strContent substringFromIndex:iInputLocation-1];
    
    NSRange range1 = [subString rangeOfString:@"]"];
    
    if (range.location != NSNotFound
        && range1.location != NSNotFound)
    {
        NSInteger iLen = range1.location-range.location+iInputLocation;
        if (iLen >= 3)//[V]
        {
            NSRange delRange = NSMakeRange(range.location, iLen);
            NSString* delText = [strContent substringWithRange:delRange];
//            if ([FYEmoji isPetEmoji:delText])
//            {
//                [strContent deleteCharactersInRange:delRange];
//                _textView.text = strContent;
//                iInputLocation = delRange.location;
//                [self setCursorPosition:iInputLocation];
//                return YES;
//            }
        }
    }
    
    
    return NO;
    
}


- (void)setCursorPosition:(NSInteger)position
{
    UITextView *contentView = _textView;
    if (position > [contentView.text length])
    {
        position = [contentView.text length];
    }
    else if(position < 0)
    {
        position = 0;
    }
    
    NSRange range = {position, 0};
    [contentView setSelectedRange:range];
    
    [contentView scrollRangeToVisible:contentView.selectedRange];
}

#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.length == 1
        && [text length] <= 0)
    {
        NSRange selectedRange = [textView selectedRange];
        return ![self deletePetEmoji:textView.text
                            location:(selectedRange.location+selectedRange.length)];
        return YES;
    }
    else
    {
        
        return YES;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(textViewDidBeginEditing:)])
    {
        [self.delegate textViewDidBeginEditing:self];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(textViewDidEndEditing:)])
    {
        [self.delegate textViewDidEndEditing:self];
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    UITextRange *markRange = textView.markedTextRange;
    NSInteger pos = [textView offsetFromPosition:markRange.start toPosition:markRange.end];
    if (pos==0) //代表英文字符已输入或者中文输入联想已选中联想词
    {
        [self restrictionTextViewLength:textView];
    }
}


- (void)restrictionTextViewLength:(UITextView *)textView
{
    //需要限制长度
    if (self.maxTextCount > 0)
    {
        NSUInteger cursorLocation = textView.selectedRange.location;
        
//        textView.text = [FEAppUtil checkContent:textView.text
//                                         byWord:YES
//                                         maxLen:self.maxTextCount
//                                         length:nil];
        
        if (cursorLocation < [textView.text length])
        {
            NSRange range = {cursorLocation, 0};
            [textView setSelectedRange:range];
        }
        else
        {
            NSRange range = {[textView.text length], 0};
            [textView scrollRangeToVisible:range];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(textViewDidChange:)])
    {
        [self.delegate textViewDidChange:self];
    }
}

@end



