//
//  MyTestViewController.m
//  lechuan
//
//  Created by bug on 15/12/28.
//  Copyright © 2015年 Kami Mahou. All rights reserved.
//

#import "MyTestViewController.h"

@interface MyTestViewController ()

//以时间为key    value为每一个时间对应的展示数据
@property (nonatomic,strong) NSMutableArray *messages;
@property (nonatomic,strong) UITextView *textView;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,strong) UIView *sectionView;
//设置标志位,用于区分是否新的数据属于原来的数据
@property (nonatomic,assign) BOOL flag;

@end

@implementation MyTestViewController

#pragma mark Init && Add
- (instancetype)init
{
    if (self = [super init]) {
        [self setTopViewWithTitle:@"我的消息"];
    }
    return self;
}



- (NSMutableArray *)messages
{
    if (!_messages)
    {
        _messages = [NSMutableArray array];
    }
    return  _messages;
}

- (UITextView *)textView
{
    if (!_textView)
    {
        _textView = [[UITextView alloc] init];
    }
    return _textView;
}

#pragma mark - systemMethod
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.groupTableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    
    // Do any additional setup after loading the view.
    [self getMessage];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    
    [super viewWillAppear:animated];
}


#pragma mark service
- (void)getMessage
{
    NSString *imei = [[NSUserDefaults standardUserDefaults] objectForKey:kUDUUID];
    NSString *cityName = [FFConfig currentConfig].cityName;
    
    NSString *param = Interface_getMyTest(imei, cityName);
    
    [[BHServiceDataCentre sharedInstance] blHealthRequestByDict:param
                                                     parameters:nil
                                                        showHUD:YES
                                                     controller:self
                                                           type:CC_Interface_getMyTest
                                             serviceAnswerBlock:^(BOOL isSuccsee, id responseMsg,
                                                                  NSInteger type, NSString *errorMsg)
     {
         if (isSuccsee && type == CC_Interface_getMyTest)
         {
             
             self.count = 1;
             NSArray *messageArray = responseMsg[@"content"];
             //遍历数组
             for (NSDictionary *dict in messageArray)
             {
                 //1.获取创建时间
                 NSString *createTime = dict[@"createTime"];
                 //2.获取内容
                 NSString *message = dict[@"message"];
                 //第一次不需要判断,只需要添加数据
                 if (self.count == 1)
                 {
                     NSMutableArray *newArray = [NSMutableArray array];
                     [newArray addObject:message];
                     [self.messages addObject:[NSDictionary dictionaryWithObject:newArray forKey:createTime]];
                     
                     
                 }
                 
                 //遍历老司机,用来排除万难
                 for (NSDictionary *dict in self.messages)
                 {
                     self.flag = NO;
                     if ([dict[@"createTime"] isEqualToString:createTime] && self.count>1)
                     {
                         //取出数组
                         self.flag = YES;
                         NSMutableArray *messageArr =  dict[@"myCreateTime"];
                         [messageArr addObject:message];
                     }
                 }
                 
                 if (!self.flag && self.count>1)
                 {
                     NSMutableArray *newArray = [NSMutableArray array];
                     [newArray addObject:message];
                     [self.messages addObject:[NSDictionary dictionaryWithObject:newArray forKey:createTime]];
                 }
                 self.count = self.count + 1;
             }
             
             // NSLog(@"%@",self.messages);
             [self.groupTableView reloadData];
         }
         else if (!isSuccsee && type == CC_Interface_getMyTest)
         {
             
         }
     }];
    
}


#pragma mark tableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    _sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
//    _sectionView.backgroundColor = [UIColor redColor];
    UIView *firstLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH-200)/2, 1)];
    firstLineView.backgroundColor = RGBACOLOR(200, 200, 200, 1.f);
    firstLineView.center = CGPointMake(firstLineView.center.x, _sectionView.center.y);
    [_sectionView addSubview:firstLineView];
    UIView *secondLineView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-(SCREEN_WIDTH-200)/2, 0, (SCREEN_WIDTH-200)/2, 1)];
    secondLineView.center = CGPointMake(secondLineView.center.x, _sectionView.center.y);
    secondLineView.backgroundColor = RGBACOLOR(200, 200, 200, 1.f);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 0, 200, _sectionView.frame.size.height)];
    label.font = Font(11);
//    label.backgroundColor = [UIColor redColor];
    label.center = CGPointMake(label.center.x, _sectionView.center.y);
    [_sectionView addSubview:label];
    [_sectionView addSubview:secondLineView];
//    long long time = [self.messages[section][@"createTime"] integerValue];
    long long time = [[self.messages[section] allKeys][0] integerValue];
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy年MM月dd日 hh:mm:ss";
    NSString *timeString = [dateFormatter stringFromDate:date];
    //self.lastLoginTime = [NSString stringWithFormat:@"上次登录时间：%@", timeString];
    label.text = timeString;
    label.textAlignment = NSTextAlignmentCenter;
    return  _sectionView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    //    return self.messages.count;
    return self.messages.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dict = self.messages[section];
    NSMutableArray *array = [dict allValues][0];
    return array.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    DefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        cell = [[DefaultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    if (![cell.contentView.subviews containsObject:self.textView])
//    {
//        [cell.contentView addSubview:self.textView];
//    }
    //
//    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(cell.contentView.mas_top).with.offset(5*autoSizeScaleY);
//        make.bottom.equalTo(cell.contentView.mas_bottom).with.offset(-5*autoSizeScaleY);
//        make.left.equalTo(cell.contentView.mas_left).with.offset(5*autoSizeScaleX);
//        make.right.equalTo(cell.contentView.mas_right).with.offset(-5*autoSizeScaleX);
//    }];
    [cell.firstTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(150));
        make.left.equalTo(cell).with.offset(5);
        make.right.equalTo(cell).with.offset(-5);
//        make.top.equalTo(cell).with.offset(5);
//        make.bottom.equalTo(cell).with.offset(-5);
    }];
    cell.firstTextView.layer.cornerRadius = 5;
    cell.firstTextView.layer.borderWidth = 0.5f;
    cell.firstTextView.layer.borderColor = RGBACOLOR(150, 150, 150, 1.f).CGColor;
    cell.firstTextView.textAlignment = NSTextAlignmentNatural;
    NSDictionary *dict = self.messages[indexPath.section];
    cell.firstTextView.text = [dict allValues][0][indexPath.row];
    //    self.textView.backgroundColor = [UIColor redColor];
    //    cell.firstLabel.frame = CGRectMake(10*autoSizeScaleX, 5*autoSizeScaleY, SCREEN_WIDTH-20*autoSizeScaleX,150*autoSizeScaleY );
    //    cell.firstLabel.backgroundColor = [UIColor redColor];
    //    cell.firstLabel.text = @"lihaiahiahaihaihaihah";
    return cell;
}

@end
