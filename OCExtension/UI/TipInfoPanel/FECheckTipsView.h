//
//  FECheckTipsView.h
//  Pet
//
//  Created by Tom on 15/5/5.
//  Copyright (c) 2015年 fanying. All rights reserved.
//

#import <UIKit/UIKit.h>


//用户输入检查时 提示语
@interface FECheckTipsView : UIView

+(instancetype)checkTipsView;

-(void)showMessageTips:(NSString *)message inView:(UIView *)view;

-(void)hiddenTips;

@end

