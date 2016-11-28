

#import "UIView+add.h"


@implementation UIView(add)

- (void)setX_:(CGFloat)x
{
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}

- (CGFloat)getX_
{
    return self.frame.origin.x;
}

- (void)setY_:(CGFloat)y
{
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}

- (CGFloat)getY_
{
    return self.frame.origin.y;
}

- (void)setWidth_:(CGFloat)width
{
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}

- (CGFloat)getWidth_
{
    return self.frame.size.width;
}

- (void)setHeight_:(CGFloat)height
{
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

- (CGFloat)getHeight_
{
    return self.frame.size.height;
}

- (void)setSize_:(CGSize)size
{
    CGRect rect = self.frame;
    rect.size = size;
    self.frame = rect;
}

- (CGSize)getSize_
{
    return self.frame.size;
}

- (void)setOrigin_:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)getOrigin_
{
    return self.frame.origin;
}

- (void)setTop_:(CGFloat)top
{
    self.y = top;
}

- (CGFloat)getTop_
{
    return self.y;
}

- (void)setLeft_:(CGFloat)left
{
    self.x = left;
}

- (CGFloat)getLeft_
{
    return self.x;
}

- (void)setButtom_:(CGFloat)botm
{
    self.y = botm - self.height;
}

- (CGFloat)getButtom_
{
    return self.y + self.height;
}

- (void)setRight_:(CGFloat)right
{
    self.x = right - self.width;
}

- (CGFloat)getRight_
{
    return self.x + self.width;
}

- (void)setCenterX_:(CGFloat)centerX
{
    [self setCenter:(CGPoint){centerX, self.center.y}];
}

- (CGFloat)getCenterX_
{
    return self.center.x;
}

- (void)setCenterY_:(CGFloat)centerY
{
    [self setCenter:(CGPoint){self.center.x, centerY}];
}

- (CGFloat)getCenterY_
{
    return self.center.y;
}


- (CGFloat)getMidWidth_
{
    return self.width * 0.5f;
}

- (void)setMidWidth_:(CGFloat)midWidth
{
    self.width = self.width * 0.5f;
}


- (CGFloat)getMidHeight_
{
    return self.height * 0.5f;
}

- (void)setMidHeight_:(CGFloat)midWidth
{
    self.height = self.height * 0.5f;
}





- (void)setFrame:(CGFloat)x y:(CGFloat)y w:(CGFloat)w h:(CGFloat)h
{
    [self setFrame:CGRectMake(x, y, w, h)];
}

- (void)setXY:(CGFloat)x Y:(CGFloat)y
{
    CGPoint point;
    point.x = x;
    point.y = y;
    
    self.origin = point;
}

- (void)setSizew:(CGFloat)w h:(CGFloat)h
{
    CGSize size;
    size.width = w;
    size.height = h;
    
    self.size = size;
}

- (CGRect)getFrameApplyAffineTransform_
{
    return CGRectApplyAffineTransform(self.frame, self.transform);
}

- (CGRect)getBoundsApplyAffineTransform_
{
    return CGRectApplyAffineTransform(self.bounds, self.transform);
}

// <----------------快速坐标 End---------------->

// <----------------快速排版---------------->

//添加子视图@[]
- (void)addSubviewAry:(NSArray *)objects
{
    for(UIView *vi in objects)
        [self addSubview:vi];
}

//置父视图顶部
- (void)setSuperViewTop
{
    self.y = 0;
}

//置父视图左边
- (void)setSuperViewLeft
{
    self.x = 0;
}

//置父视图底部
- (void)setSuperViewBotm
{
    NSAssert(self.superview, @"not superView!");
    self.y = self.superview.height - self.height;
}

//置父视图右边
- (void)setSuperViewRight
{
    NSAssert(self.superview, @"not superView!");
    self.x = self.superview.width - self.width;
}

//置View到指定View的顶部，并且设置间距
- (void)setTopFromView:(UIView*)vi dis:(CGFloat)dis
{
    self.y = vi.y - dis - self.height;
}

//置View到指定View左边，并且设置间距
- (void)setLeftFromView:(UIView*)vi dis:(CGFloat)dis
{
    self.x = vi.x - dis - self.width;
}

//置View到指定View底部，并且设置间距
- (void)setBotmFromView:(UIView*)vi dis:(CGFloat)dis
{
    self.y = vi.buttom + dis;
}

//置View到指定View右边，并且设置间距
- (void)setRightFromView:(UIView*)vi dis:(CGFloat)dis
{
    self.x = vi.right + dis;
}

