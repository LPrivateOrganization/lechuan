//
//  LoginViewController.m
//  lechuan
//
//  Created by Kami Mahou on 15/12/9.
//  Copyright © 2015年 Kami Mahou. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginTextField.h"
#import "ForgetButton.h"
#import "ProgressButton.h"
#import "UserAgreementViewController.h"
#import "ChangePasswordViewController.h"
#import <TencentOpenAPI/sdkdef.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import "UMessage.h"

@interface LoginViewController () <UIApplicationDelegate, TencentSessionDelegate>

{
    TencentOAuth * _tencentOAuth;
}

@property (nonatomic, strong) UIImageView *midView;
@property (nonatomic, strong) UIImageView *loginView;
@property (nonatomic, strong) UIImageView *registView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *registButton;
@property (nonatomic, strong) ForgetButton *forgetPasswordButton;
@property (nonatomic, strong) ProgressButton *progressButton;
//!登录还是注册 （0是登录 1是注册）
@property (nonatomic, assign) NSInteger buttonType;

@end

@implementation LoginViewController

#pragma mark Init && Add
- (instancetype)init
{
    if (self = [super init]) {
        [self setTopViewWithTitle:@""];
        self.topTitleView.height = 250*autoSizeScaleY;
        if (isIPhone4) {
            self.topTitleView.height = 180;
        }
        [[self.topTitleView viewWithTag:-1] setHidden:YES];//隐藏分割线
        
        self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self.scrollView addSubview:self.topTitleView];
        [self setTopView];
        
        _buttonType = 0;
    }
    return self;
}

- (UIImageView *)midView
{
    if (!_midView) {
        _midView = [[UIImageView alloc] init];
        
        _midView.frame = CGRectMake(0, self.topTitleView.height+2, SCREEN_WIDTH, 44*autoSizeScaleY);
        if (SCREEN_HEIGHT == 960)
        {
            _midView.frame = CGRectMake(0, self.topTitleView.height+2, SCREEN_WIDTH, 38);
            
        }
        _midView.image = [UIImage imageNamed:@"loginImage"];
        _midView.userInteractionEnabled = YES;
        
        [self.scrollView addSubview:_midView];
        
        NSArray *textArray = @[@"登录", @"注册"];
        for (int i = 0; i < 2; i++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            button.tag = i;
            button.frame = CGRectMake(i*SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, _midView.height);
            [button setTitle:textArray[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];
            
            [_midView addSubview:button];
        }
    }
    return _midView;
}

- (UIImageView *)loginView
{
    if (!_loginView) {
        _loginView = [[UIImageView alloc] init];
        _loginView.frame = CGRectMake((SCREEN_WIDTH-272*autoSizeScaleX)/2, self.midView.bottom+44*autoSizeScaleY, 272*autoSizeScaleX, 92*autoSizeScaleY);
        if (isIPhone4)
        {
            _loginView.frame = CGRectMake((SCREEN_WIDTH-272)/2, self.midView.bottom+18, 272, 79);
        }
        _loginView.image = [UIImage imageNamed:@"loginBgView"];
        _loginView.userInteractionEnabled = YES;
        
        [self.scrollView addSubview:_loginView];
        
        NSArray *placeholder = @[@"请输入用户名", @"请输入密码"];
        for (int i = 0; i < 2; i++)
        {
            LoginTextField *textField = [[LoginTextField alloc] init];
            
            textField.tag = i+10;
            textField.frame = CGRectMake(0,     i*_loginView.height/2, _loginView.width, _loginView.height/2);
            textField.leftViewMode = UITextFieldViewModeAlways;
            textField.font = Font(10*autoSizeScaleY);
            textField.placeholder = placeholder[i];
            if (i == 1) {
                textField.secureTextEntry = YES;
            }
            
            UIImageView *imageView = [[UIImageView alloc] init];;
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"loginTextfield_%d", i]];
            
            textField.leftView = imageView;
            
            [_loginView addSubview:textField];
        }
    }
    return _loginView;
}

