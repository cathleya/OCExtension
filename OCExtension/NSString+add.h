
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface NSString(add)

- (NSString *)stringByTrimmingWhitespaceAndNewlineCharacters;
- (NSString *)stringByTrimmingLeadingCharactersInSet:(NSCharacterSet *)characterSet;
- (NSString *)stringByTrimmingLeadingWhitespaceAndNewlineCharacters;
- (NSString *)stringByTrimmingTrailingCharactersInSet:(NSCharacterSet *)characterSet;
- (NSString *)stringByTrimmingTrailingWhitespaceAndNewlineCharacters;

//替换中间连续空格(待测试)
- (NSString*)stringReplaceMiddleWhitespaceWithString:(NSString*)string;

//替换中间连续换行
- (NSString*)stringByReplaceMiddleContinuousNewlineCharactersWithString:(NSString*)string;

//替换换行
- (NSString*)stringByReplaceMiddleNewlineCharactersWithString:(NSString*)string;


//url encode/decode
- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;

- (BOOL)isSpacingString;

//比较版本号
- (NSComparisonResult)compareVersion:(NSString*)verString;

//计算字符尺寸
- (CGSize)sizeCustomWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;


/**
*   从url中获取value  key=value&key2=value2
*   其中  key 需要带上等号 = 
 */
- (NSString *)getUrlValueWithKey:(NSString *)key;
@end
