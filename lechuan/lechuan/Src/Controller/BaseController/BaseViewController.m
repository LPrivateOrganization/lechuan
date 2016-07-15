//
//  NeedInheritViewController.m
//  BLHealth
//
//  Created by lyywhg on 10-10-11.
//  Copyright 2010 BLHealth. All rights reserved.
//

#import "BaseViewController.h"

//改为0就取消手势返回
#define GestureBackEnabled 1

@interface BaseViewController ()

@end

@implementation BaseViewController

#pragma mark Init & Add
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
        _tableView.scrollEnabled = YES;
        _tableView.userInteractionEnabled = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColorFromRGB(0xf6f6f6);
        _tableView.backgroundView = nil;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}


- (UITableView *)groupTableView
{
    if(!_groupTableView)
    {
        _groupTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_groupTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_groupTableView setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
        _groupTableView.scrollEnabled = YES;
        _groupTableView.userInteractionEnabled = YES;
        _groupTableView.delegate = self;
        _groupTableView.dataSource = self;
        _groupTableView.backgroundColor = UIColorFromRGB(0xf6f6f6);
        _groupTableView.backgroundView = nil;
        [self.view addSubview:_groupTableView];
    }
    return _groupTableView;
}

- (UIImageView *)topTitleView
{
    if (!_topTitleView)
    {
        _topTitleView = [[UIImageView alloc] init];
        _topTitleView.userInteractionEnabled = YES;
        _topTitleView.backgroundColor = UIColorFromRGB(0xf7f7f7);
        _topTitleView.image = [UIImage imageNamed:@"titleBg"];
        
        self.TopHeight = 64;
        
        _topTitleView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.TopHeight);
        
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, self.TopHeight-0.5, SCREEN_WIDTH, 0.5);
        view.backgroundColor = UIColorFromRGB(0xd8d8d8);
        view.tag = -1;
        [_topTitleView addSubview:view];
        [_topTitleView addSubview:self.topTitleLabel];
        [self.view addSubview:_topTitleView];
    }
    return _topTitleView;
}

- (UILabel *)topTitleLabel
{
    if (!_topTitleLabel)
    {
        _topTitleLabel = [[UILabel alloc] init];
        _topTitleLabel.textAlignment = NSTextAlignmentCenter;
        _topTitleLabel.textColor = [UIColor whiteColor];
        _topTitleLabel.backgroundColor = [UIColor clearColor];
        _topTitleLabel.font = Font(18);
        _topTitleLabel.frame = CGRectMake(40, self.TopHeight-44, self.view.frame.size.width-80, 44);
    }
    return _topTitleLabel;
}

