//
//  NSObject+GCD.h
//  IOS-Categories
//
//  Created by Jakey on 14/12/15.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NSObject (GCD)

//主线程
- (void)performOnMainThread:(void(^)(void))block wait:(BOOL)wait;

//异步 global_queue
- (void)performAsynchronous:(void(^)(void))block;

//同步 global_queue
- (void)performSynchronous:(void(^)(void))block;

//多少秒后 执行blcok, block将在主线程执行
- (void)performAfter:(NSTimeInterval)seconds block:(void(^)(void))block;



@end