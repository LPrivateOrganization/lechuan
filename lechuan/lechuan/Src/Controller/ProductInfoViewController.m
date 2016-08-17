//
//  ProductInfoViewController.m
//  lechuan
//
//  Created by Kami Mahou on 15/12/14.
//  Copyright © 2015年 Kami Mahou. All rights reserved.
//

#import "ProductInfoViewController.h"
#import "LocationButton.h"
#import "MapViewController.h"
#import "MyTicketViewController.h"
#import "UMessage.h"

#import "UMSocial.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"

bool check;
NSString *phone;
NSString *confirmPhone;
NSString *gender;
NSString *age;
NSString *job;

@interface ProductInfoViewController ()<UMSocialUIDelegate,UIWebViewDelegate>

@property (nonatomic, strong) LocationButton *locationButton;
@property (nonatomic, strong) UIImageView *productImageView;
@property (nonatomic, strong) UIButton *getProductButton;
//!领取成功弹窗
@property (nonatomic, strong) UIView *successView;
//!领取电子通讯成功弹窗
@property (nonatomic, strong) UIView *electronSuccessView;
@property (nonatomic, strong) UIView *electronView;
@property (nonatomic, strong) UITextField *textfield;
@property (nonatomic, strong) UITextField *confirmTextfild;
//!第一次抢弹窗
@property (nonatomic, strong) UIView *firstview;
@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, assign) NSString *gender;
@property (nonatomic, assign) NSString *age;
@property (nonatomic, assign) NSString *job;

@property (nonatomic, strong)UIWebView *webView;
@property (nonatomic, strong)NSData *shareImageData;//分享图片

@end

@implementation ProductInfoViewController

#pragma mark Init && Add
- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

- (LocationButton *)locationButton
{
    if (!_locationButton) {
        _locationButton = [LocationButton buttonWithType:UIButtonTypeCustom];
        
        _locationButton.frame = CGRectMake(SCREEN_WIDTH-48-15, 64-44, 48, 44);
        [_locationButton setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
        [_locationButton setTitle:@"定位" forState:UIControlStateNormal];
        [_locationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _locationButton.titleLabel.font = Font(12);
        _locationButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [_locationButton addTarget:self action:@selector(jumoToMapVC) forControlEvents:UIControlEventTouchUpInside];
        
        [self.topTitleView addSubview:_locationButton];
    }
    return _locationButton;
}

- (UIImageView *)productImageView
{
    if (!_productImageView) {
        _productImageView = [[UIImageView alloc] init];
        
        _productImageView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-50*autoSizeScaleY);
        NSString *path = @"";
        
        for (NSDictionary *imageDic in self.infoDic[@"productImages"])
        {
            if ([imageDic[@"type"] integerValue] == 2)
            {
                path = imageDic[@"path"];
                
            }
        }
        if ([TextFieldCheckAlert isStringNull:path]) {
            path = self.infoDic[@"imagePath"];
        }
        //update by lcw
        if ([TextFieldCheckAlert isStringNull:path]) {
            path = @"";
        }
        NSString *url = [baseServerAddress stringByAppendingString:path];
        [_productImageView sd_setImageWithURL:[NSURL URLWithString:[url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                             placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
         [self.view addSubview:_productImageView];
    }
    return _productImageView;
}

/**
 *  内置浏览器
 *
 *  @return
 */
-(UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-50*autoSizeScaleY)];
        NSString *url = self.infoDic[@"activityUrl"];;

        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [_webView loadRequest:request];
    }
    return _webView;
}

- (UIView *)successView
{
    if (!_successView) {
        NSString *date;
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        date = [formatter stringFromDate:[NSDate date]];
//        NSString *validDate;
//        validDate = [NSString stringWithFormat:@"%@天",self.infoDic[@"validDay"]];
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *myDate = [dateFormatter dateFromString:date];
        NSDate *newDate = [myDate dateByAddingTimeInterval:60 * 60 * 24 *  [self.infoDic[@"validDay"] intValue]];
        NSString *validDate = [dateFormatter stringFromDate:newDate];
        
        NSArray *infoArray = @[self.infoDic[@"activityTitle"],date,self.infoDic[@"name"],self.infoDic[@"vendor"],[self.infoDic[@"simpleAddress"] substringFromIndex:3],self.infoDic[@"fetchTelephone"],validDate];
        NSArray *titleArray = @[@"转发内容：",@"转发时间：",@"获奖产品：",@"提供商家：",@"领取地址：",@"领取电话：",@"领取有效期："];
       
        _successView = [[UIView alloc] init];
        
        _successView.frame = CGRectMake(30*autoSizeScaleX, 120, SCREEN_WIDTH-60*autoSizeScaleX, 340*autoSizeScaleY);
        _successView.backgroundColor = UIColorFromRGB(0x282828);
        UILabel *titleLabel = [[UILabel alloc] init];
        
        [_successView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(_successView.width, 20));
            make.left.equalTo(_successView);
            make.top.equalTo(_successView).with.offset(20*autoSizeScaleY);
        }];
        
        titleLabel.text = @"恭喜您获奖";
        titleLabel.textColor = UIColorFromRGB(0xbebebe);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = Font(18);
        for (int i = 0; i < 7; i++) {
            UILabel *label = [[UILabel alloc] init];
            
            UILabel *textLabel = [[UILabel alloc] init];
            
            if (i == 0)
            {
                textLabel.frame = CGRectMake(130*autoSizeScaleX, 50*autoSizeScaleY, 160*autoSizeScaleX, 40);
                label.frame = CGRectMake(10*autoSizeScaleX, 55*autoSizeScaleY, 80*autoSizeScaleX, 18*autoSizeScaleY);
            }
            else if (i > 0 && i < 4)
            {
                textLabel.frame = CGRectMake(130*autoSizeScaleX, 95*autoSizeScaleY+23*autoSizeScaleY*(i-1), 160*autoSizeScaleX, 18*autoSizeScaleY);
                label.frame = CGRectMake(10*autoSizeScaleX, 95*autoSizeScaleY+23*autoSizeScaleY*(i-1), 80*autoSizeScaleX, 18*autoSizeScaleY);
            }
            else if (i == 4)
            {
                textLabel.frame = CGRectMake(130*autoSizeScaleX, 95*autoSizeScaleY+23*autoSizeScaleY*2, 160*autoSizeScaleX, 60*autoSizeScaleY);
                label.frame = CGRectMake(10*autoSizeScaleX, 95*autoSizeScaleY+23*autoSizeScaleY*3, 80*autoSizeScaleX, 18*autoSizeScaleY);
            }
            else
            {
                textLabel.frame = CGRectMake(130*autoSizeScaleX, 201*autoSizeScaleY+23*autoSizeScaleY*(i-5), 160*autoSizeScaleX, 18*autoSizeScaleY);
                label.frame = CGRectMake(10*autoSizeScaleX, 201*autoSizeScaleY+23*autoSizeScaleY*(i-5), 100*autoSizeScaleX, 18*autoSizeScaleY);

            }
            textLabel.textColor = UIColorFromRGB(0xbebebe);
            textLabel.text = infoArray[i];
            textLabel.font = Font(13);
            textLabel.numberOfLines = NO;
            textLabel.textAlignment = NSTextAlignmentNatural;
            
            label.text = titleArray[i];
            label.font = Font(13);
            label.textColor = UIColorFromRGB(0xbebebe);

            [_successView addSubview:textLabel];
            [_successView addSubview:label];

        }
        UILabel *bottomLabel = [[UILabel alloc] init];
        
        bottomLabel.frame = CGRectMake(0, 260*autoSizeScaleY, _successView.width, 16*autoSizeScaleY);
        bottomLabel.text = @"逾期未领 自动作废";
        bottomLabel.textColor = UIColorFromRGB(0xbebebe);
        bottomLabel.textAlignment = NSTextAlignmentCenter;
        
        [_successView addSubview:bottomLabel];
        
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        confirmButton.frame = CGRectMake(15*autoSizeScaleX, 290*autoSizeScaleY, _successView.width-30*autoSizeScaleX, 50*autoSizeScaleY);
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [confirmButton addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
        confirmButton.titleLabel.font = Font(28);
        confirmButton.titleLabel.textColor = [UIColor whiteColor];
        
        [_successView addSubview:confirmButton];
        
        [self.view addSubview:_successView];
    }
    return _successView;
}

