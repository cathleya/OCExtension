

#import "FEImageView.h"
#import "FEPrecompile.h"

@implementation FEImageView
{
    UIButton                *_touchBtn;//处理点击事件
}

@dynamic hitTestEdgeInsets;

-(id)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    if (self)
    {
        [self initSelf];
    }
    
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initSelf];
    }
    
    return self;
}

-(void)awakeFromNib
{
    [self initSelf];
}

-(void)initSelf
{
    self.userInteractionEnabled = YES;
    
    _touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _touchBtn.frame = self.bounds;
    [_touchBtn addTarget:self
                  action:@selector(buttonTouchUpInside:)
        forControlEvents:UIControlEventTouchUpInside];
    
    [_touchBtn addTarget:self
                  action:@selector(buttonToucheDown:)
        forControlEvents:UIControlEventTouchDown];
    
    [_touchBtn addTarget:self
                  action:@selector(buttonToucheCancel:)
        forControlEvents:UIControlEventTouchUpOutside];
    
    [_touchBtn addTarget:self
                  action:@selector(buttonTouchUpOutside:)
        forControlEvents:UIControlEventTouchUpOutside];
    
    [self addSubview:_touchBtn];
    [_touchBtn setExclusiveTouch:YES];//避免两个view同时被点击
    _touchBtn.titleEdgeInsets = UIEdgeInsetsMake(-5, -5, -5, -5);
}

- (void)setEnableSelectedSytle:(BOOL)enableSelectedSytle
{
    _enableSelectedSytle = enableSelectedSytle;
    if (_enableSelectedSytle) {
        if (_selectedBackgroundView == nil) {
            _selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
            _selectedBackgroundView.backgroundColor = RGBAHEX(0xeeeeee, 0.5);
            _selectedBackgroundView.hidden = YES;
            [self addSubview:_selectedBackgroundView];
            [self bringSubviewToFront:_selectedBackgroundView];
        }
    } else {
        [_selectedBackgroundView removeFromSuperview];
        _selectedBackgroundView = nil;
    }
}

- (void)setHitTestEdgeInsets:(UIEdgeInsets)hitTestEdgeInsets
{
    _touchBtn.titleEdgeInsets = hitTestEdgeInsets;
}

- (UIEdgeInsets)hitTestEdgeInsets
{
    return _touchBtn.titleEdgeInsets;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _touchBtn.frame = self.bounds;
    
    if (_selectedBackgroundView) {
        _selectedBackgroundView.frame = self.bounds;
    }
}

- (void)buttonTouchUpInside:(id)sender
{
    if (_selectedBackgroundView) {
        _selectedBackgroundView.hidden = YES;
    }

    if ([_delegate conformsToProtocol:@protocol(FEImageViewDelegate)]
        && [_delegate respondsToSelector:@selector(onTouchUpInside:)])
    {
        [_delegate onTouchUpInside:self];
    }
}

- (void)buttonToucheDown:(id)sender
{
    if (_selectedBackgroundView) {
        
        _selectedBackgroundView.hidden = NO;
    }
}

- (void)buttonToucheCancel:(id)sender
{
    if (_selectedBackgroundView) {
        
        _selectedBackgroundView.hidden = YES;
    }
}

- (void)buttonTouchUpOutside:(id)sender
{
    if (_selectedBackgroundView) {
        
        _selectedBackgroundView.hidden = YES;
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (UIEdgeInsetsEqualToEdgeInsets(_touchBtn.titleEdgeInsets, UIEdgeInsetsZero))
    {
        return [super pointInside:point withEvent:event];
    }
    else
    {
        CGRect relativeFrame = self.bounds;
        CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, _touchBtn.titleEdgeInsets);
        return CGRectContainsPoint(hitFrame, point);
    }
}

@end
