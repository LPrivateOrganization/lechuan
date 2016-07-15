//
//  Utilities.m
//  ecmc
//
//  Created by cp9 on 13-1-8.
//  Copyright (c) 2013年 cp9. All rights reserved.
//

#import "Utilities.h"
#import "Reachability.h"
#import "PublicDefinitions.h"
#import <CommonCrypto/CommonDigest.h>
#include <sys/sysctl.h>
#import "KeychainContext.h"
#import "PersistProxy.h"

@implementation Utilities
+(NSString*)getLaunchImageName
{
    
    NSArray* images= @[@"LaunchImage.png", @"LaunchImage@2x.png",@"LaunchImage-700@2x.png",@"LaunchImage-568h@2x.png",@"LaunchImage-700-568h@2x.png",@"LaunchImage-700-Portrait@2x~ipad.png",@"LaunchImage-Portrait@2x~ipad.png",@"LaunchImage-700-Portrait~ipad.png",@"LaunchImage-Portrait~ipad.png",@"LaunchImage-Landscape@2x~ipad.png",@"LaunchImage-700-Landscape@2x~ipad.png",@"LaunchImage-Landscape~ipad.png",@"LaunchImage-700-Landscape~ipad.png"];
    
    UIImage *splashImage;
    
    if ([self isDeviceiPhone])
    {
        if ([self isDeviceiPhone4] && [self isDeviceRetina])
        {
            splashImage = [UIImage imageNamed:images[1]];
            if (splashImage.size.width!=0)
                return images[1];
            else
                return images[2];
        }
        else if ([self isDeviceiPhone5])
        {
            splashImage = [UIImage imageNamed:images[1]];
            if (splashImage.size.width!=0)
                return images[3];
            else
                return images[4];
        }
        else
            return images[0]; //Non-retina iPhone
    }
    else if ([[UIDevice currentDevice] orientation]==UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown)//iPad Portrait
    {
        if ([self isDeviceRetina])
        {
            splashImage = [UIImage imageNamed:images[5]];
            if (splashImage.size.width!=0)
                return images[5];
            else
                return images[6];
        }
        else
        {
            splashImage = [UIImage imageNamed:images[7]];
            if (splashImage.size.width!=0)
                return images[7];
            else
                return images[8];
        }
        
    }
    else
    {
        if ([self isDeviceRetina])
        {
            splashImage = [UIImage imageNamed:images[9]];
            if (splashImage.size.width!=0)
                return images[9];
            else
                return images[10];
        }
        else
        {
            splashImage = [UIImage imageNamed:images[11]];
            if (splashImage.size.width!=0)
                return images[11];
            else
                return images[12];
        }
    }
}

+(BOOL)isDeviceiPhone
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        return TRUE;
    }
    
    return FALSE;
}

+(BOOL)isDeviceiPhone4
{
    if ([[UIScreen mainScreen] bounds].size.height==480)
        return TRUE;
    
    return FALSE;
}


+(BOOL)isDeviceRetina
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0))        // Retina display
    {
        return TRUE;
    }
    else                                          // non-Retina display
    {
        return FALSE;
    }
}


+(BOOL)isDeviceiPhone5
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && [[UIScreen mainScreen] bounds].size.height>480)
    {
        return TRUE;
    }
    return FALSE;
}
+ (NSString *)bundlePath:(NSString *)fileName
{
	return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:fileName];
}

+ (NSString *)documentsPath:(NSString *)fileName
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:fileName];
}

+ (UIImage *)loadImageByName:(NSString *)imageName
{
    if (nil == imageName || YES == [imageName isEqualToString:@""])
        return nil;
    NSString *sImagePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:imageName];
    UIImage *image = [UIImage imageWithContentsOfFile:sImagePath];
    if (nil == image)
        image = [UIImage imageNamed:imageName];
    return image;
}

+ (void)CreateDir:(NSString *)filePath
{
	[[NSFileManager defaultManager] createDirectoryAtPath:filePath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
}

+(UIImage *)getNewImage:(UIImage *)image Rect:(CGRect)rect{
    UIImage *tempImage = image;
    CGImageRef imgRef = tempImage.CGImage;
    CGImageRef img=CGImageCreateWithImageInRect(imgRef,rect);
    UIImage *newImage = [UIImage imageWithCGImage:img];
    CGImageRelease(img);
    return newImage;
}

+ (void)deletePath:(NSString *)filePath
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
}

//写入号码，密码,是否记住密码，是否自动登录
+ (void)savePwdWithPhone:(NSString *)phone pwd:(NSString *)pwd pwdRmbFlg:(BOOL)pwdFlag autoFlag:(BOOL)autoFlag
{
    if(phone == nil)
    {
        return;
    }
    
    NSString *plistPath = [Utilities documentsPath:@"password.plist"];
    
    NSMutableDictionary *allRecords = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    if(!allRecords)
    {
        allRecords = [[NSMutableDictionary alloc] init];
    }
    
    BOOL flag = NO;
    
    if(allRecords)
    {
        NSArray *allKey = [allRecords allKeys];
        if(allKey && [allKey containsObject:phone])
        {
            NSDictionary *tempDic = [allRecords objectForKey:phone];
            if(tempDic)
            {
                [tempDic setValue:pwd forKey:@"pwd"];
                [tempDic setValue:@(pwdFlag) forKey:@"pwdRmbFlag"];
                [tempDic setValue:@(autoFlag) forKey:@"autoFlag"];
                flag = YES;
            }
        }
    }
    
    if(!flag)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setValue:pwd forKey:@"pwd"];
        [dic setValue:@(pwdFlag) forKey:@"pwdRmbFlag"];
        [dic setValue:@(autoFlag) forKey:@"autoFlag"];
        [allRecords setValue:dic forKey:phone];
    }
 
    [allRecords writeToFile:plistPath atomically:YES];
}

