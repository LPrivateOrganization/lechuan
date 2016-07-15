//
//  PublicDefinitions.h
//  ecmc
//
//  Created by cp9 on 13-1-10.
//  Copyright (c) 2013年 cp9. All rights reserved.
//

//现网环境地址
#define kServerAddr @"http://223.68.131.168:28080/hnmccClient/action.dox"
//@"http://service.js.10086.cn/jsmccClient/action.dox"
//测试环境地址
//#define kServerAddr @"http://service.js.10086.cn/jsmccClientM/jsmccTest/action.dox" // 测试库
//#define kServerAddr @"http://service.js.10086.cn/jsmccClientM/jsmcc/action.dox" // 现网库

//http://service.js.10086.cn/jsmccClientM/jsmcc/action.dox
//这个是测试环境地址
//http://service.js.10086.cn/jsmccClient/action.dox
//这个是现网地址

//=================NSUserDefaults值===================//
#pragma mark - NSUserDefaults
//自动登录
#define kUD_AutoLogin @"AutoLogin"
//手机号码
#define kUD_MyPhoneNumber @"myPhoneNumber"

//更换欢迎页
#define KUD_queryWelcome @"queryWelcome"
#define kWelcomeImageSaved @"WelcomImageSaved"

//广告请求
#define kRequestAdvert @"RequestAdvert"
#define kUpdateDB @"UpdateDB"

//强制升级
#define KVersionUpgrade @"UpgradeVersion"
#define KUpgradeVersionInfo @"UpgradeVersionInfo"

//检测更新
#define KCheckVersion @"CheckVersion"
//deviceToken
#define KDeviceToken @"devToken"

#define kNavHeight 44

//业务宏定义
#define Font_Size 14.0f
#define Bis_Cell_Content_Width 320.0f
#define Bis_Cell_Content_Margin 10.0f

//流量查询
#define curMonthFlow_tag 9000  //9000-9050都已使用
//新业务全部业务
#define allBisTitleLabel_tag 9051
#define allBisHeadImage_tag 9150
#define allBisChildTitleLabel_tag 9250
#define allBisChildHeadImage_tag 9350
#define allBisChildContentLabel_tag 9450
#define allBisChildLine_tag 9550
//新分享
#define share_btn_tag 9600 //9600-9610使用
//彩铃试听非wifi提示
#define ring_tip_tag  9620
//新充值
#define recharge_tipView_tag 9621
#define recharge_tipLabel_tag 9622
#define recharge_money_btn_tag 9623 //-9633使用
#define recharge_activity_view_tag 9634 //-9639使用
#define recharge_pay_btn_tag 9640 //-9650
#define recharge_line_view_tag 9651
#define recharge_banner_btn_ag 9652 //-9672使用
#define recharge_notice_btn_tag 9673 //-9693使用
#define recharge_ye_label_tag 9694 //-9697使用
#define recharge_ye_bg_tag 9698
#define recharge_wenxin_textField_tag 9699
#define recharge_Records_textField_tag 9700
#define recharge_wenxi_label_tab 9701
#define recharge_phoneNumRemmber_btn_tag 9702
#define recharge_gotoContactVC_btn_tag 9703
#define recharge_activityBtn_tag 9704 //-9724
#define recharge_activite_line_view_tag 9725 //-9726
#define recharge_wenxin_ImgView_tag 9727
#define upgrade_alertView1_tag 9728
#define upgrade_alertView2_tag 9729

//ios7适配的高度选择
#define kIOSHeight       ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? 20.0 : 0.0)

//ios7适配导航栏按钮的位置
#define kIOSEdgeInsets   ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? 0.0 : 0.0)

//ios7适配导航栏按钮的位置
#define kIOSRightEdgeInsets   ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? 12.0 : 0.0)


#define kScreenHeightWithNaviBarAndTabbar  ([UIScreen mainScreen].bounds.size.height- 49 - 64)
#define kScreenHeightWithNaviBarNoTabbar  ([UIScreen mainScreen].bounds.size.height- 49)
#define kScreenHeightWithTabbarNoNaviBar  ([UIScreen mainScreen].bounds.size.height- 64)

//表格标题颜色
#define KTableTitleColor @"525252"
#define KTableSubTitleColor @"979797"
#define KTableSelectedColor @"d6eafb"

