//
//  FEKeyTextViewCell.h
//  Pet
//
//  Created by Tom on 15/4/10.
//  Copyright (c) 2015年 fanying. All rights reserved.
//

#import "FETableViewCell.h"
#import "FETextView.h"

@class FEKeyTextViewCell;

@protocol FEKeyTextViewCellDelegate <NSObject>
@optional
- (void)textViewDidBeginEditing:(FEKeyTextViewCell *)textViewCell;
- (void)textViewDidEndEditing:(FEKeyTextViewCell *)textViewCell;
- (void)textViewDidChange:(FEKeyTextViewCell *)textViewCell;


@end

@interface FEKeyTextViewCell : FETableViewCell
<
UITextViewDelegate
>

@property (nonatomic, strong)   UILabel         * keyLabel;
@property (nonatomic, strong)   FETextView      * textView;
@property (nonatomic, assign)   CGFloat         padding;//默认14 //key 和 value 的间距
@property (nonatomic, assign)   CGFloat         keyLabelWidth;//默认 0系统计算，如果设置了则按设置的值


@property (nonatomic, assign)   NSInteger       maxTextCount;

@property (nonatomic, weak) id<FEKeyTextViewCellDelegate> delegate;


- (void)deleteEmoji;
- (void)insertEmoji:(NSString *)text;
@end
