//
//  TextFieldCheckAlert.h
//  BLHealth
//
//  Created by lyywhg on 12-10-16.
//  Copyright (c) 2012年 BH. All rights reserved.
//

@interface TextFieldCheckAlert : NSObject

+ (BOOL)isStringNull:(NSString *)tmpString;
+ (BOOL)isHaveSpace:(NSString *)tmpString;
+ (BOOL)isHaveChinese:(NSString *)tmpString;
+ (BOOL)isHaveNum:(NSString *)tmpString;
+ (BOOL)isHaveWord:(NSString *)tmpString;
+ (BOOL)isHaveCharacter:(NSString *)tmpString;
+ (BOOL)isLengthOverGivenLength:(NSString *)tmpString length:(int)length;
+ (BOOL)isLengthUnderGivenLength:(NSString *)tmpString length:(int)length;
+ (BOOL)isRightUserPassword:(NSString *)tmpString;
+ (BOOL)isFirstIsNumOne:(NSString *)tmpString;
+ (BOOL)isRightPhone:(NSString *)tmpString;
+ (BOOL)isAllNumber:(NSString*)tmpString;
+ (BOOL)isEmail:(NSString *)tmpString;
//+ (BOOL)isAllNumber:(NSString*)tmpString;
+ (NSString*)converDateForString:(NSDate*)date;
+ (BOOL)isPureInt:(NSString*)string;
+ (BOOL)validateIdentityCard:(NSString *)identityCard;

@end
