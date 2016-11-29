//
//  FEPageMenuView.h
//
//
//  Created by ios on 15/11/9.
//
//

#import "FEPageMenuView.h"
#import "FEPageMenuItem.h"
#import "FEPageProgressView.h"
#import "FEPageFooldView.h"
//#import "UIImage+add.h"
#import "UIView+add.h"
#import "FEPrecompile.h"

#define kItemWidth          60
#define kItemWidthOffset    20
#define kTagGap             6250
#define kBGColor            [UIColor colorWithRed:172.0/255.0 green:165.0/255.0 blue:162.0/255.0 alpha:1.0]

#define kExtentViewWidthOffset     5

@interface FEPageMenuView () <FEPageMenuItemDelegate> {
    CGFloat _norSize;
    CGFloat _selSize;
    UIColor *_norColor;
    UIColor *_selColor;
}

@property (nonatomic, weak)     UIScrollView        *scrollView;
@property (nonatomic, weak)     FEPageProgressView  *progressView;
@property (nonatomic, weak)     FEPageMenuItem      *selItem;
@property (nonatomic, strong)   UIColor             *bgColor;
@property (nonatomic, strong)   NSMutableArray      *frameArray;
@property (nonatomic, strong)   UIView              *extentView;
@end

// 下划线的高度
static CGFloat const FEPageProgressHeight = 2.0;

@implementation FEPageMenuView

#pragma mark - Lazy
- (CGFloat)progressHeight {
    if (_progressHeight == 0.0) {
        _progressHeight = FEPageProgressHeight;
    }
    return _progressHeight;
}

- (UIColor *)lineColor {
    if (!_lineColor) {
        _lineColor = _selColor;
    }
    return _lineColor;
}

- (NSMutableArray *)frameArray {
    if (_frameArray == nil) {
        _frameArray = [NSMutableArray array];
    }
    return _frameArray;
}

#pragma mark - Public Methods
- (instancetype)initWithFrame:(CGRect)frame
              backgroundColor:(UIColor *)bgColor
                      norSize:(CGFloat)norSize
                      selSize:(CGFloat)selSize
                     norColor:(UIColor *)norColor
                     selColor:(UIColor *)selColor {
    if (self = [super initWithFrame:frame]) {

        if (bgColor) {
            _bgColor = bgColor;
        } else {
            _bgColor = kBGColor;
        }
        _norSize  = norSize;
        _selSize  = selSize;
        _norColor = norColor;
        _selColor = selColor;

    }
    return self;
}

- (void)slideMenuAtProgress:(CGFloat)progress {
    if (self.progressView) {
        self.progressView.progress = progress;
    }
    NSInteger tag = (NSInteger)progress + kTagGap;
    CGFloat rate = progress - tag + kTagGap;
    FEPageMenuItem *currentItem = (FEPageMenuItem *)[self viewWithTag:tag];
    FEPageMenuItem *nextItem = (FEPageMenuItem *)[self viewWithTag:tag+1];
    if (rate == 0.0) {
        self.selItem.rate = 0;
        [self.selItem deselectedItemWithoutAnimation];
        self.selItem = currentItem;
        self.selItem.rate = 1;
        [self.selItem selectedItemWithoutAnimation];
        [self refreshContenOffsetAnimated:YES];
        return;
    }
    currentItem.rate = 1-rate;
    nextItem.rate = rate;
}

- (void)selectItemAtIndex:(NSInteger)index {
    [self selectItemAtIndex:index animated:NO];
}

- (void)selectItemAtIndex:(NSInteger)index animated:(BOOL)animated
{
    NSInteger tag = index + kTagGap;
    NSInteger currentIndex = self.selItem.tag - kTagGap;
    FEPageMenuItem *item = (FEPageMenuItem *)[self viewWithTag:tag];
    [self.selItem deselectedItemWithoutAnimation];
    self.selItem = item;
    [self.selItem selectedItemWithoutAnimation];
    [self.progressView setProgressWithOutAnimate:index];
    if ([self.delegate respondsToSelector:@selector(menuView:didSelesctedIndex:currentIndex:)]) {
        [self.delegate menuView:self didSelesctedIndex:index currentIndex:currentIndex];
    }
    
    [self refreshContenOffsetAnimated:animated];
}

- (void)reloadData
{
    [self removeAllSubviews];
    self.scrollView = nil;
    self.extentView = nil;
    
    _menuCount = 0;
    
    if ([_dataSource respondsToSelector:@selector(numberOfMenusInMenuView:)]) {
        _menuCount = [_dataSource numberOfMenusInMenuView:self];
    }
    
    if ([_dataSource respondsToSelector:@selector(extendViewForMenu)]) {
        self.extentView = [_dataSource extendViewForMenu];
    }
    
    [self addScrollView];
    [self addItems];
    [self makeStyle];
}

#pragma mark - Private Methods
// 有没更好地命名
- (void)makeStyle {
    switch (self.style) {
        case FEPageMenuViewStyleLine:
            [self addProgressView];
            break;
        case FEPageMenuViewStyleFoold:
            [self addFooldViewHollow:NO];
            break;
        case FEPageMenuViewStyleFooldHollow:
            [self addFooldViewHollow:YES];
            break;
        default:
            break;
    }
}

// 让选中的item位于中间
- (void)refreshContenOffset {
    
    [self refreshContenOffsetAnimated:NO];
}

