
#ifdef __OBJC__
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <TargetConditionals.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#endif

#ifdef DEBUG
static const int ddLogLevel = DDLogLevelVerbose;
#else
static const int ddLogLevel = DDLogLevelError;
#endif


#pragma mark - UIImage
//获取 本地图片png
#define UIImageWithContentsOfFile(imageName) [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:imageName ofType:nil]]

#define UIImageWithName(imageName) [UIImage imageNamed:imageName]


#pragma mark - 颜色
//颜色
#ifndef RGB
#define RGB(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#endif

#ifndef RGBA
#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f \
alpha:(a)]
#endif

#ifndef RGBHEX
#define RGBHEX(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#endif

#ifndef RGBAHEX
#define RGBAHEX(rgbValue, a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]
#endif


#pragma mark - log信息
//log信息
#ifndef SHOW_LOG_FLAG
#define SHOW_LOG_FLAG (1)
#endif


//static const DDLogLevel ddLogLevel = DDLogLevelAll; // 定义日志级别

#if SHOW_LOG_FLAG > 0
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif

#pragma mark - 单例模式
//单例模式
#undef	AS_SINGLETON
#define AS_SINGLETON( __class ) \
+ (__class *)sharedInstance;

#undef	DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
return __singleton__; \
}


//GCD 同步
#define dispatch_main_sync_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

//异步
//#define dispatch_main_async_safe(block)\
//if ([NSThread isMainThread]) {\
//block();\
//} else {\
//dispatch_async(dispatch_get_main_queue(), block);\
//}

//判断数据类型
#pragma mark - 判断数据类型
#define IS_NUMBER(obj)      ([obj isKindOfClass:[NSNumber class]])
#define IS_STRING(obj)      ([obj isKindOfClass:[NSString class]])
#define IS_ARRAY(obj)       ([obj isKindOfClass:[NSArray class]])
#define IS_DICTIONARY(obj)  ([obj isKindOfClass:[NSDictionary class]])
#define IS_NULL(obj)        ([obj isKindOfClass:[NSNull class]])

//NSCoder 宏
#define OBJC_STRING_IF(x) @#x

#define EncodeObject(x)     [aCoder encodeObject:x forKey:OBJC_STRING_IF(x)]
#define EncodeBool(x)       [aCoder encodeBool:x forKey:OBJC_STRING_IF(x)]
#define EncodeInt(x)        [aCoder encodeInt:x forKey:OBJC_STRING_IF(x)]
#define EncodeInteger(x)    [aCoder encodeInteger:x forKey:OBJC_STRING_IF(x)]
#define EncodeInt32(x)      [aCoder encodeInt32:x forKey:OBJC_STRING_IF(x)]
#define EncodeInt64(x)      [aCoder encodeInt64:x forKey:OBJC_STRING_IF(x)] //对应 long long
#define EncodeFloat(x)      [aCoder encodeFloat:x forKey:OBJC_STRING_IF(x)]
#define EncodeDouble(x)     [aCoder encodeDouble:x forKey:OBJC_STRING_IF(x)]


#define DecodeObject(x)     x = [aDecoder decodeObjectForKey:OBJC_STRING_IF(x)]
#define DecodeBool(x)       x = [aDecoder decodeBoolForKey:OBJC_STRING_IF(x)]
#define DecodeInt(x)        x = [aDecoder decodeIntForKey:OBJC_STRING_IF(x)]
#define DecodeInteger(x)    x = [aDecoder decodeIntegerForKey:OBJC_STRING_IF(x)]
#define DecodeInt32(x)      x = [aDecoder decodeInt32ForKey:OBJC_STRING_IF(x)]
#define DecodeInt64(x)      x = [aDecoder decodeInt64ForKey:OBJC_STRING_IF(x)]//对应 long long
#define DecodeFloat(x)      x = [aDecoder decodeFloatForKey:OBJC_STRING_IF(x)]
#define DecodeDouble(x)     x = [aDecoder decodeDoubleForKey:OBJC_STRING_IF(x)]


#pragma mark - 系统版本号判断
//系统版本号判断
//大于等于 9.0
#define IOS9_OR_LATER	([[[UIDevice currentDevice] systemVersion] compare:@"9.0" options:NSNumericSearch] != NSOrderedAscending)

//大于等于 8.0
#define IOS8_OR_LATER	([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending)

//大于等于 7.0
#define IOS7_OR_LATER	([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending)

//大于等于 6.0
#define IOS6_OR_LATER	([[[UIDevice currentDevice] systemVersion] compare:@"6.0" options:NSNumericSearch] != NSOrderedAscending)

#pragma mark - 判断设备
//iphone5
#define IS_IPHONE4 CGSizeEqualToSize(CGSizeMake(320, 480), [UIScreen mainScreen].bounds.size)
#define IS_IPHONE5 CGSizeEqualToSize(CGSizeMake(320, 568), [UIScreen mainScreen].bounds.size)
#define IS_IPHONE6 CGSizeEqualToSize(CGSizeMake(375, 667), [UIScreen mainScreen].bounds.size)
#define IS_IPHONE6P CGSizeEqualToSize(CGSizeMake(414, 736), [UIScreen mainScreen].bounds.size)


//状态栏高度
#define APP_STATUSBAR_HEIGHT   20//             (CGRectGetHeight([UIApplication sharedApplication].statusBarFrame))
#define APP_NAVIGATIONBAR_HEIGHT   44

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define SCREEN_SCALE_6P (SCREEN_WIDTH/414.0f)
#define SCREEN_SCALE_6  (SCREEN_WIDTH/375.0f)

#define SCREEN_SCALE    [[UIScreen mainScreen] scale]

//除以2
#define MID(a) ((a)*0.5)

//属性定义宏
#define  PROPERTY_WEAK       @property (nonatomic,weak)
#define  PROPERTY_ASSIGN     @property (nonatomic,assign)
#define  PROPERTY_COPY       @property (nonatomic,copy  )
#define  PROPERTY_STRONG     @property (nonatomic,strong)
#define  PROPERTY_READONLY   @property (nonatomic,readonly)
#define  PROPERTY_STRONG_R   @property (nonatomic,strong,readonly)

//特殊属性
#define PROPERTY_LONG_LONG  @property (nonatomic,assign) long long  //long long
#define PROPERTY_DOUBLE     @property (nonatomic,assign) double     //double

#define PROPERTY_ID        @property (nonatomic,assign) long long  // ID

//weak strong 宏
#define WeakObj(obj)        __weak typeof(obj) weak##obj = obj;
#define StrongObj(obj)      __strong typeof(obj) strong##obj = obj;





