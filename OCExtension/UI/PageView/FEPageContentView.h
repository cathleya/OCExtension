//
//  FEPageContentView.h
//  Pet
//
//  Created by Tom on 15/6/25.
//  Copyright (c) 2015年 fanying. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "FYSuperView.h"

@interface FEPageContentView : UIView//FYSuperView

@property (nonatomic,readonly) NSString *reuseIdentifier;


- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier;

@end