//根据号码从文件中读入密码，是否记住密码，是否自动登录
+ (NSDictionary*)readPwdWithPhone:(NSString*)phone{
	if (phone == nil)
	{
		return nil;
	}
	NSString *plistPath = [Utilities documentsPath:@"password.plist"];
	if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
	{
        return nil;
	}
    
    NSMutableDictionary *allRecords = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    if(allRecords)
    {
        NSArray *allKey = [allRecords allKeys];
        if(allKey && [allKey containsObject:phone])
        {
            return [allRecords objectForKey:phone];
        }
    }
	return nil;
}

+ (void)writeToFileLoginLog:(NSString *)content
{
    if (content==nil || ![content isKindOfClass:[NSString class]] || content.length<=0) {
        return;
    }
    unsigned long long fileLength = 0;
    NSData* data = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSString* filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"loginLogin.txt"];
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    if (fileHandle == nil) {
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
        fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    }
    else {
        fileLength = [fileHandle seekToEndOfFile];
    }
    if (fileLength > 1024*50) {
        [fileHandle truncateFileAtOffset:0];
    }
    [fileHandle writeData:data];
    [fileHandle closeFile];
}

+ (NSString *)setArrayData:(NSMutableArray *)arrayPsd random:(int)rand
{
	NSMutableArray *arrayData = [[NSMutableArray alloc] init];
	
	NSArray *array1 = [[NSArray alloc] initWithObjects:@"a",@"k",@"u",@"e",@"o",@"y",@"i",@"s",@"c",@"m",nil];
	NSArray *array2 = [[NSArray alloc] initWithObjects:@"b",@"l",@"v",@"f",@"p",@"z",@"j",@"t",@"d",@"n",nil];
	NSArray *array3 = [[NSArray alloc] initWithObjects:@"c",@"m",@"w",@"g",@"q",@"a",@"k",@"u",@"e",@"o",nil];
	NSArray *array4 = [[NSArray alloc] initWithObjects:@"d",@"n",@"x",@"h",@"r",@"b",@"l",@"v",@"f",@"p",nil];
	NSArray *array5 = [[NSArray alloc] initWithObjects:@"e",@"o",@"y",@"i",@"s",@"c",@"m",@"w",@"g",@"q",nil];
	NSArray *array6 = [[NSArray alloc] initWithObjects:@"f",@"p",@"z",@"j",@"t",@"d",@"n",@"x",@"h",@"r",nil];
	NSArray *array7 = [[NSArray alloc] initWithObjects:@"g",@"q",@"a",@"k",@"u",@"e",@"o",@"y",@"i",@"s",nil];
	NSArray *array8 = [[NSArray alloc] initWithObjects:@"h",@"r",@"b",@"l",@"v",@"f",@"p",@"z",@"j",@"t",nil];
	NSArray *array9 = [[NSArray alloc] initWithObjects:@"i",@"s",@"c",@"m",@"w",@"g",@"q",@"a",@"k",@"u",nil];
	NSArray *array10 = [[NSArray alloc] initWithObjects:@"j",@"t",@"d",@"n",@"x",@"h",@"r",@"b",@"l",@"v",nil];
	
	[arrayData addObject:array1];
	[arrayData addObject:array2];
	[arrayData addObject:array3];
	[arrayData addObject:array4];
	[arrayData addObject:array5];
	[arrayData addObject:array6];
	[arrayData addObject:array7];
	[arrayData addObject:array8];
	[arrayData addObject:array9];
	[arrayData addObject:array10];
	NSString *dataString = @"";
	NSArray *tempArr = [arrayData objectAtIndex:rand];
	for (int i = 0; i < [arrayPsd count]; i++) {
		NSString *tempString = [tempArr objectAtIndex:[[arrayPsd objectAtIndex:i] intValue]];
		dataString = [dataString stringByAppendingString:tempString];
	}
	dataString = [dataString stringByAppendingFormat:@"%d",rand];
	return dataString;
}

//提示窗口
+ (void)MsgBox:(NSString *)msg{
	if (msg && [msg length] > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg
                                                       delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

//得到当前日期
+ (NSString *)getCurrentYearMonth:(NSDate *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyyMM";
    NSString *strDate = [format stringFromDate:date];
    return strDate;
}

//得到当前年份
+ (int)getCurrentYear:(NSDate *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy";
    NSString *strDate = [format stringFromDate:date];
    return [strDate intValue];
}

//得到当前日期
+ (NSString *)getCurrentDate:(NSDate *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyyMMdd";
    NSString *strDate = [format stringFromDate:date];
    return strDate;
}

//获取时间全格式
+(NSString *)getTime4Date:(NSDate *)date
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    return [formatter stringFromDate:date];
}

//获取时间全格式
+(NSString *)getTimeInterValDate:(NSDate *)date
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddHHmmssSSSSSS"];
    return [formatter stringFromDate:date];
}

//转换字符串
+(NSDate *)getDateForString:(NSString *)dateStr withFromat:(NSString *)format
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    return [formatter dateFromString:dateStr];
}

