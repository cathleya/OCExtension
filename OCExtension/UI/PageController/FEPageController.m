//
//  FEPageController.m
//  
//
//  Created by ios on 15/11/9.
//
//

#import "FEPageController.h"
#import "FEPageControllerConst.h"
#import "FENavigationController.h"
#import "UIView+add.h"
#import "FEPrecompile.h"

@interface FEPageController ()
<FEPageMenuViewDelegate
, FEPageMenuViewDataSource
, UIScrollViewDelegate
>
{
    CGFloat _viewHeight;
    CGFloat _viewWidth;
    CGFloat _viewX;
    CGFloat _viewY;
    CGFloat _targetX;
    BOOL    _animate;
    BOOL    _hasInitView;
}
@property (nonatomic, strong, readwrite) UIViewController *currentViewController;
// 用于记录子控制器view的frame，用于 scrollView 上的展示的位置
@property (nonatomic, strong) NSMutableArray *childViewFrameArray;
// 当前展示在屏幕上的控制器，方便在滚动的时候读取 (避免不必要计算)
@property (nonatomic, strong) NSMutableDictionary *displayVC;
// 用于记录销毁的viewController的位置 (如果它是某一种scrollView的Controller的话)
@property (nonatomic, strong) NSMutableDictionary *posRecordArray;
// 用于缓存加载过的控制器
@property (nonatomic, strong) NSCache *memCache;

@property (nonatomic, assign) NSInteger numberOfPages;

@end

@implementation FEPageController

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Lazy Loading
- (NSMutableDictionary *)posRecordArray {
    if (_posRecordArray == nil) {
        _posRecordArray = [[NSMutableDictionary alloc] init];
    }
    return _posRecordArray;
}

- (NSMutableDictionary *)displayVC {
    if (_displayVC == nil) {
        _displayVC = [[NSMutableDictionary alloc] init];
    }
    return _displayVC;
}

#pragma mark - Public Methods
- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    [self setSelectIndex:selectIndex animated:NO];
}

- (void)setSelectIndex:(NSInteger)selectIndex animated:(BOOL)animated
{
    _selectIndex = selectIndex;
    
    if (self.menuView) {
        [self.menuView selectItemAtIndex:selectIndex];
    } else {
        _animate = NO;
        CGPoint targetPoint = CGPointMake(_viewWidth * _selectIndex, 0);
        [self.scrollView setContentOffset:targetPoint animated:animated];
        if (!animated) {
            [self layoutChildViewControllers];
            self.currentViewController = self.displayVC[@(self.selectIndex)];
            
            for (int i = 0; i<[self.displayVC.allKeys count]; i++)
            {
                if ([self.displayVC.allKeys[i] integerValue]!=self.selectIndex)
                {
                    UIViewController *vc = [self.displayVC objectForKey:self.displayVC.allKeys[i]];
                    
                    [self removeViewController:vc  atIndex:[self.displayVC.allKeys[i] integerValue]];
                }
            }
            
            [self postFullyDisplayedNotificationWithCurrentIndex:(int)index];
        }
    }
}

#pragma mark - Private Methods

// 当子控制器init完成时发送通知
- (void)postAddToSuperViewNotificationWithIndex:(NSInteger)index {
    if (!self.postNotification) return;
    NSDictionary *info = @{
                           @"index":@(index),
                           };
    [[NSNotificationCenter defaultCenter] postNotificationName:FEPageControllerDidAddToSuperViewNotification
                                                        object:info];
}

// 当子控制器完全展示在user面前时发送通知
- (void)postFullyDisplayedNotificationWithCurrentIndex:(NSInteger)index {
    if (!self.postNotification) return;
    NSDictionary *info = @{
                           @"index":@(index),
                           };
    [[NSNotificationCenter defaultCenter] postNotificationName:FEPageControllerDidFullyDisplayedNotification
                                                        object:info];
}

// 初始化一些参数，在init中调用
- (void)setup {
    
    self.hidesBottomBarWhenPushed = YES;
    _titleSizeSelected  = FETitleSizeSelected;
    _titleColorSelected = FETitleColorSelected;
    _titleSizeNormal    = FETitleSizeNormal;
    _titleColorNormal   = FETitleColorNormal;
    
    _menuBGColor   = FEMenuBGColor;
    _menuHeight    = FEMenuHeight;    
    _memCache = [[NSCache alloc] init];
}

