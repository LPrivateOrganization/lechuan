//
//  MyTicketViewController.m
//  lechuan
//
//  Created by Kami Mahou on 15/12/8.
//  Copyright © 2015年 Kami Mahou. All rights reserved.
//

#import "MyTicketViewController.h"
#import "LoginButgton.h"
#import "UsableTicketViewController.h"
#import "UnUsableTicketViewController.h"
#import "ManageAccountViewController.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "LoginViewController.h"
#import "MyTestViewController.h"

@interface MyTicketViewController () <LoginViewControllerDelegate>

@property (nonatomic, strong) LoginButgton *loginButton;
//登录状态的cell
@property (nonatomic, strong) NSArray *loginCellArray;
//注销状态的cell
@property (nonatomic, strong) NSArray *logoffCellArray;
//展示的cell
@property (nonatomic, strong) NSArray *showCellArray;
@property (nonatomic, strong) NSMutableArray *usableArray;
@property (nonatomic, strong) NSMutableArray *unUsableArray;


@end

@implementation MyTicketViewController

#pragma mark Init && Add
- (instancetype)init
{
    if (self = [super init]) {
        [self setTopViewWithTitle:@"我的券"];
        self.backBtn.hidden = YES;
    }
    return self;
}

- (NSMutableArray *)usableArray
{
    if (!_usableArray)
    {
        _usableArray = [NSMutableArray array];
    }
    return _usableArray;
}


- (NSMutableArray *)unUsableArray
{
    if (!_unUsableArray)
    {
        _unUsableArray = [NSMutableArray array];
    }
    return _unUsableArray;
}
- (LoginButgton *)loginButton
{
    if (!_loginButton) {
        _loginButton = [[LoginButgton alloc] init];
        
        _loginButton.frame = CGRectMake(SCREEN_WIDTH-100-15, 64-44, 100, 44);
        [_loginButton setImage:[UIImage imageNamed:@"userHead"] forState:UIControlStateNormal];
        [_loginButton setTitle:@"登录/注册" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginButton.titleLabel.font = Font(12);
        _loginButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [_loginButton addTarget:self action:@selector(jumoToLoginVC) forControlEvents:UIControlEventTouchUpInside];
        
        [self.topTitleView addSubview:_loginButton];
    }
    return _loginButton;
}

- (NSArray *)loginCellArray
{
    if (!_loginCellArray) {
        _loginCellArray = @[@[@{@"可用礼品券":@"myTicketCell_0"}, @{@"失效礼品券":@"myTicketCell_1"}],
                            @[@{@"我的消息":@"myTicketCell_2"}],
                            @[@{@"账号管理":@"myTicketCell_3"}, @{@"安全退出":@"myTicketCell_4"}]];
    }
    return _loginCellArray;
}

- (NSArray *)logoffCellArray
{
    if (!_logoffCellArray) {
        _logoffCellArray = @[@[@{@"可用礼品券":@"myTicketCell_0"}, @{@"失效礼品券":@"myTicketCell_1"}],
                            @[@{@"我的消息":@"myTicketCell_2"}]
                             ];
    }
    return _logoffCellArray;
}

#pragma mark System Action
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTickt:) name:@"refreshUsedTicket" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTickt1:) name:@"refreshUsedTicket1" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearData) name:@"changeRes" object:nil];
    self.loginButton.alpha = 1.0f;
    [self.tableView setMjHeaderController:self Selector:@selector(downRefreshTick)];

    
    self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49);
    self.tableView.backgroundColor = UIColorFromRGB(0xeeeeee);
    [self getUsableTicket];
    [self getUnUsableTicket];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.showCellArray = [[FFConfig currentConfig].isLogin boolValue] ? self.loginCellArray : self.logoffCellArray;
    
    if ([[FFConfig currentConfig].isLogin boolValue])
    {
        [self.loginButton setTitle:[FFConfig currentConfig].userName forState:UIControlStateNormal];
    }
    else
    {
        [self.loginButton setTitle:@"登录/注册" forState:UIControlStateNormal];
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Other Action
- (void)jumoToLoginVC
{
    if ([[FFConfig currentConfig].isLogin boolValue])
    {
        return;
    }
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    
    loginVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (void)jumpAction:(NSInteger)index
{
    
    switch (index) {
        case 0:
        {
            if (!self.usableArray.count == 0)
            {
                UsableTicketViewController *usableTicketVC = [[UsableTicketViewController alloc] init];
                usableTicketVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:usableTicketVC animated:YES];

            }
        }
            break;
        case 1:
        {
            if (!self.unUsableArray.count == 0)
            {
                UnUsableTicketViewController *unUsableTicketVC = [[UnUsableTicketViewController alloc] init];
                unUsableTicketVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:unUsableTicketVC animated:YES];
            }
        }
            break;
        case 10:
        {
                MyTestViewController *myTestViewVC = [[MyTestViewController alloc] init];
                myTestViewVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:myTestViewVC animated:YES];
        }
            break;
        case 20:
        {
            ManageAccountViewController *manageAccountVC = [[ManageAccountViewController alloc] init];
            manageAccountVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:manageAccountVC animated:YES];
        }
            break;
        case 21:
        {
            //安全退出
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定退出？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
        }
            break;
        default:
            break;
    }
}

