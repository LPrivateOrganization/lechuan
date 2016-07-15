//
//  UsableTicketViewController.m
//  lechuan
//
//  Created by Kami Mahou on 15/12/11.
//  Copyright © 2015年 Kami Mahou. All rights reserved.
//

#import "UsableTicketViewController.h"

@interface UsableTicketViewController ()

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation UsableTicketViewController

#pragma mark Init && Add
- (instancetype)init
{
    if (self = [super init]) {
        [self setTopViewWithTitle:@"可用礼品券"];
    }
    return self;
}

#pragma mark System Action
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    [self getUsableTicket];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Other Action
- (void)receive:(UIButton *)button
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"领取电子券" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alertView setAlertViewStyle:UIAlertViewStyleSecureTextInput];
    alertView.tag = button.tag;
    [alertView show];
}

#pragma mark TableView DataSource && Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140*autoSizeScaleY+22;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    DefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[DefaultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.backgroundColor = UIColorFromRGB(0xeeeeee);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.frame = CGRectMake(0, 0, SCREEN_WIDTH, 140*autoSizeScaleY+22);
    cell.ViewBack.frame = cell.frame;
    cell.ViewBack.backgroundColor = cell.backgroundColor;
    
    NSDictionary *dict = self.dataArray[indexPath.row];
    
    //背景
    [cell.firstImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(cell);
        make.size.mas_equalTo(AutoCGSizeMake(321, 140));
    }];
    cell.firstImageView.image = [UIImage imageNamed:@"usableTicket"];
    
    //名称、供应商
    [cell.firstLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.firstImageView).with.offset(8*autoSizeScaleY);
        make.left.equalTo(cell.firstImageView).with.offset(8*autoSizeScaleY);
        make.right.equalTo(cell.firstImageView).with.offset(-8*autoSizeScaleY);
    }];
    NSString *title = [NSString stringWithFormat:@"%@\n%@", dict[@"productName"], dict[@"productVendorName"]];
    NSMutableAttributedString *titleAttributeString = [[NSMutableAttributedString alloc] initWithString:title];
    
    [titleAttributeString addAttribute:NSFontAttributeName
                                 value:Font(15*autoSizeScaleY)
                                 range:NSMakeRange(0, [dict[@"productName"] length])];
    [titleAttributeString addAttribute:NSFontAttributeName
                                 value:Font(11*autoSizeScaleY)
                                 range:NSMakeRange([dict[@"productName"] length]+1, [dict[@"productVendorName"] length])];
    [titleAttributeString addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor whiteColor]
                                 range:NSMakeRange(0, title.length)];
    cell.firstLabel.attributedText = titleAttributeString;
    
    //领取按钮
    [cell.firstButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell.firstImageView).with.offset(-13*autoSizeScaleY);
        make.size.mas_equalTo(AutoCGSizeMake(66, 25));
        make.top.equalTo(cell.firstImageView).with.offset(36*autoSizeScaleY);
    }];
    [cell.firstButton setBackgroundImage:[UIImage imageNamed:@"receiveButton"] forState:UIControlStateNormal];
    cell.firstButton.tag = indexPath.row;
    [cell.firstButton addTarget:self action:@selector(receive:) forControlEvents:UIControlEventTouchUpInside];
    
    //领取地址
    NSString *fetchAddress = [NSString stringWithFormat:@"领取地址：%@", dict[@"product"][@"fetchAddress"]];
    //联系电话
    NSString *fetchTelephone = [NSString stringWithFormat:@"联系电话：%@", dict[@"product"][@"fetchTelephone"]];
    //有效期限
    long long time = [dict[@"validTime"] integerValue];
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy年MM月dd日";
    NSString *timeString = [dateFormatter stringFromDate:date];
    NSString *validTime = [NSString stringWithFormat:@"有效期限：%@", timeString];
    //友情提示
    NSString *tip = [NSString stringWithFormat:@"友情提示：%@", dict[@"product"][@"tips"]];
    
    NSString *content = [NSString stringWithFormat:@"%@\n%@\n%@\n%@", fetchAddress, fetchTelephone, validTime, tip];
    [cell.secondLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.firstImageView).with.offset(72*autoSizeScaleY);
        make.left.equalTo(cell.firstLabel);
        make.right.equalTo(cell.firstLabel);
    }];
    cell.secondLabel.textColor = UIColorFromRGB(0x636363);
    cell.secondLabel.text = content;
    cell.secondLabel.numberOfLines = 0;
    cell.secondLabel.font = Font(11*autoSizeScaleY);
    
    return cell;
}

#pragma mark Service
- (void)getUsableTicket
{
    NSString *imei = [[NSUserDefaults standardUserDefaults] objectForKey:kUDUUID];
    if ([[FFConfig currentConfig].isLogin boolValue]) 
    {
        NSString *param = Interface_usableTicket1;
        [[BHServiceDataCentre sharedInstance] blHealthRequestByDict:param
                                                         parameters:nil
                                                            showHUD:YES
                                                         controller:self
                                                               type:CC_Interface_usableTicket
                                                 serviceAnswerBlock:^(BOOL isSuccsee, id responseMsg,
                                                                      NSInteger type, NSString *errorMsg)
         {
             if (isSuccsee && type == CC_Interface_usableTicket)
             {
                 if ([Utilities isValidArray:responseMsg[@"content"]])
                 {
                     self.dataArray = [responseMsg[@"content"] mutableCopy];
                     [self.tableView reloadData];
                 }
             }
             else
             {
                 
             }
         }];
    }
    else
    {
        NSString *param = Interface_usableTicket(imei);
        [[BHServiceDataCentre sharedInstance] blHealthRequestByDict:param
                                                         parameters:nil
                                                            showHUD:YES
                                                         controller:self
                                                               type:CC_Interface_usableTicket
                                                 serviceAnswerBlock:^(BOOL isSuccsee, id responseMsg,
                                                                      NSInteger type, NSString *errorMsg)
         {
             if (isSuccsee && type == CC_Interface_usableTicket)
             {
                 self.dataArray = nil;
                 if ([Utilities isValidArray:responseMsg[@"content"]])
                 {
                     self.dataArray  = responseMsg[@"content"];
                 }
                 [self.tableView reloadData];
             }
         }];

    }
}

//!领取电子券
- (void)fetchTicket:(NSInteger)tag password:(NSString *)password
{
    NSDictionary *dict = self.dataArray[tag];
    NSDictionary *parameters = @{@"id":dict[@"id"],
                                 @"fetchPassword":password};
    NSString *param = Intrrface_fetchTicket;
    [[BHServiceDataCentre sharedInstance] blHealthRequestByDict:param
                                                     parameters:parameters
                                                        showHUD:YES
                                                     controller:self
                                                           type:CC_Intrrface_fetchTicket
                                             serviceAnswerBlock:^(BOOL isSuccsee, id responseMsg,
                                                                  NSInteger type, NSString *errorMsg)
     {
         if (isSuccsee && type == CC_Intrrface_fetchTicket)
         {
             if (![TextFieldCheckAlert isStringNull:responseMsg[@"message"]])
             {
                 [self showHUDText:responseMsg[@"message"] delay:1];
             }
             
             [self getUsableTicket];
         }
     }];
}

#pragma mark delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSString *password = [[alertView textFieldAtIndex:0] text];
        if ([TextFieldCheckAlert isStringNull:password])
        {
            [self showHUDText:@"请输入密码" delay:2];
        }
        else
        {
            [self fetchTicket:alertView.tag password:password];
        }
    }
}

@end
