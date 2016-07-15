//
//  UnionViewController.m
//  lechuan
//
//  Created by Kami Mahou on 15/12/8.
//  Copyright © 2015年 Kami Mahou. All rights reserved.
//

#import "UnionViewController.h"
#import "SpreadViewController.h"
#import "DelegateViewController.h"
#import "AnnouncementViewController.h"
#import "InviteFriendViewController.h"
#import "ContactCustomerViewController.h"
#import "UseGuideViewController.h"
#import "UserGuideViewController.h"
#import "UserGuideView.h"

@interface UnionViewController ()

//展示的cell
@property (nonatomic, strong) NSArray *showCellArray;

@end

@implementation UnionViewController

#pragma mark Init && Add
- (instancetype)init
{
    if (self = [super init]) {
        [self setTopViewWithTitle:@"合联盟"];
        self.backBtn.hidden = YES;
    }
    return self;
}

- (NSArray *)showCellArray
{
    if (!_showCellArray) {
        _showCellArray = @[@[@{@"我要传播":@"union_0"}, @{@"我要代理":@"union_1"}, @{@"邀请好友":@"union_2"}],
                           @[@{@"乐传公告":@"union_3"},@{@"使用向导":@"union_5"}, @{@"联系客服":@"union_4"}]];
    }
    return _showCellArray;
}

#pragma mark System Action
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49);
    self.tableView.backgroundColor = UIColorFromRGB(0xeeeeee);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    [cell.firstLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell).with.offset(44);
        make.centerY.equalTo(cell);
    }];
    cell.firstLabel.text = dict.allKeys[0];
    cell.firstLabel.font = Font(13);
    
    cell.firstLineView.frame = CGRectMake(0, 39.5, SCREEN_WIDTH, 0.5);
    cell.firstLineView.backgroundColor = UIColorFromRGB(0xe4e4e4);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger index = indexPath.section*10+indexPath.row;
    switch (index) {
        case 0:
        {
            SpreadViewController *spreadVC = [[SpreadViewController alloc] init];
            
            spreadVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:spreadVC animated:YES];
        }
            break;
        case 1:
        {
            DelegateViewController *delegateVC = [[DelegateViewController alloc] init];
            
            delegateVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:delegateVC animated:YES];
        }
            break;
        case 2:
        {
            InviteFriendViewController *inviteFriendVC = [[InviteFriendViewController alloc] init];
            
            inviteFriendVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:inviteFriendVC animated:YES];
        }
            break;
        case 10:
        {
            AnnouncementViewController *announcementVC = [[AnnouncementViewController alloc] init];
            
            announcementVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:announcementVC animated:YES];
        }
            break;
        case 11:
        {
            UseGuideViewController *useGuideVC = [[UseGuideViewController alloc] init];
            
            useGuideVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:useGuideVC animated:YES];
        }
            break;
        case 12:
        {
            ContactCustomerViewController *contactVC = [[ContactCustomerViewController alloc] init];
            
            
            contactVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:contactVC animated:YES];
        }
            break;
        default:
            break;
    }
    
}

@end
