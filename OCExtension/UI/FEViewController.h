//
//  FEViewController.h
//  FEFramework
//
//  Created by Tom on 15/1/20.
//  Copyright (c) 2015年 liyy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FEViewController : UIViewController

+(instancetype)VC;

@property(nonatomic, assign) CGFloat topOffset;
@property(nonatomic, assign) BOOL    hideNavBar;
@property(nonatomic, assign) BOOL    hideStatusBar;
@property(nonatomic, assign) BOOL    isViewAppear;
@property(nonatomic, assign) CGRect  viewFrame;

-(BOOL)screenEdgePanGestureRecognizerShouldBegin;

//界面数据持久化
//备注：数据必须支持 NSCoding 协议
-(void)archive:(id)data withKey:(NSString*)strKey;
-(id)unarchiveWithKey:(NSString*)strKey;

//return 缓存的数据
//cacheTime 缓存的时间
-(id)unarchiveWithKey:(NSString*)strKey cacheTime:(double*)cacheTime;

//获取缓存时间
- (NSTimeInterval)unarchiveCacheTimeWithKey:(NSString *)strKey;

//序列化界面数据 根据不同情况 数据不同有区别
-(void)archive:(id)data withKey:(NSString*)strKey uniqueId:(long long)uniqueId;
-(id)unarchiveWithKey:(NSString*)strKey uniqueId:(long long)uniqueId;

//return 缓存的数据
//cacheTime 缓存的时间
-(id)unarchiveWithKey:(NSString*)strKey uniqueId:(long long)uniqueId cacheTime:(double*)cacheTime;

//获取缓存时间
- (NSTimeInterval)unarchiveCacheTimeWithKey:(NSString *)strKey uniqueId:(long long)uniqueId;




//全局的界面缓存
+ (void)globalArchive:(id)data withKey:(NSString*)strKey;
+ (id)globalUnarchiveWithKey:(NSString*)strKey;

@end
