//
//  FloatingWindowJumpViewController.m
//  lechuan
//
//  Created by bug on 15/12/17.
//  Copyright © 2015年 Kami Mahou. All rights reserved.
//

#import "FloatingWindowJumpViewController.h"

@interface FloatingWindowJumpViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation FloatingWindowJumpViewController

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
    
    NSURL *url = [NSURL URLWithString:[self.jumpURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self updateList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateList
{
    NSDictionary *dict = @{@"keyValue": self.jumpURL};
    NSString *param = Interface_uploadList;
    [[BHServiceDataCentre sharedInstance] blHealthRequestByDict:param
                                                     parameters:dict
                                                        showHUD:NO
                                                     controller:self
                                                           type:CC_Interface_uploadList
                                             serviceAnswerBlock:^(BOOL isSuccess, id responseMsg,
                                                                  NSInteger type, NSString *errorMsg)
     {
         if (isSuccess && type == CC_Interface_uploadList)
         {
             
         }
         else if (!isSuccess && type == CC_Interface_uploadList)
         {
             
         }
     }];
}

#pragma mark delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self setTopViewWithTitle:[webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
}

@end
