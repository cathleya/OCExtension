

#import "FEStyleLabel.h"
#import <QuartzCore/QuartzCore.h>
#import "NSMutableAttributedString+NimbusAttributedLabel.h"

@implementation FEStyleLabel
{
    NSMutableAttributedString *_mutableAttributedString;
}

-(void)dealloc
{
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)setText:(NSString *)text
{
    [super setText:text];
    
    if ([text length] > 0)
    {
        NSMutableAttributedString *mutaString = [[NSMutableAttributedString alloc]initWithString:text];
        
        _mutableAttributedString = mutaString;
        
        [self setFont:self.font];
        [self setTextColor:self.textColor];
    }
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTextColor:(UIColor *)textColor {
    [super setTextColor:textColor];
    
    [_mutableAttributedString setTextColor:textColor];
    [self attributedTextDidChange];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTextColor:(UIColor *)textColor range:(NSRange)range
{
    [_mutableAttributedString setTextColor:textColor range:range];
    
    [self attributedTextDidChange];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    [_mutableAttributedString setFont:font];
    [self attributedTextDidChange];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setFont:(UIFont *)font range:(NSRange)range
{
    [_mutableAttributedString setFont:font range:range];
    
    [self attributedTextDidChange];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setUnderlineStyle:(CTUnderlineStyle)style
{
    [_mutableAttributedString setUnderlineStyle:style modifier:kCTUnderlinePatternSolid];
    
    [self attributedTextDidChange];
}




///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setUnderlineStyle:(CTUnderlineStyle)style modifier:(CTUnderlineStyleModifiers)modifier range:(NSRange)range
{
    [_mutableAttributedString setUnderlineStyle:style modifier:modifier range:range];
    
    [self attributedTextDidChange];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setStrokeWidth:(CGFloat)strokeWidth
{
    [_mutableAttributedString setStrokeWidth:strokeWidth];
    
    [self attributedTextDidChange];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setStrokeWidth:(CGFloat)width range:(NSRange)range
{
    [_mutableAttributedString setStrokeWidth:width range:range];
    
    [self attributedTextDidChange];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setStrokeColor:(UIColor *)strokeColor
{
    [_mutableAttributedString setStrokeColor:strokeColor];
    
    [self attributedTextDidChange];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setStrokeColor:(UIColor*)color range:(NSRange)range
{
    [_mutableAttributedString setStrokeColor:color range:range];
    
    [self attributedTextDidChange];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTextKern:(CGFloat)textKern
{
    [_mutableAttributedString setKern:textKern];
    
    [self attributedTextDidChange];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTextKern:(CGFloat)kern range:(NSRange)range
{
    [_mutableAttributedString setKern:kern range:range];
    
    [self attributedTextDidChange];
}

- (void)attributedTextDidChange
{
    self.attributedText = _mutableAttributedString;
    [self setNeedsDisplay];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    if (nil == _mutableAttributedString)
    {
        return CGSizeZero;
    }
    
    return [self constrainedToSize:size];
}

-(void)sizeToFit
{
    CGSize size = [self sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    self.frame = CGRectMake(self.left, self.top, size.width, size.height);
}

-(CGSize)constrainedToSize:(CGSize)size
{
    if (nil == _mutableAttributedString)
    {
        return CGSizeZero;
    }
    
    CFAttributedStringRef attributedStringRef = (__bridge CFAttributedStringRef)_mutableAttributedString;
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attributedStringRef);
    CFRange range = CFRangeMake(0, 0);
    
    if (self.numberOfLines > 0 && nil != framesetter)
    {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, CGRectMake(0, 0, size.width, size.height));
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
        CFArrayRef lines = CTFrameGetLines(frame);
        
        if (nil != lines && CFArrayGetCount(lines) > 0)
        {
            NSInteger lastVisibleLineIndex = MIN(self.numberOfLines, CFArrayGetCount(lines)) - 1;
            CTLineRef lastVisibleLine = CFArrayGetValueAtIndex(lines, lastVisibleLineIndex);
            
            CFRange rangeToLayout = CTLineGetStringRange(lastVisibleLine);
            range = CFRangeMake(0, rangeToLayout.location + rangeToLayout.length);
        }
        
        CFRelease(frame);
        CFRelease(path);
    }
    
    CFRange fitCFRange = CFRangeMake(0, 0);
    CGSize newSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, range, NULL, size, &fitCFRange);
    
    if (nil != framesetter)
    {
        CFRelease(framesetter);
        framesetter = nil;
    }
    
    return CGSizeMake(ceilf(newSize.width), ceilf(newSize.height));
}

@end
