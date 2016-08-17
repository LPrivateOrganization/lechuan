//
//  AppDelegate.m
//  lechuan
//
//  Created by lichaowei on 16/7/12.
//  Copyright © 2016年 lcw. All rights reserved.
//

#import "AppDelegate.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "WXApi.h"//微信
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
//#import "UMSocialTencentWeiboHandler.h"
#import "UMSocialRenrenHandler.h"

#import "UserGuideViewController.h"
#import "UMessage.h"
//#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAMapKit.h>

//友盟
#define UmengAppkey @"567b9cf067e58e0328001837"
//1-微信
//#define WXAppId @"wx9544599ba9eeb641"
//#define WXAppSecret @"bf2e624408c9f52a828e995c21d10be8"

//2-update by lcw
//#define WXAppId @"wx2096c885e9decaa3"
//#define WXAppSecret @"d4624c36b6795d1d99dcf0547af5443d"

//3-update by lcw
#define WXAppId @"wx63e868ae2813ecb8"
#define WXAppSecret @"f14f97c84ccd0f93e2a91e0f1c35fac8"

//高德地图
#define GaoDeAppKey @"ec59da5fd6eeee28f486f6fda61438c4"
//新浪微博
#define SinaAppkey @"2937440630"
#define SinaAppSecret @"6f339bed04c474302b14b02f83b2eff1"
//人人网
#define RenRenAppKey @"92f2688d61ae43739ffdad8a93102d67"
#define RenRenAppSecret @"159494e5c5e34aa680d4ce0642ab9037"
//QQ
#define QQAppId @"1104971870" //16进制41dc885e
#define QQAppSecret @"9vuQje4iyisdMbt9"
//UMessage
#define UMessageAppkey @"567b9cf067e58e0328001837"

#define RedirectUrl @"http://sns.whalecloud.com/sina2/callback" //回调地址
//下载地址
#define AppDownloadURL @"http://101.200.188.142:8080/apk/download.html"

@interface AppDelegate () <WeiboSDKDelegate, WXApiDelegate, WBHttpRequestDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [Utilities resetLocalCacheWhenUpdated];    //比对版本号，版本号更改所有信息重置
    
    NSUInteger launchTimes = [[NSUserDefaults standardUserDefaults] integerForKey:@"LaunchTimes"];
    if (launchTimes == 0)
    {
        // 生成UUID
        NSString *uuId = [[NSUserDefaults standardUserDefaults] objectForKey:kUDUUID];
        if (!uuId || [uuId length] == 0)
        {
            uuId = [Utilities getDeviceUUID];
            [[NSUserDefaults standardUserDefaults] setObject:uuId forKey:kUDUUID];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        [self showUserGuide];
    }
    else
    {
        [self showTabBar];
    }
    
    [[NSUserDefaults standardUserDefaults] setInteger:++launchTimes forKey:@"LaunchTimes"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //注册高德地图
    [MAMapServices sharedServices].apiKey = GaoDeAppKey;
    
    //注册友盟
    
    [self umengSocial];
    
    //    [UMSocialData setAppKey:@"5647fd35e0f55ae3400096a2"];
    //设置微信AppId、appSecret，分享url
//    [UMSocialWechatHandler setWXAppId:WXAppId appSecret:WXAppSecret url:@"http://www.umeng.com/social"];
    //注册新浪微博
//    [WeiboSDK enableDebugMode:YES];
//    [WeiboSDK registerApp:SinaAppkey];
    
    //set AppKey and AppSecret
    [UMessage startWithAppkey:UMessageAppkey launchOptions:launchOptions];
    [UMessage addTag:@[@"南京",@"男",@"教师",@"16-20岁"]
            response:^(id responseObject, NSInteger remain, NSError *error)
     {
         //add your codes
     }];
    //    [UMessage removeTag:@[@"南京",@"男"]
    //               response:^(id responseObject, NSInteger remain, NSError *error) {
    //                   //add your codes
    //               }];
    [UMessage getTags:^(NSSet *responseTags, NSInteger remain, NSError *error) {
        //add your codes
    }];
    if(IOS8_OR_LATER)
    {
        //register remoteNotification types （iOS 8.0及其以上版本）
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
        
    }
    else
    {
        //register remoteNotification types (iOS 8.0以下)
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
    }
    //for log
    [UMessage setLogEnabled:YES];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [UMessage registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UMessage didReceiveRemoteNotification:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    BOOL result = [UMSocialSnsService handleOpenURL:url];
//    if (result == FALSE) {
//        //调用其他SDK，例如支付宝SDK等
//    }
//    return result;
//}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    //调用其他SDK，例如支付宝SDK等
    NSString *msg = url.absoluteString;
    if ([msg hasPrefix:@"wx"]) {
        return  [WXApi handleOpenURL:url delegate:self];
    }
    if ([msg hasPrefix:@"tencent"]) {
        return [TencentOAuth HandleOpenURL:url];
    }
    else if([msg hasPrefix:@"wb"]){
        return [WeiboSDK handleOpenURL:url delegate:self];
    }else
    {
        return [UMSocialSnsService handleOpenURL:url];
    }
    
    return YES;
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSString *msg = url.absoluteString;
    if ([msg hasPrefix:@"wx"]) {
        return  [WXApi handleOpenURL:url delegate:self];
    }
    if ([msg hasPrefix:@"tencent"]) {
        return [TencentOAuth HandleOpenURL:url];
    }
    return [TencentOAuth HandleOpenURL:url];
}

#pragma mark Other Action
- (void)showTabBar
{
    self.customTBC = [[CustomTabBarController alloc] init];
    self.window.rootViewController = self.customTBC;
    [self.window makeKeyAndVisible];
}

//!用户引导
- (void)showUserGuide
{
    UserGuideViewController *userGuide = [[UserGuideViewController alloc] init];
    self.window.rootViewController = userGuide;
}

#pragma mark delegate
//新浪微博返回的值
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request;
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBAuthorizeResponse.class])//三方登录认证
    {
        if (response.statusCode == 0)
        {
            [[NSUserDefaults standardUserDefaults] setObject:[(WBAuthorizeResponse *)response accessToken]
                                                      forKey:@"weiboToken"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //获取用户信息
            if ([response.userInfo objectForKey:@"uid"] == nil )
            {
                return;
            }
            NSString * userInfoUrl = @"https://api.weibo.com/2/users/show.json";
            NSMutableDictionary * param = [[NSMutableDictionary alloc]initWithCapacity:2];
            [param setObject:response.userInfo[@"access_token"] forKey:@"access_token"];
            [param setObject:response.userInfo[@"uid"] forKey:@"uid"];
            
            [WBHttpRequest requestWithAccessToken:response.userInfo[@"access_token"]
                                              url:userInfoUrl
                                       httpMethod:@"GET"
                                           params:param
                                         delegate:self
                                          withTag:@"userInfo"];
        }
        else
        {
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"新浪微博授权失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])//分享结果回调
    {
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) { // 分享成功
            
            [[LTools shareInstance] shareResultIsSuccess:YES];
        }else
        {
            [[LTools shareInstance] shareResultIsSuccess:NO];
        }
    }
}

- (void)request:(WBHttpRequest *)request didFinishLoadingWithDataResult:(NSData *)data;
{
    NSDictionary *dict = [data objectFromJSONData];
    
    NSString *openId = dict[@"id"];
    NSString *openIdString = [NSString stringWithFormat:@"%ld",(long)[openId integerValue]];
    NSDictionary *loginInfo = @{@"thirdType":@"sina",
                                @"openId":openIdString,
                                @"screenName":dict[@"screen_name"],
                                @"imei":[[NSUserDefaults standardUserDefaults] objectForKey:kUDUUID]};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"thirdPartLogin" object:loginInfo];
    
    DLog(@"%@", dict);
}

