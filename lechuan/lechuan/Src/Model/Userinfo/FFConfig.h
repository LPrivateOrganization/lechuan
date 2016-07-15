//
//  FFConfig.h
//  FFLtd.
//
//  Created by KamiMahou on 07/01/15.
//  Copyright (c) 2015 FFLtd. All rights reserved.
//

#import <Foundation/Foundation.h>


#define  dHasSendSMS                     NSStringFromSelector(@selector(dHasSendSMS))

#define  dHasLoginPwd                    NSStringFromSelector(@selector(dHasLoginPwd))
#define  dPubkey                         NSStringFromSelector(@selector(dPubkey))

#define  dUserAreaNum                    NSStringFromSelector(@selector(dUserAreaNum))
#define  dUserCounty                     NSStringFromSelector(@selector(dUserCounty))
#define  dBrandBusiNum                   NSStringFromSelector(@selector(dBrandBusiNum))
#define  dUserType                       NSStringFromSelector(@selector(dUserType))
#define  dUserState                      NSStringFromSelector(@selector(dUserState))
#define  dBalance                        NSStringFromSelector(@selector(dBalance))
#define  dBrandJbNumName                 NSStringFromSelector(@selector(dBrandJbNumName))
#define  dUserName                       NSStringFromSelector(@selector(dUserName))
#define  dCityBusiNum                    NSStringFromSelector(@selector(dCityBusiNum))
#define  dPhoneNumber                    NSStringFromSelector(@selector(dPhoneNumber))
#define  dPhonePwd                       NSStringFromSelector(@selector(dPhonePwd))
#define  dJSESSIONID                     NSStringFromSelector(@selector(dJSESSIONID))
#define  dCurMonthFee                    NSStringFromSelector(@selector(dCurMonthFee))
#define  dUsedFlow                       NSStringFromSelector(@selector(dUsedFlow))
#define  dTotalFlow                      NSStringFromSelector(@selector(dTotalFlow))
#define  dIsUnlimitedBandwidth           NSStringFromSelector(@selector(dIsUnlimitedBandwidth))
#define  dIsPlayAt                       NSStringFromSelector(@selector(dIsPlayAt))
#define  dIsHalfFlag                     NSStringFromSelector(@selector(dIsHalfFlag))
#define  dUseFlux                        NSStringFromSelector(@selector(dUseFlux))
#define  dIs4G                           NSStringFromSelector(@selector(dIs4G))
#define  dMailCount                      NSStringFromSelector(@selector(dMailCount))

#define  dIsUsedZy                       NSStringFromSelector(@selector(dIsUsedZy))
#define  dZyTotal                        NSStringFromSelector(@selector(dZyTotal))
#define  dZyUsed                         NSStringFromSelector(@selector(dZyUsed))

#define  dScore                          NSStringFromSelector(@selector(dScore))
#define  dECoin                          NSStringFromSelector(@selector(dECoin))
#define  dMpoint                         NSStringFromSelector(@selector(dMpoint))
#define  dResultCode                     NSStringFromSelector(@selector(dResultCode))
#define  dUnReadHotPushCount             NSStringFromSelector(@selector(dUnReadHotPushCount))
#define  dIsLogin                        NSStringFromSelector(@selector(dIsLogin))
#define  dIsAutoLogin                    NSStringFromSelector(@selector(dIsAutoLogin))
#define  dTwoNetFlux                     NSStringFromSelector(@selector(dTwoNetFlux))
#define  dThreeNetFlux                   NSStringFromSelector(@selector(dThreeNetFlux))
#define  dFourNetFlux                    NSStringFromSelector(@selector(dFourNetFlux))
#define  dJxs                            NSStringFromSelector(@selector(dJxs))
#define  dCjn                            NSStringFromSelector(@selector(dCjn))

#define  dShareMessed                    NSStringFromSelector(@selector(dShareMessed))
#define  dShareMessedId                  NSStringFromSelector(@selector(dShareMessedId))
#define  dShareSuccess                   NSStringFromSelector(@selector(dShareSuccess))
#define  dNeedDoShareMessod              NSStringFromSelector(@selector(dNeedDoShareMessod))
#define  dIsLocked                       NSStringFromSelector(@selector(dIsLocked))
#define  dIsLight                        NSStringFromSelector(@selector(dIsLight))

