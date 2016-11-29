//
//  FENavigationController.h
//  FEFramework
//
//  Created by Tom on 15/1/20.
//  Copyright (c) 2015年 liyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationController+FEBackGesture.h"
#import "UIBarButtonItem+Extension.h"

@interface FENavigationController : UINavigationController

- (UIScreenEdgePanGestureRecognizer *)screenEdgePanGestureRecognizer;

@end
