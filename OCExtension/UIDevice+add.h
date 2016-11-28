

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UIDevice(add)

/**
	获取设备模式信息
	@returns 设备模式,返回值如下：
	 iPhone1,1 ->    iPhone 1G
	 iPhone1,2 ->    iPhone 3G
	 iPhone2,1 ->    iPhone 3GS
	 iPhone3,1 ->    iPhone 4 GSM
	 iPhone3,3 ->    iPhone 4 CDMA 
	 iPhone4,1 ->    iPhone 4S  
	 iPhone5,1 ->    iPhone 5   
	 
	 iPod1,1   -> iPod touch 1G
	 iPod2,1   -> iPod touch 2G
	 iPod3,1   -> iPod touch 3G
	 iPod4,1   -> iPod touch 4
 	 iPod5,1   -> iPod touch 5
	 
	 iPad1,1   -> iPad,  WiFi
	 iPad2,1   -> iPad2, WiFi
	 iPad2,2   -> iPad2, 3G
	 iPad2,3   -> iPad, CDMAV 
	 iPad2,4   -> iPad, CDMAS
 	 iPad3,1   -> the New iPad, WIFI
 	 iPad3,1   -> the New iPad, GSM
 	 iPad3,3   -> the New iPad, CDMA
 */

+ (NSString *)currentPlatform;

/**
	获取运营商名称
	@returns 运营商名称
 */
+ (NSString *)carrierName;


/**
	获取运营商国家码
	@returns 运营商国家码
 */
+ (NSString *)carrierCountryCode;

/**
	获取手机所属国家码
	@returns 手机所属国家码
 */
+ (NSString *)mobileCountryCode;

/**
	获取系统越狱标识
	@returns YES表示已经越狱，否则没有越狱。
 */
+ (BOOL)isJailBroken;

/**
	获取设备生产商名称
	@returns 固定返回"Apple"
 */
+ (NSString *)deviceManufacturer;

//iphone  | Ipad
+ (BOOL)isIPhone;

//iphone6p
+ (BOOL)isPhone6P;

//iphone6
+ (BOOL)isPhone6;
@end