- (void)request:(WBHttpRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    
}

/**
 收到快速SSO授权的重定向
 
 @param URI
 */

- (void)request:(WBHttpRequest *)request didReciveRedirectResponseWithURI:(NSURL *)redirectUrl
{
    
}

#pragma mark ----------------------------


//微信返回
- (void)onResp:(BaseResp *)resp
{
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"produceTicket" object:nil];
    if([resp errCode] == 0)
    {
        DLog(@"微信分享成功");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"productTicket" object:@{@"isNeedShare":@"1"}];
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"" object:@{@"isNeedShare":@"1"}];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"productTicket2" object:@{@"isNeedShare":@"1"}];
    }
    else
    {
        DLog(@"微信分享失败");
        //        [FFConfig currentConfig].isNeedShare = -1;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"productTicket" object:@{@"isNeedShare":@"-1"}]; //userInfo:@{@"isNeedShare":@(-1)}];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"productTicket2" object:@{@"isNeedShare":@"-1"}];
    }
}

#pragma mark - 友盟相关

- (void)umengSocial
{
    
    [UMSocialData setAppKey:UmengAppkey];
    
    //打开调试log的开关
    [UMSocialData openLog:NO];
    
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。需要 #import "UMSocialSinaSSOHandler.h"
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:SinaAppkey secret:SinaAppSecret RedirectURL:RedirectUrl];
        
    //设置分享到QQ空间的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:QQAppId appKey:QQAppSecret url:AppDownloadURL];
    
    //设置支持没有客户端情况下使用SSO授权
    [UMSocialQQHandler setSupportWebView:YES];
    
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:WXAppId appSecret:WXAppSecret url:AppDownloadURL];
    
    //打开腾讯微博SSO开关，设置回调地址，只支持32位
//    [UMSocialTencentWeiboHandler openSSOWithRedirectUrl:@"http://sns.whalecloud.com/tencent2/callback"];
    
    //打开人人网SSO开关
    [UMSocialRenrenHandler openSSO];
}

@end
