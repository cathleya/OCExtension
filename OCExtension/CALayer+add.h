//
//  CALayer+add.h
//  
//
//  Created by Tom on 15/10/14.
//
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CALayer (add)
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
                   radius:(CGFloat)radius;

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
           radius:(CGFloat)radius;
@end
