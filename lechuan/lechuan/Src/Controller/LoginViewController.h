//
//  LoginViewController.h
//  lechuan
//
//  Created by Kami Mahou on 15/12/9.
//  Copyright © 2015年 Kami Mahou. All rights reserved.
//

#import "BaseViewController.h"
@protocol LoginViewControllerDelegate <NSObject>

//!登录成功页面回调函数
- (void)loginDelegate:(NSInteger)index;

@end

@interface LoginViewController : BaseViewController

@property (nonatomic, weak) id <LoginViewControllerDelegate> delegate;
//!根据index跳转页面
@property (nonatomic, assign) NSInteger index;

@end
