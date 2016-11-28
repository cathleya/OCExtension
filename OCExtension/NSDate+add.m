

#import "NSDate+add.h"

#define MIN_1 60                //一分钟 60
#define HOUR_1 3600             //一小时 MIN_1 * 60
#define DYA_1 86400             //一天 HOUR_1 * 24
#define WEEK_1 604800           //一周 DYA_1 * 7
#define MONTH_1 2419200         // WEEK_1 *  4
#define YEAR_1 29030400          //MONTH_1 * 12

static long  s_system_time_fix_value = 0;

@implementation NSDate(add)

+(void)updateSystemTime:(NSTimeInterval)timeInterval
{
    NSDate* nowDate = [NSDate date];
    NSTimeInterval nowTimeInterval = [nowDate timeIntervalSince1970];
    
    s_system_time_fix_value = timeInterval - nowTimeInterval;
}

+(NSDate*)systemDate
{
    if (s_system_time_fix_value == 0)
    {
        return [NSDate date];
    }
    else
    {
        //同步本地时间
        NSTimeInterval nowTimeInterval = [[NSDate date]timeIntervalSince1970];
        NSTimeInterval sysTimeInterval  = nowTimeInterval + s_system_time_fix_value;
        
        return [NSDate dateWithTimeIntervalSince1970:sysTimeInterval];
    }
}

//获取NSDate的年份部分
+(NSInteger)getFullYear:(NSDate *)date{
	NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy"];
	NSString *yearStr=[formatter stringFromDate:date];
	return atoi([yearStr UTF8String]);
}

//获取NSDate的月份部分
+(NSInteger)getMonth:(NSDate *)date{
	NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MM"];
	NSString *monthStr=[formatter stringFromDate:date];
	
	return atoi([monthStr UTF8String]);
}
//获取NSDate的日期部分
+(NSInteger)getDay:(NSDate *)date{
	NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"dd"];
	NSString *dayStr=[formatter stringFromDate:date];
	
	return atoi([dayStr UTF8String]);
}
//获取NSDate的小时部分
+(NSInteger)getHour:(NSDate *)date{
	NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"HH"];
	NSString *hourStr=[formatter stringFromDate:date];
	
	return atoi([hourStr UTF8String]);
}
//获取NSDate的分钟部分
+(NSInteger)getMinute:(NSDate *)date{
	NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
	[formatter dateFromString:@"mm"];
	NSString *minuteStr=[formatter stringFromDate:date];
	
	return atoi([minuteStr UTF8String]);
}
//获取NSDate的秒部分
+(NSInteger)getSecond:(NSDate *)date{
	NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
	[formatter dateFromString:@"ss"];
	NSString *secondStr=[formatter stringFromDate:date];
	
	return atoi([secondStr UTF8String]);
}

//+ (NSInteger)getPetAge:(NSTimeInterval)time1970
//{
//    NSDate * curDate = [NSDate date];
//    NSDate * ageDate = [NSDate dateWithTimeIntervalSince1970:time1970];
//    
//    NSInteger petAge = [NSDate getFullYear:ageDate];
//    NSInteger curAge = [NSDate getFullYear:curDate];
//    
//    NSInteger retAge = curAge - petAge;
//    
//    NSInteger petMonth = [NSDate getMonth:ageDate];
//    NSInteger curMonth = [NSDate getMonth:curDate];
//    
//    NSInteger petDay = [NSDate getDate:ageDate];
//    NSInteger curDay = [NSDate getDate:curDate];
//    
//    BOOL flag = NO;
//    if (petMonth > curMonth) {
//        flag = YES;
//    }
//    
//    if (petDay > curDay) {
//        flag = YES;
//    }
//    
//    if (flag) {
//        retAge -=1;
//    }
//    if (retAge < 0) {
//        retAge = 0;
//    }
//    return retAge;
//}

+(NSDate*)dateByAge:(NSInteger)age
{
    NSDate* date = [NSDate systemDate];
    NSInteger year = [NSDate getFullYear:date] - age;
    NSInteger month = [NSDate getMonth:date];
    NSInteger day = [NSDate getDay:date];
    return [NSDate dateByStringFormat:@"yyyy-MM-dd" dateString:[NSString stringWithFormat:@"%ld-%ld-%ld" ,(long)year ,(long)month, (long)day]];
}

//根据字符串格式转换字符串为日期
+ (NSDate *)dateByStringFormat:(NSString *)format dateString:(NSString *)dateString
{
	NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
	[formatter setDateFormat:format];
	NSDate * date = [formatter dateFromString:dateString];
	
	return date;
}

+ (NSDate *)dateByStringFormat:(NSString *)format dateString:(NSString *)dateString locale:(NSLocale *)locale
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
	[formatter setDateFormat:format];
    formatter.locale = locale;
	NSDate *date=[formatter dateFromString:dateString];
	
	return date;
}


//将时间戳转换成格式化字符串
+(NSString *)dateByStringFormat:(NSString *)format timeInterval:(NSTimeInterval)timeInterval
{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    return [NSDate stringByStringFormat:format data:date];
}


//根据字符串格式转换日期为字符串
+(NSString *)stringByStringFormat:(NSString *)format data:(NSDate *)date
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:format];
	NSString *dateStr = [formatter stringFromDate:date];
	return dateStr;
}

+(NSDate *)dateByYear:(NSInteger)year month:(NSInteger)month date:(NSInteger)date hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second{
	
	NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate *dateObj=[formatter dateFromString:[NSString stringWithFormat:@"%4ld-%2ld-%2ld %2ld:%2ld:%2ld",(long)year,(long)month,(long)date,(long)hour,(long)minute,(long)second]];
	
	return dateObj;
}

/*
 距离某个日期多少天
 如果 < 0, anotherDate:1998,01,01 ,date:2000,01,01
 如果 > 0, anotherDate:2000,01,01 ,date:1998,01,01
 */
- (NSInteger)daysSinceDate:(NSDate *)anotherDate
{
    static NSString * const dateFromat = @"yyyy-MM-dd";
    
    NSString* dateString = [NSDate stringByStringFormat:dateFromat data:self];
    NSString* anotherDateString = [NSDate stringByStringFormat:dateFromat data:anotherDate];
    NSDate *date = [NSDate dateByStringFormat:dateFromat dateString:dateString];
    NSDate *otherDate = [NSDate dateByStringFormat:dateFromat dateString:anotherDateString];
    
    NSTimeInterval timeInterval = [date timeIntervalSinceDate:otherDate];
    NSInteger days = timeInterval / DYA_1;
    return days;
}

/*
 日期增减
 */
-(NSDate *)addDays:(NSInteger)day
{
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = day;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    return [theCalendar dateByAddingComponents:dayComponent toDate:self options:0];
}

@end
