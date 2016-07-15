//
//  AppDelegate.h
//  lechuan
//
//  Created by lichaowei on 16/7/12.
//  Copyright © 2016年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabBarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) CustomTabBarController *customTBC;

- (void)showTabBar;

@end

