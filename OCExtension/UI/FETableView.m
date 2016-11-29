//
//  FETableView.m
//  Pet
//
//  Created by Tom on 15/5/13.
//  Copyright (c) 2015年 fanying. All rights reserved.
//

#import "FETableView.h"

@implementation FETableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    if ([self.delegate respondsToSelector:@selector(tableViewTouched:)])
    {
        [(id)(self.delegate) tableViewTouched:self];
    }
}

@end
