//
//  UserGuideViewController.m
//  XinJiang
//
//  Created by Kami Mahou on 15/9/7.
//  Copyright (c) 2015年 Kami Mahou. All rights reserved.
//

#import "UserGuideViewController.h"
#import "UserGuideView.h"

@interface UserGuideViewController ()

@property (nonatomic, strong) UserGuideView *userGuideView;

@end

@implementation UserGuideViewController

#pragma mark Init && Add
- (UserGuideView *)userGuideView
{
    if (!_userGuideView) {
        _userGuideView = [[UserGuideView alloc] init];
        _userGuideView.superVC = self;
    }
    return _userGuideView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.userGuideView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //改变状态栏颜色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
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

@end
