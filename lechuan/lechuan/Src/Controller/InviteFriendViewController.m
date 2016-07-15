//
//  InviteFriendViewController.m
//  lechuan
//
//  Created by Kami Mahou on 15/12/9.
//  Copyright © 2015年 Kami Mahou. All rights reserved.
//

#import "InviteFriendViewController.h"
#import "InviteButton.h"
#import "QRCodeGenerator.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>

@interface InviteFriendViewController ()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, copy) NSString *shareContent;
@property (nonatomic, copy) NSString *messageContent;
@property (nonatomic, copy) NSString *shareUrl;
@property (nonatomic, strong) NSData *shareImageData;

@end

@implementation InviteFriendViewController

#pragma mark Init && Add
- (instancetype)init
{
    if (self = [super init]) {
        [self setTopViewWithTitle:@"邀请好友"];
    }
    return self;
}

- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 219*autoSizeScaleY);
        _topView.backgroundColor = [UIColor whiteColor];
        
        //标题
        UILabel *titleLabel = [[UILabel alloc] init];
        
        titleLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, 35*autoSizeScaleY);
        titleLabel.text = @"分享到";
        titleLabel.textColor = UIColorFromRGB(0x343434);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = Font(15*autoSizeScaleY);
        
        [_topView addSubview:titleLabel];
        
        //分割线
        UIImageView *lineImageView = [[UIImageView alloc] init];
        
        lineImageView.frame = CGRectMake(0, titleLabel.bottom, SCREEN_WIDTH, 0.5);
        lineImageView.image = [UIImage imageNamed:@"lineImage"];
        
        [_topView addSubview:lineImageView];
        
        //分享类别
        NSArray *textArray = @[@"微信好友", @"人人网", @"新浪微博", @"QQ好友",@"QQ空间",@"短信"];
        for (int i = 0; i < 6; i++)
        {
            InviteButton *button = [InviteButton buttonWithType:UIButtonTypeCustom];
            
            button.frame = CGRectMake(SCREEN_WIDTH/3*(i%3), lineImageView.bottom+11+(i/3)*(72+11)*autoSizeScaleY, SCREEN_WIDTH/3, 72*autoSizeScaleY);
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"shareButton_%d", i]]
                    forState:UIControlStateNormal];
            [button setTitle:textArray[i] forState:UIControlStateNormal];
            [button setTitleColor:UIColorFromRGB(0x595959) forState:UIControlStateNormal];
            button.titleLabel.font = Font(13);
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            button.tag = i;
            [button addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [_topView addSubview:button];
        }
        
        [self.scrollView addSubview:_topView];
    }
    return _topView;
}

- (UIView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [[UIView alloc] init];
        
        [self.scrollView addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-34, 291*autoSizeScaleY));
            make.left.equalTo(self.view.mas_left).with.offset(17);
            make.top.equalTo(self.topView.mas_bottom).with.offset(12);
            make.bottom.equalTo(self.scrollView).with.offset(-12);
        }];
        
        _bottomView.layer.cornerRadius = 10;
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        //标题
        UILabel *titleLabel = [[UILabel alloc] init];
        
        titleLabel.frame = CGRectMake(0, 20*autoSizeScaleY, SCREEN_WIDTH-34, 18*autoSizeScaleY);
        titleLabel.text = @"扫描下方二维码关注乐传最新动态";
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = Font(15*autoSizeScaleY);
        
        [_bottomView addSubview:titleLabel];
        
        //底部图片
        UIImageView *bottomImage = [[UIImageView alloc] init];
        
        [_bottomView addSubview:bottomImage];
        [bottomImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_bottomView);
            make.size.mas_equalTo(CGSizeMake(29*autoSizeScaleY, 29*autoSizeScaleY));
            make.bottom.equalTo(_bottomView).with.offset(-14*autoSizeScaleY);
        }];
        
        bottomImage.image = [UIImage imageNamed:@"scanImage"];
        
        //二维码
        NSString *shareLink = self.shareUrl;
        
        UIImageView *QRCodeIV = [[UIImageView alloc] init];
        
        [self.view addSubview:QRCodeIV];
        [QRCodeIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_bottomView);
            make.size.mas_equalTo(CGSizeMake(177*autoSizeScaleY, 177*autoSizeScaleY));
            make.bottom.equalTo(bottomImage.mas_top).with.offset(-15*autoSizeScaleY);
        }];
        QRCodeIV.layer.borderColor = [UIColor redColor].CGColor;
        QRCodeIV.layer.borderWidth = 4;
        QRCodeIV.layer.cornerRadius = 6;

        
        QRCodeIV.image = [QRCodeGenerator qrImageForString:shareLink imageSize:150];
    }
    return _bottomView;
}

