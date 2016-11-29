//
//  GridPhotoView.h
//  Pet
//
//  Created by Tom on 15/4/21.
//  Copyright (c) 2015年 fanying. All rights reserved.
//

#import "DFImageView.h"
#import "IGridItemView.h"
#import "DFImageView.h"


@class GridPhotoItem;

@interface GridItemView : DFImageView<IGridItemView>

@property (nonatomic, strong) GridPhotoItem* photoItem;

@end


#pragma mark -
@interface GridPhotoItem : NSObject

@property (nonatomic, copy) NSString    *imageUrl;//网络地址
@property (nonatomic, copy) NSString    *imagePath;//本地地址

@property (nonatomic, strong) id        userInfo;

@end
