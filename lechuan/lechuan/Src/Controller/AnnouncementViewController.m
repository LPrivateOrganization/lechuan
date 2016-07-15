//
//  AnnouncementViewController.m
//  lechuan
//
//  Created by Kami Mahou on 15/12/9.
//  Copyright © 2015年 Kami Mahou. All rights reserved.
//

#import "AnnouncementViewController.h"

@interface AnnouncementViewController ()

@end

@implementation AnnouncementViewController

#pragma mark Init && Add
- (instancetype)init
{
    if (self = [super init]) {
        [self setTopViewWithTitle:@"乐传公告"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *urlString = [NSString stringWithFormat:@"%@/notice.html",baseServerAddress];
    NSURL *url = [NSURL URLWithString:[urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];

    UIWebView *webView = [[UIWebView alloc] init];
    
    webView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    [webView loadRequest:request];
    [self.view addSubview:webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