+(NSString *)getStrForDate:(NSDate *)date withFormat:(NSString *)format
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:date];
}

//根据给定日期计算新日期
+ (NSDate *)getNewDateFromDate:(NSDate *)date withMonth:(int)month
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    //组装新日期
    comps.month = month;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *dateNew = [calendar dateByAddingComponents:comps toDate:date options:nil];
    return dateNew;
}

+(NSString *)getExactDescription4Date:(NSDate *)date
{
    NSString *dateDescr = nil;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    dateDescr = [df stringFromDate:date];
    NSString *title = NSLocalizedString(@"今天", nil);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                               fromDate:date toDate:[NSDate date] options:0];
    int year = [components year];
    int month = [components month];
    int day = [components day];
    if (year == 0 && month == 0 && day < 3) {
        if (day == 0) {
            title = NSLocalizedString(@"今天",nil);
        } else if (day == 1) {
            title = NSLocalizedString(@"昨天",nil);
        } else if (day == 2) {
            title = NSLocalizedString(@"前天",nil);
        }
        df.dateFormat = [NSString stringWithFormat:@"%@ HH:mm",title];
        dateDescr = [df stringFromDate:date];
        
    }
    return dateDescr;
    
}

//最后更新提示（状态栏显示）
+(void)lastUpdate:(NSString *)text withTimeDuration:(CGFloat)duration
{
  /*  NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"HH:mm"];
    NSDate *date = [NSDate date];
    text = [format stringFromDate:date];
    UIWindow *win = [[UIWindow alloc] initWithFrame:[UIApplication sharedApplication].statusBarFrame];
    [win setWindowLevel:UIWindowLevelStatusBar + 1];
    UILabel *lastTime = [[UILabel alloc] initWithFrame:CGRectMake(100, -20, 120, 20)];
    if(ISIOS7)
    {
        lastTime.backgroundColor = [UIColor whiteColor];
        lastTime.textColor = [UIColor blackColor];
    }
    else
    {
        lastTime.backgroundColor = [UIColor blackColor];
        lastTime.textColor = [UIColor whiteColor];
    }
   
    lastTime.text =[NSString stringWithFormat:@"最后更新:  今天 %@",text];
    [lastTime setFont:[UIFont boldSystemFontOfSize:11.0f]];
    if (ISIOS6) {
        lastTime.textAlignment = NSTextAlignmentCenter;
    } else {
        lastTime.textAlignment = NSTextAlignmentCenter;
    }
    [win addSubview:lastTime];
   
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window performSelector:@selector(makeKeyAndVisible) withObject:nil afterDelay:duration+0.9];
    
    [self performSelector:@selector(hiddenLabel:) withObject:lastTime afterDelay:duration+0.4];
    
    [win makeKeyAndVisible];
    
    [UIView animateWithDuration:0.4 animations:^{
        lastTime.frame = CGRectMake(100, 0, 120, 20);
    }];*/
}

+(void) hiddenLabel:(UILabel *)label
{
    [UIView animateWithDuration:0.4 animations:^{
        label.frame = CGRectMake(100, -20, 120, 20);
    }];
}

//检测网络
+ (BOOL)checkNetWork
{
    BOOL flag = YES;
    Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            // 没有网络连接
            flag = NO;
            break;
        case ReachableViaWWAN:
            // 使用3G网络
            break;
        case ReachableViaWiFi:
            // 使用WiFi网络
            break;
    }
    return flag;
}

+ (NSString *) returnNetWork
{
    NSString *flag = @"2G";
    Reachability *r = [Reachability reachabilityWithHostName:@"www.goole.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            // 没有网络连接
            flag = @"";
            break;
        case ReachableViaWWAN:
            // 使用3G网络
            flag = @"2G/3G";
            break;
        case ReachableViaWiFi:
            // 使用WiFi网络
            flag = @"WiFi";
            break;
    }
    return flag;
}

+ (void)showNetworkActivityIndicator
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