//使用Margin设置坐标-相对父视图
- (void)setMarginTop:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right
{
    NSAssert(self.superview, @"没有父视图!");
    CGRect frame;
    frame.origin.y = top;
    frame.origin.x = left;
    frame.size.height = self.superview.height - frame.origin.y - bottom;
    frame.size.width = self.superview.width - frame.origin.x - right;
    self.frame = frame;
}

//设置UIViewAutoresizingFlexibleLeftMargin
- (void)setLeftMargin
{
    self.autoresizingMask |= UIViewAutoresizingFlexibleLeftMargin;
}

//设置UIViewAutoresizingFlexibleRightMargin
- (void)setRightMargin
{
    self.autoresizingMask |= UIViewAutoresizingFlexibleRightMargin;
}

//设置UIViewAutoresizingFlexibleTopMargin
- (void)setTopMargin
{
    self.autoresizingMask |= UIViewAutoresizingFlexibleTopMargin;
}

//设置UIViewAutoresizingFlexibleWidth
- (void)setWidthMargin
{
    self.autoresizingMask |= UIViewAutoresizingFlexibleWidth;
}

//设置UIViewAutoresizingFlexibleHeight
- (void)setHeightMargin
{
    self.autoresizingMask |= UIViewAutoresizingFlexibleHeight;
}

//设置UIViewAutoresizingFlexibleBottomMargin
- (void)setBottomMargin
{
    self.autoresizingMask |= UIViewAutoresizingFlexibleBottomMargin;
}

//设置AllMargin
- (void)setAllMargin
{
    [self setLeftMargin];
    [self setRightMargin];
    [self setTopMargin];
    [self setHeightMargin];
    [self setBottomMargin];
}

//输出View的Frame
- (void)ptrFrame
{
    NSLog(@"[%@]", NSStringFromCGRect(self.frame));
}

// <----------------快速排版 End---------------->

// <----------------杂项---------------->

//使用空白背景颜色
- (void)setBgrClearColor
{
    self.backgroundColor = [UIColor clearColor];
}

// <----------------杂项 End---------------->


#pragma mark - < 分割 > -

/**
 *  打印视图层次
 *
 *  @param aView     视图
 *  @param indent    层次等级,0 为最高级
 *  @param outstring 打印字符串
 */
+ (void)TprintViewLevel:(UIView *)aView
               atIndent:(int)indent
                 output:(NSMutableString *)outstring
{
    @autoreleasepool {
        for (int i = 0; i < indent; i++) {
            [outstring appendString:@"--"];
        }
        [outstring appendFormat:@"[%2d] %@\n", indent, [[aView class] description]];
        for (UIView *view in [aView subviews]) {
            [UIView TprintViewLevel:view atIndent:indent + 1 output:outstring];
        }
    }
}

/**
 *  打印视图层次
 */
- (void)TprintViewLevel
{
    @autoreleasepool {
        NSMutableString * outstring = [NSMutableString stringWithString:@"\n-- BEGIN --\n"];
        [UIView TprintViewLevel:self atIndent:0 output:outstring];
        [outstring appendString:@"\n-- END --\n"];
        NSLog(@"ViewLevel:%@",outstring);
    }
}




+ (id)viewWithFrame:(CGRect)frame
{
    UIView *view = [[[self class] alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor clearColor];
    return view;
}



-(void)removeAllSubviews{
	while (self.subviews.count) {
		UIView* child = self.subviews.lastObject;
		[child removeFromSuperview];
	}
}

-(UIImage*) convertToImage {
    
    UIImage *returnimage;
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:ctx];
    returnimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return returnimage;
    
}

- (UIView *)findFirstResponder
{
    if ([self isFirstResponder])
    {
        return self;
    }
    else
    {
        NSArray *subViewArr = [self subviews];
        for (UIView *subView in subViewArr)
        {
            if ([subView isKindOfClass:[UIView class]])
            {
                UIView *subSubView = [subView findFirstResponder];
                if (subSubView)
                {
                    return subSubView;
                }
            }
        }
    }

    return nil;
}

+(UIView *)keyView
{
    UIWindow *window = (UIWindow*)[UIView keyWindow];
    if ([window.subviews count] > 0) {
        return window.subviews[0];
    } else {
        return window;
    }
}

+(UIView*)keyWindow
{
    UIWindow *w = [[UIApplication sharedApplication]keyWindow];
    return w;
}

- (UIViewController *)getBelongViewController
{
    for (UIView* next = self; next; next = next.superview)
    {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

+ (CGRect)viewRectInWindow:(UIView *)view
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    return [view convertRect:view.bounds toView:window];
}
@end