- (void)refreshContenOffsetAnimated:(BOOL)animated
{
    CGRect frame = self.selItem.frame;
    CGFloat itemX = frame.origin.x;
    CGFloat width = self.scrollView.frame.size.width;
    CGSize contentSize = self.scrollView.contentSize;
    if (itemX > width/2) {
        CGFloat targetX;
        if ((contentSize.width-itemX) <= width/2) {
            targetX = contentSize.width - width;
        } else {
            targetX = frame.origin.x - width/2 + frame.size.width/2;
        }
        // 应该有更好的解决方法
        if (targetX + width > contentSize.width) {
            targetX = contentSize.width - width;
        }
        
        if (targetX < 0) {
            targetX = 0;
        }
        
        [self.scrollView setContentOffset:CGPointMake(targetX, 0) animated:animated];
    } else {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:animated];
    }
}

- (void)addScrollView {
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    if (self.extentView) {
        width -= self.extentView.width;
    }

    CGRect frame = CGRectMake(0, 0, width + kExtentViewWidthOffset, height);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator   = NO;
    scrollView.backgroundColor = self.bgColor;
    scrollView.scrollsToTop = NO;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    if (self.extentView) {
        self.extentView.origin = CGPointMake(width, MID(self.height-self.extentView.height));
        [self addSubview:self.extentView];
    }
}

- (void)addItems {
    
    CGFloat contentWidth = self.itemMargin;
    for (int i = 0; i < _menuCount; i++) {

        FEPageMenuItem *item = [[FEPageMenuItem alloc] initWithFrame:CGRectZero];
        item.tag = (i+kTagGap);
        item.delegate = self;
        
        NSString *title = nil;
        if ([_dataSource respondsToSelector:@selector(menuView:titleForMenuAtIndex:)]) {
            title = [_dataSource menuView:self titleForMenuAtIndex:i];
        }
        
        item.text = title;
        item.textAlignment = NSTextAlignmentCenter;
        item.textColor = _norColor;
        item.userInteractionEnabled = YES;
        if (self.fontName) {
            item.font = [UIFont fontWithName:self.fontName size:_selSize];
        } else {
            item.font = [UIFont systemFontOfSize:_selSize];
        }
        
        item.backgroundColor = [UIColor clearColor];
        item.normalSize    = _norSize;
        item.selectedSize  = _selSize;
        item.normalColor   = _norColor;
//        item.selectedColor = _selColor;
//        item.themeMap = @{kThemeMenuItemSelectedColor:@"kThemeNewsMenuSelectedColor"};
        if (i == 0) {
            [item selectedItemWithoutAnimation];
            self.selItem = item;
        } else {
            [item deselectedItemWithoutAnimation];
        }
        [self.scrollView addSubview:item];
        
        [item sizeToFit];
        CGFloat itemW = floor(item.frame.size.width) + kItemWidthOffset;
        if (itemW < kItemWidth) {
            itemW = kItemWidth;
        }
        
        CGRect frame = CGRectMake(contentWidth, 0, itemW, self.frame.size.height);
        item.frame = frame;
        // 记录frame
        [self.frameArray addObject:[NSValue valueWithCGRect:frame]];
        
        contentWidth += itemW + self.itemMargin;
    }
    
    
    // 如果总宽度小于屏幕宽,重新计算frame,为item间添加间距
    if (contentWidth < self.scrollView.width) {
        self.scrollView.scrollEnabled = NO;
    } else {
        self.scrollView.scrollEnabled = YES;
    }
    
    self.scrollView.contentSize = CGSizeMake(contentWidth, self.frame.size.height);
}

// MARK:Progress View
- (void)addProgressView {
    FEPageProgressView *pView = [[FEPageProgressView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - self.progressHeight, self.scrollView.contentSize.width, self.progressHeight)];
    pView.itemFrameArray = self.frameArray;
    pView.color = self.lineColor.CGColor;
    pView.backgroundColor = [UIColor clearColor];
    self.progressView = pView;
    [self.scrollView addSubview:pView];
}

- (void)addFooldViewHollow:(BOOL)isHollow {
    FEPageFooldView *fooldView = [[FEPageFooldView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.contentSize.width, self.frame.size.height)];
    fooldView.itemFrameArray = self.frameArray;
    fooldView.color = self.lineColor.CGColor;
    fooldView.hollow = isHollow;
    fooldView.backgroundColor = [UIColor clearColor];
    self.progressView = fooldView;
    [self.scrollView insertSubview:fooldView atIndex:0];
}

#pragma mark - Menu item delegate
- (void)didPressedMenuItem:(FEPageMenuItem *)menuItem {
    if (self.selItem == menuItem)
    {
     if ([self.delegate respondsToSelector:@selector(menuView:didSelectedSameIndex:)])
     {
        [self.delegate menuView:self didSelectedSameIndex:menuItem.tag-kTagGap ];
     }
      return;
    }
    NSLog(@"self.selItem.color = %@",self.selItem.selectedColor);
    CGFloat progress = menuItem.tag - kTagGap;
    [self.progressView moveToPostion:progress];
    
    NSInteger currentIndex = self.selItem.tag - kTagGap;
    if ([self.delegate respondsToSelector:@selector(menuView:didSelesctedIndex:currentIndex:)]) {
        [self.delegate menuView:self didSelesctedIndex:menuItem.tag-kTagGap currentIndex:currentIndex];
    }
    
    menuItem.selected = YES;
    self.selItem.selected = NO;
    self.selItem = menuItem;
    // 让选中的item位于中间
    [self refreshContenOffsetAnimated:YES];
}

@end
