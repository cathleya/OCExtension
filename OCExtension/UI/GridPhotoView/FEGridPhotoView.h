//
//  FEGridPhotoView.h
//  Pet
//
//  Created by Tom on 15/4/10.
//  Copyright (c) 2015年 fanying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridItemView.h"


@class FEGridPhotoView;
@protocol FEGridPhotoViewDelegate <NSObject>

@optional
-(void)gridPhotoView:(FEGridPhotoView*)gridView selected:(NSInteger)index;

//返回itemView, 如果不实现此代理 则默认用 itemViewClass 创建
-(UIView<IGridItemView>*)gridPhotoView:(FEGridPhotoView*)gridView itemViewWithFrame:(CGRect)frame;

//返回 item data 如果不实现此代理 则默认用 photoItemArray里的数据
-(id)gridPhotoView:(FEGridPhotoView*)gridView itemDataWithIndex:(NSInteger)index;

@end

@interface FEGridPhotoView : UIView
<
UICollectionViewDataSource
, UICollectionViewDelegate
>

@property (nonatomic, assign)   CGSize      photoSize;      //照片显示大小
@property (nonatomic, assign)   CGFloat     v_padding;      // 纵向间距
@property (nonatomic, assign)   CGFloat     h_padding;      //横向间距
@property (nonatomic, assign)   NSInteger   maxRow;    //最大行数
@property (nonatomic, assign)   NSInteger   maxCol;    //最大列数

@property (nonatomic, strong)   Class       itemViewClass;//默认 GridItemView

@property (nonatomic, weak)     id<FEGridPhotoViewDelegate> delegate;


-(void)updateWithPhotoItems:(NSArray*)photoItemArray;

+(CGSize)sizeWithMaxRow:(NSInteger)maxRow
                 maxCol:(NSInteger)maxCol
               itemSize:(CGSize)size
               vPadding:(CGFloat)vPadding
               hPadding:(CGFloat)hPadding
              itemCount:(NSInteger)itemCount;

@end


