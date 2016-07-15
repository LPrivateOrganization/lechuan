//
//  SpreadViewController.m
//  lechuan
//
//  Created by Kami Mahou on 15/12/9.
//  Copyright © 2015年 Kami Mahou. All rights reserved.
//

#import "SpreadViewController.h"

@interface SpreadViewController ()

@end

@implementation SpreadViewController

#pragma mark Init && Add
- (instancetype)init
{
    if (self = [super init]) {
        [self setTopViewWithTitle:@"我要传播"];
    }
    return self;
}

- (UITextView *)contentTextView
{
    if (!_contentTextView) {
        _contentTextView = [[UITextView alloc] init];
        _contentTextView.frame = CGRectMake(15, 64+13, SCREEN_WIDTH-30, SCREEN_HEIGHT-64-26);
        _contentTextView.backgroundColor = [UIColor whiteColor];
        _contentTextView.layer.cornerRadius = 6;
        _contentTextView.layer.borderWidth = 0.5;
        _contentTextView.layer.borderColor = UIColorFromRGB(0xc8c8c8).CGColor;
        _contentTextView.textColor = UIColorFromRGB(0x6a6a6a);
        
        _contentTextView.textContainerInset = UIEdgeInsetsMake(15, 15, 15, 15);
        _contentTextView.editable = NO;
        
        [self.view addSubview:_contentTextView];
    }
    return _contentTextView;
}

#pragma mark System Action
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColorFromRGB(0xeeeeee);
    self.contentTextView.alpha = 1.0f;
    
    [self getContent];
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

#pragma mark Other Action
- (NSMutableAttributedString *)setAttributeString:(NSString *)text
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];//调整行间距

    [attributeString addAttribute:NSParagraphStyleAttributeName
                            value:paragraphStyle
                            range:NSMakeRange(0, text.length)];
    
    
    return attributeString;
}

#pragma mark Service
- (void)getContent
{
    NSString *param = Interface_content(6);
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
