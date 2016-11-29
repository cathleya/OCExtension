//
//  FECircularProgressView.m
//  Pet
//
//  Created by ios on 16/5/10.
//  Copyright © 2016年 Yourpet. All rights reserved.
//

#import "FECircularProgressView.h"
#import <QuartzCore/QuartzCore.h>
#import "NSMutableAttributedString+NimbusAttributedLabel.h"
#import "FEPrecompile.h"

#define PERCENT_FONT_SIZE 10

@interface FECircularProgressView()
@property (nonatomic, strong) CAShapeLayer  *backgroundLayer;
@property (nonatomic, strong) CAShapeLayer  *progressLayer;
@property (nonatomic, strong) UILabel       *progressLabel;

@end

@implementation FECircularProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupDefaultPara];
        
        [self setUp];
    }
    
    return self;
}

- (void)setupDefaultPara
{
    _backColor = RGBHEX(0xCCCCCC);
    _progressColor = RGBHEX(0x6ca2de);
    _lineWidth = 2.0;
    _progressLabelColor = _progressColor;
    _progressLabelFontSize = 17;
}

- (void)setUp{
    
    self.backgroundColor = [UIColor clearColor];
    
    [_backgroundLayer removeFromSuperlayer];
    _backgroundLayer = nil;
    
    [_progressLayer removeFromSuperlayer];
    _progressLayer = nil;
    
    [_progressLabel removeFromSuperview];
    _progressLabel = nil;
    
    CGFloat lineWidth = self.lineWidth;
    
    _backgroundLayer = [self createRingLayerWithCenter:CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2)
                                                             radius:CGRectGetWidth(self.bounds) / 2 - lineWidth
                                                          lineWidth:lineWidth * 0.5
                                                              color:self.backColor];
    
    [self.layer addSublayer:_backgroundLayer];
    
    _progressLayer = [self createRingLayerWithCenter:CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2)
                                              radius:CGRectGetWidth(self.bounds) / 2 - lineWidth / 2
                                           lineWidth:lineWidth
                                               color:self.progressColor];
    _progressLayer.strokeEnd = 0;
    [self.layer addSublayer:_progressLayer];
    
    _progressLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _progressLabel.backgroundColor = [UIColor clearColor];
    _progressLabel.textAlignment = NSTextAlignmentCenter;
    _progressLabel.font = [UIFont systemFontOfSize:_progressLabelFontSize];
    _progressLabel.textColor = _progressLabelColor;
    [self addSubview:_progressLabel];
}



- (CAShapeLayer *)createRingLayerWithCenter:(CGPoint)center radius:(CGFloat)radius lineWidth:(CGFloat)lineWidth color:(UIColor *)color {
    
    UIBezierPath *smoothedPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:radius startAngle:- M_PI_2 endAngle:(M_PI + M_PI_2) clockwise:YES];
    CAShapeLayer *slice = [CAShapeLayer layer];
    slice.contentsScale = [[UIScreen mainScreen] scale];
    slice.frame = CGRectMake(center.x - radius, center.y - radius, radius * 2, radius * 2);
    slice.fillColor = [UIColor clearColor].CGColor;
    slice.strokeColor = color.CGColor;
    slice.lineWidth = lineWidth;
    slice.lineCap = kCALineJoinBevel;
    slice.lineJoin = kCALineJoinBevel;
    slice.path = smoothedPath.CGPath;
    return slice;
}

- (void)setBackColor:(UIColor *)backColor
{
    _backColor = backColor;
    _backgroundLayer.strokeColor = _backColor.CGColor;
}

- (void)setProgressColor:(UIColor *)progressColor
{
    _progressColor = progressColor;
    _progressLayer.strokeColor = _progressColor.CGColor;
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    if (_lineWidth != lineWidth) {
        _lineWidth = lineWidth;
        
    }
}

- (void)setProgressLabelColor:(UIColor *)progressLabelColor
{
    _progressLabelColor = progressLabelColor;
    _progressLabel.textColor = _progressLabelColor;
}

- (void)setProgressLabelFontSize:(CGFloat)progressLabelFontSize
{
    _progressLabelFontSize = progressLabelFontSize;
    _progressLabel.font = [UIFont systemFontOfSize:_progressLabelFontSize];
}

- (void)setProgress:(CGFloat)progress
{
    if (progress == 0) {
        self.progressLayer.hidden = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.progressLayer.strokeEnd = 0;
        });
    } else {
        self.progressLayer.hidden = NO;
        self.progressLayer.strokeEnd = progress;
    }
    
    NSString *string = [NSString stringWithFormat:@"%.0f%%", progress * 100];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string];
    
    if (_progressLabelFontSize != PERCENT_FONT_SIZE) {
        NSRange range = [string rangeOfString:@"%"];
        if (range.location != NSNotFound) {
            [attributeString setFont:[UIFont systemFontOfSize:PERCENT_FONT_SIZE] range:range];
        }
    }

    _progressLabel.attributedText = attributeString;
}

@end