- (UIImageView *)registView
{
    if (!_registView) {
        _registView = [[UIImageView alloc] init];
        _registView.frame = CGRectMake((SCREEN_WIDTH-272*autoSizeScaleX)/2, self.midView.bottom+44*autoSizeScaleY, 272*autoSizeScaleX, 138*autoSizeScaleY);
        _registView.image = [UIImage imageNamed:@"registBgView"];
        _registView.userInteractionEnabled = YES;
        _registView.alpha = 0;
        
        [self.scrollView addSubview:_registView];
        
        NSArray *placeholder = @[@"请输入用户名", @"请输入密码", @"请输入手机号"];
        for (int i = 0; i < 3; i++)
        {
            LoginTextField *textField = [[LoginTextField alloc] init];
            
            textField.tag = i+10;
            textField.frame = CGRectMake(0, i*_loginView.height/2, _loginView.width, _loginView.height/2);
            textField.leftViewMode = UITextFieldViewModeAlways;
            textField.font = Font(10*autoSizeScaleY);
            textField.placeholder = placeholder[i];
            if (i == 1) {
                textField.secureTextEntry = YES;
            }
            
            UIImageView *imageView = [[UIImageView alloc] init];;
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"loginTextfield_%d", i]];
            
            textField.leftView = imageView;
            
            [_registView addSubview:textField];
        }
    }
    return _registView;
}

- (UIButton *)loginButton
{
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self.scrollView addSubview:_loginButton];
        
        [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(179*autoSizeScaleX, 87*autoSizeScaleY));
            make.centerX.mas_equalTo(self.loginView);
            make.top.mas_equalTo(self.loginView.mas_bottom).with.offset(32*autoSizeScaleY);
        }];
        if (isIPhone4) {
            [_loginButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(179, 87));
                make.centerX.mas_equalTo(self.loginView);
                make.top.mas_equalTo(self.loginView.mas_bottom).with.offset(32);
            }];
        }
        
        [_loginButton setBackgroundImage:[UIImage imageNamed:@"loginButton"] forState:UIControlStateNormal];
        [_loginButton setBackgroundImage:[UIImage imageNamed:@"loginButtonSelected"] forState:UIControlStateHighlighted];
        [_loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _loginButton;
}

- (UIButton *)registButton
{
    if (!_registButton) {
        _registButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self.scrollView addSubview:_registButton];
        
        [_registButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(179*autoSizeScaleX, 87*autoSizeScaleY));
            make.centerX.mas_equalTo(self.loginView);
            make.top.mas_equalTo(self.registView.mas_bottom).with.offset(45*autoSizeScaleY);
        }];
        if (isIPhone4) {
            [_registButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(179, 87));
                make.centerX.mas_equalTo(self.loginView);
                make.top.mas_equalTo(self.registView.mas_bottom).with.offset(32);
            }];
        }
        
        [_registButton setBackgroundImage:[UIImage imageNamed:@"registButton"] forState:UIControlStateNormal];
        [_registButton setBackgroundImage:[UIImage imageNamed:@"registButtonSelected"] forState:UIControlStateHighlighted];
        [_registButton addTarget:self action:@selector(registAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registButton;
}

- (ForgetButton *)forgetPasswordButton
{
    if (_forgetPasswordButton) {
        _forgetPasswordButton = [ForgetButton buttonWithType:UIButtonTypeCustom];
        
        [self.scrollView addSubview:_forgetPasswordButton];
        
        [_forgetPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(82, 20));
            make.top.mas_equalTo(self.loginView.mas_bottom).with.offset(5);
            make.right.mas_equalTo(self.view).with.offset(-44);
        }];
        
        [_forgetPasswordButton setImage:[UIImage imageNamed:@"forgetPsssword"] forState:UIControlStateNormal];
        [_forgetPasswordButton addTarget:self action:@selector(findPassword) forControlEvents:UIControlEventTouchUpInside];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"忘记密码？"];
        [string addAttribute:NSUnderlineStyleAttributeName
                       value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                       range:NSMakeRange(0, 5)];
        [string addAttribute:NSForegroundColorAttributeName
                       value:UIColorFromRGB(0xbbbbbb)
                       range:NSMakeRange(0, 5)];
        [string addAttribute:NSFontAttributeName
                       value:Font(12)
                       range:NSMakeRange(0, 5)];
        [_forgetPasswordButton setAttributedTitle:string forState:UIControlStateNormal];
    }
    return _forgetPasswordButton;
}