+ (void)hideNetworkActivityIndicator
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
//根据错误码显示错误信息
+ (void) showErrorMessage:(int)errorcode
{
    switch (errorcode) {
 		case 10202:
        {
            [Utilities MsgBox:@"铃音设置时发现存在时间段重叠的分时段设置"];
        }
            break;
		case 200001:
        {
            [Utilities MsgBox:@"必选参数输入为空。"];
        }
            break;
        case 200002:
        {
            [Utilities MsgBox:@"参数格式错误。"];
        }
            break;
        case 100002:
        {
            [Utilities MsgBox:@"系统忙。"];
        }
            break;
        case 100005:
        {
            [Utilities MsgBox:@"数据库操作异常。"];
        }
            break;
        case 100006:
        {
            [Utilities MsgBox:@"数据库执行失败。"];
        }
            break;
        case 300002:
        {
            [Utilities MsgBox:@"获取信息失败。"];
        }
            break;
        case 302003:
        {
            [Utilities MsgBox:@"该铃音不存在。"];
        }
            break;
        case 70089:
        {
            [Utilities MsgBox:@"用户不存在"];
        }
            break;
        case 70010:
        {
            [Utilities MsgBox:@"非正常状态彩铃用户"];
        }
            break;
        case 11000:
        {
            [Utilities MsgBox:@"非彩铃用户"];
        }
            break;
        case 11005:
        {
            [Utilities MsgBox:@"非正常状态彩铃用户，状态为 预配未开通"];
        }
            break;
        case 11003:
        {
            [Utilities MsgBox:@"非正常状态彩铃用户"];
        }
            break;
        case 11001:
        {
            [Utilities MsgBox:@"铃音编码不存在"];
        }
            break;
        case 70006:
        {
            [Utilities MsgBox:@"短信sid为空"];
        }
            break;
        case 70007:
        {
            [Utilities MsgBox:@"短信sidpwd为空"];
        }
            break;
        case 70002:
        {
            [Utilities MsgBox:@"网站sid为空"];
        }
            break;
        case 70003:
        {
            [Utilities MsgBox:@"网站sidpwd为空"];
        }
            break;
        case 70004:
        {
            [Utilities MsgBox:@"tonecode为空"];
        }
            break;
        case 70009:
        {
            [Utilities MsgBox:@"用户未登陆"];
        }
            break;
        case 70008:
        {
            [Utilities MsgBox:@"SP的用户名和密码错误"];
        }
            break;
        case 90001:
        {
            [Utilities MsgBox:@"数据库操作异常"];
        }
            break;
        case 302011:
        {
            [Utilities MsgBox:@"重复订购铃音/铃音盒"];
        }
            break;
        case 308001:
        {
            [Utilities MsgBox:@"被赠送用户还未开通彩铃。"];
        }
            break;
        case 308002:
        {
            [Utilities MsgBox:@"被赠送用户个人铃音库已满。"];
        }
            break;
        case -10002:
        {
            [Utilities MsgBox:@"验证码错误"];
        }
            break;
            case 301001:
        {
            [Utilities MsgBox:@"用户不存在"];
        }
            break;
            case 301011:
        {
             [Utilities MsgBox:@"用户已经欠费"];
        }
            break;
        case 301014:
        {
            [Utilities MsgBox:@"用户业务状态不允许设置"];
        }
            break;
            case 308027:
        {
             [Utilities MsgBox:@"该彩铃已存在"];
        }
            break;
            case -10004:
        {
            [Utilities MsgBox:@"验证码已失效"];
        }
            break;
            case -10003:
        {
            [Utilities MsgBox:@"验证码输入错误超过3次"];
        }
            break;
            case 302001:
        {
            [Utilities MsgBox:@"该铃音已经存在"];
        }
            break;
            case 302010:
        {
            [Utilities MsgBox:@"计费失败"];
        }
            break;
            case 301015:
        {
            [Utilities MsgBox:@"赠送方业务状态不允许其赠送。"];
        }
            break;
            case 301023:
        {
            [Utilities MsgBox:@"已超过消费限额。"];
        }
            break;
            case 303057:
        {
            [Utilities MsgBox:@"缺少相关的系统配置信息。"];
        }
            break;
            case 302108:
        {
            [Utilities MsgBox:@"复制方已下载了大礼包中的所有铃音。"];
        }
            break;
            case 308005:
        {
             [Utilities MsgBox:@"赠送方本月赠送彩铃月功能月份总数已经超过系统限制。"];
        }
            break;
            case 70055:
        {
            [Utilities MsgBox:@"receiver为空"];
        }
            break;
            case 10565:
        {
            [Utilities MsgBox:@"用户赠送铃音的个数已经超出系统允许每天赠送的个数"];
        }
            break;
            case 70005:
        {
            [Utilities MsgBox:@"短信randomsessionkey为空"];
        }
            break;
        default:
        {
            [Utilities MsgBox:@"操作失败"];
        }
            break;
    }
}

+ (NSDate*)stringToNSDate:(NSString*)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyyMMdd"];
    NSDate *date=[formatter dateFromString:dateString];
    return date;
}

+ (NSString*)dateToNSString:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

//业务分享点击量Type
+ (NSString *)ywShareType:(int)ywid
{
    NSString *share = @"";
    if(ywid == 565 || ywid == 569 || ywid == 570 || ywid == 571)//叠加包
    {
        share = @"djb";
    }
    else if(ywid == 609) //流量套餐
    {
        share = @"lltc";
    }
    else if(ywid == 579 || ywid == 580 || ywid == 581)
    { //随意玩
        share = @"syw";
    }
    else if(ywid == 179) //冲浪助手
    {
        share = @"clzs";
    }
    else if(ywid == 180 || ywid == 181 || ywid == 182 || ywid == 183) //免费139邮箱
    {
        share = @"mf139";
    }
    else if(ywid == 206)//咪咕会员
    {
        share = @"mg";
    }
    else if(ywid == 384 || ywid == 385 || ywid == 387) //飞信
    {
        share = @"fx";
    }
    else if(ywid ==  184)//手机阅读
    {
        share = @"sjyd";
    }
    else if(ywid == 4 || ywid== 6 || ywid == 7 || ywid == 8 || ywid == 11 || ywid == 19 || ywid == 21
            || ywid == 23 || ywid == 331 || ywid == 332 || ywid == 333 || ywid == 334 || ywid == 335 || ywid == 336) //手机报
    {
        share = @"sjb";
    }
    return share;
}

