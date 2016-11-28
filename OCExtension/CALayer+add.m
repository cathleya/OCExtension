//
//  CALayer+add.m
//  
//
//  Created by Tom on 15/10/14.
//
//

#import "CALayer+add.h"

@implementation CALayer (add)
/**
 *  添加阴影
 *
 *  @param shadowColor 阴影颜色
 *  @param offset      阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
 *  @param opacity     阴影透明度，默认0
 *  @param radius      阴影半径，默认3
 */
- (void)addShadowWithPath:(UIColor *)shadowColor
                   offset:(CGSize)offset
                  opacity:(CGFloat)opacity
                   radius:(CGFloat)radius
{
    self.shadowColor = shadowColor.CGColor;//shadowColor阴影颜色
    self.shadowOffset = offset;//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    self.shadowOpacity = opacity;//阴影透明度，默认0
    self.shadowRadius = radius;//阴影半径，默认3
    
    //路径阴影
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    float x = self.bounds.origin.x;
    float y = self.bounds.origin.y;
    float addWH = 10;
    
    CGPoint topLeft      = self.bounds.origin;
    CGPoint topMiddle = CGPointMake(x+(width/2),y-addWH);
    CGPoint topRight     = CGPointMake(x+width,y);
    
    CGPoint rightMiddle = CGPointMake(x+width+addWH,y+(height/2));
    
    CGPoint bottomRight  = CGPointMake(x+width,y+height);
    CGPoint bottomMiddle = CGPointMake(x+(width/2),y+height+addWH);
    CGPoint bottomLeft   = CGPointMake(x,y+height);
    
    
    CGPoint leftMiddle = CGPointMake(x-addWH,y+(height/2));
    
    [path moveToPoint:topLeft];
    //添加四个二元曲线
    [path addQuadCurveToPoint:topRight
                 controlPoint:topMiddle];
    [path addQuadCurveToPoint:bottomRight
                 controlPoint:rightMiddle];
    [path addQuadCurveToPoint:bottomLeft
                 controlPoint:bottomMiddle];
    [path addQuadCurveToPoint:topLeft
                 controlPoint:leftMiddle];
    //设置阴影路径
    self.shadowPath = path.CGPath;
}


/**
 *  添加阴影
 *
 *  @param shadowColor 阴影颜色
 *  @param offset      阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
 *  @param opacity     阴影透明度，默认0
 *  @param radius      阴影半径，默认3
 */
- (void)addShadow:(UIColor *)shadowColor
           offset:(CGSize)offset
          opacity:(CGFloat)opacity
           radius:(CGFloat)radius
{
    self.shadowColor = [UIColor blackColor].CGColor;
    self.shadowOffset = CGSizeMake(1,1);
    self.shadowOpacity = 0.8;
    self.shadowRadius = 1;
}


@end
