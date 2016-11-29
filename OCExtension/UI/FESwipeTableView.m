//
//  FESwipeTableView.m
//  Pet
//
//  Created by Tom on 15/7/2.
//  Copyright (c) 2015年 fanying. All rights reserved.
//

#import "FESwipeTableView.h"
#import "UIView+add.h"
#import "FEPrecompile.h"
#import "FESwipeTableView.h"
#import <objc/runtime.h>

const static CGFloat kDeleteButtonWidth = 64;
const static CGFloat kDeleteButtonHeight = 44.f;


const static char * kFESwipeTableViewCellIndexPathKey = "FESwipeTableViewCellIndexPathKey";

@interface UIButton (NSIndexPath)

- (void)setIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPath;

@end

@implementation UIButton (NSIndexPath)

- (void)setIndexPath:(NSIndexPath *)indexPath {
    objc_setAssociatedObject(self, kFESwipeTableViewCellIndexPathKey, indexPath, OBJC_ASSOCIATION_RETAIN);
}

- (NSIndexPath *)indexPath {
    id obj = objc_getAssociatedObject(self, kFESwipeTableViewCellIndexPathKey);
    if([obj isKindOfClass:[NSIndexPath class]]) {
        return (NSIndexPath *)obj;
    }
    return nil;
}

@end

@interface FESwipeTableView() {
    UISwipeGestureRecognizer * _leftGestureRecognizer;
    UISwipeGestureRecognizer * _rightGestureRecognizer;
    UITapGestureRecognizer * _tapGestureRecognizer;
    
    UIButton * _deleteButton;
    
    NSIndexPath * _editingIndexPath;
}

@end

@implementation FESwipeTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        _leftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
        _leftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        _leftGestureRecognizer.delegate = self;
        [self addGestureRecognizer:_leftGestureRecognizer];
        
        _rightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
        _rightGestureRecognizer.delegate = self;
        _rightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:_rightGestureRecognizer];
        
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        _tapGestureRecognizer.delegate = self;
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.frame = CGRectMake(self.width, 0, kDeleteButtonWidth, kDeleteButtonHeight);
        _deleteButton.backgroundColor = RGBHEX(0xff5555);
        _deleteButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _deleteButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [_deleteButton setTitle:@"删除"  forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteItem:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteButton];
        
        
        [self.panGestureRecognizer addTarget:self action:@selector(panGestureHandler:)];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame style:UITableViewStylePlain];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // drawing code
 }
 */

- (void)swiped:(UISwipeGestureRecognizer *)gestureRecognizer {
    NSIndexPath * indexPath = [self cellIndexPathForGestureRecognizer:gestureRecognizer];
    if(indexPath == nil)
        return;
    
    id dataSource = self.dataSource;
    BOOL canDelete = NO;
    if ([dataSource respondsToSelector:@selector(tableView:canDeleteRowAtIndexPath:)]) {
        canDelete = [dataSource tableView:self canDeleteRowAtIndexPath:indexPath];
    }
    
    if(!canDelete) {
        return;
    }
    
    if(gestureRecognizer == _leftGestureRecognizer && ![_editingIndexPath isEqual:indexPath]) {
        UITableViewCell * cell = [self cellForRowAtIndexPath:indexPath];
        [self setEditing:YES atIndexPath:indexPath cell:cell];
    } else if (gestureRecognizer == _rightGestureRecognizer && [_editingIndexPath isEqual:indexPath]){
        UITableViewCell * cell = [self cellForRowAtIndexPath:indexPath];
        [self setEditing:NO atIndexPath:indexPath cell:cell];
    }
}

- (void)tapped:(UIGestureRecognizer *)gestureRecognizer
{
    if(_editingIndexPath) {
        UITableViewCell * cell = [self cellForRowAtIndexPath:_editingIndexPath];
        [self setEditing:NO atIndexPath:_editingIndexPath cell:cell];
    }
}

-(void)panGestureHandler:(UIPanGestureRecognizer*)gestureRecognizer
{
    if(_editingIndexPath) {
        UITableViewCell * cell = [self cellForRowAtIndexPath:_editingIndexPath];
        [self setEditing:NO atIndexPath:_editingIndexPath cell:cell];
    }
}

- (NSIndexPath *)cellIndexPathForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    UIView * view = gestureRecognizer.view;
    if(![view isKindOfClass:[UITableView class]]) {
        return nil;
    }
    
    CGPoint point = [gestureRecognizer locationInView:view];
    NSIndexPath * indexPath = [self indexPathForRowAtPoint:point];
    return indexPath;
}

- (void)setEditing:(BOOL)editing atIndexPath:indexPath cell:(UITableViewCell *)cell {
    
    if(editing) {
        if(_editingIndexPath) {
            UITableViewCell * editingCell = [self cellForRowAtIndexPath:_editingIndexPath];
            [self setEditing:NO atIndexPath:_editingIndexPath cell:editingCell];
        }
        [self addGestureRecognizer:_tapGestureRecognizer];
    } else {
        [self removeGestureRecognizer:_tapGestureRecognizer];
    }
    
    CGRect frame = cell.frame;
    
    CGFloat cellXOffset;
    CGFloat deleteButtonXOffsetOld;
    CGFloat deleteButtonXOffset;
    
    if(editing) {
        cellXOffset = -kDeleteButtonWidth;
        deleteButtonXOffset = self.width - kDeleteButtonWidth;
        deleteButtonXOffsetOld = self.width;
        _editingIndexPath = indexPath;
    } else {
        cellXOffset = 0;
        deleteButtonXOffset = self.width;
        deleteButtonXOffsetOld = self.width - kDeleteButtonWidth;
        _editingIndexPath = nil;
    }
    
    CGFloat cellHeight = [self.delegate tableView:self heightForRowAtIndexPath:indexPath];
    _deleteButton.frame = (CGRect) {deleteButtonXOffsetOld, frame.origin.y, _deleteButton.frame.size.width, cellHeight};
    _deleteButton.indexPath = indexPath;
    
    [UIView animateWithDuration:0.2f animations:^{
        cell.frame = CGRectMake(cellXOffset, frame.origin.y, frame.size.width, frame.size.height);
        _deleteButton.frame = (CGRect) {deleteButtonXOffset, frame.origin.y, _deleteButton.frame.size.width, cellHeight};
    }];
}

#pragma mark - Interaciton
- (void)deleteItem:(id)sender {
    UIButton * deleteButton = (UIButton *)sender;
    NSIndexPath * indexPath = deleteButton.indexPath;
    [self hideUtilityButtonsAnimated:NO];
    
    id dataSource = self.dataSource;
    if ([dataSource respondsToSelector:@selector(tableView:commitDeleteForRowAtIndexPath:)]) {
        [dataSource tableView:self commitDeleteForRowAtIndexPath:indexPath];
    }
    
    _editingIndexPath = nil;
}

- (void)hideUtilityButtonsAnimated:(BOOL)animated;
{
    if(_editingIndexPath)
    {
        UITableViewCell * cell = [self cellForRowAtIndexPath:_editingIndexPath];
        [self setEditing:NO atIndexPath:_editingIndexPath cell:cell];
    }
}

//#pragma mark - UIGestureRecognizerDelegate
//-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    if (gestureRecognizer == self.panGestureRecognizer
//        && _editingIndexPath) {
//        return NO;
//    } else {
//        return YES;
//    }
//}

@end
