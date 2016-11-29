//
//  IGridItemView.h
//  Pet
//
//  Created by Tom on 15/4/21.
//  Copyright (c) 2015年 fanying. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IGridItemView <NSObject>

@required
-(id)data;
-(void)setData:(id)data;
@end
