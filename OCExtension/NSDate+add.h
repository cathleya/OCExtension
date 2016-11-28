

#import <Foundation/Foundation.h>


@interface NSDate(add)

//更新系统时间
+(void)updateSystemTime:(NSTimeInterval)timeInterval;

//返回和服务器校正后的时间
+(NSDate*)systemDate;

//获取NSDate的年份部分
+(NSInteger)getFullYear:(NSDate *)date;
//获取NSDate的月份部分
+(NSInteger)getMonth:(NSDate *)date;
//获取NSDate的日期部分
+(NSInteger)getDay:(NSDate *)date;
//获取NSDate的小时部分
+(NSInteger)getHour:(NSDate *)date;
//获取NSDate的分钟部分
+(NSInteger)getMinute:(NSDate *)date;
//获取NSDate的秒部分
+(NSInteger)getSecond:(NSDate *)date;

+(NSDate*)dateByAge:(NSInteger)age;

//根据字符串格式转换字符串为日期
+(NSDate *)dateByStringFormat:(NSString *)format dateString:(NSString *)dateString;

/**
 *	@brief	根据字符串格式转换字符串为日期
 *
 *	@param 	format 	格式
 *	@param 	dateString 	日期时间字符串
 *	@param 	locale 	本地化设置
 *
 *	@return	日期时间对象
 */
+ (NSDate *)dateByStringFormat:(NSString *)format dateString:(NSString *)dateString locale:(NSLocale *)locale;


//根据字符串格式转换日期为字符串
+(NSString *)stringByStringFormat:(NSString *)format data:(NSDate *)date;
//根据年月日返回日期
+(NSDate *)dateByYear:(NSInteger)year month:(NSInteger)month date:(NSInteger)date hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;

//将时间戳转换成格式化字符串
+(NSString *)dateByStringFormat:(NSString *)format timeInterval:(NSTimeInterval)timeInterval;

/*
    距离某个日期多少天
    如果 < 0, anotherDate:1998,01,01 ,date:2000,01,01
    如果 > 0, anotherDate:2000,01,01 ,date:1998,01,01
 */
- (NSInteger)daysSinceDate:(NSDate *)anotherDate;

/*
 日期增减
 */
-(NSDate *)addDays:(NSInteger)day;

@end
