//
//  UIColor+add.m
//  Pet
//
//  Created by Tom on 15/3/4.
//  Copyright (c) 2015年 fanying. All rights reserved.
//

#import "UIColor+add.h"

@implementation UIColor(add)

+ (UIColor *)colorWithHexString:(NSString *)hexString
{
    // String should be 6 or 8 characters
    if([hexString length] < 6 || [hexString length] > 8)
    {
        return nil;
    }
    // strip 0X if it appears
    if([hexString hasPrefix:@"0X"])
    {
        hexString = [hexString substringFromIndex:2];
    }
    else if([hexString hasPrefix:@"0x"])
    {
        hexString = [hexString substringFromIndex:2];
    }
    else if([hexString hasPrefix:@"#"])
    {
        hexString = [hexString substringFromIndex:1];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString * rString = [hexString substringWithRange:range];
    range.location = 2;
    NSString * gString = [hexString substringWithRange:range];
    range.location = 4;
    NSString * bString = [hexString substringWithRange:range];
    // Scan valuesunsigned
    unsigned r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
@end
