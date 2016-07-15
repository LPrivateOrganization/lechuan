//
//  FFConfig.h
//  FFLtd.
//
//  Created by 两元鱼 on 10/13/12.
//  Copyright (c) 2012 FFLtd. All rights reserved.
//


#import "FFConfig.h"

@implementation FFConfig

@synthesize defaults;

@dynamic hasSendSMS;
@dynamic hasLoginPwd;

@dynamic pubkey;

@dynamic userAreaNum;
@dynamic userCounty;
@dynamic brandBusiNum;
@dynamic userType;
@dynamic userState;
@dynamic balance;
@dynamic brandJbNumName;
@dynamic userName;
@dynamic cityBusiNum;
@dynamic phoneNumber;
@dynamic phonePwd;
@dynamic jSESSIONID;
@dynamic curMonthFee;
@dynamic usedFlow;
@dynamic totalFlow;
@dynamic isUnlimitedBandwidth;
@dynamic isPlayAt;
@dynamic isHalfFlag;
@dynamic useFlux;
@dynamic is4G;
@dynamic mailCount;

@dynamic isUsedZy;
@dynamic zyTotal;
@dynamic zyUsed;

@dynamic score;
@dynamic eCoin;
@dynamic mpoint;
@dynamic resultCode;
@dynamic unReadHotPushCount;
@dynamic isLogin;
@dynamic isAutoLogin;
@dynamic twoNetFlux;
@dynamic threeNetFlux;
@dynamic fourNetFlux;
@dynamic jxs;
@dynamic cjn;

@dynamic shareMessed;
@dynamic shareMessedId;
@dynamic shareSuccess;
@dynamic needDoShareMessod;

@dynamic isLocked;
@dynamic isLight;

@dynamic bunderPath;

@dynamic cityId;
@dynamic token;
@dynamic cityName;

//@dynamic isNeedShare;

-(id) init
{
    if(!(self = [super init]))
    {
        return self;
	}
    self.defaults = [NSUserDefaults standardUserDefaults];
	
    [self.defaults registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
                                     @NO,   dHasLoginPwd,
                                     @NO,   dHasSendSMS,
                                     @"",   dPubkey,
                                     
                                     @"",   dUserAreaNum,
                                     @"",   dUserCounty,
                                     @"",   dBrandBusiNum,
                                     @"",   dUserType,
                                     @"",   dUserState,
                                     @"",   dBalance,
                                     @"",   dBrandJbNumName,
                                     @"",   dUserName,
                                     @"",   dCityBusiNum,
                                     @"",   dPhoneNumber,
                                     @"",   dPhonePwd,
                                     @"1",  dJSESSIONID,
                                     @"",   dCurMonthFee,
                                     @"",   dUsedFlow,
                                     @"",   dTotalFlow,
                                     @"",   dIsUnlimitedBandwidth,
                                     @"",   dIsPlayAt,
                                     @"",   dIsHalfFlag,
                                     @"",   dUseFlux,
                                     @"",   dIs4G,
                                     @"",   dMailCount,
                                     
                                     @"",   dIsUsedZy,
                                     @"",   dZyTotal,
                                     @"",   dZyUsed,
                                     
                                     @"",   dScore,
                                     @"",   dECoin,
                                     @"",   dMpoint,
                                     @"",   dResultCode,
                                     @"",   dUnReadHotPushCount,
                                     @NO,   dIsLogin,
                                     @NO,   dIsAutoLogin,
                                     @"",   dTwoNetFlux,
                                     @"",   dThreeNetFlux,
                                     @"",   dFourNetFlux,
                                     @"",   dJxs,
                                     @"",   dCjn,
                                     @"",   dShareMessed,
                                     @"",   dShareMessedId,
                                     @"",   dShareSuccess,
                                     @NO,   dNeedDoShareMessod,
                                     @NO,   dIsLocked,
                                     @YES,  dIsLight,
                                     @"",   dBunderPath,
                                     @"1",  dCityId,
                                     @"",   dToken,
                                     @"呼和浩特",   dCityName,
                                     nil]];
    
	return self;
}

+(FFConfig *) currentConfig
{
    static FFConfig *instance;
    if(!instance)
    {
        instance = [[FFConfig alloc] init];
    }
    return instance;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    if ([NSStringFromSelector(aSelector) hasPrefix:@"set"])
    {
        return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
	}
    return [NSMethodSignature signatureWithObjCTypes:"@@:"];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    NSString *selector = NSStringFromSelector(anInvocation.selector);
    if ([selector hasPrefix:@"set"])
    {
        NSRange firstChar, rest;
        firstChar.location  = 3;
        firstChar.length    = 1;
        rest.location       = 4;
        rest.length         = selector.length - 5;
        
        selector = [NSString stringWithFormat:@"%@%@", [[selector substringWithRange:firstChar] lowercaseString], [selector substringWithRange:rest]];
        id value;
        [anInvocation getArgument:&value atIndex:2];
        
        if ([value isKindOfClass:[NSArray class]])
        {
            [self.defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:value] forKey:selector];
        }
        else
        {
            [self.defaults setObject:value forKey:selector];
        }
    }
    else
    {
        id value = [self.defaults objectForKey:selector];
        
        if ([value isKindOfClass:[NSData class]]) 
        {
            value = [NSKeyedUnarchiver unarchiveObjectWithData:value];
        }
        [anInvocation setReturnValue:&value];
    }
}

- (void)rese
{
//    self.defaults = nil;
    
    self.hasLoginPwd = nil;
    self.hasSendSMS = nil;
    
    self.pubkey = nil;
    
    self.userAreaNum = nil;
    self.userCounty = nil;
    self.brandBusiNum = nil;
    self.userType = nil;
    self.userState = nil;
    self.balance = nil;
    self.brandJbNumName = nil;
    self.userName = nil;
    self.cityBusiNum = nil;
    self.phoneNumber = nil;
    self.phonePwd = nil;
    self.jSESSIONID = nil;
    self.curMonthFee = nil;
    self.usedFlow = nil;
    self.totalFlow = nil;
    self.isUnlimitedBandwidth = nil;
    self.isPlayAt = nil;
    self.isHalfFlag = nil;
    self.useFlux = nil;
    self.is4G = nil;
    self.mailCount = nil;
    
    self.isUsedZy = nil;
    self.zyUsed = nil;
    self.zyTotal = nil;
    
    self.score = nil;
    self.eCoin = nil;
    self.mpoint = nil;
    self.resultCode = nil;
    self.unReadHotPushCount = nil;
    self.isLogin = nil;
    self.isAutoLogin = nil;
    self.twoNetFlux = nil;
    self.threeNetFlux = nil;
    self.fourNetFlux = nil;
    self.jxs = nil;
    self.cjn = nil;
    self.shareMessed = nil;
    self.shareMessedId = nil;
    self.shareSuccess = nil;
    self.needDoShareMessod = nil;
    self.isLocked = nil;
    self.isLight = nil;
    self.bunderPath = nil;
    self.cityId = @"1";
    self.token = @"";
    self.cityName = @"呼和浩特";
    self.isNeedShare = 0;
}

@end