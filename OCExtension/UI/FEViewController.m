//
//  FEViewController.m
//  FEFramework
//
//  Created by Tom on 15/1/20.
//  Copyright (c) 2015年 liyy. All rights reserved.
//

#import "FEViewController.h"
#import "FETableViewController.h"
#import "FESandbox.h"
#import "FEPrecompile.h"
//#import "FEEncrypt.h"
#import "NSDate+add.h"
#import "UIView+add.h"

#define kViewControllerCacheTime @"kCacheTime" //界面缓存时间戳

@interface FEViewController ()

@end

@implementation FEViewController

+(instancetype)VC
{
    return [[[self class] alloc] init];
}

-(BOOL)prefersStatusBarHidden
{
    return self.hideStatusBar;
}
- (BOOL)shouldAutorotate
{
    return NO;
}

-(BOOL)screenEdgePanGestureRecognizerShouldBegin
{
    return YES;
}

-(void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
#ifdef DEBUG
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
#endif
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    //>=7.0
    CGFloat y = 0;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.topOffset = 20;
        
        if (self.navigationController
            && !self.hideNavBar)
        {
            y += self.navigationController.navigationBar.frame.size.height;
            
            if ([self prefersStatusBarHidden] == NO)
            {
                y += 20;
            }
        }
    }
    else
    {
        self.topOffset = 0;
        if (self.hideStatusBar == NO)
        {
            y += 20;
        }
        
        if (self.navigationController
            && !self.hideNavBar)
        {
            y += self.navigationController.navigationBar.frame.size.height;
        }
    }
    
    CGFloat height = SCREEN_HEIGHT - y;
    if (self.tabBarController.tabBar
        && !(self.hidesBottomBarWhenPushed))
    {
        height -= self.tabBarController.tabBar.height;
    }
    
    self.viewFrame =  CGRectMake(0, y, SCREEN_WIDTH, height);
    self.view.frame = self.viewFrame;
#ifdef DEBUG
    NSLog(@"VC: %@, frame:%@",  NSStringFromClass([self class]),  NSStringFromCGRect(self.view.frame));
#endif
    
}