//业务分享点击量TypeNmae
+ (NSString *)ywShareTypeName:(int)ywid
{
    NSString *share = @"";
    if(ywid == 565 || ywid == 569 || ywid == 570 || ywid == 571)//叠加包
    {
        share = @"叠加包";
    }
    else if(ywid == 609) //流量套餐
    {
        share = @"流量套餐";
    }
    else if(ywid == 579 || ywid == 580 || ywid == 581)
    { //随意玩
        share = @"随意玩";
    }
    else if(ywid == 179) //冲浪助手
    {
        share = @"冲浪助手";
    }
    else if(ywid == 180 || ywid == 181 || ywid == 182 || ywid == 183) //免费139邮箱
    {
        share = @"免费139邮箱";
    }
    else if(ywid == 206)//咪咕会员
    {
        share = @"咪咕会员";
    }
    else if(ywid == 384 || ywid == 385 || ywid == 387) //飞信
    {
        share = @"飞信";
    }
    else if(ywid ==  184)//手机阅读
    {
        share = @"手机阅读";
    }
    else if(ywid == 4 || ywid== 6 || ywid == 7 || ywid == 8 || ywid == 11 || ywid == 19 || ywid == 21
            || ywid == 23 || ywid == 331 || ywid == 332 || ywid == 333 || ywid == 334 || ywid == 335 || ywid == 336) //手机报
    {
        share = @"手机报";
    }
    return share;
}

/*==获取UUID==*/
+(NSString *)getDeviceUUID
{
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

//=================硬件相关=================//
/**
 获取系统中原始设备信息
 @returns 返回设备原始信息
 */
+ (NSString *) platform{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

/**
 获取具体设备名称
 @returns 设备名称
 */
+ (NSString *) platformString{
    NSString *platform = [self platform];
    if ([platform isEqualToString:@"iPod1,1"])    return @"iPod Touch";
    if ([platform isEqualToString:@"iPod2,1"])    return @"iPod Touch Second Generation";
    if ([platform isEqualToString:@"iPod3,1"])    return @"iPod Touch Third Generation";
    if ([platform isEqualToString:@"iPod4,1"])    return @"iPod Touch Fourth Generation";
    if ([platform isEqualToString:@"iPod5,1"])    return @"iPod Touch Fifth Generation";
    
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6Plus";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPad1,1"])    return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])    return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"])    return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])    return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"])    return @"iPad 2";
    if ([platform isEqualToString:@"iPad3,1"])    return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"])    return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"])    return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])    return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,5"])    return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])    return @"iPad 4";
    if ([platform isEqualToString:@"iPad2,5"])    return @"iPad Mini";
    if ([platform isEqualToString:@"iPad2,6"])    return @"iPad Mini";
    if ([platform isEqualToString:@"iPad2,7"])    return @"iPad Mini";
    //if ([platform isEqualToString:@"i386"])    return @”simulator”;
    return @"simulator";
}

+ (NSString *)screenSize {
    NSString *strSize = [NSString stringWithFormat:@"%.f*%.f", [[UIScreen mainScreen] currentMode].size.width, [[UIScreen mainScreen] currentMode].size.height];
    return strSize;
}

//=================接口安全相关=================//
//md5加密
+(NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];//转换成utf-8
    unsigned char result[16];//开辟一个16字节（128位：md5加密出来就是128位/bit）的空间（一个字节=8字位=8个二进制数）
    CC_MD5( cStr, strlen(cStr), result);
    /*
     extern unsigned char *CC_MD5(const void *data, CC_LONG len, unsigned char *md)官方封装好的加密方法
     把cStr字符串转换成了32位的16进制数列（这个过程不可逆转） 存储到了result这个空间中
     */
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
    /*
     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     NSLog("%02X", 0x888);  //888
     NSLog("%02X", 0x4); //04
     */
}

+ (NSString *)md5Lowercase:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    
    NSMutableString *resultString = [NSMutableString string];
    for (int i = 0; i != sizeof(result)/sizeof(unsigned char); ++i) {
//        [resultString appendFormat:@"%02X", result[i]];  // 大写
        [resultString appendFormat:@"%02x", result[i]];  // 小写
    }
    return resultString;
}

//安全接口（4.4.1发布后删除）
+ (NSString *)safeRequest2:(NSString *)strclientstampNow
{    
    NSString *strcstamp = [[NSUserDefaults standardUserDefaults] objectForKey:kUD_cstamp];
    NSString *strclientstamp = [[NSUserDefaults standardUserDefaults] objectForKey:kUD_clientstamp];

    
    //客户端请求时，动态计算服务端时间戳。计算方法：cstamp+（客户端当前时间戳-缓存客户端时间戳）
    NSString *cstamp = [NSString stringWithFormat:@"%.f", [strcstamp floatValue]+[strclientstampNow floatValue]-[strclientstamp floatValue]];
    
    NSString *strMD5Origin = [NSString stringWithFormat:@"%@%@%@%@%@", @"iphone",kappKey, kpwd, cstamp, strclientstampNow];
    NSString *strMD5 = [self md5:strMD5Origin];
    NSString *strRequest = @"";
    if([FFConfig currentConfig].jxs.length>0)
    {
        strRequest = [NSString stringWithFormat:@"auth=%@&appKey=%@&cstamp=%@&sign=%@&internet=%@&sys_version=%@&screen=%@&model=%@&jxs=%@",
                      kauth, kappKey, cstamp, strMD5,
                      [self returnNetWork], [[UIDevice currentDevice] systemVersion], [self screenSize], [[UIDevice currentDevice] model]
                      ,[FFConfig currentConfig].jxs];
    }
    else
    {
        strRequest = [NSString stringWithFormat:@"auth=%@&appKey=%@&cstamp=%@&sign=%@&internet=%@&sys_version=%@&screen=%@&model=%@",
                      kauth, kappKey, cstamp, strMD5, [self returnNetWork], [[UIDevice currentDevice] systemVersion], [self screenSize], [[UIDevice currentDevice] model]];
    }
    
    //添加uuid
    NSString *uuid = [[KeychainContext sharedKeychainContext] getUUID];
    if([uuid length] > 0 && ![uuid isEqual:[NSNull null]])
    {
        strRequest = [NSString stringWithFormat:@"%@&imei=%@",strRequest,uuid];
    }
   
    return strRequest;
}

