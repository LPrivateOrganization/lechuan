//
//  TiePhoneViewController.m
//  lechuan
//
//  Created by bug on 15/12/15.
//  Copyright © 2015年 Kami Mahou. All rights reserved.
//

#import "TiePhoneViewController.h"
#import "LoginTextField.h"

@interface TiePhoneViewController ()

@end

@implementation TiePhoneViewController

#pragma mark Init && Add
- (instancetype)init
{
    if (self = [super init]) {
        [self setTopViewWithTitle:@"绑定手机"];
        if (![self.phoneNum isEqualToString: @""])
        {
            [self setTopViewWithTitle:@"更改手机"];
        }
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
    NSArray *placeholder = @[@"请输入手机号", @"短信验证码"];
    LoginTextField *textField = [[LoginTextField alloc] init];
    
    textField.frame = CGRectMake(17*autoSizeScaleX, 64+19*autoSizeScaleY, SCREEN_WIDTH-34*autoSizeScaleX, 35*autoSizeScaleY);
    textField.font = Font(13*autoSizeScaleY);
    textField.backgroundColor = [UIColor whiteColor];
    textField.layer.cornerRadius = 10;
    
    textField.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *imageView = [[UIImageView alloc] init];;
    imageView.image = [UIImage imageNamed:@"phoneIcon"];
    textField.tag = -100;
    textField.leftView = imageView;
    
    
    textField.placeholder = placeholder[0];
    
    [self.view addSubview:textField];
    
    UIButton *certainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    certainButton.frame = CGRectMake(17*autoSizeScaleX, textField.bottom+30*autoSizeScaleY, SCREEN_WIDTH-34*autoSizeScaleX, 66*autoSizeScaleY);
    certainButton.layer.cornerRadius = 10;
    [certainButton setImage:[UIImage imageNamed:@"confirmBtn"] forState:UIControlStateNormal];
    [certainButton addTarget:self action:@selector(changePhone) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:certainButton];
    
    UILabel *label = [[UILabel alloc] init];
    
    label.frame = CGRectMake(25*autoSizeScaleX, certainButton.bottom, SCREEN_WIDTH-25*autoSizeScaleX, 30*autoSizeScaleY);
    label.font = Font(13);
//    label.text = @"手机号可以用于找回密码";
    label.textColor = UIColorFromRGB(0x969696);
    
    [self.view addSubview:label];
}

#pragma mark Service
- (void)changePhone
{
    [self.view endEditing:YES];
    
    NSString *newPhone = [(UITextField *)[self.view viewWithTag:-100] text];
    if ([TextFieldCheckAlert isStringNull:newPhone])
    {
        [self showHUDText:@"请输入手机号" delay:1];
        return;
    }
    
    NSString *param = Intrrface_updateUserInfo;
    NSDictionary *dict = @{@"telephone":newPhone};
    
    [[BHServiceDataCentre sharedInstance] blHealthRequestByDict:param
                                                     parameters:dict
                                                        showHUD:YES
                                                     controller:self
                                                           type:CC_Intrrface_updateUserInfo
                                             serviceAnswerBlock:^(BOOL isSuccess, id responseMsg,
                                                                  NSInteger type, NSString *erroeMsg)
     {
         if (isSuccess && type == CC_Intrrface_updateUserInfo)
         {
             [self showHUDText:@"手机号更改成功" delay:1];
             [self performSelector:@selector(backAction) withObject:nil afterDelay:1];
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"getUserName" object:nil];
         }
     }];
}

@end
