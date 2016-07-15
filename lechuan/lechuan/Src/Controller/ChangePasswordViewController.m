//
//  ChangePasswordViewController.m
//  lechuan
//
//  Created by bug on 15/12/15.
//  Copyright © 2015年 Kami Mahou. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "LoginTextField.h"
#import <TencentOpenAPI/TencentOAuth.h>

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

#pragma mark Init && Add
- (instancetype)init
{
    if (self = [super init]) {
        [self setTopViewWithTitle:@"修改密码"];
    }
    return self;
}

#pragma mark System Action
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(0xeeeeee);
    
    [self setFrame];
}

#pragma mark other Action
- (void)setFrame
{
    NSArray *placeholder = @[@"新密码", @"确认密码", @"短信验证码"];
    for (int i = 0; i < 2; i++) {
        LoginTextField *textField = [[LoginTextField alloc] init];
        
        textField.frame = CGRectMake(17*autoSizeScaleX, 64+19*autoSizeScaleY+46*autoSizeScaleY*i, SCREEN_WIDTH-34*autoSizeScaleX, 35*autoSizeScaleY);
        textField.font = Font(13*autoSizeScaleY);
        textField.backgroundColor = [UIColor whiteColor];
        textField.layer.cornerRadius = 10;
        textField.secureTextEntry = YES;
        textField.tag = -(i+1);
        
        textField.leftViewMode = UITextFieldViewModeAlways;
        UIImageView *imageView = [[UIImageView alloc] init];;
        imageView.image = [UIImage imageNamed:@"passwordIcon"];
        textField.leftView = imageView;
        
        textField.placeholder = placeholder[i];
        
        [self.view addSubview:textField];
        
        if (i == 1) {
            UIButton *certainButton = [UIButton buttonWithType:UIButtonTypeCustom];
            
            certainButton.frame = CGRectMake(17*autoSizeScaleX, textField.bottom+30*autoSizeScaleY, SCREEN_WIDTH-34*autoSizeScaleX, 66*autoSizeScaleY);
            certainButton.layer.cornerRadius = 10;
            [certainButton setImage:[UIImage imageNamed:@"confirmBtn"] forState:UIControlStateNormal];
            
            [certainButton addTarget:self action:@selector(changePassword) forControlEvents:UIControlEventTouchUpInside];
            
            [self.view addSubview:certainButton];
        }
    }
}

#pragma mark service
- (void)changePassword
{
    [self.view endEditing:YES];
    
    NSString *newPasword = [(UITextField *)[self.view viewWithTag:-1] text];
    NSString *certainPassword = [(UITextField *) [self.view viewWithTag:-2] text];
    if ([TextFieldCheckAlert isStringNull:newPasword])
    {
        [self showHUDText:@"请输入新密码" delay:1];
        return;
    }
    if (![newPasword isEqualToString:certainPassword]) {
        [self showHUDText:@"请保持密码一致" delay:1];
        return;
    }
    
    NSString *param = Intrrface_changePassword;
    NSDictionary *dict = @{@"newPassword":newPasword};
    
    [[BHServiceDataCentre sharedInstance] blHealthRequestByDict:param
                                                     parameters:dict
                                                        showHUD:YES
                                                     controller:self
                                                           type:CC_Intrrface_changePassword
                                             serviceAnswerBlock:^(BOOL isSuccess, id responseMsg,
                                                                  NSInteger type, NSString *erroeMsg)
     {
         if (isSuccess && type == CC_Intrrface_changePassword)
         {
             [FFConfig currentConfig].isLogin = @NO;
             [FFConfig currentConfig].token = @"";
             
             TencentOAuth *tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1104971870" andDelegate:self];
             [tencentOAuth logout:nil];
             [WeiboSDK logOutWithToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"weiboToken"]
                              delegate:nil
                               withTag:@"0"];
             
             [self showHUDText:@"密码修改成功" delay:1];
             [self performSelector:@selector(backToRootVC) withObject:nil afterDelay:1];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"changeRes" object:nil];
         }
     }];
}

- (void)backToRootVC
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
