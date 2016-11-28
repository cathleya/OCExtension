//
//  UIButton+add.m
//  
//
//  Created by FE on 13-11-15.
//
//

#import "UIButton+add.h"
#import "UIView+add.h"
#import <objc/runtime.h>

static const char *EdgeInsets="__EdgeInsets";
const static char * IndexPathKey = "IndexPathKey";

#define BUTTON_DEFAULT_INTERVAL 1

@interface UIButton()
/**bool 类型   设置是否执行点UI方法*/
@property (nonatomic, assign) BOOL ignoreEvent;
@end


@implementation UIButton (add)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL selA = @selector(sendAction:to:forEvent:);
        SEL selB = @selector(mySendAction:to:forEvent:);
        Method methodA =   class_getInstanceMethod(self,selA);
        Method methodB = class_getInstanceMethod(self, selB);
        BOOL isAdd = class_addMethod(self, selA, method_getImplementation(methodB), method_getTypeEncoding(methodB));
        if (isAdd) {
            class_replaceMethod(self, selB, method_getImplementation(methodA), method_getTypeEncoding(methodA));
        }else{
            method_exchangeImplementations(methodA, methodB);
        }
    });
}

- (void)mySendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    if ([self isMemberOfClass:[UIButton class]]) {

        if (self.ignoreEvent) {
            return;
        }
        
//        if (self.timeInterval == 0) {
//            self.timeInterval = BUTTON_DEFAULT_INTERVAL;
//        }
        
        if (self.timeInterval > 0)
        {
            self.ignoreEvent = YES;
            [self performSelector:@selector(setIgnoreEvent:) withObject:@(NO) afterDelay:self.timeInterval];
        }
    }
    
    [self mySendAction:action to:target forEvent:event];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (UIEdgeInsetsEqualToEdgeInsets(self.hitTestEdgeInsets, UIEdgeInsetsZero))
    {
        return [super pointInside:point withEvent:event];
    }
    else
    {
        CGRect relativeFrame = self.bounds;
        CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.hitTestEdgeInsets);
        return CGRectContainsPoint(hitFrame, point);
    }

}
-(void)setHitTestEdgeInsets:(UIEdgeInsets)hitTestEdgeInsets
{
    NSValue *valueUIEdgeInsets = [NSValue valueWithUIEdgeInsets:hitTestEdgeInsets];
    objc_setAssociatedObject(self, &EdgeInsets, valueUIEdgeInsets, OBJC_ASSOCIATION_RETAIN);
}

-(UIEdgeInsets)hitTestEdgeInsets
{
    NSValue* valueUIEdgeInsets = objc_getAssociatedObject(self, &EdgeInsets);
    return [valueUIEdgeInsets UIEdgeInsetsValue];
}

- (NSTimeInterval)timeInterval
{
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

- (void)setTimeInterval:(NSTimeInterval)timeInterval
{
    objc_setAssociatedObject(self, @selector(timeInterval), @(timeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setIgnoreEvent:(BOOL)ignoreEvent{
    objc_setAssociatedObject(self, @selector(ignoreEvent), @(ignoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)ignoreEvent{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

#pragma mark - 设置方法

- (void)setTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
}

- (void)setTitleColor:(UIColor *)color
{
    [self setTitleColor:color forState:UIControlStateNormal];
}

- (void)setImage:(UIImage *)image
{
    [self setImage:image forState:UIControlStateNormal];
}

- (void)setTitle:(NSString *)title icon:(UIImage *)icon gap:(CGFloat)gap iconOrien:(FEButtonIconOrien)orien
{
    [self setTitle:title];
    [self setImage:icon forState:UIControlStateNormal];

    CGSize labelSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font
                                        constrainedToSize:CGSizeMake(self.width, self.height)];

    CGSize iconSize = icon.size;

    switch (orien)
    {
        case FEButtonIconSideLeft:
        {
            CGFloat totalW = labelSize.width + gap + iconSize.width;
            [self setImageEdgeInsets:UIEdgeInsetsMake(0, (iconSize.width - totalW) * 0.5, 0, 0)];
            [self setTitleEdgeInsets:UIEdgeInsetsMake(0, (totalW - labelSize.width) * 0.5, 0, 0)];
            break;
        }
        case FEButtonIconSideTop:
        {
            CGFloat totalW = labelSize.height + gap + iconSize.height;
            [self setImageEdgeInsets:UIEdgeInsetsMake(0, (iconSize.width - totalW) * 0.5, 0, 0)];
            [self setTitleEdgeInsets:UIEdgeInsetsMake(0, (totalW - labelSize.width) * 0.5, 0, 0)];
            break;
        }
        case FEButtonIconSideRight:
        {
            CGFloat totalW = labelSize.width + gap + iconSize.width;
            [self setImageEdgeInsets:UIEdgeInsetsMake(0, (iconSize.width - totalW) * 0.5, 0, 0)];
            [self setTitleEdgeInsets:UIEdgeInsetsMake(0, (totalW - labelSize.width) * 0.5, 0, 0)];
            break;
        }
        case FEButtonIconSideBottom:
        {
            CGFloat totalW = labelSize.width + gap + iconSize.width;
            [self setImageEdgeInsets:UIEdgeInsetsMake(0, (iconSize.width - totalW) * 0.5, 0, 0)];
            [self setTitleEdgeInsets:UIEdgeInsetsMake(0, (totalW - labelSize.width) * 0.5, 0, 0)];
            break;
        }
        default:
            break;
    }
}

- (void)setBackgroundStretchableImage:(UIImage *)image
{
    image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5f topCapHeight:image.size.height * 0.5f];
    [self setBackgroundImage:image forState:UIControlStateNormal];
}

- (void)setBackgroundStretchableImage:(UIImage *)image forState:(UIControlState)state
{
    image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5f topCapHeight:image.size.height * 0.5f];
    [self setBackgroundImage:image forState:state];
}

- (void)addTarget:(id)target action:(SEL)action
{
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}


- (CGSize)sizeForImageView
{
    CGSize imgSize = CGSizeZero;
    if (self.imageView.image) {
        imgSize = self.imageView.image.size;
    }
    return imgSize;
}

- (CGSize)sizeForTitleLabel
{
    [self.titleLabel sizeToFit];
    return self.titleLabel.size;
}


- (void)setIndexPath:(NSIndexPath *)indexPath {
    objc_setAssociatedObject(self, IndexPathKey, indexPath, OBJC_ASSOCIATION_RETAIN);
}

- (NSIndexPath *)indexPath {
    id obj = objc_getAssociatedObject(self, IndexPathKey);
    if([obj isKindOfClass:[NSIndexPath class]]) {
        return (NSIndexPath *)obj;
    }
    return nil;
}
@end

