//
//  NoteViewController.m
//  渠道助手
//
//  Created by bug on 16/4/11.
//  Copyright © 2016年 Kami Mahou. All rights reserved.
//

#import "NoteViewController.h"

@interface NoteViewController ()

@property (nonatomic, strong) UIView *topView;

@end

@implementation NoteViewController

- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        
        _topView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 64);
        _topView.backgroundColor = [UIColor lightGrayColor];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(12,20,80,44);
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [button addTarget:self action:@selector(goBackView) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"System_Nav_Back_btn"] forState:UIControlStateNormal];
//        [button setBackgroundImage:[UIImage imageNamed:@"System_Nav_Back_btn"] forState:UIControlStateNormal];
//        button.backgroundColor = [UIColor orangeColor];
        [_topView addSubview:button];

        [self.view addSubview:_topView];
    }
    return _topView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIWebView *webView = [[UIWebView alloc] init];
    
    webView.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64);
    NSURL* url = [NSURL URLWithString:self.infoDic[@"url"]];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [webView loadRequest:request];//加载
    [self.view addSubview:webView];
    [self topView];
    [self updateList];
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
//返回上一级
- (void)goBackView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateList
{
    NSDictionary *dict = @{@"keyValue": self.infoDic[@"url"]};
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
@end
