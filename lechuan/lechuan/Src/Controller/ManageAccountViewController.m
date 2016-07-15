//
//  ManageAccountViewController.m
//  lechuan
//
//  Created by Kami Mahou on 15/12/13.
//  Copyright © 2015年 Kami Mahou. All rights reserved.
//

#import "ManageAccountViewController.h"
#import "ChangePasswordViewController.h"
#import "TiePhoneViewController.h"
#import "TieMailboxViewController.h"

@interface ManageAccountViewController ()

@property (nonatomic, strong) NSMutableArray *cellDataArray;
@property (nonatomic, strong) NSArray *infoArray;
@property (nonatomic, copy) NSString *lastLoginTime;

@end

@implementation ManageAccountViewController

#pragma mark Init && Add
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"getUserName" object:nil];
}

- (instancetype)init
{
    if (self = [super init]) {
        [self setTopViewWithTitle:@"账号管理"];
        _lastLoginTime = @"上次登录时间：--";
    }
    return self;
}

- (NSMutableArray *)cellDataArray
{
    if (!_cellDataArray) {
        _cellDataArray = [[NSMutableArray alloc] init];
        [_cellDataArray addObjectsFromArray:@[@{@"修改密码":@"修改"},
                                              @{@"手机":@"绑定"},
                                              @{@"邮箱":@"绑定"}]];
    }
    return _cellDataArray;
}

- (NSArray *)infoArray
{
    if (!_infoArray) {
        _infoArray = @[@"", @"", @""];
    }
    return _infoArray;
}

#pragma mark System Action
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    self.tableView.backgroundColor = UIColorFromRGB(0xeeeeee);
    
    [self getUserInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfo) name:@"getUserName" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableView DataSource && Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 41;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    //背景
    UIView *view = [[UIView alloc] init];
    
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 41);
    view.backgroundColor = UIColorFromRGB(0xeeeeee);
    
    //时间label
    UILabel *timeLabel = [[UILabel alloc] init];
    
    timeLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, 41);
    timeLabel.font = Font(13);
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.text = self.lastLoginTime;
    timeLabel.textColor = UIColorFromRGB(0xababab);
    
    [view addSubview:timeLabel];
    
    //线
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(23*autoSizeScaleX, 40.5, SCREEN_WIDTH-46*autoSizeScaleX, 0.5);
    lineView.backgroundColor = UIColorFromRGB(0xc8c8c8);
    
    [view addSubview:lineView];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.cellDataArray[indexPath.row];
    
    static NSString *cellIdentifier = @"cell";
    DefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[DefaultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.backgroundColor = UIColorFromRGB(0xeeeeee);
    
    cell.firstLabel.frame = CGRectMake(23*autoSizeScaleX, 0, 200, 62);
    cell.firstLabel.text = dict.allKeys[0];
    cell.firstLabel.font = Font(15);
    cell.firstLabel.textColor = UIColorFromRGB(0xababab);
    
    cell.secondLabel.frame = CGRectMake(SCREEN_WIDTH-46.5*autoSizeScaleX-6.5-100, 0, 100, 62);
    cell.secondLabel.text = dict.allValues[0];
    cell.secondLabel.font = Font(12);
    cell.secondLabel.textColor = UIColorFromRGB(0xababab);
    cell.secondLabel.textAlignment = NSTextAlignmentRight;
    
    cell.thirdLabel.frame = CGRectMake(145*autoSizeScaleX, 0, 135*autoSizeScaleX, 62);
    cell.thirdLabel.text = self.infoArray[indexPath.row];
    cell.thirdLabel.font = Font(11);
    cell.thirdLabel.textColor = UIColorFromRGB(0xababab);
    cell.thirdLabel.textAlignment = NSTextAlignmentRight;
    
    cell.firstImageView.frame = CGRectMake(SCREEN_WIDTH-30*autoSizeScaleX-6.5, 25, 6.5, 12);
    cell.firstImageView.image = [UIImage imageNamed:@"rightCell"];
    
    cell.firstLineView.frame = CGRectMake(23*autoSizeScaleX, 61.5, SCREEN_WIDTH-46*autoSizeScaleX, 0.5);
    cell.firstLineView.backgroundColor = UIColorFromRGB(0xc8c8c8);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger index = indexPath.row;
    switch (index) {
        case 0:
        {
            ChangePasswordViewController *chagePasswordVC = [[ChangePasswordViewController alloc] init];
            chagePasswordVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chagePasswordVC animated:YES];
        }
            break;
        case 1:
        {
            TiePhoneViewController *tiePhoneVC = [[TiePhoneViewController alloc] init];
            
            tiePhoneVC.phoneNum = self.infoArray[1];
            tiePhoneVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:tiePhoneVC animated:YES];
        }
            break;
        case 2:
        {
            TieMailboxViewController *tieMailboxVC = [[TieMailboxViewController alloc] init];
            
            tieMailboxVC.mailAdress = self.infoArray[2];
            tieMailboxVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:tieMailboxVC animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark service
- (void)getUserInfo
{
    NSString *param = Intrrface_achieveInfo;
    
    [[BHServiceDataCentre sharedInstance] blHealthRequestByDict:param
                                                     parameters:nil
                                                        showHUD:YES
                                                     controller:self
                                                           type:CC_Intrrface_achieveInfo
                                             serviceAnswerBlock:^(BOOL isSuccess, id responseMsg,
                                                                  NSInteger type, NSString *erroeMsg)
     {
         if (isSuccess && type == CC_Intrrface_achieveInfo)
         {
             NSString *telephone = @"";
             NSString *email = @"";
             BOOL hasTelephon = ![responseMsg[@"telephone"] isKindOfClass:[NSNull class]];
             BOOL hasEmail = ![responseMsg[@"email"] isKindOfClass:[NSNull class]];
             
             if (hasTelephon)
             {
                 telephone = ![TextFieldCheckAlert isStringNull:responseMsg[@"telephone"]] ? responseMsg[@"telephone"] : @"";
//                 telephone = [telephone stringByReplacingCharactersInRange:NSMakeRange(2, 7) withString:@"*******"];
                 
                 [self.cellDataArray replaceObjectAtIndex:1 withObject:@{@"手机":@"修改"}];
             }
             if (hasEmail)
             {
                 email = ![TextFieldCheckAlert isStringNull:responseMsg[@"email"]] ? responseMsg[@"email"] : @"";
//                 email = [email stringByReplacingCharactersInRange:NSMakeRange(1, 3) withString:@"***"];

                 [self.cellDataArray replaceObjectAtIndex:2 withObject:@{@"邮箱":@"修改"}];
             }
             
             self.infoArray = @[@"", telephone, email];
             
             long long time = [responseMsg[@"lastLoginTime"] integerValue];
             NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
             NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
             dateFormatter.dateFormat = @"yyyy年MM月dd日 hh:mm";
             NSString *timeString = [dateFormatter stringFromDate:date];
             self.lastLoginTime = [NSString stringWithFormat:@"上次登录时间：%@", timeString];

             [self.tableView reloadData];
         }
     }];
}

@end
