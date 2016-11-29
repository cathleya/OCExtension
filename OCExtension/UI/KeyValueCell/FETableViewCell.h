//
//  FETableViewCell.h
//  Pet
//
//  Created by Tom on 15/4/10.
//  Copyright (c) 2015年 fanying. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark 广告链接类型
typedef NS_ENUM(NSInteger, FETableViewCellRowType) {
    FETableViewCellRowTypeButtom = 0,//最后一行
    FETableViewCellRowTypeTop = 1, //第一行
    FETableViewCellRowTypeMiddle = 2,//中间行
};

@interface FETableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView           *rightArrowView;
@property (nonatomic, strong) UIImageView           *selectedFlagView;
@property (nonatomic, strong) UIView                *selectedBGView;//高亮是背景view

@property (nonatomic, strong) UIView                *lineView;//下分割线

@property (nonatomic, assign, readonly) CGFloat     maxContentWidth;//cell宽度 -（右箭头or右选中）和 右间距

@property (nonatomic, assign) BOOL                   showRightArrowView;//是否显示右箭头 //默认NO
@property (nonatomic, assign) CGFloat                rightArrowViewPadding;//右箭头边距， 默认20

@property (nonatomic, assign) BOOL                   showSelectedFlagView;//显示选中标识， 如果cell被选中时 //默认NO

@property (nonatomic, assign) BOOL                   showSeperateLine;//是否显示分割线//默认YES
@property (nonatomic, assign) BOOL                   showTopSeperateLine;//是否显示上分割线//默认NO

@property (nonatomic, assign) FETableViewCellRowType cellRowType;// cell 所在行的位置

//初始化
- (void)initSelf;

//子类可重写 Cell的高度
+ (CGFloat)cellHeightWithData:(id)data;

//子类可重写 分割线 缩进宽度
- (CGFloat)seperateLineIndentationWidth;

//更新cell
- (void)updateCellWithData:(id)data;

@end
