

#import "NSString+add.h"
#import <RegexKitLite-NoWarning/RegexKitLite.h>


@implementation NSString(add)

- (NSString *)stringByTrimmingWhitespaceAndNewlineCharacters
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)stringByTrimmingLeadingCharactersInSet:(NSCharacterSet *)characterSet {
    NSRange rangeOfFirstWantedCharacter = [self rangeOfCharacterFromSet:[characterSet invertedSet]];
    if (rangeOfFirstWantedCharacter.location == NSNotFound) {
        return @"";
    }
    return [self substringFromIndex:rangeOfFirstWantedCharacter.location];
}

- (NSString *)stringByTrimmingLeadingWhitespaceAndNewlineCharacters {
    return [self stringByTrimmingLeadingCharactersInSet:
            [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)stringByTrimmingTrailingCharactersInSet:(NSCharacterSet *)characterSet {
    NSRange rangeOfLastWantedCharacter = [self rangeOfCharacterFromSet:[characterSet invertedSet]
															   options:NSBackwardsSearch];
    if (rangeOfLastWantedCharacter.location == NSNotFound) {
        return @"";
    }
    return [self substringToIndex:rangeOfLastWantedCharacter.location+1]; // non-inclusive
}

- (NSString *)stringByTrimmingTrailingWhitespaceAndNewlineCharacters {
    return [self stringByTrimmingTrailingCharactersInSet:
            [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString*)stringReplaceMiddleWhitespaceWithString:(NSString*)string
{
    if (string == nil) {
        string = @" ";
    }
    NSString* content = [self stringByReplacingOccurrencesOfRegex:@"\\s\\s*" withString:string];
    return content;
}

-(NSString*)stringByReplaceMiddleContinuousNewlineCharactersWithString:(NSString*)string
{
    if (string == nil) {
        string = @" ";
    }
    
    NSString* content = [self stringByReplacingOccurrencesOfRegex:@"\\n+(\\s*)\\n+" withString:string];
    
    return content;
}

-(NSString*)stringByReplaceMiddleNewlineCharactersWithString:(NSString*)string
{
    if (string == nil) {
        string = @" ";
    }
    
    NSString* content = [self stringByReplacingOccurrencesOfRegex:@"\r|\n" withString:string];
    
    return content;
}

- (NSString *)URLEncodedString
{
    
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                             (CFStringRef)self,
                                                                                             NULL,
                                                                                             CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                             kCFStringEncodingUTF8));
	return result;
}

- (NSString*)URLDecodedString
{
	NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
																						   (CFStringRef)self,
																						   CFSTR(""),
																						   kCFStringEncodingUTF8));
	return result;
}


- (BOOL)isSpacingString
{
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimedString = [self stringByTrimmingCharactersInSet:set];
    return trimedString.length == 0;
}

- (NSComparisonResult)compareVersion:(NSString*)verString
{
    NSArray* verArray = [self componentsSeparatedByString:@"."];
    NSArray* appVerArray = [verString componentsSeparatedByString:@"."];
    
    NSComparisonResult result = NSOrderedSame;
    for (NSInteger i = 0; i < [verArray count] && i < [appVerArray count]; ++i) {
        NSInteger m = [verArray[i] integerValue];
        NSInteger n = [appVerArray[i] integerValue];
        if (m > n) {
            result = NSOrderedAscending;
            break;
        } else if (m < n) {
            result = NSOrderedDescending;
            break;
        }
    }
    return result;
}

- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    return [self sizeCustomWithFont:font constrainedToSize:size];
}

- (CGSize)sizeCustomWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    CGSize resultSize;
    NSDictionary *attributes = @{NSFontAttributeName: font};
    CGRect rect = [self boundingRectWithSize:size
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];
    resultSize.width = ceilf(rect.size.width);
    resultSize.height = ceilf(rect.size.height);
    
    return resultSize;
}

- (NSString *)getUrlValueWithKey:(NSString *)key;
{
    if ([key length] == 0) {
        return nil;
    }
    
    //添加后缀
    if (![key hasSuffix:@"="]) {
        key = [key stringByAppendingString:@"="];
    }
    
    NSString * str = nil;
    NSString* url = self;
    NSRange start = [url rangeOfString:key];
    if (start.location != NSNotFound)
    {
        NSRange end = [[url substringFromIndex:start.location+start.length] rangeOfString:@"&"];
        NSUInteger offset = start.location+start.length;
        str = end.location == NSNotFound
        ? [url substringFromIndex:offset]
        : [url substringWithRange:NSMakeRange(offset, end.location)];
        str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    return str;
}


@end