- (UIButton *)getProductButton
{
    if (!_getProductButton) {
        _getProductButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _getProductButton.frame = CGRectMake(0, SCREEN_HEIGHT-50*autoSizeScaleY, SCREEN_WIDTH, 50*autoSizeScaleY);
        [_getProductButton setBackgroundImage:[UIImage imageNamed:@"getProduct_normal"] forState:UIControlStateNormal];
        [_getProductButton setBackgroundImage:[UIImage imageNamed:@"getProduct_height"] forState:UIControlStateHighlighted];
        if (self.check == YES) {
            if ([self.infoDic[@"surplusNumber"] intValue] == 0)
            {
                [_getProductButton addTarget:self action:@selector(knockFinish) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                [_getProductButton addTarget:self action:@selector(addProduct) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        else
        {
            if ([self.infoDic[@"surplusNumber"] intValue] == 0)
            {
                [_getProductButton addTarget:self action:@selector(produceTicket:) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                [_getProductButton addTarget:self action:@selector(addProduct) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        
        [self.view addSubview:_getProductButton];
    }
    return _getProductButton;
}

- (UIView *)electronSuccessView:(NSNotification *)noti
{
    
    
    if ([self.infoDic[@"forceShare"] intValue] == 1)
    {
        
        
        if ([noti.object[@"isNeedShare"] intValue] == -1)
        {
            [self showHUDText:@"请您分享，来获得心仪的礼品吧。" delay:3];
            return nil;
        }
        else
        {
            
        }
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }

    
    if (!_electronSuccessView)
    {
        _electronSuccessView = [[UIView alloc] init];
        
        _electronSuccessView.frame = CGRectMake(30*autoSizeScaleX, 120, SCREEN_WIDTH-60*autoSizeScaleX, 260*autoSizeScaleY);
        _electronSuccessView.backgroundColor = UIColorFromRGB(0x282828);
        
        UILabel *titleLabel = [[UILabel alloc] init];
        
        [_electronSuccessView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(_electronSuccessView.width, 20));
            make.left.equalTo(_electronSuccessView);
            make.top.equalTo(_electronSuccessView).with.offset(20*autoSizeScaleY);
        }];
        
        titleLabel.text = @"恭喜您获奖";
        titleLabel.textColor = UIColorFromRGB(0xbebebe);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = Font(18);
        
        UILabel *bottomLabel = [[UILabel alloc] init];
        
        bottomLabel.frame = CGRectMake(33*autoSizeScaleX, 130*autoSizeScaleY, _electronSuccessView.width-66*autoSizeScaleX, 55*autoSizeScaleY);
        NSString *phoneType;
        if ([self.infoDic[@"phoneType"] intValue] == 1)
        {
            phoneType = @"移动";
        }
        else if ([self.infoDic[@"phoneType"] intValue] == 2)
        {
            phoneType = @"联通";
        }
        else
        {
            phoneType = @"电信";
        }
        bottomLabel.text = [NSString stringWithFormat:@"请填写归属内蒙古正常使用的%@手机号码，异地、销户、欠费、停机等异常号码将无法为您赠送。",phoneType];
        bottomLabel.font = Font(11);
        bottomLabel.textColor = UIColorFromRGB(0xbebebe);
        bottomLabel.numberOfLines = NO;
        bottomLabel.textAlignment = NSTextAlignmentCenter;
        
        [_electronSuccessView addSubview:bottomLabel];
        
        NSArray *titleArray = @[@"手机号码",@"再次输入"];
        for (int i = 0; i < 2; i++) {
            UILabel *titleLabel = [[UILabel alloc] init];
            
            titleLabel.frame = CGRectMake(30*autoSizeScaleX, 60*autoSizeScaleY+31*autoSizeScaleY*i, 60*autoSizeScaleX, 18*autoSizeScaleY);
            titleLabel.text = titleArray[i];
            titleLabel.font = Font(11);
            titleLabel.textColor = UIColorFromRGB(0xbababa);
            
            [_electronSuccessView addSubview:titleLabel];
           
            UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
            
            confirmButton.frame = CGRectMake(15*autoSizeScaleX, bottomLabel.bottom+20*autoSizeScaleY, _electronSuccessView.width-30*autoSizeScaleX, 43*autoSizeScaleY);
            [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
            confirmButton.titleLabel.textColor = [UIColor whiteColor];
            confirmButton.titleLabel.font = Font(28);
            [confirmButton addTarget:self action:@selector(electronProduceTicket) forControlEvents:UIControlEventTouchUpInside];

            [_electronSuccessView addSubview:confirmButton];
        }
        
//        [self.view addSubview:_electronSuccessView];
        [self textfield];
        [self confirmTextfild];
    }
//    self.electronSuccessView = nil;
    self.textfield.text = @"";
    self.confirmTextfild.text = @"";
    [self.view addSubview:_electronSuccessView];
    return _electronSuccessView;
}

- (UITextField *)textfield
{
    if (!_textfield)
    {
        _textfield = [[UITextField alloc] init];
            
        _textfield.frame = CGRectMake(103*autoSizeScaleX, 60*autoSizeScaleY+31*autoSizeScaleY*0, _electronSuccessView.width-91*autoSizeScaleX, 18*autoSizeScaleY);
        _textfield.placeholder = @"请输入您的手机号";
        [_textfield setValue:UIColorFromRGB(0x858585) forKeyPath:@"_placeholderLabel.textColor"];
        _textfield.font = Font(11);
        _textfield.textColor = [UIColor whiteColor];
        
            [self.electronSuccessView addSubview:_textfield];
    }
    return _textfield;
}

- (UITextField *)confirmTextfild
{
    if (!_confirmTextfild) {
        _confirmTextfild = [[UITextField alloc] init];
        
        _confirmTextfild.frame = CGRectMake(103*autoSizeScaleX, 60*autoSizeScaleY+31*autoSizeScaleY, _electronSuccessView.width-91*autoSizeScaleX, 18*autoSizeScaleY);
        _confirmTextfild.placeholder = @"请再次输入";
        [_confirmTextfild setValue:UIColorFromRGB(0x858585) forKeyPath:@"_placeholderLabel.textColor"];
        _confirmTextfild.font = Font(11);
        _confirmTextfild.textColor = [UIColor whiteColor];
        
        [self.electronSuccessView addSubview:_confirmTextfild];
    }
    return _confirmTextfild;
}

- (UIView *)firstview
{
    if (!_firstview) {
        NSArray *titleArray = @[@"感谢参与数据调查",@"您的性别：",@"您的年龄：",@"您的职业："];
        NSArray *textArray = @[@"男",@"女",@"16岁以下",@"16--25岁",@"25--35岁",@"35--45岁",@"45--60岁",@"60岁以上",@"教师",@"学生",@"行政事业单位职工",@"企业员工",@"个体工商户"];
        
        _firstview = [[UIView alloc] init];
        
        _firstview.frame = CGRectMake(30*autoSizeScaleX, 64, SCREEN_WIDTH-60*autoSizeScaleX, SCREEN_HEIGHT-108);
        _firstview.backgroundColor = UIColorFromRGB(0x282828);
        for (int i = 0; i < 4; i++) {
            UILabel *label = [[UILabel alloc] init];
            
            if (i == 0)
            {
                label.frame = CGRectMake(0, 20*autoSizeScaleY, _firstview.width, 20*autoSizeScaleY);
                label.textAlignment = NSTextAlignmentCenter;
                label.font = Font(15);
            }
            else if (i == 1)
            {
                label.frame = CGRectMake(15*autoSizeScaleX, 20*autoSizeScaleY+30*autoSizeScaleY, 68*autoSizeScaleX, 20*autoSizeScaleY);
                label.font = Font(11);
            }
            else if (i == 2)
            {
                label.frame = CGRectMake(15*autoSizeScaleX, 20*autoSizeScaleY+120*autoSizeScaleY, 68*autoSizeScaleX, 20*autoSizeScaleY);
                label.font = Font(11);
            }
            else if (i == 3)
            {
                label.frame = CGRectMake(15*autoSizeScaleX, 20*autoSizeScaleY+320*autoSizeScaleY, 68*autoSizeScaleX, 20*autoSizeScaleY);
                label.font = Font(11);
            }
            label.text = titleArray[i];
            label.textColor = UIColorFromRGB(0xc4c4c4);
            
            [_firstview addSubview:label];
        }
        for (int i = 0 ; i < 13; i++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            UILabel *label = [[UILabel alloc] init];
            
            if (i < 2) {
                button.frame = CGRectMake(100*autoSizeScaleX, 50*autoSizeScaleY+33*autoSizeScaleY*i, 18*autoSizeScaleY, 18*autoSizeScaleY);
                label.frame = CGRectMake(130*autoSizeScaleX, 50*autoSizeScaleY+33*autoSizeScaleY*i, _firstview.width-130*autoSizeScaleX*autoSizeScaleY, 18*autoSizeScaleY);
            }
            else if (i >= 2 && i < 8)
            {
                button.frame = CGRectMake(100*autoSizeScaleX, 140*autoSizeScaleY+33*autoSizeScaleY*(i-2), 18*autoSizeScaleY, 18*autoSizeScaleY);
                label.frame = CGRectMake(130*autoSizeScaleX, 140*autoSizeScaleY+33*autoSizeScaleY*(i-2), _firstview.width-130*autoSizeScaleX*autoSizeScaleY, 18*autoSizeScaleY);
            }
            else
            {
                button.frame = CGRectMake(100*autoSizeScaleX, 340*autoSizeScaleY+33*autoSizeScaleY*(i-8), 18*autoSizeScaleY, 18*autoSizeScaleY);
                label.frame = CGRectMake(130*autoSizeScaleX, 340*autoSizeScaleY+33*autoSizeScaleY*(i-8), _firstview.width-130*autoSizeScaleX*autoSizeScaleY, 18*autoSizeScaleY);
            }
            button.tag = i;
            [button setImage:[UIImage imageNamed:@"normalRadio"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"selectRadio"] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(radioClick:) forControlEvents:UIControlEventTouchUpInside];
            
            label.textColor = [UIColor whiteColor];
            label.text = textArray[i];
            label.font = Font(15);
            
            [_firstview addSubview:button];
            [_firstview addSubview:label];
        }
        
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        confirmButton.frame = CGRectMake(200*autoSizeScaleX, 340*autoSizeScaleY+33*autoSizeScaleY*5, 130*autoSizeScaleX*autoSizeScaleY, 18*autoSizeScaleY);
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        confirmButton.titleLabel.font = Font(15);
        confirmButton.titleLabel.textColor = UIColorFromRGB(0xc4c4c4);
        [confirmButton addTarget:self action:@selector(firstClick) forControlEvents:UIControlEventTouchUpInside];
        
        [_firstview addSubview:confirmButton];
        
        _firstview.hidden = YES;
        [self.view addSubview:_firstview];
    }
    return _firstview;
}

- (UIView *)electronView
{
    if (!_electronView) {
        NSString *date;
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        date = [formatter stringFromDate:[NSDate date]];
//        NSString *validDate;
//        validDate = [NSString stringWithFormat:@"%@天",self.infoDic[@"validDay"]];
        
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *myDate = [dateFormatter dateFromString:date];
        NSDate *newDate = [myDate dateByAddingTimeInterval:60 * 60 * 24 *  [self.infoDic[@"validDay"] intValue]];
        NSString *validDate = [dateFormatter stringFromDate:newDate];

        
        NSArray *infoArray = @[self.textfield.text,self.infoDic[@"activityTitle"],date,self.infoDic[@"name"],self.infoDic[@"vendor"],validDate];
        NSArray *titleArray = @[@"客户电话：",@"转发内容：",@"转发时间：",@"获奖产品：",@"提供商家：",@"到账时间："];
        
        _electronView = [[UIView alloc] init];
        
        _electronView.frame = CGRectMake(30*autoSizeScaleX, 120, SCREEN_WIDTH-60*autoSizeScaleX, 260*autoSizeScaleY);
        _electronView.backgroundColor = UIColorFromRGB(0x282828);
        UILabel *titleLabel = [[UILabel alloc] init];
        
        [_electronView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(_electronView.width, 20));
            make.left.equalTo(_electronView);
            make.top.equalTo(_electronView).with.offset(20*autoSizeScaleY);
        }];
        
        titleLabel.text = @"恭喜您获奖";
        titleLabel.textColor = UIColorFromRGB(0xbebebe);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = Font(18);
        for (int i = 0; i < 6; i++) {
            UILabel *label = [[UILabel alloc] init];
            
            UILabel *textLabel = [[UILabel alloc] init];
            
            if (i == 0)
            {
                textLabel.frame = CGRectMake(130*autoSizeScaleX, 50*autoSizeScaleY, 160*autoSizeScaleX, 18);
                label.frame = CGRectMake(10*autoSizeScaleX, 50*autoSizeScaleY, 80*autoSizeScaleX, 18*autoSizeScaleY);
            }
            else if (i == 1)
            {
                textLabel.frame = CGRectMake(130*autoSizeScaleX, 73*autoSizeScaleY+23*autoSizeScaleY*(i-1), 160*autoSizeScaleX, 40*autoSizeScaleY);
                label.frame = CGRectMake(10*autoSizeScaleX, 73*autoSizeScaleY+23*autoSizeScaleY*(i-1), 80*autoSizeScaleX, 18*autoSizeScaleY);
            }
            else
            {
                textLabel.frame = CGRectMake(130*autoSizeScaleX, 95*autoSizeScaleY+23*autoSizeScaleY*(i-1), 160*autoSizeScaleX, 18*autoSizeScaleY);
                label.frame = CGRectMake(10*autoSizeScaleX, 95*autoSizeScaleY+23*autoSizeScaleY*(i-1), 80*autoSizeScaleX, 18*autoSizeScaleY);
            }
            textLabel.textColor = UIColorFromRGB(0xbebebe);
            textLabel.text = infoArray[i];
            textLabel.font = Font(13);
            textLabel.numberOfLines = NO;
            textLabel.textAlignment = NSTextAlignmentNatural;
            
            label.text = titleArray[i];
            label.font = Font(13);
            label.textColor = UIColorFromRGB(0xbebebe);
            
            [_electronView addSubview:textLabel];
            [_electronView addSubview:label];
            
        }
        
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        confirmButton.frame = CGRectMake(15*autoSizeScaleX, 210*autoSizeScaleY, _electronView.width-30*autoSizeScaleX, 50*autoSizeScaleY);
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [confirmButton addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
        confirmButton.titleLabel.font = Font(28);
        confirmButton.titleLabel.textColor = [UIColor whiteColor];
        
        [_electronView addSubview:confirmButton];
        
        [self.view addSubview:_electronView];
    }
    return _electronView;
}

- (NSDictionary *)dict
{
    if (!_dict) {
        _dict =nil;
    }
    return _dict;
}

#pragma mark System Action
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setTopViewWithTitle:@"产品活动"];

    [self.view addSubview:self.webView];
    self.locationButton.alpha = 1.0f;
    [self getKnockInfo];
    if ([self.banner integerValue] == 1) {
        [self updateList];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [self getBannerTest];
//    self.productImageView.alpha = 1.0f;
    self.getProductButton.alpha = 1.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - mark 获取分享图片

- (NSData *)shareImageData
{
    if (!_shareImageData) {
        NSString *path = @"";
        
        for (NSDictionary *imageDic in self.infoDic[@"productImages"])
        {
            if ([imageDic[@"type"] integerValue] == 0)// 0 分享 2 原先需要显示
            {
                path = imageDic[@"path"];
            }
        }
        if ([TextFieldCheckAlert isStringNull:path]) {
            path = self.infoDic[@"imagePath"];
        }
        //update by lcw
        if ([TextFieldCheckAlert isStringNull:path]) {
            path = @"";
        }
        NSString *url = [baseServerAddress stringByAppendingString:path];
        
        NSData *shareImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        
        _shareImageData = shareImageData;
    }
    return _shareImageData;
}

#pragma mark - 分享
- (void)shareActionType:(int)shareType
{
    NSString *url = self.infoDic[@"activityUrl"];;
    NSString *title = self.infoDic[@"activityTitle"];
    NSString *description = self.infoDic[@"name"];
    
    NSString *snsName = UMShareToWechatSession;
    switch (shareType) {
        case 1:
        {
            snsName = UMShareToWechatSession;//1-微信好友
        }
            break;
        case 2:
        {
            snsName = UMShareToQQ;//2-QQ
        }
            break;
        case 3:
        {
            snsName = UMShareToQzone;//3-QQ空间
        }
            break;
        case 4:
        {
            snsName = UMShareToSina;//4-新浪微博
        }
            break;
        case 5:
        {
            snsName = UMShareToTencent;//5-腾讯微博
        }
            break;
        case 6:
        {
            snsName = UMShareToRenren;//6-人人网
        }
            break;
        case 7:
        {
            snsName = UMShareToSms;//7-短信
        }
            break;
        default:
            break;
    }
    
    UIImage *shareImage = [UIImage imageNamed:@"appIcon"];
    
    id shareData = self.shareImageData ? self.shareImageData : shareImage;
    
    [[LTools shareInstance] autoShareToSnsName:snsName shareTitle:title shareText:description shareImage:shareData shareUrl:url presentViewController:self];
}

#pragma mark Other Action

- (void)addProduct
{
    //    在产品里多加个字段shareType：
    //    private Integer shareType;  //分享渠道 1-微信好友，2-QQ，3-QQ空间，4-新浪微博，5-腾讯微博，6-人人网，7-短信
    //    7、短信分享也不需要做了。
    
//    shareType
    
    NSString *shareTypeString = self.infoDic[@"shareType"];
    
    int temp = 3;//默认QQ空间
    
    if ([shareTypeString isKindOfClass:[NSNull class]]) {
        
        shareTypeString = [NSString stringWithFormat:@"%d",temp];
    }
    
    int shareType = temp;//默认QQ空间

    if ([shareTypeString isKindOfClass:[NSNumber class]] ||
        [shareTypeString isKindOfClass:[NSString class]]) {
        
        shareType = [shareTypeString intValue];
        
        if (shareType < 1 || shareType > 7) {
            shareType = temp;//超出范围 默认temp
        }
    }
    
    
    [self shareActionType:shareType];
    
    BOOL result = NO;
    
    if (shareType == 1)//微信
    {
        result = [WXApi isWXAppInstalled];
        
    }else if (shareType == 2 || shareType == 3)//QQ\QQ空间
    {
        result = [QQApiInterface isQQInstalled]&&[QQApiInterface isQQSupportApi];
    }else
    {
        result = YES;
    }
    
    if (result)
    {
        
        if (self.check == YES || [self.infoDic[@"categoryId"] intValue] == 3)
        {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(isShow:)
                                                         name:@"productTicket2"
                                                       object:nil];
            
        }
        //        else if ([self.infoDic[@"categoryId"] intValue] == 3)
        //        {
        //            [[NSNotificationCenter defaultCenter] addObserver:self
        //                                                     selector:@selector(electronSuccessView)
        //                                                         name:@"produceTicket"
        //                                                       object:nil];
        //        }
        else
        {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(produceTicket:)
                                                         name:@"productTicket"
                                                       object:nil];
            
        }
        
    }
    else
    {
        if ([self.infoDic[@"forceShare"] intValue] == 1)
        {
            [self showHUDText:@"请您分享，来获得心仪的礼品吧。" delay:5];
            return;
        }
        else
        {
            if (self.check == YES) {
                [self electronSuccessView];
            }
            else
            {
                [self produceTicket:nil];
                
            }
        }
    }
}

//- (void)addProduct
//{
//    [self shareAction];
//    
//    return;
//    
//    if ([WXApi isWXAppInstalled])
//    {
//        //网页形式
//        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
//        req.bText = NO;//分享内容带图片和文字时必须为NO
//        
//        //设置这个路径是为了点击聊天列表的气泡时也可以跳转
//        WXWebpageObject *ext = [WXWebpageObject object];
//        ext.webpageUrl = self.infoDic[@"activityUrl"];
//        
//        WXMediaMessage *mess = [WXMediaMessage message];
//        //    [mess setThumbImage:newImage];
//        mess.mediaObject = ext;
//        //如果分享的内容包括文字和图片,这个时候的文字不能使用req.text属性来接收,必须使用下边的两个属性
//        mess.title = self.infoDic[@"activityTitle"];
//        mess.description = self.infoDic[@"name"];
//        req.message = mess;
//        req.scene = WXSceneTimeline;
//        [WXApi sendReq:req];
//        
//        if (self.check == YES || [self.infoDic[@"categoryId"] intValue] == 3)
//        {
//                [[NSNotificationCenter defaultCenter] addObserver:self
//                                                         selector:@selector(isShow:)
//                                                             name:@"productTicket2"
//                                                           object:nil];
//            
//        }
////        else if ([self.infoDic[@"categoryId"] intValue] == 3)
////        {
////            [[NSNotificationCenter defaultCenter] addObserver:self
////                                                     selector:@selector(electronSuccessView)
////                                                         name:@"produceTicket"
////                                                       object:nil];
////        }
//        else
//        {
//                [[NSNotificationCenter defaultCenter] addObserver:self
//                                                         selector:@selector(produceTicket:)
//                                                             name:@"productTicket"
//                                                           object:nil];
//            
//        }
//
//    }
//    else
//    {
//        if ([self.infoDic[@"forceShare"] intValue] == 1)
//        {
//            [self showHUDText:@"请您分享，来获得心仪的礼品吧。" delay:5];
//            return;
//        }
//        else
//        {
//            if (self.check == YES) {
//                [self electronSuccessView];
//            }
//            else
//            {
//                [self produceTicket:nil];
//                
//            }
//        }
//    }
//}

- (void)jumoToMapVC
{
    MapViewController *mapVC = [[MapViewController alloc] init];
    
    mapVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mapVC animated:YES];
}

- (void)confirmClick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUsedTicket" object:nil];
//    [self.navigationController popToRootViewControllerAnimated:YES];
    AppDelegate * delegate =  (AppDelegate*)[UIApplication sharedApplication].delegate;
    delegate.customTBC.selectedViewController = delegate.customTBC.viewControllers[1];
    
    [self.navigationController popViewControllerAnimated:YES];
}

//单选按钮
- (void)radioClick:(UIButton *)bt
{
    if (bt.selected == YES) {
        bt.selected = NO;
    }
    else
    {
        bt.selected = YES;
    }
    switch (bt.tag) {
        case 0:
            gender = @"1";
            break;
        case 1:
            gender = @"2";
            break;
        case 2:
            age = @"1";
            break;
        case 3:
            age = @"2";
            break;
        case 4:
            age = @"3";
            break;
        case 5:
            age = @"4";
            break;
        case 6:
            age = @"5";
            break;
        case 7:
            age = @"6";
            break;
        case 8:
            job = @"1";
            break;
        case 9:
            job = @"2";
            break;
        case 10:
            job = @"3";
            break;
        case 11:
            job = @"4";
            break;
        case 12:
            job = @"5";
            break;
            
        default:
            break;
    }
}

- (void)firstClick
{
    NSString *imei = [[NSUserDefaults standardUserDefaults] objectForKey:kUDUUID];
//        NSString *imei = @"866184023271406";
    NSString *phoneNum = [FFConfig currentConfig].phoneNumber ? [FFConfig currentConfig].phoneNumber : @"";

    NSString *aId = [NSString stringWithFormat:@"%ld",[self.infoDic[@"id"] integerValue]] ;
    
    NSMutableDictionary *temp = [NSMutableDictionary dictionary];
    [temp safeSetString:aId forKey:@"productId"];
    [temp safeSetString:imei forKey:@"imei"];
    [temp safeSetString:phoneNum forKey:@"customerTelephone"];
    [temp safeSetString:gender forKey:@"gender"];
    [temp safeSetString:age forKey:@"age"];
    [temp safeSetString:job forKey:@"job"];

    self.dict = [NSDictionary dictionaryWithDictionary:temp];
    
    NSString *param = Interface_writeInfo;
    
    NSMutableDictionary *tempUserInfo = [NSMutableDictionary dictionary];
    [tempUserInfo safeSetString:imei forKey:@"imei"];
    [tempUserInfo safeSetString:gender forKey:@"gender"];
    [tempUserInfo safeSetString:age forKey:@"age"];
    [tempUserInfo safeSetString:job forKey:@"job"];
    NSDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:tempUserInfo];
    
    [[BHServiceDataCentre sharedInstance] blHealthRequestByDict:param
                                                     parameters:userInfo
                                                        showHUD:YES
                                                     controller:self
                                                           type:CC_Intrrface_whriteInfo
                                             serviceAnswerBlock:^(BOOL isSuccsee, id responseMsg,
                                                                  NSInteger type, NSString *errorMsg)
     {
         if (isSuccsee && type == CC_Intrrface_whriteInfo)
         {
             switch ([gender intValue]) {
                 case 1:
                     self.gender = @"男";
                     break;
                 case 2:
                     self.gender = @"女";
                     break;
                     
                 default:
                     break;
             }
             switch ([age intValue]) {
                 case 1:
                     self.age = @"16岁以下";
                     break;
                 case 2:
                     self.age = @"16--25岁";
                     break;
                 case 3:
                     self.age =@"25--35岁";
                     break;
                 case 4:
                     self.age = @"35--45岁";
                     break;
                 case 5:
                     self.age = @"45--60岁";
                     break;
                 case 6:
                     self.age = @"60岁以上";
                     break;
                     
                 default:
                     break;
             }
             switch ([job intValue]) {
                 case 1:
                     self.job = @"教师";
                     break;
                 case 2:
                     self.job = @"学生";
                     break;
                 case 3:
                     self.job = @"行政事业单位职工";
                     break;
                 case 4:
                     self.job = @"企业员工";
                     break;
                 case 5:
                     self.job = @"个体工商户";
                     break;
                     
                 default:
                     break;
             }
             
             [self writeLabelAction];
         }
         else
         {
         
         }
     }];

    [self.firstview removeFromSuperview];
}
- (void)isShow:(NSNotification *)noti
{
    [self electronSuccessView:noti];
}

-(void)knockFinish
{
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"您的手有点慢哟，本图文礼品已发完，抓紧抢别的东东吧！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    alert.backgroundColor = UIColorFromRGB(0x282828);
    [alert show];
}

#pragma mark Service
- (void)produceTicket:(NSNotification *)noti
{
    
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if ([self.infoDic[@"forceShare"] intValue] == 1)
    {
        if ([noti.object[@"isNeedShare"] intValue] == -1)
        {
            [self showHUDText:@"请您分享，来获得心仪的礼品吧。" delay:3];
            
            return;
        }
        else
        {
            
        }
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }

    
    NSString *param = Intrrface_produceTicket;
    
    [[BHServiceDataCentre sharedInstance] blHealthRequestByDict:param
                                                     parameters:self.dict
                                                        showHUD:YES
                                                     controller:self
                                                           type:CC_Intrrface_produceTicket
                                             serviceAnswerBlock:^(BOOL isSuccsee, id responseMsg,
                                                                  NSInteger type, NSString *errorMsg)
     {
         if (isSuccsee && type == CC_Intrrface_produceTicket)
         {
             if (![TextFieldCheckAlert isStringNull:responseMsg[@"message"]])
             {
//                 [self showHUDText:responseMsg[@"message"] delay:2];
                 UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:responseMsg[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                 alert.backgroundColor = UIColorFromRGB(0x282828);
                 [alert show];
                 
             }
             else
             {
                 [self successView];
                 
             }
         }
     }];
}

- (void)electronProduceTicket
{
    [self.view endEditing:YES];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    phone = self.textfield.text;
    confirmPhone = self.confirmTextfild.text;

        if ([phone isEqualToString:@""]) {
            [self showHUDText:@"手机号不能为空" delay:2];
            return;
        }
        if (![phone isEqualToString:confirmPhone]) {
            [self showHUDText:@"请保持号码一致" delay:2];
            return;
        }
    NSString *imei = [[NSUserDefaults standardUserDefaults] objectForKey:kUDUUID];
    //        NSString *imei = @"866184023271406";
   
    if (self.firstview.hidden == NO) {
        self.dict = @{@"productId":self.infoDic[@"id"],
                      @"imei":imei,
                      @"customerTelephone":phone,
                      @"gender":gender,
                      @"age":age,
                      @"job":job};
    }
    else
    {
        self.dict = @{@"productId":self.infoDic[@"id"],
                      @"imei":imei,
                      @"customerTelephone":phone};
    }
    
    NSString *param = Intrrface_produceTicket;
    
    [[BHServiceDataCentre sharedInstance] blHealthRequestByDict:param
                                                     parameters:self.dict
                                                        showHUD:YES
                                                     controller:self
                                                           type:CC_Intrrface_produceTicket
                                             serviceAnswerBlock:^(BOOL isSuccsee, id responseMsg,
                                                                  NSInteger type, NSString *errorMsg)
     {
         if (isSuccsee && type == CC_Intrrface_produceTicket)
         {
             if (![TextFieldCheckAlert isStringNull:responseMsg[@"message"]])
             {
                 [self.electronSuccessView removeFromSuperview];
                 
                 UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:responseMsg[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                 [alert show];
             }
             else
             {
                 [self electronView];
                 
//                 [self showHUDText:@"领取成功" delay:2];
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUsedTicket" object:nil];
             }
         }
         else
         {
             [self.electronSuccessView removeFromSuperview];
             [self showHUDText:@"服务器异常" delay:2];
         }
     }];
}

- (void)getKnockInfo
{
    NSString *imei = [[NSUserDefaults standardUserDefaults] objectForKey:kUDUUID];
//    NSString *imei = @"866184023271419";
    NSString *param = Intrrface_knockTicket(imei);
    
    [[BHServiceDataCentre sharedInstance] blHealthRequestByDict:param
                                                     parameters:nil
                                                        showHUD:YES
                                                     controller:self
                                                           type:CC_Intrrface_knockTicket
                                             serviceAnswerBlock:^(BOOL isSuccsee, id responseMsg,
                                                                  NSInteger type, NSString *errorMsg)
     {
         if (isSuccsee && type == CC_Intrrface_knockTicket)
         {
             if (![TextFieldCheckAlert isStringNull:responseMsg[@"imei"]])
             {
                 NSString *imei = [[NSUserDefaults standardUserDefaults] objectForKey:kUDUUID];
                 NSString *phoneNum = [FFConfig currentConfig].phoneNumber ? [FFConfig currentConfig].phoneNumber : @"";
                 self.dict = @{@"productId":self.infoDic[@"id"],
                               @"imei":imei,
                               @"customerTelephone":phoneNum};
            }
             else
             {
                 self.firstview.hidden = NO;
             }
         }
     }];
}

- (void)updateList
{
    NSDictionary *dict = @{@"keyValue": self.bannerId};
    NSString *param = Interface_uploadList;
    [[BHServiceDataCentre sharedInstance] blHealthRequestByDict:param
                                                     parameters:dict
                                                        showHUD:NO
                                                     controller:self
                                                           type:CC_Interface_uploadList
                                             serviceAnswerBlock:^(BOOL isSuccess, id responseMsg,
                                                                  NSInteger type, NSString *errorMsg)
     {
         if (isSuccess && type == CC_Interface_uploadList)
         {
             
         }
         else if (!isSuccess && type == CC_Interface_uploadList)
         {
             
         }
     }];
}
//友盟添加标签
- (void)writeLabelAction
{
    NSString *imei = [[NSUserDefaults standardUserDefaults] objectForKey:kUDUUID];
    
    if (!self.gender) {
        self.gender = @"";
    }
    
    if (!self.age) {
        self.age = @"";
    }
    
    if (!self.job) {
        self.job = @"";
    }
    
    [UMessage addTag:@[[FFConfig currentConfig].cityName,self.gender,self.age,self.job,imei]
            response:^(id responseObject, NSInteger remain, NSError *error)
     {
         //add your codes
     }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