- (void)reloadData
{
    [self.memCache removeAllObjects];
    [self.displayVC removeAllObjects];
    [self.posRecordArray removeAllObjects];
    
    [self.scrollView removeAllSubviews];
    
    if (self.currentViewController) {
        [self.currentViewController willMoveToParentViewController:nil];
        [self.currentViewController removeFromParentViewController];
        [self.currentViewController didMoveToParentViewController:nil];
        self.currentViewController = nil;
    }
    
    self.numberOfPages = 0;
    if ([_dataSource respondsToSelector:@selector(numberOfPagesInPageController:)]) {
        self.numberOfPages = [_dataSource numberOfPagesInPageController:self];
    }
    
    [self calculateSize];
    
    if (self.showMenu) {
        self.menuView.frame = CGRectMake(0, 0, _viewWidth, self.menuHeight);
        [self.menuView reloadData];
    }
    
    self.scrollView.frame = CGRectMake(_viewX, _viewY, _viewWidth, _viewHeight);
    
    self.scrollView.contentSize = CGSizeMake(self.numberOfPages * _viewWidth, _viewHeight);
    
    [self setSelectIndex:_selectIndex animated:NO];
}

// 包括宽高，子控制器视图 frame
- (void)calculateSize {
    _viewWidth = self.viewFrame.size.width;
    _viewX = 0;
    if (self.showMenu) {
        _viewHeight = self.viewFrame.size.height - self.menuHeight;
        _viewY = self.menuHeight;
    } else {
        _viewHeight = self.viewFrame.size.height;
    }
    
    // 重新计算各个控制器视图的宽高
    _childViewFrameArray = [NSMutableArray array];
    
    for (int i = 0; i < self.numberOfPages; i++) {
        CGRect frame = CGRectMake(i*_viewWidth, 0, _viewWidth, _viewHeight);
        [_childViewFrameArray addObject:[NSValue valueWithCGRect:frame]];
    }
}

- (void)addScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    
    scrollView.pagingEnabled = YES;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.delegate = self;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.scrollsToTop = NO;
    scrollView.clipsToBounds = NO;
    
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    UINavigationController *navController = self.navigationController;
    if ([navController isKindOfClass:[FENavigationController class]]) {
        UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer = [(FENavigationController*)navController screenEdgePanGestureRecognizer];
        [_scrollView.panGestureRecognizer requireGestureRecognizerToFail:screenEdgePanGestureRecognizer];
    }

}

- (void)addMenuView {
    CGRect frame = CGRectMake(0, 0, _viewWidth, self.menuHeight);
    
    FEPageMenuView *menuView = [[FEPageMenuView alloc] initWithFrame:frame
                                                     backgroundColor:self.menuBGColor
                                                             norSize:self.titleSizeNormal
                                                             selSize:self.titleSizeSelected
                                                            norColor:self.titleColorNormal
                                                            selColor:self.titleColorSelected];
    menuView.delegate = self;
    menuView.dataSource = self;
    menuView.style = self.menuViewStyle;
    menuView.progressHeight = self.progressHeight;
    menuView.itemMargin = self.itemMargin;
    if (self.titleFontName) {
        menuView.fontName = self.titleFontName;
    }
    if (self.progressColor) {
        menuView.lineColor = self.progressColor;
    }
    [self.view addSubview:menuView];
    self.menuView = menuView;
    if (IOS8_OR_LATER)
    {
        UIVisualEffectView *visualEffect = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
        
        CGRect frame = _menuView.bounds;
        frame.size.width = SCREEN_WIDTH;
        visualEffect.frame = frame;
        visualEffect.backgroundColor = [UIColor whiteColor];
        visualEffect.alpha = 0.8;
        [self.view addSubview:visualEffect];
        [self.view bringSubviewToFront:_menuView];
    }
}

- (void)layoutChildViewControllers {
    
    NSInteger numberOfPages = self.numberOfPages;
    
    int currentPage = (int)self.scrollView.contentOffset.x / _viewWidth;
    int start = currentPage == 0 ? currentPage : (currentPage - 1);
    
    int end = (currentPage == numberOfPages - 1) ? currentPage : (currentPage + 1);
    for (int i = start; i <= end; i++) {
        CGRect frame = [self.childViewFrameArray[i] CGRectValue];
        UIViewController *vc = [self.displayVC objectForKey:@(i)];
        if ([self isInScreen:frame]) {
            if (vc == nil) {
                // 先从 cache 中取
                vc = [self.memCache objectForKey:@(i)];
                if (vc) {
                    // cache 中存在，添加到 scrollView 上，并放入display
                    [self addCachedViewController:vc atIndex:i];
                } else {
                    // cache 中也不存在，创建并添加到display
                    [self addViewControllerAtIndex:i];
                }
                [self postAddToSuperViewNotificationWithIndex:i];
            }
        } else {
            if (vc) {
                // vc不在视野中且存在，移除他
                [self removeViewController:vc atIndex:i];
            }
        }
    }
}

