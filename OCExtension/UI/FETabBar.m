//
//  FETabBar.m
//  FEFramework
//
//  Created by Tom on 15/1/20.
//  Copyright (c) 2015年 liyy. All rights reserved.
//

#import "FETabBar.h"
#import "FEBadgeLabel.h"
#import "UIView+add.h"
#import "FEPrecompile.h"
//#import "FYThemeKit.h"

#define BADGE_LABEL_TAG 1000

#define BADGE_LABEL_LEFT_OFFSET 8
#define BADGE_LABEL_TOP_OFFSET  2
#define BADGE_LABEL_RIGHT_PADDING   5

@interface FETabBar ()
<
UIGestureRecognizerDelegate
>
/**
 *  设置之前选中的按钮
 */
@property (nonatomic, strong) UIButton *selectedBtn;
@property (nonatomic, strong) NSMutableArray* tabBarItemArray;
@property (nonatomic, strong) UIButton *shortcutsButton;
@property (nonatomic, assign) CGSize shortcutsButtonSize;
@property (nonatomic, strong) UIImageView *bgImgView;

@end

@implementation FETabBar

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    //    frame.origin.y -= 20;
    //    frame.size.height += 20;
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        _bgImgView = [[UIImageView alloc]init];
        _bgImgView.image = UIImageWithName(@"tabbar_bg.png");
        [_bgImgView sizeToFit];
        _bgImgView.frame = CGRectMake(0, self.height - _bgImgView.height, self.width, _bgImgView.height);
        [self addSubview:_bgImgView];
    }
    
    return self;
}

- (void)themeChanged
{
//    if (self.themeMap[kThemeImageNameNomal]) {
//        
//        _bgImgView.image = ThemeImageFormName(self.themeMap[kThemeImageNameNomal]);
//    }
//    
//    [_bgImgView sizeToFit];
//    _bgImgView.frame = CGRectMake(0, self.height - _bgImgView.height, self.width, _bgImgView.height);
}

-(UIButton *)addShortcutsButtonWithTitle:(NSString*)title image:(UIImage *)image selectedImage:(UIImage *) selectedImage
{
    self.shortcutsButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.shortcutsButton setImage:image forState:UIControlStateNormal];
    [self.shortcutsButton setImage:selectedImage forState:UIControlStateSelected];
    [self.shortcutsButton setTitle:title forState:UIControlStateNormal];
    
    _shortcutsButtonSize = image.size;
    
    //带参数的监听方法记得加"冒号"
    [self.shortcutsButton addTarget:self
                             action:@selector(shortcutsButtonClick:)
                   forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.shortcutsButton];
    
    return self.shortcutsButton;
}

-(FETabBarItem *)addButtonWithTitle:(NSString*)title image:(NSString *)image selectedImage:(NSString *) selectedImage;
{
    FETabBarItem *btn = [FETabBarItem buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:10];
    [btn setImage:UIImageWithName(image) forState:UIControlStateNormal];
    [btn setImage:UIImageWithName(selectedImage) forState:UIControlStateSelected];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:self.titleColor forState:UIControlStateNormal];
    [btn setTitleColor:self.titleSelectedColor forState:UIControlStateSelected];
    btn.adjustsImageWhenHighlighted = NO;
    btn.titleButtomOffset = 6;
    
    FEBadgeLabel* _badgeLabel = [[FEBadgeLabel alloc] initWithFrame:CGRectZero];
    _badgeLabel.tag = BADGE_LABEL_TAG;
    [btn addSubview:_badgeLabel];
    
    UITapGestureRecognizer* doubleGestureReconginze = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doulbeTapGestureHandler:)];
    doubleGestureReconginze.delegate = self;
    doubleGestureReconginze.numberOfTapsRequired = 2;
    doubleGestureReconginze.enabled = NO;
    [btn addGestureRecognizer:doubleGestureReconginze];
    
    
    //带参数的监听方法记得加"冒号"
    [btn addTarget:self
            action:@selector(clickBtn:)
  forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:btn];
    
    if (self.tabBarItemArray == nil) {
        self.tabBarItemArray = [NSMutableArray arrayWithCapacity:5];
    }
    
    [self.tabBarItemArray addObject:btn];
    
    //如果是第一个按钮, 则选中(按顺序一个个添加)
    if (self.tabBarItemArray.count == 1)
    {
        [self clickBtn:btn];
    }
    
    return btn;
}