- (ProgressButton *)progressButton
{
    if (!_progressButton) {
        _progressButton = [ProgressButton buttonWithType:UIButtonTypeCustom];

        [self.scrollView addSubview:_progressButton];
        
        [_progressButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(110, 20));
            make.top.mas_equalTo(self.registView.mas_bottom).with.offset(5);
            make.right.mas_equalTo(self.view).with.offset(-44);
        }];
        
        [_progressButton setImage:[UIImage imageNamed:@"progerssButton"] forState:UIControlStateNormal];
        [_progressButton setImage:[UIImage imageNamed:@"progerssButton"] forState:UIControlStateSelected];
        [_progressButton setImage:[UIImage imageNamed:@"progerssButton"] forState:UIControlStateHighlighted];
        [_progressButton addTarget:self action:@selector(jumpProgress) forControlEvents:UIControlEventTouchUpInside];
        [_progressButton setTitle:@"是否同意《用户协议》" forState:UIControlStateNormal];
        [_progressButton setTitleColor:UIColorFromRGB(0xbbbbbb) forState:UIControlStateNormal];
        _progressButton.titleLabel.font = Font(9);
    }
    return _progressButton;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        
        _bottomView.frame = CGRectMake(0, SCREEN_HEIGHT-85*autoSizeScaleY, SCREEN_WIDTH, 85*autoSizeScaleY);
        
        UILabel *label = [[UILabel alloc] init];
        
        [_bottomView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_bottomView).with.offset(0);
            make.centerX.mas_equalTo(_bottomView);
        }];
        
        label.text = @"使用第三方账号登陆";
        label.textColor = UIColorFromRGB(0x8e8e8e);
        label.font = Font(13);
        
        for (int i = 0; i < 2; i++) {
            UIView *lineImage = [[UIView alloc] init];
            
            lineImage.frame = CGRectMake(20*autoSizeScaleX+255*autoSizeScaleX*i, label.y+7*autoSizeScaleY, 79*autoSizeScaleX, 1*autoSizeScaleY);
            if (isIPhone4) {
                lineImage.frame = CGRectMake(20+202*i, label.y+7, 79, 1);

            }
            lineImage.backgroundColor = UIColorFromRGB(0xeaeaea);
            
            [_bottomView addSubview:lineImage];
        }
        
        CGFloat spaceX = 56*autoSizeScaleX;
        CGFloat width = 45*autoSizeScaleX;
        CGFloat height = width;
//        CGFloat x = (SCREEN_WIDTH-width*2-spaceX)/2;
        
        NSArray *imageArray = @[@"shareButton_3", @"shareButton_2"];
//        if ([TencentOAuth iphoneQQInstalled])
//        {
//            for (int i = 0; i < 2; i++)
//            {
//                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//                
//                button.tag = i;
//                button.frame = CGRectMake(x+(spaceX+width)*i, 23*autoSizeScaleY, width, height);
//                [button setBackgroundImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
//                [button addTarget:self action:@selector(thirdPartLogin:) forControlEvents:UIControlEventTouchUpInside];
//                
//                [_bottomView addSubview:button];
//            }
//        }
//        else
//        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [_bottomView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(width, height));
                make.centerX.equalTo(_bottomView);
                make.top.equalTo(_bottomView).with.offset(23*autoSizeScaleY);
            }];
            button.tag = 1;
            [button setBackgroundImage:[UIImage imageNamed:imageArray[1]] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(thirdPartLogin:) forControlEvents:UIControlEventTouchUpInside];
            
//        }
        
        [self.scrollView addSubview:_bottomView];
    }
    return _bottomView;
}