- (void)addCachedViewController:(UIViewController *)viewController atIndex:(NSInteger)index {
    viewController.view.frame = [self.childViewFrameArray[index] CGRectValue];
    [viewController willMoveToParentViewController:self];
    [self addChildViewController:viewController];
    [self.scrollView addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];

    [self.displayVC setObject:viewController forKey:@(index)];
}

// 添加子控制器
- (void)addViewControllerAtIndex:(NSInteger)index {
    
    UIViewController *viewController = nil;
    if ([_dataSource respondsToSelector:@selector(pageController:viewControllerAtIndex:)]) {
        viewController = [_dataSource pageController:self viewControllerAtIndex:index];
    }
    
    if (viewController == nil) {
        viewController = [[UIViewController alloc] init];
    }

    [viewController willMoveToParentViewController:self];
    [self addChildViewController:viewController];
    viewController.view.frame = [self.childViewFrameArray[index] CGRectValue];
    [self.scrollView addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
    
    [self.displayVC setObject:viewController forKey:@(index)];
    
    [self backToPositionIfNeeded:viewController atIndex:index];
}

// 移除控制器，且从display中移除
- (void)removeViewController:(UIViewController *)viewController atIndex:(NSInteger)index {
    [self rememberPositionIfNeeded:viewController atIndex:index];
    [viewController willMoveToParentViewController:nil];
    [viewController.view removeFromSuperview];
    [viewController removeFromParentViewController];
    [viewController didMoveToParentViewController:nil];
    
    [self.displayVC removeObjectForKey:@(index)];
    
    // 放入缓存
    if (![self.memCache objectForKey:@(index)]) {
        [self.memCache setObject:viewController forKey:@(index)];
    }
}

- (void)backToPositionIfNeeded:(UIViewController *)controller atIndex:(NSInteger)index {
    if ([self.memCache objectForKey:@(index)]) return;
    UIScrollView *scrollView = [self isKindOfScrollViewController:controller];
    if (scrollView) {
        NSValue *pointValue = self.posRecordArray[@(index)];
        if (pointValue) {
            CGPoint pos = [pointValue CGPointValue];
            // 奇怪的现象，我发现 collectionView 的 contentSize 是 {0, 0};
            [scrollView setContentOffset:pos];
        }
    }
}

- (void)rememberPositionIfNeeded:(UIViewController *)controller atIndex:(NSInteger)index {
    UIScrollView *scrollView = [self isKindOfScrollViewController:controller];
    if (scrollView) {
        CGPoint pos = scrollView.contentOffset;
        self.posRecordArray[@(index)] = [NSValue valueWithCGPoint:pos];
    }
}

- (UIScrollView *)isKindOfScrollViewController:(UIViewController *)controller {
    UIScrollView *scrollView = nil;
    if ([controller.view isKindOfClass:[UIScrollView class]]) {
        // Controller的view是scrollView的子类(UITableViewController/UIViewController替换view为scrollView)
        scrollView = (UIScrollView *)controller.view;
    } else if (controller.view.subviews.count >= 1) {
        // Controller的view的subViews[0]存在且是scrollView的子类，并且frame等与view得frame(UICollectionViewController/UIViewController添加UIScrollView)
        UIView *view = controller.view.subviews[0];
        if ([view isKindOfClass:[UIScrollView class]]) {
            scrollView = (UIScrollView *)view;
        }
    }
    return scrollView;
}

- (BOOL)isInScreen:(CGRect)frame {
    CGFloat x = frame.origin.x;
    CGFloat ScreenWidth = self.scrollView.frame.size.width;
    
    CGFloat contentOffsetX = self.scrollView.contentOffset.x;
    if (CGRectGetMaxX(frame) > contentOffsetX && x-contentOffsetX < ScreenWidth) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!_hasInitView) {
        _hasInitView = YES;
        
        self.numberOfPages = 0;
        if ([_dataSource respondsToSelector:@selector(numberOfPagesInPageController:)]) {
            self.numberOfPages = [_dataSource numberOfPagesInPageController:self];
        }
        
        // 计算宽高及子控制器的视图frame
        [self calculateSize];
        
        [self addScrollView];
        
        if (self.showMenu) {
            [self addMenuView];
            
            [self.menuView reloadData];
        }
        
        CGRect scrollFrame = CGRectMake(_viewX, _viewY, _viewWidth, _viewHeight);
        self.scrollView.frame = scrollFrame;
        
        
        self.scrollView.contentSize = CGSizeMake(self.numberOfPages * _viewWidth, _viewHeight);
        [self.scrollView setContentOffset:CGPointMake(self.selectIndex * _viewWidth, 0)];
        
        self.currentViewController.view.frame = [self.childViewFrameArray[self.selectIndex] CGRectValue];
        
        if (self.selectIndex == 0) {
            [self addViewControllerAtIndex:self.selectIndex];
        }
        
        self.currentViewController = self.displayVC[@(self.selectIndex)];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self postFullyDisplayedNotificationWithCurrentIndex:self.selectIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self.memCache removeAllObjects];
    
//    if (self.isViewLoaded && !self.view.window) {
//        _hasInitView = NO;
//        self.view = nil;
//    }

}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self layoutChildViewControllers];
    if (_animate) {
        CGFloat contentOffsetX = scrollView.contentOffset.x;
        if (contentOffsetX < 0) {
            contentOffsetX = 0;
        }
        if (contentOffsetX > scrollView.contentSize.width - _viewWidth) {
            contentOffsetX = scrollView.contentSize.width - _viewWidth;
        }
        CGFloat rate = contentOffsetX / _viewWidth;
        [self.menuView slideMenuAtProgress:rate];
        
        if ([_delegate respondsToSelector:@selector(pageController:slideProgress:)]) {
            [_delegate pageController:self slideProgress:rate];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _animate = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _selectIndex = (NSInteger)scrollView.contentOffset.x / _viewWidth;
    self.currentViewController = self.displayVC[@(self.selectIndex)];
    [self postFullyDisplayedNotificationWithCurrentIndex:self.selectIndex];
    
    if ([_delegate respondsToSelector:@selector(pageController:selectedIndex:)]) {
        [_delegate pageController:self selectedIndex:_selectIndex];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.currentViewController = self.displayVC[@(self.selectIndex)];
    [self postFullyDisplayedNotificationWithCurrentIndex:self.selectIndex];
    
    for (int i = 0; i<[self.displayVC.allKeys count]; i++)
    {
        if ([self.displayVC.allKeys[i] integerValue]!=self.selectIndex)
        {
            UIViewController *vc = [self.displayVC objectForKey:self.displayVC.allKeys[i]];
            
            [self removeViewController:vc  atIndex:[self.displayVC.allKeys[i] integerValue]];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        CGFloat rate = _targetX / _viewWidth;
        [self.menuView slideMenuAtProgress:rate];
        
        if ([_delegate respondsToSelector:@selector(pageController:slideProgress:)]) {
            [_delegate pageController:self slideProgress:rate];
        }
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    _targetX = targetContentOffset->x;
}

#pragma mark - FEPageMenuView Delegate

- (NSInteger)numberOfMenusInMenuView:(FEPageMenuView *)menu
{
    return self.numberOfPages;
}

- (NSString *)menuView:(FEPageMenuView *)menu titleForMenuAtIndex:(NSInteger)index
{
    NSString* title = nil;
    if ([_dataSource respondsToSelector:@selector(pageController:titleForMenuAtIndex:)]) {
        title = [_dataSource pageController:self titleForMenuAtIndex:index];
    }
    
    return title;
}

//扩展view
- (UIView *)extendViewForMenu
{
    UIView *view = nil;
    if ([_dataSource respondsToSelector:@selector(extendViewForMenu:viewHeight:)]) {
        view = [_dataSource extendViewForMenu:self viewHeight:self.menuHeight];
    }
    
    return view;
}

- (void)menuView:(FEPageMenuView *)menu didSelesctedIndex:(NSInteger)index currentIndex:(NSInteger)currentIndex {
    NSInteger gap = (NSInteger)labs(index - currentIndex);
    _selectIndex = index;
    _animate = NO;
    CGPoint targetP = CGPointMake(_viewWidth*index, 0);
    BOOL animated = gap > 1 ? NO : self.pageAnimatable;
    [self.scrollView setContentOffset:targetP animated:animated];
    if (!animated) {
        // 由于不触发 -scrollViewDidScroll: 手动处理控制器
        [self layoutChildViewControllers];
        self.currentViewController = self.displayVC[@(self.selectIndex)];
        
        for (int i = 0; i<[self.displayVC.allKeys count]; i++)
        {
            if ([self.displayVC.allKeys[i] integerValue]!=self.selectIndex)
            {
                UIViewController *vc = [self.displayVC objectForKey:self.displayVC.allKeys[i]];

                [self removeViewController:vc  atIndex:[self.displayVC.allKeys[i] integerValue]];
            }
        }
        [self postFullyDisplayedNotificationWithCurrentIndex:(int)index];
    }
    
    if ([_delegate respondsToSelector:@selector(pageController:selectedIndex:)]) {
        [_delegate pageController:self selectedIndex:_selectIndex];
    }
}

- (void)menuView:(FEPageMenuView *)menu didSelectedSameIndex:(NSInteger)index
{
    if ([_delegate respondsToSelector:@selector(pageController:selectedSameIndex:)]) {
        [_delegate pageController:self selectedSameIndex:_selectIndex];
    }
}
@end
