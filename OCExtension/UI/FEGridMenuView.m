
#import "FEGridMenuView.h"
#import "UIView+add.h"
#import "FEPrecompile.h"

#define PADDING 20

@implementation FEGridMenuView

//必须指定frame的width, 其它可以设置为0， 调用updateLayout后可以获取实际frame

- (id)initWithFrame:(CGRect)frame itemSize:(CGSize)size
{
    self = [self initWithFrame:frame];
    if (self)
    {
        _itemSize = size;
        _iColumnCount = 4;
        _rowPadding = PADDING;
    }
    
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _itemSize = CGSizeZero;
        self.backgroundColor = [UIColor clearColor];
        _menuItemArray = [[NSMutableArray alloc]initWithCapacity:8];
    }
    
    return self;
}

-(void)dealloc
{
}

-(void)setIColumnCount:(NSInteger)iColumnCount
{
    _iColumnCount = iColumnCount;
}

-(FEMenuButton *)addMenuIcon:(UIImage*)image title:(NSString*)title
{
    FEMenuButton* button = [[FEMenuButton alloc]initWithFrame:CGRectZero];
    button.contentOffset = 5;
    button.backgroundColor = [UIColor clearColor];
    [button setTitleColor:RGBHEX(0x666666) forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(menuItemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_menuItemArray addObject:button];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:button];

    return button;
}

-(void)removeMenuAtIndex:(NSInteger)index
{
    if (index >= 0
        && index < [_menuItemArray count])
    {
        FEMenuButton* button = (FEMenuButton*)[_menuItemArray objectAtIndex:index];
        [button removeFromSuperview];
        [_menuItemArray removeObjectAtIndex:index];
    }
}

-(void)setItemEnable:(BOOL)bEnable index:(NSInteger)index
{
    if (index >= 0
        && index < [_menuItemArray count])
    {
        FEMenuButton* button = (FEMenuButton*)[_menuItemArray objectAtIndex:index];
        button.enabled = bEnable;
    }
}

-(void)updateLayout
{
    FEMenuButton* button = nil;
    NSInteger iLeft = 0;
    NSInteger iTop = 0;
    NSInteger iColCount = _iColumnCount;
    NSInteger iWidth = 0;
    NSInteger iHeight = 0;
    NSInteger iPadding = PADDING;
    
    if (CGSizeEqualToSize(_itemSize, CGSizeZero))
    {
        iWidth = (self.width-PADDING*(iColCount+1))/iColCount;
        iHeight = iWidth;
    }
    else
    {
        iWidth = _itemSize.width;
        iHeight = _itemSize.height;
        iPadding = (self.width-iWidth*iColCount)/(iColCount+1);
    }
    
    for (int i = 0; i < [_menuItemArray count]; ++i)
    {
        iLeft = (iWidth+iPadding) * (i % iColCount) + iPadding;
        iTop = (iHeight+_rowPadding) * (i / iColCount);
        button = [_menuItemArray objectAtIndex:i];
        button.tag = i;
        button.frame = CGRectMake(iLeft, iTop, iWidth, iHeight);     
    }
    self.frame = CGRectMake(self.left, self.top, self.width, iTop+iHeight);
}

#pragma mark - private
-(void)menuItemButtonClick:(UIButton*)sender
{
    if ([self.delegate respondsToSelector:@selector(gridMenuView:itemSelected:)])
    {
        [self.delegate gridMenuView:self itemSelected:[sender tag]];
    }
}

@end
