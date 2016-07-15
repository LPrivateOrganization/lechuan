//
//  LTools.m
//  lechuan
//
//  Created by lichaowei on 16/7/14.
//  Copyright © 2016年 lcw. All rights reserved.
//

#import "LTools.h"
#import "UMSocial.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"

@interface LTools ()<UMSocialUIDelegate>

@end

@implementation LTools

+ (id)shareInstance
{
    static dispatch_once_t once_t;
    static LTools *manager = nil;
    dispatch_once(&once_t, ^{
        
        manager = [[LTools alloc]init];
    });
    return manager;
}


//分享
- (void)autoShareToSnsName:(NSString *)snsName
                shareTitle:(NSString *)shareTitle
                 shareText:(NSString *)shareText
                shareImage:(id)shareImage
                  shareUrl:(NSString *)shareUrl
     presentViewController:(UIViewController *)presentViewController
{
    if ([snsName isEqualToString:UMShareToQQ] || [snsName isEqualToString:UMShareToQzone]) {
        
        if (![QQApiInterface isQQInstalled] || ![QQApiInterface isQQSupportApi]) {
            
            [self showHUDText:@"抱歉,没有安装QQ客户端" delay:1.f];
            return;
        }
    }
    
    if ([snsName isEqualToString:UMShareToWechatSession] || [snsName isEqualToString:UMShareToWechatTimeline]) {
        
        if (![WXApi isWXAppInstalled] || ![WXApi isWXAppSupportApi]) {
            
            [self showHUDText:@"您的设备没有安装微信客户端" delay:1.f];
            
            return;
        }
    }
    
    UIViewController *root = presentViewController;
    
    if ([snsName isEqualToString:UMShareToQQ]) {
        
        [UMSocialData defaultData].extConfig.qqData.title = shareTitle;
        [UMSocialData defaultData].extConfig.qqData.url = shareUrl; //设置你自己的url地址;
        
    }else if ([snsName isEqualToString:UMShareToSina]){ //新浪微博
        
        shareText = [NSString stringWithFormat:@"%@%@",shareText,shareUrl];
    }
    else if ([snsName isEqualToString:UMShareToTencent]){ //腾讯微博
        
        shareText = [NSString stringWithFormat:@"%@%@",shareText,shareUrl];
        [UMSocialData defaultData].extConfig.tencentData.title = shareTitle;
        [UMSocialData defaultData].extConfig.tencentData.author = @"乐传"; //设置你自己的url地址;
        
    }else if ([snsName isEqualToString:UMShareToQzone]){
        
        //qqzone
        [UMSocialData defaultData].extConfig.qzoneData.title = shareTitle;
        [UMSocialData defaultData].extConfig.qzoneData.url = shareUrl; //设置你自己的url地址;
        
    }else if ([snsName isEqualToString:UMShareToWechatSession]){ //微信好友
        
        [UMSocialData defaultData].extConfig.wechatSessionData.title = shareTitle;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = shareUrl; //设置你自己的url地址;
        
    }else if ([snsName isEqualToString:UMShareToWechatTimeline]){ //朋友圈
        
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = shareTitle;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareUrl; //设置你自己的url地址;
        
    }else if ([snsName isEqualToString:UMShareToRenren]){ //人人网
        
        [UMSocialData defaultData].extConfig.renrenData.appName = @"乐传";
        [UMSocialData defaultData].extConfig.renrenData.url = shareUrl; //设置你自己的url地址;
        shareText = [NSString stringWithFormat:@"%@%@",shareText,shareUrl];
    }else if ([snsName isEqualToString:UMShareToSms]){ //短信
        
        shareText = [NSString stringWithFormat:@"%@%@",shareText,shareUrl];
    }
    
    [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:shareImage socialUIDelegate:self];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snsName];
    snsPlatform.snsClickHandler(root,[UMSocialControllerService defaultControllerService],YES);
    
}

#pragma mark - 分享 delegate

//实现回调方法（可选）：
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@ 成功",[[response.data allKeys] objectAtIndex:0]);
        [self showHUDText:@"分享成功" delay:1];
        
        [self shareResultIsSuccess:YES];
        
    }else if (response.responseCode == UMSResponseCodeCancel)
    {
        [self showHUDText:@"用户取消授权" delay:1];
        
        [self shareResultIsSuccess:NO];
    }
    else
    {
        NSLog(@"share to sns name is %@ 失败:%d",[[response.data allKeys] objectAtIndex:0],response.responseCode);
        [self showHUDText:@"分享失败,请再次尝试" delay:1];
        
        [self shareResultIsSuccess:NO];

    }
}

/**
 *  分享是否成功
 *
 *  @param success
 */
- (void)shareResultIsSuccess:(BOOL)success
{
    if (success) {
        DLog(@"分享成功");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"productTicket" object:@{@"isNeedShare":@"1"}];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"productTicket2" object:@{@"isNeedShare":@"1"}];
    }else
    {
        DLog(@"分享失败");
        //        [FFConfig currentConfig].isNeedShare = -1;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"productTicket" object:@{@"isNeedShare":@"-1"}]; //userInfo:@{@"isNeedShare":@(-1)}];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"productTicket2" object:@{@"isNeedShare":@"-1"}];
    }
}

- (void)showHUDText:(NSString *)text delay:(NSTimeInterval)delay
{
    UIView *view = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.margin = 10.f;
    hud.yOffset = 100.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:delay];
}

@end
