//
//  Utilities.h
//  ecmc
//
//  Created by cp9 on 13-1-8.
//  Copyright (c) 2013年 cp9. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZipArchive.h"

@interface Utilities : NSObject
+(NSString*)getLaunchImageName;
+(BOOL)isDeviceiPhone;
+(BOOL)isDeviceiPhone4;
+(BOOL)isDeviceRetina;
+(BOOL)isDeviceiPhone5;

+ (NSString *)bundlePath:(NSString *)fileName;
+ (NSString *)documentsPath:(NSString *)fileName;
+ (UIImage *)loadImageByName:(NSString *)imageName;
+ (void)CreateDir:(NSString *)filePath;
+ (void)deletePath:(NSString *)filePath;
//写入号码，密码,是否记住密码，是否自动登录
+ (void)savePwdWithPhone:(NSString *)phone pwd:(NSString *)pwd pwdRmbFlg:(BOOL)pwdFlag autoFlag:(BOOL)autoFlag;
//根据号码从文件中读入密码，是否记住密码，是否自动登录
+ (NSDictionary*)readPwdWithPhone:(NSString*)phone;
+ (void)writeToFileLoginLog:(NSString *)content;
//加密字符串
+ (NSString *)setArrayData:(NSMutableArray *)arrayPsd random:(int)rand;

//得到当前日期
+ (NSString *)getCurrentYearMonth:(NSDate *)date;
+ (int)getCurrentYear:(NSDate *)date;
//得到当前日期
+ (NSString *)getCurrentDate:(NSDate *)date;
//获取data的日期和时间yyyyMMddHHmmss
+(NSString *)getTime4Date:(NSDate *)date;
//获取data的日期和时间yyyyMMddHHmmssSSSSSS
+(NSString *)getTimeInterValDate:(NSDate *)date;
+(NSDate *)getDateForString:(NSString *)dateStr withFromat:(NSString *)format;
+(NSString *)getStrForDate:(NSDate *)date withFormat:(NSString *)format;
//根据给定日期计算新日期
+ (NSDate *)getNewDateFromDate:(NSDate *)date withMonth:(int)month;
//获取时间描述:今天/昨天/。。。。 上午/下午 某时某刻某秒 今天：14：30
+(NSString *)getExactDescription4Date:(NSDate *)date;

//提示窗口
+ (void)MsgBox:(NSString *)msg;
//截取小图
+(UIImage *)getNewImage:(UIImage *)image Rect:(CGRect)rect;

//最后更新提示（状态栏显示）
+(void)lastUpdate:(NSString *)text withTimeDuration:(CGFloat)duration;

//网络检测
+ (BOOL) checkNetWork;
+ (NSString *) returnNetWork;
+ (void)showNetworkActivityIndicator;
+ (void)hideNetworkActivityIndicator;
//根据错误码显示错误信息
+ (void) showErrorMessage:(int)errorcode;
+ (NSDate*)stringToNSDate:(NSString*)dateString;
+ (NSString*)dateToNSString:(NSDate*)date;

//业务分享点击量Type
+ (NSString *)ywShareType:(int)ywid;
+ (NSString *)ywShareTypeName:(int)ywid;

//获取设备唯一标识
+(NSString *)getDeviceUUID;

//接口安全认证
+ (NSString *) platform;
+ (NSString *) platformString;
+ (NSString *)screenSize;
+ (NSString *)md5:(NSString *)str;
+ (NSString *)md5Lowercase:(NSString *)str;
+ (NSString *)safeRequest2:(NSString *)strclientstampNow;
+ (NSMutableData *)safeRequest:(NSMutableData *)jsonParam;

//url截取字段
+ (NSString *)getParamValueFromUrl:(NSString*)url paramName:(NSString *)paramName;
//倒序string
+ (NSString *)reverseString :(NSString *)reverString;
//解压文件
+ (void)decompressionDBAndImage:(BOOL)bundle;
+(void)decompressionFileTo:(NSString*)directory sourcepath:(NSString*)sourcepath target:(ZipArchive*)zipArchive;

+ (UIImage*) imageBlackToTransparent:(UIImage*) image;

//! 重置缓存，如果版本有更新的话
+ (void)resetLocalCacheWhenUpdated;

+ (UIImage*) CombinedPicture:(UIImage*)img1 :(UIImage*)img2;

//改变请求得图片得大小
+ (UIImage*) setImg:(UIImage*)img Size:(CGSize)size;

+ (void) deleteBillCache;

//! 是否是有效的字典
+ (BOOL)isValidDictionary:(id)object;
//! 是否是有效的数组
+ (BOOL)isValidArray:(id)object;
//! 是否是有效的字符串
+ (BOOL)isValidString:(id)object;

//NSDictionary、NSArray、NSString 转换成 NSString
+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary;
+(NSString *) jsonStringWithArray:(NSArray *)array;
+(NSString *) jsonStringWithString:(NSString *) string;
+(NSString *) jsonStringWithObject:(id) object;

//数据库操作
//宫格
+(NSMutableArray *)returnSelectedFunButton;
+(NSMutableArray *)returnUNSelectedFunButton;
//返回数据库版本
+(NSMutableArray *)returnSqlVersion;
//导航
+(NSMutableArray *)returnNavigation;
//业务办理 全部分类
+(NSMutableArray *)returnBusinessType;
+(NSMutableArray *)returnBusinessContent:(NSString*)sid;
+(NSMutableArray *)returnBusinessSimpleContent:(NSString*)sid;
//个人喜欢业务
+(NSMutableArray *)returnLinkedBis:(NSString *)type;

+ (NSMutableArray *)returnBis:(NSString *)bid;
//查找4g业务
+(NSMutableArray *)return4GBis:(NSString *)sid;
//返回当前字符串是不是url
+ (BOOL)returnURL:(NSString *)symbolStr;

+ (CGFloat)pxTurnPt:(CGFloat)px;

+ (int)getDaysOfMonth:(int)year :(int)month;

@end