#pragma mark TableView DataSource && Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.showCellArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.showCellArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 12);
    view.backgroundColor = UIColorFromRGB(0xeeeeee);

    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    DefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[DefaultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *dict = self.showCellArray[indexPath.section][indexPath.row];
    
    [cell.firstImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell).with.offset(10);
        make.centerY.equalTo(cell);
    }];
    cell.firstImageView.image = [UIImage imageNamed:dict.allValues[0]];
    
    [cell.secondImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell).with.offset(-20);
        make.centerY.equalTo(cell);
    }];
    cell.secondImageView.image = [UIImage imageNamed:@"rightCell"];
    if (indexPath.section == 1 && indexPath.row == 1) {
        cell.secondImageView.hidden = YES;
    }
    
    [cell.firstLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell).with.offset(44);
        make.centerY.equalTo(cell);
    }];
    cell.firstLabel.text = dict.allKeys[0];
    cell.firstLabel.font = Font(13);
    
    if (indexPath.section < 1)
    {
        NSString *str = @"";

        if (indexPath.row == 0)
        {
            str = [NSString stringWithFormat:@"%lu张", (unsigned long)self.usableArray.count];
            cell.secondLabel.backgroundColor = UIColorFromRGB(0xda2315);
        }
        else
        {
            str =[NSString stringWithFormat:@"%lu张", (unsigned long)self.unUsableArray.count];
            cell.secondLabel.backgroundColor = UIColorFromRGB(0xc0c0c0);
        }
        CGFloat width = [GetStringWidthAndHeight getStringWidth:str height:15 font:Font(12)].width;
        
        [cell.secondLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(width+15, 15));
            make.left.equalTo(cell).with.offset(120);
            make.centerY.equalTo(cell);
        }];
        
        cell.secondLabel.text = str;
        cell.secondLabel.textColor = [UIColor whiteColor];
        cell.secondLabel.font = Font(12);
        cell.secondLabel.layer.cornerRadius = 5;
        cell.secondLabel.layer.masksToBounds = YES;
        cell.secondLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    cell.firstLineView.frame = CGRectMake(0, 39.5, SCREEN_WIDTH, 0.5);
    cell.firstLineView.backgroundColor = UIColorFromRGB(0xe4e4e4);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger index = indexPath.section*10+indexPath.row;
    
    [self jumpAction:index];
}

#pragma mark Service
- (void)getUsableTicket
{
    [self.usableArray removeAllObjects];
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
                     self.usableArray = [responseMsg[@"content"] mutableCopy];
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
             if ([Utilities isValidArray:responseMsg[@"content"]])
             {
                 self.usableArray = [responseMsg[@"content"] mutableCopy];
                 [self.tableView reloadData];
             }
         }
         else
         {
         
         }
     }];
    }
}

- (void)getUnUsableTicket
{
    NSString *param = Interface_unUsableTicket;
    [self.unUsableArray removeAllObjects];
    if ([[FFConfig currentConfig].isLogin boolValue])
    {
        [[BHServiceDataCentre sharedInstance] blHealthRequestByDict:param
                                                         parameters:nil
                                                            showHUD:YES
                                                         controller:self
                                                               type:CC_Interface_unUsableTicket
                                                 serviceAnswerBlock:^(BOOL isSuccsee, id responseMsg,
                                                                      NSInteger type, NSString *errorMsg)
         {
             if (isSuccsee && type == CC_Interface_unUsableTicket)
             {
                 
                 
                 if ([Utilities isValidArray:responseMsg[@"content"]])
                 {
                     self.unUsableArray  = [responseMsg[@"content"] mutableCopy];
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
        NSString *imei = [[NSUserDefaults standardUserDefaults] objectForKey:kUDUUID];
        NSString *param = Interface_unUsableTicket1(imei);
            [[BHServiceDataCentre sharedInstance] blHealthRequestByDict:param
                                                             parameters:nil
                                                                showHUD:YES
                                                             controller:self
                                                                   type:CC_Interface_unUsableTicket1
                                                     serviceAnswerBlock:^(BOOL isSuccsee, id responseMsg,
                                                                          NSInteger type, NSString *errorMsg)
             {
                 if (isSuccsee && type == CC_Interface_unUsableTicket1)
                 {
                     
                     
                     if ([Utilities isValidArray:responseMsg[@"content"]])
                     {
                         self.unUsableArray  = [responseMsg[@"content"] mutableCopy];
                         [self.tableView reloadData];
                     }
                 }
                 else
                 {
                     
                     
                 }
             }];
    }
}

#pragma mark delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [FFConfig currentConfig].isLogin = @NO;
        [FFConfig currentConfig].token = @"";
        
        TencentOAuth *tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1104971870" andDelegate:self];
        [tencentOAuth logout:nil];
        [WeiboSDK logOutWithToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"weiboToken"]
                         delegate:nil
                          withTag:@"0"];
        
        
        [self.usableArray removeAllObjects];
        [self.unUsableArray removeAllObjects];
//        self.unUsableArray = nil;
//        [self.tableView reloadData];
        [self viewWillAppear:YES];
    }
}



- (void)loginDelegate:(NSInteger)index
{
    [self jumpAction:index];
}


#pragma mark - notification
- (void)refreshTickt:(NSNotification *)noti
{
    [self getUnUsableTicket];
    [self getUsableTicket];
}
- (void)refreshTickt1:(NSNotification *)noti
{
    [self getUnUsableTicket];
    [self getUsableTicket];
}

-(void)downRefreshTick
{
    [self getUnUsableTicket];
    [self getUsableTicket];
    [self.tableView reloadData];
    [self.tableView.header endRefreshing];
}

- (void)clearData
{
//    [FFConfig currentConfig].isLogin = @NO;
//    [FFConfig currentConfig].token = @"";
    [self.usableArray removeAllObjects];
    [self.unUsableArray removeAllObjects];
    [self viewWillAppear:YES];
}
@end