/**专门用来布局子视图, 别忘了调用super方法*/
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSInteger count = [self.tabBarItemArray count];
    UIButton *btn = nil;
    CGFloat width = 0;
    CGFloat height = self.bounds.size.height;
    
    if (self.shortcutsButton)
    {
        width = (self.bounds.size.width - _shortcutsButtonSize.width)/count;
        self.shortcutsButton.frame = CGRectMake((self.width-_shortcutsButtonSize.width)*0.5, (self.height-_shortcutsButtonSize.height)*0.5, width, _shortcutsButtonSize.height);
        
        NSInteger midCount = count/2;
        for (NSInteger i = 0; i < count; ++i)
        {
            //取得按钮
            btn = self.tabBarItemArray[i];
            btn.tag = i;
            CGFloat x = 0;
            if (i <= (midCount - 1))
            {
                x = i * width;
            }
            else
            {
                x = self.width - (count-i)*width;
            }
            
            btn.frame = CGRectMake(x, 0, width, height);
        }
    }
    else
    {
        CGFloat width = self.bounds.size.width/count;
        for (NSInteger i = 0; i < count; ++i)
        {
            //取得按钮
            btn = self.tabBarItemArray[i];
            btn.tag = i;
            CGFloat x = i * width;
            
            btn.frame = CGRectMake(x, 2, width, height);
            
            FEBadgeLabel* badgeLabel = (FEBadgeLabel*)[btn viewWithTag:BADGE_LABEL_TAG];
            CGFloat left = btn.width*0.5 + BADGE_LABEL_LEFT_OFFSET;
            CGFloat top = BADGE_LABEL_TOP_OFFSET;
            
            CGRect frame  = CGRectMake(left, top, badgeLabel.width, badgeLabel.height);

            if (i == (count - 1)) { //最后一个要解决超出view的情况
                CGFloat padding = self.width - BADGE_LABEL_RIGHT_PADDING - (btn.left + left + badgeLabel.width);
                if (padding < 0) {
                    frame.origin.x += padding;
                }
            }
            
            badgeLabel.frame = frame;
        }
        
    }
    
    
}

-(void)setBadgeValue:(NSInteger)badgeValue index:(NSInteger)index
{
    if (index >= 0
        && index < [_tabBarItemArray count])
    {
        FETabBarItem* barItem = (FETabBarItem*)_tabBarItemArray[index];
        FEBadgeLabel* badgeLabel = (FEBadgeLabel*)[barItem viewWithTag:BADGE_LABEL_TAG];
        badgeLabel.value = badgeValue;
        
        [self setNeedsLayout];
        
    }
}

-(void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (_selectedIndex != selectedIndex)
    {
        if (selectedIndex >= 0
            && selectedIndex < [_tabBarItemArray count])
        {
            UIGestureRecognizer *gestureRecognizer = [[self.selectedBtn gestureRecognizers] lastObject];
            if (gestureRecognizer) {
                gestureRecognizer.enabled = NO;
            }
            
            UIButton* button = _tabBarItemArray[selectedIndex];
            //1.先将之前选中的按钮设置为未选中
            self.selectedBtn.selected = NO;
            //2.再将当前按钮设置为选中
            button.selected = YES;
            //3.最后把当前按钮赋值为之前选中的按钮
            self.selectedBtn = button;
            _selectedIndex = selectedIndex;
            
            gestureRecognizer = [[self.selectedBtn gestureRecognizers] lastObject];
            if (gestureRecognizer) {
                gestureRecognizer.enabled = YES;
            }
        }
    }
}

/**
 *  自定义TabBar的按钮点击事件
 */
- (void)clickBtn:(UIButton *)button {
    //1.先将之前选中的按钮设置为未选中
    
    if (self.selectedBtn == button) {
        if ([self.delegate respondsToSelector:@selector(tabBar:selectedFrom:to:)])
        {
            [self.delegate tabBar:self selectedFrom:self.selectedBtn.tag to:_selectedIndex];
        }
    } else {
        self.selectedBtn.selected = NO;
        
        UIGestureRecognizer *gestureRecognizer = [[self.selectedBtn gestureRecognizers] lastObject];
        if (gestureRecognizer) {
            gestureRecognizer.enabled = NO;
        }
        
        //2.再将当前按钮设置为选中
        button.selected = YES;
        //3.最后把当前按钮赋值为之前选中的按钮
        self.selectedBtn = button;
        _selectedIndex = button.tag;
        
        if ([self.delegate respondsToSelector:@selector(tabBar:selectedFrom:to:)])
        {
            [self.delegate tabBar:self selectedFrom:self.selectedBtn.tag to:_selectedIndex];
        }
        
        gestureRecognizer = [[self.selectedBtn gestureRecognizers] lastObject];
        if (gestureRecognizer) {
            gestureRecognizer.enabled = YES;
        }
    }
}

-(void)shortcutsButtonClick:(FETabBarItem*)sender
{
    if ([self.delegate respondsToSelector:@selector(tabBar:shortcutsButtonTouched:)])
    {
        [self.delegate tabBar:self shortcutsButtonTouched:self.shortcutsButton];
    }
}

#pragma mark -
- (void)doulbeTapGestureHandler:(UIGestureRecognizer *)gestureRecognizer
{
    if ([self.delegate respondsToSelector:@selector(tabBar:doubleSelected:)]) {
        [self.delegate tabBar:self doubleSelected:self.selectedIndex];
    }
}

@end
