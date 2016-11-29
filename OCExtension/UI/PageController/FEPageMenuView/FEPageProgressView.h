//
//  FEPageProgressView.h
//
//
//  Created by ios on 15/11/9.
//
//

#import <UIKit/UIKit.h>

@interface FEPageProgressView : UIView
@property (nonatomic, strong)   NSArray *itemFrameArray;
@property (nonatomic, assign)   CGColorRef color;
@property (nonatomic, assign)   CGFloat progress;

- (void)setProgressWithOutAnimate:(CGFloat)progress;
- (void)moveToPostion:(NSInteger)pos;
@end
