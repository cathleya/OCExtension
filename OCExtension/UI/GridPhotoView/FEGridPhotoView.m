//
//  FEGridPhotoView.m
//  Pet
//
//  Created by Tom on 15/4/10.
//  Copyright (c) 2015年 fanying. All rights reserved.
//

#import "FEGridPhotoView.h"
#import "DFImageView.h"
#import "UIView+add.h"

#define CONTENT_VIEW_TAG 1000


@implementation FEGridPhotoView
{
    UICollectionView            *_collectionView;
    NSInteger                   _numberOfRow;
    NSInteger                   _numberOfCol;
    
    NSArray                     *_itemArray;
    
}

+(CGSize)sizeWithMaxRow:(NSInteger)maxRow
                 maxCol:(NSInteger)maxCol
               itemSize:(CGSize)size
               vPadding:(CGFloat)vPadding
               hPadding:(CGFloat)hPadding
              itemCount:(NSInteger)itemCount
{
    NSInteger row = 0;
    NSInteger col = 0;
    if (itemCount <= maxCol)
    {
        row = 1;
        col = itemCount;
    }
    else
    {
        row = itemCount / maxCol;
        if (itemCount % maxCol != 0)
        {
            row += 1;
        }
        
        if (row > maxRow)
        {
            row = maxRow;
        }
        
        col = maxCol;
    }
    
    CGFloat width = size.width * col + (col - 1) * hPadding;
    CGFloat height = size.height * row + (row - 1) * vPadding;
    
    return CGSizeMake(width, height);
}

-(instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        _photoSize = CGSizeMake(50, 50);
        _h_padding = 5;
        _v_padding = 5;
        _maxCol = 4;
        _maxRow = 2;
        
        _itemViewClass = [GridItemView class];
        
        
        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.scrollEnabled = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator =  NO;
        
        [_collectionView registerClass:[UICollectionViewCell class]
            forCellWithReuseIdentifier:@"UICollectionViewCell"];
        
        [self addSubview:_collectionView];
    }
    
    return self;
}

-(void)updateWithPhotoItems:(NSArray*)photoItemArray
{
    _itemArray = photoItemArray;
    
    NSInteger itemCount = [_itemArray count];
    if (itemCount <= _maxCol)
    {
        _numberOfRow = 1;
        _numberOfCol = itemCount;
    }
    else
    {
        _numberOfRow = itemCount / _maxCol;
        if (itemCount % _maxCol != 0)
        {
            _numberOfRow += 1;
        }
        
        if (_numberOfRow > _maxRow)
        {
            _numberOfRow = _maxRow;
        }
        
        _numberOfCol = _maxCol;
    }
    
    
    CGSize size = [FEGridPhotoView sizeWithMaxRow:_maxRow
                                           maxCol:_maxCol
                                         itemSize:_photoSize
                                         vPadding:_v_padding
                                         hPadding:_h_padding
                                        itemCount:[_itemArray count]];
    
    self.frame = CGRectMake(self.left, self.top, size.width, size.height);
    _collectionView.frame = CGRectMake(0, 0, size.width, size.height);
    
    [_collectionView reloadData];
    
}

#pragma mark UICollectionViewDataSource UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _numberOfRow;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _numberOfCol;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = (UICollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    
    UIView<IGridItemView>* imageView = ( UIView<IGridItemView>*)[cell.contentView viewWithTag:CONTENT_VIEW_TAG];
    if (imageView == nil)
    {
        CGRect frame = CGRectMake(0, 0, _photoSize.width, _photoSize.height);
        if ([_delegate respondsToSelector:@selector(gridPhotoView:itemViewWithFrame:)])
        {
            imageView = [_delegate gridPhotoView:self itemViewWithFrame:frame];
        }
        else
        {
            imageView = [[_itemViewClass alloc] initWithFrame:frame];
        }

        imageView.center = cell.contentView.center;
        [cell.contentView addSubview:imageView];
        imageView.userInteractionEnabled = NO;
        imageView.tag = CONTENT_VIEW_TAG;
    }
    
    NSInteger index = indexPath.section * _maxCol + indexPath.item;
    if (index >= 0
        && index < [_itemArray count])
    {
        cell.hidden = NO;
        
        id photoItem = nil;
        if ([_delegate respondsToSelector:@selector(gridPhotoView:itemDataWithIndex:)])
        {
            photoItem = [_delegate gridPhotoView:self itemDataWithIndex:index];
        }
        else
        {
            photoItem = _itemArray[index];
        }
        
        [imageView setData:photoItem];
    }
    else
    {
        cell.hidden = YES;
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return _photoSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, _v_padding, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.section * _maxCol + indexPath.item;
    if ([self.delegate respondsToSelector:@selector(gridPhotoView:selected:)])
    {
        [self.delegate gridPhotoView:self selected:index];
    }
}

@end


