//
//  UITextView+add.m
//  
//
//  Created by FE on 14-3-7.
//
//

#import "UITextView+add.h"

@implementation UITextView (add)

- (void)setTextAndKeepCursor:(NSString *)text
{
    NSRange range = self.selectedRange;
    self.text = text;
    self.selectedRange = range;
}

@end
