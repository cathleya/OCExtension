//
//  UIScrollView+AllowPanGestureEventPass.m
//  Pet
//
//  Created by ios on 15/12/25.
//  Copyright © 2015年 Yourpet. All rights reserved.
//

#import "UIScrollView+AllowPanGestureEventPass.h"

@implementation UIScrollView (AllowPanGestureEventPass)

//暂时屏蔽掉
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]
//        && [otherGestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]])
//    {
//        if (self.contentOffset.x > 0) {
//            return NO;
//        } else {
//            return YES;
//        }
//    }
//    else
//    {
//        return  NO;
//    }
//}


@end
