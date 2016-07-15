//
//  UseGuideViewController.m
//  乐传
//
//  Created by bug on 16/1/5.
//  Copyright © 2016年 Kami Mahou. All rights reserved.
//

#import "UseGuideViewController.h"
#import "UseGuideView.h"

@interface UseGuideViewController ()
@property (nonatomic, strong) UseGuideView *userGuideView;

@end

@implementation UseGuideViewController

#pragma mark Init && Add
- (UseGuideView *)userGuideView
{
    if (!_userGuideView) {
        _userGuideView = [[UseGuideView alloc] init];
        _userGuideView.superVC = self;  
    }
    return _userGuideView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
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