-(void)viewWillAppear:(BOOL)animated
{
//#ifdef DEBUG
//    NSLog(@"VC:%@ -- %@",  NSStringFromClass([self class]), @"viewWillAppear");
//#endif
    [super viewWillAppear:animated];
    
    self.isViewAppear = YES;
    
    [self.navigationController setNavigationBarHidden:self.hideNavBar animated:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
#ifdef DEBUG
    NSLog(@"VC: %@ -- %@",  NSStringFromClass([self class]), @"viewDidAppear");
#endif
    
    [super viewDidAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
//#ifdef DEBUG
//    NSLog(@"VC:%@ -- %@",  NSStringFromClass([self class]), @"viewWillDisappear");
//#endif
    
    [super viewWillDisappear:animated];
    self.isViewAppear = NO;

}

-(void)viewDidDisappear:(BOOL)animated
{
//#ifdef DEBUG
//    NSLog(@"VC:%@ -- %@",  NSStringFromClass([self class]), @"viewDidDisappear");
//#endif
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
#ifdef DEBUG
    NSLog(@"VC: %@ -- %@",  NSStringFromClass([self class]), @"didReceiveMemoryWarning");
#endif
    // Dispose of any resources that can be recreated.
}


#pragma mark 持久化

+ (NSString *)globalArchivePath
{
    NSString* tmpPath = [[FESandbox tmpPath]stringByAppendingPathComponent:@"staticviewcache"];
    [FESandbox createDirectoryAtPath:tmpPath];
    return tmpPath;
}


+ (void)globalArchive:(id)data withKey:(NSString*)strKey
{
    
#ifndef DEBUG
    strKey = [FEEncrypt md5:strKey];
#endif
    
    NSString* archivePath = [FEViewController globalArchivePath];
    [FESandbox createDirectoryAtPath:archivePath];
    
    NSString* strPath = [NSString stringWithFormat:@"%@/%@", archivePath, strKey];
    
#ifndef DEBUG
    @try {
        [NSKeyedArchiver archiveRootObject:data toFile:strPath];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
#else
    [NSKeyedArchiver archiveRootObject:data toFile:strPath];
#endif

    
    //缓存时间
    strPath = [NSString stringWithFormat:@"%@%@", strPath, kViewControllerCacheTime];
    NSTimeInterval  time = [[NSDate systemDate] timeIntervalSince1970];
    [NSKeyedArchiver archiveRootObject:@(time) toFile:strPath];
}

+ (id)globalUnarchiveWithKey:(NSString*)strKey
{
#ifndef DEBUG
    strKey = [FEEncrypt md5:strKey];
#endif
    
    NSString* archivePath = [FEViewController globalArchivePath];
    NSString* strPath = [NSString stringWithFormat:@"%@/%@", archivePath, strKey];
    
    id data = nil;
    
#ifndef DEBUG
    @try {
        data = [NSKeyedUnarchiver unarchiveObjectWithFile:strPath];
    }
    @catch (NSException *exception) {
        data = nil;
    }
    @finally {
    }
#else
    data = [NSKeyedUnarchiver unarchiveObjectWithFile:strPath];
#endif

    
    return data;
}




-(NSString*)archivePath
{
    NSString* tmpPath = [[FESandbox tmpPath]stringByAppendingPathComponent:@"viewcache"];
    [FESandbox createDirectoryAtPath:tmpPath];

    return tmpPath;
}



-(void)archive:(id)data withKey:(NSString*)strKey
{
    NSString* keyPath = NSStringFromClass([self class]);
    
#ifndef DEBUG
    strKey = [FEEncrypt md5:strKey];
    keyPath = [FEEncrypt md5:keyPath];
#endif
    
    NSString* archivePath = [[self archivePath] stringByAppendingPathComponent:keyPath];
    [FESandbox createDirectoryAtPath:archivePath];

    NSString* strPath = [NSString stringWithFormat:@"%@/%@", archivePath, strKey];
    
#ifndef DEBUG
    @try {
        [NSKeyedArchiver archiveRootObject:data toFile:strPath];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
#else
    [NSKeyedArchiver archiveRootObject:data toFile:strPath];
#endif
    
    //缓存时间
    strPath = [NSString stringWithFormat:@"%@%@", strPath, kViewControllerCacheTime];
    NSTimeInterval  time = [[NSDate systemDate] timeIntervalSince1970];
    [NSKeyedArchiver archiveRootObject:@(time) toFile:strPath];

}

-(id)unarchiveWithKey:(NSString*)strKey
{
    return [self unarchiveWithKey:strKey cacheTime:nil];
}

-(id)unarchiveWithKey:(NSString*)strKey cacheTime:(double*)cacheTime
{
    NSString* keyPath = NSStringFromClass([self class]);
    
#ifndef DEBUG
    strKey = [FEEncrypt md5:strKey];
    keyPath = [FEEncrypt md5:keyPath];
#endif
    
    NSString* archivePath = [[self archivePath] stringByAppendingPathComponent:keyPath];
    NSString* strPath = [NSString stringWithFormat:@"%@/%@", archivePath, strKey];
    
    id data = nil;
    
#ifndef DEBUG
    @try {
        data = [NSKeyedUnarchiver unarchiveObjectWithFile:strPath];
    }
    @catch (NSException *exception) {
        data = nil;
    }
    @finally {
    }
#else
    data = [NSKeyedUnarchiver unarchiveObjectWithFile:strPath];
#endif

    
    if (cacheTime) {
        strPath = [NSString stringWithFormat:@"%@%@", strPath, kViewControllerCacheTime];
        id time = [NSKeyedUnarchiver unarchiveObjectWithFile:strPath];
        *cacheTime = [time doubleValue];
    }
    
    return data;
}

//获取缓存时间
- (NSTimeInterval)unarchiveCacheTimeWithKey:(NSString *)strKey
{
    NSString* keyPath = NSStringFromClass([self class]);
    
#ifndef DEBUG
    strKey = [FEEncrypt md5:strKey];
    keyPath = [FEEncrypt md5:keyPath];
#endif
    
    NSString* archivePath = [[self archivePath] stringByAppendingPathComponent:keyPath];
    NSString* strPath = [NSString stringWithFormat:@"%@/%@%@", archivePath, strKey, kViewControllerCacheTime];
    id time = [NSKeyedUnarchiver unarchiveObjectWithFile:strPath];
   
    return [time doubleValue];
}

-(void)archive:(id)data withKey:(NSString*)strKey uniqueId:(long long)uniqueId;
{
    NSString* newKey = [NSString stringWithFormat:@"%@_%lld", strKey, uniqueId];
    
    [self archive:data withKey:newKey];
}

-(id)unarchiveWithKey:(NSString*)strKey uniqueId:(long long)uniqueId;
{
    return [self unarchiveWithKey:strKey uniqueId:uniqueId cacheTime:nil];
}

-(id)unarchiveWithKey:(NSString*)strKey uniqueId:(long long)uniqueId cacheTime:(double*)cacheTime;
{
    NSString* newKey = [NSString stringWithFormat:@"%@_%lld", strKey, uniqueId];
    
    return [self unarchiveWithKey:newKey cacheTime:cacheTime];
}

- (NSTimeInterval)unarchiveCacheTimeWithKey:(NSString *)strKey uniqueId:(long long)uniqueId
{
    NSString* newKey = [NSString stringWithFormat:@"%@_%lld", strKey, uniqueId];
    return [self unarchiveCacheTimeWithKey:newKey];
}


@end
