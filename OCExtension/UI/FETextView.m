//
//  FETextView.m
//  Pet
//
//  Created by Tom on 15/5/13.
//  Copyright (c) 2015年 fanying. All rights reserved.
//

#import "FETextView.h"

@implementation FETextView
{
    UILabel     *_placeHolderLabel;
}

-(UILabel*)placeHolderLabel
{
    if (_placeHolderLabel == nil )
    {
        UIEdgeInsets edgeInsets = self.textContainerInset;
        _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, edgeInsets.left, edgeInsets.top)];
        _placeHolderLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
        _placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _placeHolderLabel.numberOfLines = 0;
        _placeHolderLabel.font = self.font;
        _placeHolderLabel.backgroundColor = [UIColor clearColor];
        _placeHolderLabel.userInteractionEnabled = NO;
        
        if (_placeholderColor) {
            _placeHolderLabel.textColor = _placeholderColor;
        } else {
            _placeHolderLabel.textColor = [UIColor colorWithWhite:0.7 alpha:1.0];
        }
        
        _placeHolderLabel.alpha = 0;
        [self addSubview:_placeHolderLabel];
    }
    
    return _placeHolderLabel;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (_placeholder) {
        [self refreshPlaceholder];
    }
}

-(void)refreshPlaceholder
{
    if([[self text] length])
    {
        [_placeHolderLabel setAlpha:0];
    }
    else
    {
        UILabel* placeHolderLabel = [self placeHolderLabel];
        if (!_placeholderAlignmentCenter) {
            //修改不能左上对齐的问题
            //begin--liyy
            UIEdgeInsets edgeInsets = self.textContainerInset;
            CGRect frame = CGRectInset(self.bounds, edgeInsets.left + 5, edgeInsets.top);
            frame.size = [placeHolderLabel sizeThatFits:frame.size];
            placeHolderLabel.frame = frame;
            //end
        }
        else
        {
            CGRect frame = self.bounds;
            frame.size = [placeHolderLabel sizeThatFits:frame.size];
            frame.origin.y = (self.bounds.size.height - frame.size.height) * 0.5;
            placeHolderLabel.frame = frame;
            
        }

        [placeHolderLabel setAlpha:1];
    }
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    if (_placeholder) {
        [self refreshPlaceholder];
    }
}

-(void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    if (_placeholder) {
        UILabel* placeHolderLabel = [self placeHolderLabel];
        placeHolderLabel.font = self.font;
    }
}

-(void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    UILabel* placeHolderLabel = [self placeHolderLabel];
    placeHolderLabel.text = _placeholder;

    [self refreshPlaceholder];
}

-(void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    
    if (_placeholder) {
        UILabel* placeHolderLabel = [self placeHolderLabel];
        placeHolderLabel.textColor = _placeholderColor;
    }
}

//When any text changes on textField, the delegate getter is called. At this time we refresh the textView's placeholder
-(id<UITextViewDelegate>)delegate
{
    if (_placeholder) {
        [self refreshPlaceholder];
    }
    
    return [super delegate];
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
