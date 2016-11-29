//
//  FETableViewController.h
//  FEFramework
//
//  Created by Tom on 15/1/20.
//  Copyright (c) 2015年 liyy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FETableViewController : UITableViewController

+(instancetype)VC;

@property(nonatomic, assign) BOOL   hideNavBar;
@property(nonatomic, assign) BOOL    hideStatusBar;
@property(nonatomic, assign) CGFloat topOffset;
@property(nonatomic, assign) CGFloat buttomOffset;


//界面数据持久化
//备注：数据必须支持 NSCoding 协议
-(void)archive:(id)data withKey:(NSString*)strKey;
-(id)unarchiveWithKey:(NSString*)strKey;

@end