//接口安全认证
+ (NSMutableData *)safeRequest:(NSMutableData *)jsonParam
{
    NSString *uuid = [[KeychainContext sharedKeychainContext] getUUID];
//    NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:KDeviceToken];

    NSString *md5Origin = nil;
    
    //Md5Util.toMD5(appKey + pwd + deviceid + jsonParam);
    NSString *json = [[NSString alloc] initWithData:jsonParam encoding:NSUTF8StringEncoding];
    NSRange range = [json rangeOfString:@"jsonParam="]; //chty=tj&params=
    if (range.location == NSNotFound) {
        md5Origin = [NSString stringWithFormat:@"%@%@%@", kappKey, kpwd, uuid];
    }else {
        md5Origin = [NSString stringWithFormat:@"%@%@%@%@", kappKey, kpwd, uuid, [json substringFromIndex:range.location+range.length]];
    }
    NSString *md5 = [self md5:md5Origin];
    NSString *strRequest = @"";
    if([FFConfig currentConfig].jxs.length>0)
    {
        strRequest = [NSString stringWithFormat:@"auth=%@&appKey=%@&md5sign=%@&internet=%@&sys_version=%@&screen=%@&model=%@&jxs=%@&imei=%@&deviceid=%@&",
                      kauth, kappKey, md5, [self returnNetWork], [[UIDevice currentDevice] systemVersion], [self screenSize], [[UIDevice currentDevice] model],[FFConfig currentConfig].jxs,uuid,uuid];
    }
    else
    {
        strRequest = [NSString stringWithFormat:@"auth=%@&appKey=%@&md5sign=%@&internet=%@&sys_version=%@&screen=%@&model=%@&imei=%@&deviceid=%@&",
                      kauth, kappKey, md5, [self returnNetWork], [[UIDevice currentDevice] systemVersion], [self screenSize], [[UIDevice currentDevice] model],uuid,uuid];
    }
    
    NSMutableData *postBody = [NSMutableData data];
    [postBody appendData:[strRequest dataUsingEncoding:NSUTF8StringEncoding]];
    return postBody;
}

//截取url字段
+ (NSString *)getParamValueFromUrl:(NSString*)url paramName:(NSString *)paramName
{
    if (![paramName hasSuffix:@"="])
    {
        paramName = [NSString stringWithFormat:@"%@=", paramName];
    }
    
    NSString * str = nil;
    NSRange start = [url rangeOfString:paramName];
    if (start.location != NSNotFound)
    {
        // confirm that the parameter is not a partial name match
//        unichar c = '?';
//        if (start.location != 0)
//        {
//            c = [url characterAtIndex:start.location - 1];
//        }
//        if (c == '?' || c == '&' || c == '#')
//        {
            NSRange end = [[url substringFromIndex:start.location+start.length] rangeOfString:@"&"];
            NSUInteger offset = start.location+start.length;
            str = end.location == NSNotFound ?
            [url substringFromIndex:offset] :
            [url substringWithRange:NSMakeRange(offset, end.location)];
            str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        }
    }
    return str;
}

+(void)decompressionFileTo:(NSString*)directory sourcepath:(NSString*)sourcepath target:(ZipArchive*)zipArchive
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:sourcepath])
    {
        BOOL result = NO;
        if ([zipArchive UnzipOpenFile:sourcepath])
        {
            result = [zipArchive UnzipFileTo:directory  overWrite:YES];
            [zipArchive UnzipCloseFile];
            
            if (result)
            {
                //                [Utilities deletePath:sourcepath];
            }
        }
    }
}

+ (void)decompressionDBAndImage:(BOOL)bundle
{
    NSString *source = nil;
    if (bundle) {
        source = [Utilities bundlePath:@"hnmcc.zip"];
    } else {
        source = [NSString stringWithFormat:@"%@hnmcc.zip", NSTemporaryDirectory()];
    }
    //解压db
    ZipArchive *zipArchive = [[ZipArchive alloc] init];
    [self decompressionFileTo:[Utilities documentsPath:@""]
                   sourcepath:source
                       target:zipArchive];
    
}

+ (NSString *)reverseString :(NSString *)reverString
{
	NSMutableString *reversedStr;
	int len = [reverString length];
	
	reversedStr = [NSMutableString stringWithCapacity:len];
	
	// Probably woefully inefficient...
	while (len > 0)
		[reversedStr appendString: [NSString stringWithFormat:@"%C", [reverString characterAtIndex:--len]]];
	
	return reversedStr;
}
//更改图片颜色
+ (UIImage*) imageBlackToTransparent:(UIImage*) image
{
    // 分配内存
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
    // 创建context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++)
    {
        if ((*pCurPtr & 0xFFFFFF00) == 0xffffff00)    // 将白色变成透明
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
        else
        {
            // 改成下面的代码，会将图片转成想要的颜色
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = 0; //0~255
            ptr[2] = 0;
            ptr[1] = 0;
            
        }
        
    }
    
    // 将内存转成image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    
    // 释放
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    // free(rgbImageBuf) 创建dataProvider时已提供释放函数，这里不用free
    
    return resultUIImage;
}