#define  dBunderPath                     NSStringFromSelector(@selector(dBunderPath))

#define  dCityId                         NSStringFromSelector(@selector(dCityId))
#define  dToken                          NSStringFromSelector(@selector(dToken))
#define  dCityName                       NSStringFromSelector(@selector(dCityName))

@interface FFConfig : NSObject
{
	NSUserDefaults                                      *defaults;
}

+ (FFConfig *)            currentConfig;
- (void)                  rese;

@property (readwrite, retain) NSUserDefaults             *defaults;

//加入短信登录判断、服务密码登录判读
@property (nonatomic, readwrite, retain) NSNumber *hasSendSMS, *hasLoginPwd;
//支付宝公钥
@property (nonatomic, readwrite, retain) NSString *pubkey;

@property (nonatomic, readwrite, retain) NSString *userAreaNum;
@property (nonatomic, readwrite, retain) NSNumber *userCounty;
@property (nonatomic, readwrite, retain) NSString *brandBusiNum;
@property (nonatomic, readwrite, retain) NSString *userType;
@property (nonatomic, readwrite, retain) NSString *userState;
@property (nonatomic, readwrite, retain) NSString *balance;
@property (nonatomic, readwrite, retain) NSString *brandJbNumName;
@property (nonatomic, readwrite, retain) NSString *userName;
@property (nonatomic, readwrite, retain) NSString *cityBusiNum;
@property (nonatomic, readwrite, retain) NSString *phoneNumber;
@property (nonatomic, readwrite, retain) NSString *phonePwd;
@property (nonatomic, readwrite, retain) NSString *jSESSIONID;
@property (nonatomic, readwrite, retain) NSString *curMonthFee;
@property (nonatomic, readwrite, retain) NSString *usedFlow;
@property (nonatomic, readwrite, retain) NSString *totalFlow;
@property (nonatomic, readwrite, retain) NSString *isUnlimitedBandwidth;
@property (nonatomic, readwrite, retain) NSString *isPlayAt;
@property (nonatomic, readwrite, retain) NSString *isHalfFlag;
@property (nonatomic, readwrite, retain) NSString *useFlux;
@property (nonatomic, readwrite, retain) NSString *is4G;
@property (nonatomic, readwrite, retain) NSString *mailCount;

@property (nonatomic, readwrite, retain) NSString *isUsedZy;
@property (nonatomic, readwrite, retain) NSString *zyTotal;
@property (nonatomic, readwrite, retain) NSString *zyUsed;

@property (nonatomic, readwrite, retain) NSString *score;
@property (nonatomic, readwrite, retain) NSString *eCoin;
@property (nonatomic, readwrite, retain) NSString *mpoint;
@property (nonatomic, readwrite, retain) NSNumber *resultCode;
@property (nonatomic, readwrite, retain) NSString *unReadHotPushCount;
@property (nonatomic, readwrite, retain) NSNumber *isLogin;
@property (nonatomic, readwrite, retain) NSNumber *isAutoLogin;
@property (nonatomic, readwrite, retain) NSString *twoNetFlux;//2G
@property (nonatomic, readwrite, retain) NSString *threeNetFlux;//3G
@property (nonatomic, readwrite, retain) NSString *fourNetFlux;//4G
@property (nonatomic, readwrite, retain) NSString *jxs;
@property (nonatomic, readwrite, retain) NSString *cjn;

//分享
@property (nonatomic, readwrite, retain) NSString *shareMessed;
@property (nonatomic, readwrite, retain) NSString *shareMessedId;
@property (nonatomic, readwrite, retain) NSString *shareSuccess;
@property (nonatomic, readwrite, retain) NSNumber *needDoShareMessod;

//锁屏状体
@property (nonatomic, readwrite, retain) NSNumber *isLocked;
@property (nonatomic, readwrite, retain) NSNumber *isLight;//屏幕是否亮

//语言
@property (nonatomic, readwrite, retain) NSString *bunderPath;

//城市id
@property (nonatomic, readwrite, retain) NSString *cityId;
@property (nonatomic, readwrite, retain) NSString *token;
@property (nonatomic, readwrite, retain) NSString *cityName;

//强制转发
@property (nonatomic, assign) NSInteger isNeedShare;

@end
