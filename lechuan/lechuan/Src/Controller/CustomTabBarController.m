//
//  CustomTabBarController.m
//  Xinjiang
//
//  Created by Kami Mahou on 15/6/16.
//  Copyright (c) 2015年 Kami Mahou. All rights reserved.
//

#import "CustomTabBarController.h"

@interface CustomTabBarController () <UITabBarControllerDelegate>

@end

@implementation CustomTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ;
    NSArray *mainInfo = @[@{@"Controller" : @"LeChuanViewController",
                            @"Icon" : @"lechuan",
                            @"Title" : @"乐传"},
                          @{@"Controller" : @"MyTicketViewController",
                            @"Icon" : @"wodquan",
                            @"Title" : @"我的券"},
                          @{@"Controller" : @"UnionViewController",
                            @"Icon" : @"helianmeng",
                            @"Title" : @"合联盟"}];
    NSMutableArray *mainArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < mainInfo.count; i++)
    {
        NSDictionary *dict = mainInfo[i];
        
        id homeController = [[NSClassFromString(dict[@"Controller"]) alloc] init];
        if (homeController != nil)
        {
            UINavigationController *navHome = [[UINavigationController alloc]initWithRootViewController:homeController];

            navHome.tabBarItem.image = [UIImage imageNamed:dict[@"Icon"]];
            navHome.tabBarItem.selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_click",dict[@"Icon"]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            navHome.title = dict[@"Title"];
            [mainArray addObject:navHome];
        }
    }
    
    self.tabBar.tintColor = [UIColor redColor];
//    self.tabBar.barTintColor = UIColorFromRGB(0xf5f5f5);
    [self.tabBar setTranslucent:NO];
    self.viewControllers = mainArray;
    self.delegate = self;
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
