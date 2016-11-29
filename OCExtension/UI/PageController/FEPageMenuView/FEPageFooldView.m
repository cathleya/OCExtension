//
//  FEPageFooldView.m
//
//
//  Created by ios on 15/11/9.
//
//

#import "FEPageFooldView.h"

@implementation FEPageFooldView {
    CGFloat FEPageFooldMargin;
    CGFloat FEPageFooldRadius;
    CGFloat FEPageFooldLength;
    CGFloat FEPageFooldHeight;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        FEPageFooldHeight = frame.size.height;
        FEPageFooldMargin = FEPageFooldHeight * 0.15;
        FEPageFooldRadius = (FEPageFooldHeight - FEPageFooldMargin * 2) / 2;
        FEPageFooldLength = frame.size.width  - FEPageFooldRadius * 2;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    int currentIndex = (int)self.progress;
    CGFloat rate = self.progress - currentIndex;
    int nextIndex = currentIndex + 1 >= self.itemFrameArray.count ?: currentIndex + 1;

    // 当前item的各数值
    CGRect  currentFrame = [self.itemFrameArray[currentIndex] CGRectValue];
    CGFloat currentWidth = currentFrame.size.width;
    CGFloat currentX = currentFrame.origin.x;
    // 下一个item的各数值
    CGFloat nextWidth = [self.itemFrameArray[nextIndex] CGRectValue].size.width;
    CGFloat nextX = [self.itemFrameArray[nextIndex] CGRectValue].origin.x;
    // 计算点
    CGFloat startX = currentX + (nextX - currentX) * rate;
    CGFloat endX = startX + currentWidth + (nextWidth - currentWidth)*rate;
    // 绘制
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, 0.0f, FEPageFooldHeight);
    CGContextScaleCTM(ctx, 1.0f, -1.0f);
    CGContextAddArc(ctx, startX+FEPageFooldRadius, FEPageFooldHeight / 2.0, FEPageFooldRadius, M_PI_2, M_PI_2 * 3, 0);
    CGContextAddLineToPoint(ctx, endX-FEPageFooldRadius, FEPageFooldMargin);
    CGContextAddArc(ctx, endX-FEPageFooldRadius, FEPageFooldHeight / 2.0, FEPageFooldRadius, -M_PI_2, M_PI_2, 0);
    CGContextClosePath(ctx);
    
    if (self.hollow) {
        CGContextSetStrokeColorWithColor(ctx, self.color);
        CGContextStrokePath(ctx);
        return;
    }
    CGContextClosePath(ctx);
    CGContextSetFillColorWithColor(ctx, self.color);
    CGContextFillPath(ctx);
}

@end
