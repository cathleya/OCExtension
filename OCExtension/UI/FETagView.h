//
//  FETagView.h
//  Pet
//
//  Created by Tom on 15/3/19.
//  Copyright (c) 2015年 fanying. All rights reserved.
//

#import <UIKit/UIKit.h>

//图片在文字相对位置
typedef NS_ENUM(NSInteger, FETagViewImageStyle) {
    FETagViewImageStyleLeft,//图片在文字左边
    FETagViewImageStyleRight,//图片在文字右边
    FETagViewImageStyleUp,//图片在文字上边
    FETagViewImageStyleDown, //图片在文字右边
};

@interface FETagView : UIButton
@property (nonatomic, assign) CGFloat padding;
@property (nonatomic, assign) FETagViewImageStyle    imageStyle;//默认 FETagViewImageStyleLeft

+(instancetype)tagView;

@end