void ProviderReleaseData (void *info, const void *data, size_t size)
{
    free((void*)data);
}

+ (void)resetLocalCacheWhenUpdated
{
    NSString *currentBundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *lastBundleVersion = [[NSUserDefaults standardUserDefaults] objectForKey:KBundleVersion];
    // 版本号不一样，重置本地缓存
    if (![currentBundleVersion isEqualToString:lastBundleVersion])
    {
        //删除老的记住号码密码pwd.plist文件
        NSString *plistPath = [Utilities documentsPath:@"pwd.plist"];
        [Utilities deletePath:plistPath];
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        
        // 重置App启动次数，用来设置用户引导的
        [ud removeObjectForKey:@"LaunchTimes"];
        //删除缓存
        [ud removeObjectForKey:T_REQUEST_CACHE];
        //是否更新
        [ud setBool:NO forKey:@"isUpdate"];
        //重设版本号
        [ud setObject:currentBundleVersion forKey:KBundleVersion];
        
        [ud synchronize];
        
        [[FFConfig currentConfig] rese];
    }
}

+ (UIImage*) CombinedPicture:(UIImage*)img1 :(UIImage*)img2
{
    CGSize finalSize = [img1 size];
    
    UIGraphicsBeginImageContext(finalSize);
    [img1 drawInRect:CGRectMake(0,0,finalSize.width,finalSize.height)];
    [img2 drawInRect:CGRectMake(0,0,finalSize.width,finalSize.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    return newImage;
}

//改变请求得图片得大小
+ (UIImage*) setImg:(UIImage*)img Size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
//删除账单缓存
+ (void) deleteBillCache
{
  
    NSArray *fileArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] error:nil];
    NSMutableArray *toRemovedFileNames = [[NSMutableArray alloc] init];
    [fileArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        NSLog(@"%@", obj);
        if ([obj hasSuffix:@"consumeQuery.plist"]) {
            [toRemovedFileNames addObject:obj];
        }
    }];
    [toRemovedFileNames enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        [[NSFileManager defaultManager] removeItemAtPath:[Utilities documentsPath:obj] error:nil];
    }];
}

+ (BOOL)isValidDictionary:(id)object
{
    return object && [object isKindOfClass:[NSDictionary class]] && ((NSDictionary *)object).count;
}

+ (BOOL)isValidArray:(id)object
{
    return object && [object isKindOfClass:[NSArray class]] && ((NSArray *)object).count > 0;
}

+ (BOOL)isValidString:(id)object
{
    return object && [object isKindOfClass:[NSString class]] && ((NSString *)object).length;
}

+(NSString *) jsonStringWithString:(NSString *) string{
    return [NSString stringWithFormat:@"\"%@\"",
            [[string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""]
            ];
}

+(NSString *) jsonStringWithArray:(NSArray *)array{
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"["];
    NSMutableArray *values = [NSMutableArray array];
    for (id valueObj in array) {
        NSString *value = [Utilities jsonStringWithObject:valueObj];
        if (value) {
            [values addObject:[NSString stringWithFormat:@"%@",value]];
        }
    }
    [reString appendFormat:@"%@",[values componentsJoinedByString:@","]];
    [reString appendString:@"]"];
    return reString;
}

+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary{
    NSArray *keys = [dictionary allKeys];
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"{"];
    NSMutableArray *keyValues = [NSMutableArray array];
    for (int i=0; i<[keys count]; i++) {
        NSString *name = [keys objectAtIndex:i];
        id valueObj = [dictionary objectForKey:name];
        NSString *value = [Utilities jsonStringWithObject:valueObj];
        if (value) {
            [keyValues addObject:[NSString stringWithFormat:@"\"%@\":%@",name,value]];
        }
    }
    [reString appendFormat:@"%@",[keyValues componentsJoinedByString:@","]];
    [reString appendString:@"}"];
    return reString;
}

+(NSString *) jsonStringWithObject:(id) object{
    NSString *value = nil;
    if (!object) {
        return value;
    }
    if ([object isKindOfClass:[NSString class]]) {
        value = [Utilities jsonStringWithString:object];
    }else if([object isKindOfClass:[NSDictionary class]]){
        value = [Utilities jsonStringWithDictionary:object];
    }else if([object isKindOfClass:[NSArray class]]){
        value = [Utilities jsonStringWithArray:object];
    }
    return value;
}


//返回按钮标题
+(NSMutableArray *)returnSelectedFunButton {
    NSMutableArray  *resultList = [[NSMutableArray alloc] init];
    PersistProxy *dbp = [[PersistProxy alloc]init];
    NSString *sqlSelect = @"select * from t_ios_children_menu where a_usable = 0 and MENU_VERSION = 1 order by menu_sort";
    resultList = [dbp query:[sqlSelect uppercaseString] nsmdirect:nil columns:nil];
    if (!resultList) {
        return nil;
    }
    return resultList;
}

+(NSMutableArray *)returnUNSelectedFunButton {
    NSMutableArray  *resultList = [[NSMutableArray alloc] init];
    PersistProxy *dbp = [[PersistProxy alloc]init];
    NSString *sqlSelect = @"select * from t_ios_children_menu where a_usable = 0 and MENU_VERSION = 0 order by menu_sort";
    resultList = [dbp query:[sqlSelect uppercaseString] nsmdirect:nil columns:nil];
    if (!resultList) {
        return nil;
    }
    return resultList;
}

