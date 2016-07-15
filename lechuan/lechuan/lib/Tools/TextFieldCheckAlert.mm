//
//  TextFieldCheckAlert.m
//  BLHealth
//
//  Created by lyywhg on 12-10-16.
//  Copyright (c) 2012年 BH. All rights reserved.
//

#import "TextFieldCheckAlert.h"
#import "NSString+Additions.h"
#import "RegexKitLite.h"

@implementation TextFieldCheckAlert

#pragma mark-
#pragma mark TextField Content
//是否为空
+ (BOOL)isStringNull:(NSString *)tmpString
{
    BOOL bFlag = ( (tmpString == nil) || ([tmpString isEqualToString:@""]) );
    return  bFlag;
}
//有空格
+ (BOOL)isHaveSpace:(NSString *)tmpString
{
    BOOL bFlag = [tmpString isMatchedByRegex:@"[\\s]+"];
    return  bFlag;
}
//有中文
+ (BOOL)isHaveChinese:(NSString *)tmpString
{
    BOOL bFlag = [tmpString isMatchedByRegex:@"[\u2E80-\u9FFF]+"];
    return  bFlag;
}
//有数字
+ (BOOL)isHaveNum:(NSString *)tmpString
{
    BOOL bFlag = [tmpString isMatchedByRegex:@"[\\d]+"];
    return  bFlag;
}
//有字母
+ (BOOL)isHaveWord:(NSString *)tmpString
{
    BOOL bFlag = [tmpString isMatchedByRegex:@"[A-Za-z]+"];
    return  bFlag;
}
//有特殊符号
+ (BOOL)isHaveCharacter:(NSString *)tmpString
{
    BOOL bFlag = [tmpString isMatchedByRegex:@"[:`'-,;.!@#$%^&*(){}+?></]+"];
    return  bFlag;
}
//长度超过
+ (BOOL)isLengthOverGivenLength:(NSString *)tmpString length:(int)length
{
    BOOL bFlag = ([tmpString length] > length);
    return  bFlag;
}
//长度小于
+ (BOOL)isLengthUnderGivenLength:(NSString *)tmpString length:(int)length
{
    BOOL bFlag = ([tmpString length] < length);
    return  bFlag;
}
#pragma UserName
//判断是否是几种组合
+ (BOOL)isRightUserPassword:(NSString *)tmpString
{
    int num = 0;
    
    if ([self isHaveWord:tmpString])
    {
        num = num + 1;
    }
    if ([self isHaveNum:tmpString])
    {
        num = num + 1;
    }
    if ([self isHaveCharacter:tmpString])
    {
        num = num + 1;
    }
    
    return  (num > 1);
}

+ (NSString*)converDateForString:(NSDate*)date{
   
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}
//第一个是否为数字1
+ (BOOL)isFirstIsNumOne:(NSString *)tmpString
{    
    BOOL bFlag = [[tmpString substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"1"];
    return  bFlag;
}
//手机号码
+ (BOOL)isRightPhone:(NSString *)tmpString
{
    BOOL bFlag = ( [tmpString isMatchedByRegex:@"1[0-9]{10}"] && [self isLengthUnderGivenLength:tmpString length:12] );
    return  bFlag;
}
//是否纯数字
+ (BOOL)isAllNumber:(NSString*)tmpString
{
    [NSCharacterSet decimalDigitCharacterSet];
    if ([[[tmpString stringByTrimmingCharactersInSet: [NSCharacterSet decimalDigitCharacterSet]] trim] length]>0)
    {
        return YES;
    }else
    {
        return NO;
    }
}
//邮箱
+ (BOOL)isEmail:(NSString *)tmpString
{
    BOOL bFlag = [tmpString isMatchedByRegex:@"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b"];
    return  bFlag;
}

+ (BOOL)isPureInt:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//身份证号
+ (BOOL)validateIdentityCard:(NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

@end
