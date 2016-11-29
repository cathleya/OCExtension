

#import "FEProgressView.h"
#import "UIView+add.h"

@implementation FEProgressView
{
    UIView * _backgroundView;
    UIView * _foregroundView;
    CGFloat     _availableWidth;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:_backgroundView];
        
        _foregroundView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:_foregroundView];
        
        _availableWidth = self.bounds.size.width;
        
        self.progress = 0.0;

    }
    return self;
}

-(void)setTrackColor:(UIColor *)trackColor
{
    _trackColor = trackColor;
    _foregroundView.backgroundColor = _trackColor;
}

-(void)setBackColor:(UIColor *)backColor
{
    _backColor = backColor;
    _backgroundView.backgroundColor = backColor;
}

- (void)setProgress:(double)progress
{
    _progress = progress;
    if (_progress < 0) {
        _progress = 0;
    } else if (_progress > 1) {
        _progress = 1;
    }
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _foregroundView.frame = CGRectMake(0, 0, _availableWidth*_progress, _foregroundView.height);
}

@end
