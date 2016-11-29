//
//  FEPageProgressView.m
//
//
//  Created by ios on 15/11/9.
//
//


#import "FEPageProgressView.h"

@implementation FEPageProgressView {
    int         sign;
    CGFloat     gap;
    CGFloat     step;
    __weak      CADisplayLink *_link;
}

- (void)setProgressWithOutAnimate:(CGFloat)progress {
    if (self.progress == progress) return;
    _progress = progress;
    [self setNeedsDisplay];
}

- (void)moveToPostion:(NSInteger)pos {
    gap = fabs(self.progress - pos);
    sign = self.progress > pos ? -1 : 1;
    step = gap / 15.0;
    if (_link) {
        [_link removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(progressChanged)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    _link = link;
}

- (void)setProgress:(CGFloat)progress {
    if (self.progress == progress) return;
    _progress = progress;
    [self setNeedsDisplay];
}

- (void)progressChanged {
    if (gap >= 0.0) {
        gap -= step;
        if (gap < 0.0) {
            self.progress = (int)(self.progress + 0.5);
            return;
        }
        self.progress += sign * step;
    } else {
        self.progress = (int)(self.progress + 0.5);
        [_link invalidate];
        _link = nil;
    }
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    int index = (int)self.progress;
    CGFloat rate = self.progress - index;
    CGRect currentFrame = [self.itemFrameArray[index] CGRectValue];
    CGFloat currentWidth = currentFrame.size.width;
    int nextIndex = index + 1 < self.itemFrameArray.count ? index + 1 : index;
    CGFloat nextWidth = [self.itemFrameArray[nextIndex] CGRectValue].size.width;
    CGFloat height = self.frame.size.height;
    CGFloat constY = height / 2;
    CGFloat currentX = currentFrame.origin.x;
    CGFloat nextX = [self.itemFrameArray[nextIndex] CGRectValue].origin.x;
    CGFloat startX = currentX + (nextX - currentX) * rate;
    CGFloat endX = startX + currentWidth + (nextWidth - currentWidth)*rate;
    CGContextMoveToPoint(ctx, startX, constY);
    CGContextAddLineToPoint(ctx, endX, constY);
    CGContextSetLineWidth(ctx, height);
    CGContextSetStrokeColorWithColor(ctx, self.color);
    CGContextStrokePath(ctx);
}

@end
