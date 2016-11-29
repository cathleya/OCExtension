//
//  FEKeyValueCell.h
//  Pet
//
//  Created by Tom on 15/4/10.
//  Copyright (c) 2015年 fanying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FETableViewCell.h"

@interface FEKeyValueCell : FETableViewCell

@property (nonatomic, strong)   UILabel         * keyLabel;
@property (nonatomic, strong)   UILabel         * valueLabel;
@property (nonatomic, assign)   CGFloat         padding;//默认14 //key 和 value 的间距
@property (nonatomic, assign)   CGFloat         keyLabelWidth;//默认 0系统计算，如果设置了则按设置的值

@property (nonatomic, assign, readonly) CGFloat valueLabelLeft;//获取 x


@end
