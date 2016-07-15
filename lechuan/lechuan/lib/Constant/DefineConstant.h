//
//  HttpConstant.h
//  Common Application
//
//  Created by lyywhg on 11/25/11.
//  Copyright (c) 2011 BH. All rights reserved.
//

//  主要是用于定义 全局使用的 宏定义 的 头文件

//#import "FFConfig.h"

#define DB_NAME @"hnmcc.db"

//当前程序版本号
#define KBundleVersion @"BundleVersion"

#define DEBUGLOG
#ifdef DEBUGLOG
#       define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#       define DLog(...)
#endif

//本机唯一标识符uuid（程序自身存储）
#define kUDUUID @"uduuid"

#pragma mark - Local Exchange functions
#pragma mark   本地转化
/**本地化转换*/

//#define L(key) \
//[[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[FFConfig currentConfig].bunderPath ofType:@"lproj"]] localizedStringForKey:(key) value:@"" table:nil]

#pragma mark - Coordinate Functions
#pragma mark   坐标相关

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define STATUSBAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height

#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians)*(180.0/M_PI))

//自动布局，以iphone6为基准，iphone4(s)视为iphone5(s)处理
#define defaultHt (SCREEN_HEIGHT == 480 ? 568 : SCREEN_HEIGHT)
#define autoSizeScaleX (SCREEN_WIDTH/375)
#define autoSizeScaleY (defaultHt/667)
#define AutoCGRectMake(x,y,width,height) (CGRectMake(x*autoSizeScaleX,y*autoSizeScaleY,width*autoSizeScaleX,height*autoSizeScaleY))
#define AutoCGSizeMake(width,height) (CGSizeMake(width*autoSizeScaleX,height*autoSizeScaleY))

#pragma mark - color functions
#pragma mark   颜色
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define HSVCOLOR(h,s,v) [UIColor colorWithHue:h saturation:s value:v alpha:1]
#define HSVACOLOR(h,s,v,a) [UIColor colorWithHue:h saturation:s value:v alpha:a]

/// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBAlpha(rgbValue, a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#define Font(f) ([UIFont systemFontOfSize:f])

#pragma mark - degrees/radian functions
#pragma mark   角度弧度转化
//#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(radian) (radian*180.0)/(M_PI)

#pragma mark - Block functions
#pragma mark   block相关
///block 声明
#ifdef NS_BLOCKS_AVAILABLE
typedef void (^SNBasicBlock)(void);
typedef void (^SNOperationCallBackBlock)(BOOL isSuccess, NSString *errorMsg);
typedef void (^SNCallBackBlockWithResult)(BOOL isSuccess, NSString *errorMsg,id result);
typedef void (^SNArrayBlock)(NSArray *list);
#endif

#pragma mark - Thread functions
#pragma mark   GCD线程相关
///线程执行方法 GCD
#define PERFORMSEL_BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define PERFORMSEL_MAIN(block) dispatch_async(dispatch_get_main_queue(),block)

#pragma mark - Empty judge functions
#pragma mark   为空判断相关
///是否为空或是[NSNull null]
#define NotNilAndNull(_ref)  (((_ref) != nil) && (![(_ref) isEqual:[NSNull null]]))
#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))
///字符串是否为空
#define IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]))
///数组是否为空
#define IsArrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref) count] == 0))

#pragma mark -  DataTypes Generation functions
#pragma mark    类型数据生成相关
///便捷方式创建NSNumber类型
#undef	__INT
#define __INT( __x )			[NSNumber numberWithInt:(NSInteger)__x]

#undef	__UINT
#define __UINT( __x )			[NSNumber numberWithUnsignedInt:(NSUInteger)__x]

#undef	__FLOAT
#define	__FLOAT( __x )			[NSNumber numberWithFloat:(float)__x]

#undef	__DOUBLE
#define	__DOUBLE( __x )			[NSNumber numberWithDouble:(double)__x]

#define OC(str) [NSString stringWithCString:(str) encoding:NSUTF8StringEncoding]

#pragma mark -  SystemInfo functions
#pragma mark

///系统版本判断
#define IOS8_OR_LATER   ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f)
#define IOS7_OR_LATER   ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
#define IOS6_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"6.0"] != NSOrderedAscending )
#define IOS5_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"5.0"] != NSOrderedAscending )
#define IOS4_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"4.0"] != NSOrderedAscending )
#define IOS3_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"3.0"] != NSOrderedAscending )

//设备型号
#define isIPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define isIPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define isIPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define isIPhone6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

///安全释放
#define TT_RELEASE_SAFELY(__REF) \
{\
if (nil != (__REF)) \
{\
CFRelease(__REF); \
__REF = nil;\
}\
}