#pragma mark System Action
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.scrollView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    self.scrollView.backgroundColor = UIColorFromRGB(0xeeeeee);
    self.topView.alpha = 1.0f;
    
    [self getShareMessage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark Other Action
- (void)shareAction:(InviteButton *)button
{
    if (button.tag == 0)
    {
        if ([WXApi isWXAppInstalled])
        {
            //网页形式
            SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
            req.bText = NO;//分享内容带图片和文字时必须为NO
            
            //设置这个路径是为了点击聊天列表的气泡时也可以跳转
            WXWebpageObject *ext = [WXWebpageObject object];
            ext.webpageUrl = self.shareUrl;
            
            WXMediaMessage *mess = [WXMediaMessage message];
            [mess setThumbImage:[UIImage imageWithData:self.shareImageData]];
            mess.mediaObject = ext;
            //如果分享的内容包括文字和图片,这个时候的文字不能使用req.text属性来接收,必须使用下边的两个属性
            mess.title = self.shareContent;
            mess.description = self.shareContent;
            req.message = mess;
            if (button.tag == 0)
            {
                req.scene = WXSceneSession;
            }
            else
            {
                req.scene = WXSceneTimeline;
            }
            [WXApi sendReq:req];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你还没有安装微信，可去App Store下载。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"下载", nil];
            alert.tag = 0;
            
            [alert show];
        }
    }
    
    if (button.tag == 1) { // 人人网
        
        [[LTools shareInstance] autoShareToSnsName:UMShareToRenren shareTitle:self.shareContent shareText:self.shareContent shareImage:self.shareImageData shareUrl:self.shareUrl presentViewController:self];
        
    }
    if (button.tag == 5)
    {
        self.messageContent =[NSString stringWithFormat: @"%@%@",self.shareContent,self.shareUrl];
        NSArray *typeArray = @[UMShareToWechatSession, UMShareToWechatTimeline, UMShareToSina, UMShareToQQ,UMShareToQzone,UMShareToSms];
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[typeArray[button.tag]]
                                                            content:self.messageContent
                                                              image:nil
                                                           location:nil
                                                        urlResource:nil
                                                presentedController:self
                                                         completion:^(UMSocialResponseEntity *response)
         {
             if (response.responseCode == UMSResponseCodeSuccess)
             {
                 NSLog(@"分享成功！");
             }
         }];
    }
    if (button.tag == 2) //新浪微博
    {
        if ([WeiboSDK isWeiboAppInstalled])
        {
            NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"weiboToken"];
            
            WBAuthorizeRequest* authRequest = [WBAuthorizeRequest request];
            authRequest.scope = @"all";
            WBSendMessageToWeiboRequest* request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare]
                                                                                        authInfo:authRequest access_token:token];
            
            request.userInfo=@{@"ShareMessageFrom":@"ShareViewController",
                               @"Other_Info_11":[NSNumber numberWithInt:1234],
                               @"Other_Info_21":@[@"obj11",@"obj22"],
                               @"Other_Info_31":@{@"key11":@"obj11",@"key22":@"obj22"}};
            //        request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
            [WeiboSDK sendRequest:request];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你还没有安装新浪微博，可去App Store下载。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"下载", nil];
            alert.tag = 1;

            [alert show];
        }
    }
    if (button.tag == 3 || button.tag == 4)//QQ\QQ空间
    {
//        TencentOAuth * tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1104971870" andDelegate:self];
        if ([TencentOAuth iphoneQQInstalled])
        {
            //分享跳转URL
            NSString *url = self.shareUrl;
//            //分享图预览图URL地址
//            NSString *previewImageUrl = @"preImageUrl.png";
//            QQApiNewsObject *newsObj = [QQApiNewsObject
//                                        objectWithURL:[NSURL URLWithString:[url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
//                                        title: self.shareContent
//                                        description:self.shareContent
//                                        previewImageURL:[NSURL URLWithString:previewImageUrl]];
//            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
            
            
            if (button.tag == 3)
            {
                //将内容分享到qq
//                [QQApiInterface sendReq:req];
                [[LTools shareInstance] autoShareToSnsName:UMShareToQQ shareTitle:self.shareContent shareText:self.shareContent shareImage:self.shareImageData shareUrl:url presentViewController:self];
            }
            else
            {
                //将内容分享到qzone
//                [QQApiInterface SendReqToQZone:req];
                [[LTools shareInstance] autoShareToSnsName:UMShareToQzone shareTitle:self.shareContent shareText:self.shareContent shareImage:self.shareImageData shareUrl:url presentViewController:self];
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你还没有安装QQ，可去App Store下载。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"下载", nil];
            alert.tag = 2;
            
            [alert show];
        }
    }
}

//新浪微博分享的内容
- (WBMessageObject*)messageToShare
{
    WBMessageObject* message = [WBMessageObject message];
    WBImageObject* image = [WBImageObject object];
    
//    NSData* imgData = UIImagePNGRepresentation([UIImage imageNamed:@"appIcon"]);
    message.text = self.shareContent;
    message.text = [NSString stringWithFormat:@"%@ 下载地址:%@",self.shareContent,self.shareUrl];
    image.imageData = self.shareImageData;
    message.imageObject = image;
    
    return message;
}

#pragma mark Service
- (void)getShareMessage
{
    NSString *param = Intrrface_getShareMessage;
    [[BHServiceDataCentre sharedInstance] blHealthRequestByDict:param
                                                     parameters:nil
                                                        showHUD:YES
                                                     controller:self
                                                           type:CC_Intrrface_getShareMessage
                                             serviceAnswerBlock:^(BOOL isSuccess, id responseMsg,
                                                                  NSInteger type, NSString *errorMsg)
    {
        if (isSuccess && type == CC_Intrrface_getShareMessage)
        {
            if ([Utilities isValidArray:responseMsg[@"content"]])
            {
                NSArray *content = responseMsg[@"content"];
                
                NSString *imagePath = [[baseServerAddress stringByAppendingString:content[0][@"str"]] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                self.shareImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]];
                self.shareContent = content[1][@"str"];
                self.shareUrl = content[2][@"str"];
                
                self.bottomView.alpha = 1.0f;
            }
        }
    }];
}

#pragma mark delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 0 && buttonIndex == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[WXApi getWXAppInstallUrl]]];
    }
    if (alertView.tag == 1 && buttonIndex == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[WeiboSDK getWeiboAppInstallUrl]]];
    }
    if (alertView.tag == 2 && buttonIndex == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[QQApiInterface getQQInstallUrl]]];
    }
}

@end
