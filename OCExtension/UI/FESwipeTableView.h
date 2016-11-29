//
//  FESwipeTableView.h
//  Pet
//
//  Created by Tom on 15/7/2.
//  Copyright (c) 2015年 fanying. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FESwipeTableViewDataSource <UITableViewDataSource>

@optional
- (BOOL)tableView:(UITableView *)tableView canDeleteRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView commitDeleteForRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface FESwipeTableView : UITableView <UIGestureRecognizerDelegate>
- (void)hideUtilityButtonsAnimated:(BOOL)animated;
@end