#pragma mark System Action
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidekeyBoard)];
    [self.scrollView addGestureRecognizer:tap];
    
    [self bottomView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //使用NSNotificationCenter 键盘出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    //使用NSNotificationCenter 键盘隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(thirdPartLoginService:)
                                                 name:@"thirdPartLogin"
                                               object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Other Action
//!设置顶部view
- (void)setTopView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    
    imageView.image = [UIImage imageNamed:@"appIcon"];
    imageView.layer.borderWidth = 5;
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    imageView.layer.cornerRadius = 6;
    imageView.layer.masksToBounds = YES;
    [self.topTitleView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(89*autoSizeScaleY, 89*autoSizeScaleY));
        make.bottom.equalTo(self.topTitleView).with.offset(-79*autoSizeScaleY);
        make.centerX.equalTo(self.topTitleView);
    }];
    if (isIPhone4) {
        [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(74, 74));
            make.bottom.equalTo(self.topTitleView).with.offset(-64);
            make.centerX.equalTo(self.topTitleView);
        }];
    }
    
    UILabel *label = [[UILabel alloc] init];
    
    [self.topTitleView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topTitleView);
        make.bottom.equalTo(self.topTitleView).with.offset(-32*autoSizeScaleY);
    }];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"乐传";
    label.textColor = [UIColor whiteColor];
    label.font = Font(32.5);
    
    UIView *whiteView = [[UIView alloc] init];
    
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.topTitleView addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topTitleView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 2));
    }];
    
    self.loginButton.alpha = 1.0f;
    self.forgetPasswordButton.alpha = 1.0f;
}

- (void)thirdPartLogin:(UIButton *)button
{
    switch (button.tag)
    {
//        case 0:
//        {
//            SendAuthReq* req = [[SendAuthReq alloc ] init ];
//            req.scope = @"snsapi_userinfo";
//            req.state = @"123" ;
//            //第三方向微信终端发送一个SendAuthReq消息结构
//            [WXApi sendReq:req];
//        }
//            break;
//        case 0:
//        {
////            TencentOAuth * tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1104971870" andDelegate:self];
//            if ([TencentOAuth iphoneQQInstalled]) {
//                NSArray* permissions = [NSArray arrayWithObjects:
//                                        kOPEN_PERMISSION_GET_USER_INFO,
//                                        kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
//                                        kOPEN_PERMISSION_ADD_ALBUM,
//                                        kOPEN_PERMISSION_ADD_IDOL,
//                                        kOPEN_PERMISSION_ADD_ONE_BLOG,
//                                        kOPEN_PERMISSION_ADD_PIC_T,
//                                        kOPEN_PERMISSION_ADD_SHARE,
//                                        kOPEN_PERMISSION_ADD_TOPIC,
//                                        kOPEN_PERMISSION_CHECK_PAGE_FANS,
//                                        kOPEN_PERMISSION_DEL_IDOL,
//                                        kOPEN_PERMISSION_DEL_T,
//                                        kOPEN_PERMISSION_GET_FANSLIST,
//                                        kOPEN_PERMISSION_GET_IDOLLIST,
//                                        kOPEN_PERMISSION_GET_INFO,
//                                        kOPEN_PERMISSION_GET_OTHER_INFO,
//                                        kOPEN_PERMISSION_GET_REPOST_LIST,
//                                        kOPEN_PERMISSION_LIST_ALBUM,
//                                        kOPEN_PERMISSION_UPLOAD_PIC,
//                                        kOPEN_PERMISSION_GET_VIP_INFO,
//                                        kOPEN_PERMISSION_GET_VIP_RICH_INFO,
//                                        kOPEN_PERMISSION_GET_INTIMATE_FRIENDS_WEIBO,
//                                        kOPEN_PERMISSION_MATCH_NICK_TIPS_WEIBO,
//                                        nil];
//                _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1104971870" andDelegate:self];
//                [_tencentOAuth authorize:permissions inSafari:NO];
//            }
//            else
//            {
//                [self showHUDText:@"你还没有安装QQ" delay:3];
//            }
//        }
//            break;
        case 1:
        {
            WBAuthorizeRequest *request = [WBAuthorizeRequest request];
            request.redirectURI = @"http://sns.whalecloud.com";
            request.scope = @"all";
            //    request.userInfo = @{@"myKey": @"myValue"};
            [WeiboSDK sendRequest:request];
        }
            break;
   
        default:
            break;
    }
}

- (void)findPassword
{
    ChangePasswordViewController *changePasswordVC = [[ChangePasswordViewController alloc] init];
    changePasswordVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:changePasswordVC animated:YES];
}

- (void)jumpProgress
{
    UserAgreementViewController *userAgreementVC = [[UserAgreementViewController alloc] init];
    userAgreementVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userAgreementVC animated:YES];
}

