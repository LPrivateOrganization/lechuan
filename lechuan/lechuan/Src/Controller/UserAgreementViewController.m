//
//  UserAgreementViewController.m
//  lechuan
//
//  Created by bug on 15/12/18.
//  Copyright © 2015年 Kami Mahou. All rights reserved.
//

#import "UserAgreementViewController.h"

@interface UserAgreementViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation UserAgreementViewController

- (instancetype)init
{
    if (self = [super init]) {
        [self setTopViewWithTitle:@""];
    }
    return self;
}

#pragma mark System Action
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.webView = [[UIWebView alloc] init];
    
    self.webView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/license.html",baseServerAddress];
    NSURL *url = [NSURL URLWithString:[urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self setTopViewWithTitle:[webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
}

@end



