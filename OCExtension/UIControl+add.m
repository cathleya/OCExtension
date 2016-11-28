//
//  UIControl+add.m
//  Pet
//
//  Created by Tom on 11/4/16.
//  Copyright © 2016年 Yourpet. All rights reserved.
//

#import "UIControl+add.h"
#import <objc/runtime.h>

const static char * IndexPathKey = "IndexPathKey";

@implementation UIControl (add)
- (void)setIndexPath:(NSIndexPath *)indexPath {
    objc_setAssociatedObject(self, IndexPathKey, indexPath, OBJC_ASSOCIATION_RETAIN);
}

- (NSIndexPath *)indexPath {
    id obj = objc_getAssociatedObject(self, IndexPathKey);
    if([obj isKindOfClass:[NSIndexPath class]]) {
        return (NSIndexPath *)obj;
    }
    return nil;
}
@end