#pragma mark
//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    
    if (self.buttonType == 0)
    {
        if (self.loginView.bottom + kbSize.height > SCREEN_HEIGHT)
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.scrollView.y = SCREEN_HEIGHT-(self.loginView.bottom + kbSize.height);
            }];
        }
    }
    else
    {
        if (self.registView.bottom + kbSize.height > SCREEN_HEIGHT)
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.scrollView.y = SCREEN_HEIGHT-(self.registView.bottom + kbSize.height);
            }];
        }
    }
}

- (void)hidekeyBoard
{
    [self.loginView endEditing:YES];
    [self.registView endEditing:YES];
}

//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.y = 0;
    }];
}

//!更改登录、注册状态
- (void)changeType:(UIButton *)button
{
    self.buttonType = button.tag;
    if (button.tag == 0)
    {
        self.midView.image = [UIImage imageNamed:@"loginImage"];
        self.loginView.alpha = 1;
        self.forgetPasswordButton.alpha = 1;
        self.loginButton.alpha = 1;
        self.registButton.alpha = 0;
        self.registView.alpha = 0;
        self.bottomView.hidden = NO;
        self.progressButton.alpha = 0;
    }
    else
    {
        self.midView.image = [UIImage imageNamed:@"registImage"];
        self.loginView.alpha = 0;
        self.forgetPasswordButton.alpha = 0;
        self.loginButton.alpha = 0;
        self.registButton.alpha = 1;
        self.registView.alpha = 1;
        self.bottomView.hidden = YES;
        self.progressButton.alpha = 1;
    }
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUsedTicket1" object:nil];

    //登录成功后页面回调
    if (_delegate && [_delegate respondsToSelector:@selector(loginDelegate:)])
    {
        [_delegate loginDelegate:self.index];
    }
}

#pragma mark Service
- (void)loginAction
{
    NSString *param = Interface_login;
    NSString *name = [(UITextField *)[self.loginView viewWithTag:10] text];
    NSString *password = [(UITextField *)[self.loginView viewWithTag:11] text];
    NSString *imei = [[NSUserDefaults standardUserDefaults] objectForKey:kUDUUID];
    NSDictionary *dict = @{@"username":name,
                           @"password":password,
                           @"imei":imei};
    
    if ([TextFieldCheckAlert isStringNull:name])
    {
        [self showHUDText:@"请输入用户名" delay:1];
        return;
    }
    if ([TextFieldCheckAlert isStringNull:password])
    {
        [self showHUDText:@"请输入密码" delay:1];
        return;
    }
    
    [[BHServiceDataCentre sharedInstance] blHealthRequestByDict:param
                                                     parameters:dict
                                                        showHUD:YES
                                                     controller:self
                                                           type:CC_Interface_login
                                             serviceAnswerBlock:^(BOOL isSuccess, id responseMsg,
                                                                  NSInteger type, NSString *erroeMsg)
     {
         if (isSuccess && type == CC_Interface_login)
         {
             if (![TextFieldCheckAlert isStringNull:responseMsg[@"X-AUTH-TOKEN"]])
             {
                 [self showHUDText:@"登录成功" delay:1];
                 [self performSelector:@selector(back) withObject:nil afterDelay:3];
                 
                 [FFConfig currentConfig].isLogin = @YES;
                 [FFConfig currentConfig].userName = name;
                 [FFConfig currentConfig].phonePwd = password;
                 [FFConfig currentConfig].token = responseMsg[@"X-AUTH-TOKEN"];
                 [UMessage addTag:[FFConfig currentConfig].userName
                         response:^(id responseObject, NSInteger remain, NSError *error)
                  {
                      //add your codes
                  }];
             }
             else
             {
                 [self showHUDText:@"登录失败" delay:3];
             }
         }
         else if (!isSuccess && type == CC_Interface_login)
         {
             [self showHUDText:@"登录失败" delay:3];
         }
     }];
}

