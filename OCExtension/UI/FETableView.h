//
//  FETableView.h
//  Pet
//
//  Created by Tom on 15/5/13.
//  Copyright (c) 2015年 fanying. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FETableView;
@protocol FETableViewDelegate <UITableViewDelegate>
@optional
-(void)tableViewTouched:(FETableView*)tableView;
@end

@interface FETableView : UITableView

@end