//首页灰色背景及线
#define CLR_BK_LINE @"e1e1e1"
#define CLR_BORDER_VIEW @"d3d3d3"
#define CLR_TITLE @"929ca5"
#define CLR_4GBTN_TITLE @"362e2b"
#define CLR_4GBTN_CONTENT @"929ca5"
#define CLR_BK @"f1f1f1"

//蓝色背景
#define CLR_BLUE_LOW @"4097e7"
#define CLR_BLUE_DEEP @"2c7fca"


//按钮
#define CLR_BTN @"32a2ea"
#define CLR_BTN_SEL @"3aaaf2"

#define CLR_TEXT @"5e5a58"
#define CLR_BLUE @"4197e7"

#define PCColorBlue [UIColor getColor:@"20aff9"]
#define PCColorGreen [UIColor getColor:@"90c31e"]
#define PCColorOrange [UIColor getColor:@"eeaf24"]
#define PCColorRed [UIColor getColor:@"e40177"]
#define PCColorYellow [UIColor getColor:@"ecf413"]
#define PCColorDefault [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0]
#define PCColorPurper [UIColor getColor:@"8227e7"]
#define PCColorDarkBlue [UIColor getColor:@"318ae7"]

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define defaultHt (SCREEN_HEIGHT == 480 ? 568 : SCREEN_HEIGHT)
#define autoSizeScaleX (SCREEN_WIDTH/375)
#define autoSizeScaleY (defaultHt/667)
#define AutoCGRectMake(x,y,width,height) (CGRectMake(x*autoSizeScaleX,y*autoSizeScaleY,width*autoSizeScaleX,height*autoSizeScaleY))
#define AutoCGSizeMake(width,height) (CGSizeMake(width*autoSizeScaleX,height*autoSizeScaleY))

/// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#pragma mark - Safe Release functions
#pragma mark   释放相关
///安全释放
#define TT_RELEASE_SAFELY(__REF) \
{\
if (nil != (__REF)) \
{\
CFRelease(__REF); \
__REF = nil;\
}\
}

#define DEBUGLOG
#ifdef DEBUGLOG
#       define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#       define DLog(...)
#endif

//线的粗度
#define LINE_WIDTH 0.5

//首页菜单文件
#pragma mark - custom menu plist

// 首页内嵌wap
#define kHomeEmbedWebURL @"http://wap.js.10086.cn/CLIENTINDEX_IOS.shtml"

//我的e币
#define kECoinExchangeURL @"http://wap.js.10086.cn/activity/77?ch=03&from=appcxyh"

#pragma mark - new functions count
#define kNewFunctionCount @"NewFunctionCount"

//本地统计用户数据量
#define kUploadActionDispatcher @"ActionDispatcher"
#define kUploadTime @"kUploadTime"
//本地保存用户操作记录
#define kUploadActionDispatcherPlist @"ActionDispatcher.plist"
//服务密码登录失败信息保存
#define kLoginErrorMsgPlist @"LoginErrorMsg.plist"
//服务密码登录失败信息
#define kLoginErrorMsg @"LoginErrorMsg"
#define kDESKEY @"scm%e458"

//本机唯一标识符uuid（程序自身存储）
#define kUDUUID @"uduuid"

// 最后更新登录错误次数或切换号码次数的时间
#define kLastUpdateLoginErrorORSwitchUserDate @"LastUpdateLoginErrorORSwitchUserDate"
// 登录错误次数
#define kLoginErrorCount @"kLoginErrorCount"
// 切换号码次数
#define kSwitchUserCount @"SwitchUserCount"

//推送deviceToken保存
#define KDevictTokenSave @"SaveDeviceToken"
//devictToken和手机号绑定
#define KLoginTime @"LoginTime"
#define KLoginOutTime @"LoginOutTime"

#pragma mark -
#define kColorBlueStyle [UIColor colorWithRed:0 green:160/255. blue:233/255. alpha:1]

#pragma mark -
#define kApplicationFrame [[UIScreen mainScreen] applicationFrame]

#define kMakeUIViewControllerViewFrame(self) CGRectMake(0,\
0,\
CGRectGetWidth(kApplicationFrame),\
CGRectGetHeight(kApplicationFrame) - CGRectGetHeight(self.navigationController.navigationBar.frame) - CGRectGetHeight(self.tabBarController.tabBar.frame))