- (void)registAction
{
    NSString *name = [(UITextField *)[self.registView viewWithTag:10] text];
    NSString *password = [(UITextField *)[self.registView viewWithTag:11] text];
    NSString *telephone = [(UITextField *)[self.registView viewWithTag:12] text];
    NSString *imei = [[NSUserDefaults standardUserDefaults] objectForKey:kUDUUID];
    
    if ([TextFieldCheckAlert isStringNull:name])
    {
        [self showHUDText:@"请输入用户名" delay:1];
        return;
    }
    if ([TextFieldCheckAlert isStringNull:password])
    {
        [self showHUDText:@"请输入密码" delay:1];
        return;
    }
    if (![TextFieldCheckAlert isRightPhone:telephone])
    {
        [self showHUDText:@"请输入正确的手机号" delay:1];
        return;
    }
    
    NSDictionary *dict = @{@"username":name,
                           @"password":password,
                           @"telephone":telephone,
                           @"newRoles":@[@"USER"],
                           @"imei":imei};
    
    NSString *param = Interface_regist;
    [[BHServiceDataCentre sharedInstance] blHealthRequestByDict:param
                                                     parameters:dict
                                                        showHUD:YES
                                                     controller:self
                                                           type:CC_Interface_regist
                                             serviceAnswerBlock:^(BOOL isSuccess, id responseMsg,
                                                                  NSInteger type, NSString *erroeMsg)
     {
         if (isSuccess && type == CC_Interface_regist)
         {
             if ([TextFieldCheckAlert isStringNull:responseMsg[@"message"]])
             {
                 [self showHUDText:@"注册成功" delay:3];
                 [self performSelector:@selector(backAction) withObject:nil afterDelay:3];
                 
                 [FFConfig currentConfig].isLogin = @YES;
                 [FFConfig currentConfig].userName = name;
                 [FFConfig currentConfig].phonePwd = @"";
                 [FFConfig currentConfig].token = responseMsg[@"X-AUTH-TOKEN"];             }
             else
             {
                 [self showHUDText:responseMsg[@"message"] delay:3];
             }
         }
         else if (!isSuccess && type == CC_Interface_login)
         {
             
         }
     }];
}

- (void)thirdPartLoginService:(NSNotification*)loginInfo
{
    NSDictionary *temp = @{
                           @"imei" : @"169E0949-F829-4566-BFA7-2DE525C45791",
                           @"openId" : @"2772456555",
                           @"screenName" : @"GoodMor2012",
                           @"thirdType" : @"sina"
                           };
    NSString *param = Intrrface_thirdLogin;
    [[BHServiceDataCentre sharedInstance] blHealthRequestByDict:param
                                                     parameters:[loginInfo object]
                                                        showHUD:YES
                                                     controller:self
                                                           type:CC_Interface_thirdLogin
                                             serviceAnswerBlock:^(BOOL isSuccess, id responseMsg,
                                                                  NSInteger type, NSString *erroeMsg)
     {
         
         if (isSuccess && type == CC_Interface_thirdLogin)
         {
             if (![TextFieldCheckAlert isStringNull:responseMsg[@"X-AUTH-TOKEN"]])
             {
                 [self showHUDText:@"登录成功" delay:3];
                 [self performSelector:@selector(backAction) withObject:nil afterDelay:3];
                 
                 [FFConfig currentConfig].isLogin = @YES;
                 [FFConfig currentConfig].userName = [loginInfo object][@"screenName"];
                 [FFConfig currentConfig].phonePwd = @"";
                 [FFConfig currentConfig].token = responseMsg[@"X-AUTH-TOKEN"];
                 
             }
             else
             {
                 [self showHUDText:@"登录失败" delay:3];
             }
         }
         else if (!isSuccess && type == CC_Interface_thirdLogin)
         {
             
         }
     }];

}

#pragma mark delegate
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//    return [TencentOAuth HandleOpenURL:url];
//}

////QQ登录回调
//- (void)tencentDidLogin
//{
//    [_tencentOAuth getUserInfo];
//}

- (void)getUserInfoResponse:(APIResponse*) response
{
    NSDictionary *dict = response.jsonResponse;
    DLog(@"%@", response.jsonResponse);
    
    NSDictionary *loginInfo = @{@"thirdType":@"qq",
                                @"openId":[[dict objectForKey:@"figureurl"] substringWithRange:NSMakeRange(39, 32)],
                                @"screenName":dict[@"nickname"],
                                @"imei":[[NSUserDefaults standardUserDefaults] objectForKey:kUDUUID]};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"thirdPartLogin" object:loginInfo];
}

@end