+(NSMutableArray *)returnBusinessType {
    NSMutableArray  *resultList = [[NSMutableArray alloc] init];
    PersistProxy *dbp = [[PersistProxy alloc]init];
    NSString *sqlSelect = @"select * from t_bis_type where a_usable = 0 and y_id < 1000 order by y_sort";
    resultList = [dbp query:[sqlSelect uppercaseString] nsmdirect:nil columns:nil];
    if (!resultList) {
        return nil;
    }
    return resultList;
}

+(NSMutableArray *)returnBusinessContent:(NSString*)sid {
    NSMutableArray  *resultList = [[NSMutableArray alloc] init];
    PersistProxy *dbp = [[PersistProxy alloc]init];
    NSString *sqlSelect = [NSString stringWithFormat:@"SELECT * FROM (SELECT *,(','||b_type||',') btype FROM t_bis) t WHERE t.btype LIKE '%%,%@,%%' and b_f_id = 0 and a_usable = 0 order by b_sort",sid];
    resultList = [dbp query:[sqlSelect uppercaseString] nsmdirect:nil columns:nil];
    if (!resultList) {
        return nil;
    }
    return resultList;
}

+(NSMutableArray *)returnBusinessSimpleContent:(NSString*)sid {
    NSMutableArray  *resultList = [[NSMutableArray alloc] init];
    PersistProxy *dbp = [[PersistProxy alloc]init];
    NSString *sqlSelect = [NSString stringWithFormat:@"SELECT * FROM t_bis WHERE b_f_id = %@ and a_usable = 0 order by b_sort",sid];
    resultList = [dbp query:[sqlSelect uppercaseString] nsmdirect:nil columns:nil];
    if (!resultList) {
        return nil;
    }
    return resultList;
}


+(NSMutableArray *)returnSqlVersion {
    NSMutableArray  *resultList = [[NSMutableArray alloc] init];
    PersistProxy *dbp = [[PersistProxy alloc]init];
    NSString *sqlSelect = @"select version from t_sqlitedb_config";
    resultList = [dbp query:[sqlSelect uppercaseString] nsmdirect:nil columns:nil];
    if (!resultList) {
        return nil;
    }
    return resultList;
}

+(NSMutableArray *)returnNavigation {
    NSMutableArray  *resultList = [[NSMutableArray alloc] init];
    PersistProxy *dbp = [[PersistProxy alloc]init];
    NSString *sqlSelect = @"select menu_name,menu_activity,menu_icon,need_login from t_ios_main_menu where a_usable = 0 order by menu_sort";
    resultList = [dbp query:[sqlSelect uppercaseString] nsmdirect:nil columns:nil];
    if (!resultList) {
        return nil;
    }
    return resultList;
}

+ (BOOL)returnURL:(NSString *)symbolStr {
    NSString *regex =@"http+:[^\\s]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    if ([predicate evaluateWithObject:symbolStr]) {
        return YES;
    }
    return NO;
}

+(NSMutableArray *)returnLinkedBis:(NSString *)type {
    NSMutableArray  *resultList = [[NSMutableArray alloc] init];
    PersistProxy *dbp = [[PersistProxy alloc]init];
    NSString *sqlSelect = [NSString stringWithFormat:@"select a.* from t_bIS a, t_liNKED_BIS  b where a.b_id=b.c_l_b_id and b.a_usable = 0 and b.c_b_id = '%@'",type];
    resultList = [dbp query:[sqlSelect uppercaseString] nsmdirect:nil columns:nil];
    if (resultList.count <= 0) {
        resultList = [[dbp query:[@"select a.* from t_bIS a, t_liNKED_BIS  b where a.b_id=b.c_l_b_id and b.c_b_id = 99999 and b.a_usable = 0" uppercaseString] nsmdirect:nil columns:nil] copy];
    }
    if (!resultList) {
        return nil;
    }
    return resultList;
}

+ (NSMutableArray *)returnBis:(NSString *)bid {
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    PersistProxy *dbp = [[PersistProxy alloc] init];
    NSString *sqlSelect = [NSString stringWithFormat:@"select * from t_bis where b_id = '%@'",bid];
    resultList = [dbp query:[sqlSelect uppercaseString] nsmdirect:nil columns:nil];
    if (!resultList) {
        return nil;
    }
    return resultList;
}

//查找4g业务
+(NSMutableArray *)return4GBis:(NSString *)sid {
    NSMutableArray  *resultList = [[NSMutableArray alloc] init];
    PersistProxy *dbp = [[PersistProxy alloc]init];
    NSString *sqlSelect = [NSString stringWithFormat:@"select * from t_bis where s_id = '%@'",sid];
    resultList = [dbp query:[sqlSelect uppercaseString] nsmdirect:nil columns:nil];
    if (!resultList) {
        return nil;
    }
    return resultList;
}


+ (CGFloat)pxTurnPt:(CGFloat)px {
    return px/96*72;
}

+ (int)getDaysOfMonth:(int)year :(int)month
{
    int days = 0;
    
    if (month == 1 || month == 3 || month == 5 || month == 7 || month == 9 || month == 10 || month == 12)
    {
        days = 31;
    }
    else if (month == 4 || month == 6 || month == 8 || month == 11)
    {
        days = 30;
    }
    else
    { // 2月份，闰年29天、平年28天
        if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0)
        {
            days = 29;
        }
        else
        {
            days = 28;
        }
    }
    
    return days;
}

@end
