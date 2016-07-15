//
//  DelegateViewController.m
//  lechuan
//
//  Created by Kami Mahou on 15/12/9.
//  Copyright © 2015年 Kami Mahou. All rights reserved.
//

#import "DelegateViewController.h"

@interface DelegateViewController ()

@end

@implementation DelegateViewController

#pragma mark Init && Add
- (instancetype)init
{
    if (self = [super init]) {
        [self setTopViewWithTitle:@"我要代理"];
    }
    return self;
}

#pragma mark System Action
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Service
- (void)getContent
{
    NSString *param = Interface_content(7);
    [[BHServiceDataCentre sharedInstance] blHealthRequestByDict:param
                                                     parameters:nil
                                                        showHUD:YES
                                                     controller:self
                                                           type:CC_Interface_content
                                             serviceAnswerBlock:^(BOOL isSuccsee, id responseMsg,
                                                                  NSInteger type, NSString *errorMsg)
     {
         if (isSuccsee && type == CC_Interface_content)
         {
             self.contentTextView.attributedText = [self setAttributeString:responseMsg[@"content"][0][@"str"]];
         }
     }];
    
}

@end