#define kMakeUIViewControllerViewFrameWithoutTabBar(self) CGRectMake(0,\
0,\
CGRectGetWidth(kApplicationFrame),\
CGRectGetHeight(kApplicationFrame) - CGRectGetHeight(self.navigationController.navigationBar.frame))

//=================相关提示语===================//
#define kisUnlimitedBandwidth @"您开通的是WAP不限量套餐"

//=================接口安全相关=================//
//安全认证状态
#define kauth @"yes" //no

//应用渠道key
#define kappKey @"00011"

//应用渠道密钥，程序中保密保存
#define kpwd @"iphone!@#"

//服务器当前时间戳
#define kUD_cstamp @"cstamp"

//客户端/当前时间戳
#define kUD_clientstamp @"clientstamp"

//客户端/当前时间戳cookie
#define kUD_clientstampNow @"clientstampnow"

#define JFHelpWeb @"http://112.53.127.41:32815/hnmccClientWap/jfbz.html"

#pragma mark - interface
//=================接口定义=================//

//1.	首页广告列表
#define Interface_productList(cityId) [NSString stringWithFormat:@"poster/listWithProduct?search_LIKE_cityIds=%@&page.size=5&search_EQ_status=0", cityId]
//2.	首页产品列表
#define Interface_bannerList(page, type, cityId) [NSString stringWithFormat:@"product/list?page=%@&page.size=6&search_EQ_status=0&search_EQ_productCategory.id=%d&search_LIKE_cityIds=%@", page,type, cityId]
//3.	城市列表
#define Interface_cityList @"city/list?page.size=1000&search_EQ_status=0"
//4.    登录
#define Interface_login @"login"
//5.    有效礼品券
#define Interface_usableTicket(imei)[NSString stringWithFormat:@"user/prizes?page=1&page.size=100&search_EQ_status=0&search_EQ_imei=%@",imei]; 
//5.    有效礼品券1
#define Interface_usableTicket1 @"user/prizes?page=1&page.size=100&search_EQ_status=0";
//6.    失效礼品券
#define Interface_unUsableTicket @"user/prizes?page=1&page.size=100&search_GT_status=-2&search_NEQ_status=0";
//6.    失效礼品券1
#define Interface_unUsableTicket1(imei) [NSString stringWithFormat:@"user/prizes?page=1&page.size=100&search_GT_status=-2&search_NEQ_status=0&search_EQ_imei=%@",imei];
//7.    获取传播、代理 6传播，7代理
#define Interface_content(status) [NSString stringWithFormat:@"const/list?search_EQ_id=%d", status];
//8.    删除礼品券
#define Interface_deletaTicket(id) [NSString stringWithFormat:@"prize/delete?id=%d", id];
//9.    领取电子券
#define Intrrface_fetchTicket @"prize/fetch"
//10.   生成电子券
#define Intrrface_produceTicket @"prize/add"
//11.   修改密码
#define Intrrface_changePassword @"user/changePassword"
//12.   注册
#define Interface_regist @"user/register"
//13.   更新用户信息
#define Intrrface_updateUserInfo @"user/update"
//14.   获取用户信息
#define Intrrface_achieveInfo @"user/me"
//15.   浮窗接口
#define Intrrface_floatWindow @"const/list?search_GT_id=12&search_LT_id=15"
//16.   三方登录
#define Intrrface_thirdLogin @"user/thirdLogin"
//17.   获取分享与和分享链接
#define Intrrface_getShareMessage @"const/list?page.size=3&search_GT_id=9&search_LT_id=13"
//18.    消费电子券
#define Intrrface_buyTicket @"prize/buy"
//19.    获取抢卷用户信息
#define Intrrface_knockTicket(imei) [NSString stringWithFormat:@"user/userInfo?imei=%@", imei];
//20.    我的信息
#define Interface_getMyTest(imei, cityName) [NSString stringWithFormat:@"user/userMessage?page=1&page.size=6&search_EQ_imei=%@&search_LIKE_filter=%@", imei,cityName];
//21.    获取广告详细信息
#define Interface_getBannerTest(id) [NSString stringWithFormat:@"product/list?search_EQ_id=%@", id];
//22.    获取广告详细信息
#define Interface_writeInfo @"user/userInfo/save"
//23.    获取地图页面的广告详细信息
#define Interface_mapProductInfo(cityId) [NSString stringWithFormat:@"product/vendor?cityId=%@", cityId];
//上传信息
#define Interface_uploadList @"adLog/add?keyValue=1"