- (BackButton *)backBtn
{
    if (!_backBtn)
    {
        _backBtn = [BackButton buttonWithType:UIButtonTypeCustom];
        [_backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [_backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _backBtn.titleLabel.font = Font(12);
        
        _backBtn.frame = CGRectMake(15, self.TopHeight-44+5, 100, 34);
    }
    return _backBtn;
}

- (UIButton *)rightBtn
{
    if (!_rightBtn)
    {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(self.view.frame.size.width-50+10, self.TopHeight-44+5, 34, 34);
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.autoresizesSubviews = NO;
        _scrollView.userInteractionEnabled = YES;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIImageView *)loadingImageView
{
    if (!_loadingImageView) {
        _loadingImageView = [[UIImageView alloc] init];
        _loadingImageView.frame = CGRectMake(0, 0, 31, 8);
        NSArray *gifArray = @[[UIImage imageNamed:@"loading1"],
                              [UIImage imageNamed:@"loading2"],
                              [UIImage imageNamed:@"loading3"],
                              [UIImage imageNamed:@"loading4"]];
        _loadingImageView.animationImages = gifArray; //动画图片数组
        _loadingImageView.animationDuration = 1; //执行一次完整动画所需的时长
        _loadingImageView.animationRepeatCount = 0;  //动画重复次数
    }
    return _loadingImageView;
}

#pragma mark
#pragma mark View Action
- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;

    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController setNavigationBarHidden:YES];

    //改变状态栏颜色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
#if GestureBackEnabled
    BaseViewController *weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
#endif
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    DLog(@"Commmon didReceiveMemoryWarning \n");
    // Release any cached data, images, etc. that aren't in use.
}

#pragma mark
#pragma mark - Other Action
/*
 设置TopView
 默认 没有右边按钮
 背景色统一 DefaultColor
 */
- (void)setTopViewWithTitle:(NSString*)title
{
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.topTitleView.userInteractionEnabled = YES;
    [self.topTitleView addSubview:self.backBtn];
    [self.backBtn setImage:[UIImage imageNamed:@"System_Nav_Back_btn"]
                  forState:UIControlStateNormal];
    self.topTitleLabel.text = title;
}
/*
 设置TopView
 默认 没有右边按钮  没有
 背景色统一 DefaultColor
 */
- (void)setTopViewWithTitle:(NSString*)title withLeftBtn:(NSString *)btnImage
{
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.topTitleView.userInteractionEnabled = YES;
    [self.topTitleView addSubview:self.backBtn];
    [self.backBtn setImage:[UIImage imageNamed:@"System_Nav_Back_btn"]
                  forState:UIControlStateNormal];
    self.topTitleLabel.text = title;
}
/*
 设置TopView
 WithRightImage :右侧按钮图片(默认显示)
 */
- (void)setTopViewWithTitle:(NSString*)title
             WithRightImage:(NSString*)imgName
{
    [self setTopViewWithTitle:title];
    [self.rightBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [self.topTitleView addSubview:self.rightBtn];
}
/*
 设置TopView
 WithRightText :右侧文字
 */
- (void)setTopViewWithTitle:(NSString*)title
              WithRightText:(NSString*)text
{
    [self setTopViewWithTitle:title];
    CGFloat width = 0;
//    CGFloat width = [GetStringWidthAndHeight getStringWidth:text height:34 font:[UIFont systemFontOfSize:17]].width;
    if (width < 34)
    {
        width = 34;
    }
    self.rightBtn.frame = CGRectMake(SCREEN_WIDTH-width-20, 25, width, 34);
    [self.rightBtn setTitle:text forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:UIColorFromRGB(0x4197e7) forState:UIControlStateNormal];

    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:17] ;
    [self.topTitleView addSubview:self.rightBtn];
}
/*
 设置TopView
 WithLeftImage :左侧按钮图片
 */
- (void)setTopViewWithTitle:(NSString*)title
              WithLeftImage:(NSString*)imgName
{
    [self setTopViewWithTitle:title];
    [self.backBtn setImage:[UIImage imageNamed:imgName]
                  forState:UIControlStateNormal];
}

- (void)setTopViewWithTitle:(NSString*)title
              WithLeftImage:(NSString*)leftimgName
             WithRightImage:(NSString*)rightimgName
{
    [self setTopViewWithTitle:title WithRightImage:rightimgName];
    if (leftimgName == nil) {
        [self.backBtn removeFromSuperview];
    }
    [self.backBtn setImage:[UIImage imageNamed:leftimgName]
                            forState:UIControlStateNormal];
}
/*
 设置TopView
 color : TopView背景色
 */
- (void)setTopViewWithTitle:(NSString*)title
                  WithColor:(UIColor*)bgColor
{
    [self setTopViewWithTitle:title];
    _topTitleView.backgroundColor = bgColor;
}
/*
 设置TopView  中间两个label 上下结构的
 默认 有右边按钮
 背景色统一 DefaultColor
 */
- (void)setTopViewWithTitle:(NSString*)title andRightBtn:(NSString *)rightBtnName
{
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.topTitleView.userInteractionEnabled = YES;
    [self.topTitleView addSubview:self.backBtn];
    [self.backBtn setImage:[UIImage imageNamed:@"System_Nav_Back_btn"]
                  forState:UIControlStateNormal];
    self.topTitleLabel.frame = CGRectMake(40, self.TopHeight-44, self.view.frame.size.width-80, 44);
    self.topTitleLabel.text = title;
    [self.rightBtn setImage:[UIImage imageNamed:rightBtnName] forState:UIControlStateNormal];
    [self.topTitleView addSubview:self.rightBtn];
}
/*
 设置TopView
 WithRightImage :右侧按钮图片
 bgColor : TopView背景色
 */
- (void)setTopViewWithTitle:(NSString*)title
             WithRightImage:(NSString*)imgName
                  WithColor:(UIColor*)bgColor
{
    [self setTopViewWithTitle:title WithRightImage:imgName];
    _topTitleView.backgroundColor = bgColor;
}
//左侧按钮
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
//右侧按钮
- (void)rightBtnClick
{
    
}

//#pragma mark
//#pragma mark - TableView Delegate & Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

//- (void)presentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated
//{
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
//    {
//        [super presentViewController:modalViewController animated:animated completion:NULL];
//    }
//    else
//    {
//        [super presentModalViewController:modalViewController animated:animated];
//    }
//}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

#pragma mark TipString
- (void)giveTipString:(NSString *)tipString
{
    if (![TextFieldCheckAlert isStringNull:tipString])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:tipString
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

//- (NSDate *)pullingTableViewRefreshingFinishedDate
//{
//    NSDate *date = [NSDate date];
//    return date;
//}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController.viewControllers.count == 1) {
        return NO;
    }
    else {
        return YES;
    }
}

- (void)showHUDText:(NSString *)text delay:(NSTimeInterval)delay
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.margin = 10.f;
    hud.yOffset = 100.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:delay];
}

@end