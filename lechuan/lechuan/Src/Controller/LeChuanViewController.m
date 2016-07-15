//
//  LeChuanViewController.m
//  lechuan
//
//  Created by Kami Mahou on 15/12/8.
//  Copyright © 2015年 Kami Mahou. All rights reserved.
//

#import "LeChuanViewController.h"
#import "CityButton.h"
#import "LocationButton.h"
#import "Banner.h"
#import "ProductTypeButton.h"
#import "ProductInfoViewController.h"
#import "MapViewController.h"
#import "CityViewController.h"
#import "FloatingButton.h"
#import "FloatingWindowJumpViewController.h"
#import "MJRefresh.h"
#import "NoteViewController.h"
BOOL checkButton = NO;
NSString *str;
int page = 1;

@interface LeChuanViewController () <BannerDelegate>

//日用百货店三个按钮
@property(nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) CityButton *cityButton;
@property (nonatomic, strong) LocationButton *locationButton;
//!广告
@property (nonatomic, strong) Banner *bannerView;
//!广告的类型1，2，3
@property (nonatomic, assign) NSInteger type;
//!产品类型按钮view
@property (nonatomic, strong) UIView *productTypeView;
//!产品列表
@property (nonatomic, strong) NSMutableArray *productList;
//!城市列表
@property (nonatomic, strong) NSArray *cityList;



@property (nonatomic,strong) NSMutableArray *addressArray;
@property (nonatomic,strong) NSMutableArray *vendorArray;
@property (nonatomic,strong) NSMutableArray *nameArray;

@end

@implementation LeChuanViewController

#pragma mark Init && Add
- (instancetype)init
{
    if (self = [super init]) {
        [self setTopViewWithTitle:@"乐传"];
        self.backBtn.hidden = YES;
        self.type = 1;
    }
    return self;
}

- (CityButton *)cityButton
{
    if (!_cityButton) {
        _cityButton = [CityButton buttonWithType:UIButtonTypeCustom];
        
        _cityButton.frame = CGRectMake(15, 64-44, 78, 44);
        [_cityButton setImage:[UIImage imageNamed:@"cityChoose"] forState:UIControlStateNormal];
//        [_cityButton setTitle:@"呼和浩特" forState:UIControlStateNormal];
        [_cityButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cityButton.titleLabel.font = Font(12);
        [_cityButton addTarget:self action:@selector(changeCity) forControlEvents:UIControlEventTouchUpInside];
        
        [self.topTitleView addSubview:_cityButton];
    }
    return _cityButton;
}

- (LocationButton *)locationButton
{
    if (!_locationButton) {
        _locationButton = [LocationButton buttonWithType:UIButtonTypeCustom];
        
        _locationButton.frame = CGRectMake(SCREEN_WIDTH-48-15, 64-44, 48, 44);
        [_locationButton setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
        [_locationButton setTitle:@"定位" forState:UIControlStateNormal];
        [_locationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _locationButton.titleLabel.font = Font(12);
        _locationButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [_locationButton addTarget:self action:@selector(jumoToMapVC) forControlEvents:UIControlEventTouchUpInside];
        
        [self.topTitleView addSubview:_locationButton];
    }
    return _locationButton;
}

- (Banner *)bannerView
{
    if (!_bannerView) {
        _bannerView = [[Banner alloc] init];
        
        _bannerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 150);
        _bannerView.delegate = self;
    }
    return _bannerView;
}

- (UIView *)productTypeView
{
    if (!_productTypeView) {
        _productTypeView = [[UIView alloc] init];
        _productTypeView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 93*autoSizeScaleX+20);
        _productTypeView.backgroundColor = UIColorFromRGB(0xf9f9f9);
        
        NSArray *textArray = @[@"日用百货", @"休闲美食", @"电子通信"];
        NSArray *selectImage = @[@"productSelect_1",
                                 @"productSelect_2",
                                 @"productSelect_3"];

        for (int i = 0; i < 3; i++)
        {
            ProductTypeButton *button = [ProductTypeButton buttonWithType:UIButtonTypeCustom];
            
            button.tag = i;
            button.frame = CGRectMake(SCREEN_WIDTH/3*i, 0, SCREEN_WIDTH/3, _productTypeView.height-10);
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"productType_%d", i+1]]
                    forState:UIControlStateNormal];
            [button setTitle:textArray[i] forState:UIControlStateNormal];
            [button setTitleColor:UIColorFromRGB(0x919191) forState:UIControlStateNormal];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            button.titleLabel.font = Font(12);
            [button setBackgroundImage:[UIImage imageNamed:@"profuctType_normal"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:selectImage[i]] forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(changeProductType:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0)
            {
                button.selected = YES;
                [button setBackgroundImage:[UIImage imageNamed:selectImage[i]] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
            }
            
            [_productTypeView addSubview:button];
            [self.buttonArray addObject:button];
        }
    }
    return _productTypeView;
}

- (NSMutableArray *)productList
{
    if (!_productList) {
        _productList = [[NSMutableArray alloc] init];
    }
    return _productList;
}

#pragma mark System Action
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    self.cityButton.alpha = 1.0f;
    self.locationButton.alpha = 1.0f;
    
    self.tableView.frame = CGRectMake(0, 64+1, SCREEN_WIDTH, SCREEN_HEIGHT-64-1);
    [self.tableView setMjHeaderController:self Selector:@selector(getBannerList)];
    
    
   self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^
    {
       page = page + 1;
        [self getBannerList];
        if (self.productList == nil) {
            page = 1;
        }
    }];

    [self getfloatingWindow];
    [self getCityList];
    [self getBannerList];
//    [self firstview];
//    [self successView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBannerList) name:@"refreshData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCityData:) name:@"refreshCityData" object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeAnnularDeterminate;
//    hud.labelText = @"Loading";
//    [hud doSomethingInBackgroundWithProgressCallback:^(float progress) {
//        hud.progress = progress;
//    } completionCallback:^{
//        [hud hide:YES];
//    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.cityButton setTitle:[FFConfig currentConfig].cityName forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Other Action
- (void)changeProductType:(UIButton *)button
{
    if (self.type == button.tag+1)
    {
        return;
    }
    NSArray *selectImage = @[@"productSelect_1",
                             @"productSelect_2",
                             @"productSelect_3"];

    for (UIButton *bt in self.productTypeView.subviews)
    {
        if (bt == button)
        {
            [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            [bt setBackgroundImage:[UIImage imageNamed:selectImage[bt.tag]] forState:UIControlStateNormal];
            [bt setBackgroundImage:[UIImage imageNamed:@"profuctType_normal"] forState:UIControlStateHighlighted];
        }
        else
        {
            bt.selected = NO;
            [bt setBackgroundImage:[UIImage imageNamed:@"profuctType_normal"] forState:UIControlStateNormal];
            [bt setBackgroundImage:[UIImage imageNamed:selectImage[bt.tag]] forState:UIControlStateHighlighted];
        }
        button.selected = YES;
        if (button.tag == 2) {
            checkButton = YES;
        }
        else
        {
            checkButton = NO;
        }
    }
    self.type = button.tag+1;
    [self.productList removeAllObjects];
    page = 1;
    [self getProductList];
}

- (void)jumoToMapVC
{
    MapViewController *mapVC = [[MapViewController alloc] init];

    mapVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mapVC animated:YES];
}

- (void)changeCity
{
    CityViewController *cityVC = [[CityViewController alloc] init];
    
    cityVC.hidesBottomBarWhenPushed = YES;
    cityVC.cityArray = self.cityList;
    [self.navigationController pushViewController:cityVC animated:YES];
}

//!点击浮窗
- (void)floatWindowClick:(FloatingButton *)button
{
    [button removeFromSuperview];
    if (![TextFieldCheckAlert isStringNull:button.url])
    {
        FloatingWindowJumpViewController *floatingWindowJumpVC = [[FloatingWindowJumpViewController alloc] init];
        
        floatingWindowJumpVC.hidesBottomBarWhenPushed = YES;
        floatingWindowJumpVC.jumpURL = button.url;
        [self.navigationController pushViewController:floatingWindowJumpVC animated:YES];
    }
}

//!隐藏浮窗
- (void)hideFloatWindow:(FloatingButton *)button
{
    [button removeFromSuperview];
}

#pragma mark TableView DataSource && Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return 1;
    }
    else
    {
        return self.productList.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return self.bannerView.height;
    }
    else if (indexPath.section == 1)
    {
        return self.productTypeView.height;
    }
    else
    {
        return 124;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        static NSString *cellIdentifier = @"bannerView";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:self.bannerView];
        
        return cell;
    }
    else if (indexPath.section == 1)
    {
        static NSString *cellIdentifier = @"productType";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:self.productTypeView];
        
        return cell;
    }
    else
    {
        static NSString *cellIdentifier = @"product";
        DefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[DefaultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.backgroundColor = UIColorFromRGB(0xf9f9f9);
        cell.ViewBack.backgroundColor = UIColorFromRGB(0xf9f9f9);
        NSDictionary *dict;
        if ([Utilities isValidArray:self.productList])
        {
           dict =self.productList[indexPath.row];

        }
        
        
        NSString *path = @"";
        
        
        for (NSDictionary *imageDic in dict[@"productImages"])
        {
            if ([imageDic[@"type"] integerValue] == 0)
            {
                path = imageDic[@"path"];
            }
        }
        cell.firstImageView.frame = CGRectMake(12, (124-106)/2, 111, 106);
        NSString *imagePath = [baseServerAddress stringByAppendingString:path];
        NSURL *url = [NSURL URLWithString:[imagePath stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [cell.firstImageView sd_setImageWithURL:url
                               placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        
        //标题
        [cell.firstLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell).with.offset(15);
            make.left.equalTo(cell.firstImageView.mas_right).with.offset(15);
        }];
        
        NSString *name = [NSString stringWithFormat:@"%@-%@",dict[@"brand"],dict[@"name"]];
        cell.firstLabel.numberOfLines = 1;
        cell.firstLabel.font = Font(18);
        cell.firstLabel.text = name;
        cell.firstLabel.textColor = UIColorFromRGB(0x222222);
        
        //提供商
        [cell.secondLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.firstLabel.mas_bottom).with.offset(5);
            make.left.equalTo(cell.firstLabel);
        }];
        cell.secondLabel.numberOfLines = 1;
        cell.secondLabel.font = Font(12);
        cell.secondLabel.text = dict[@"vendor"];
        cell.secondLabel.textColor = UIColorFromRGB(0xb2b2b2);
        
        //现价 原价 剩余
        [cell.thirdLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.secondLabel.mas_bottom).with.offset(10);
            make.left.equalTo(cell.firstLabel);
            make.right.equalTo(cell).with.offset(-15);
        }];
        NSString *text = [NSString stringWithFormat:@"￥0 ￥%@    剩余%@份", dict[@"marketPrice"], dict[@"surplusNumber"]];
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
        [attributeString addAttributes:@{NSFontAttributeName : Font(12)} range:NSMakeRange(0, 1)];
        [attributeString addAttributes:@{NSFontAttributeName : Font(18)} range:NSMakeRange(1, 1)];
        [attributeString addAttributes:@{NSFontAttributeName : Font(12)} range:NSMakeRange(2, text.length-2)];

        [cell.thirdImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 80));
            make.center.equalTo(cell.firstImageView);
        }];
        cell.thirdImageView.image = [UIImage imageNamed:@"alreadyEndicon"];

        //活动已结束 促销价颜色置灰
        if ([dict[@"activeStatus"] integerValue] == -1)
        {
            cell.thirdImageView.alpha = 1;
            [attributeString addAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xb2b2b2)}
                                     range:NSMakeRange(0, 2)];
        }
        else
        {
            cell.thirdImageView.alpha = 0;
            [attributeString addAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xda1202)}
                                     range:NSMakeRange(0, 2)];
        }

        [attributeString addAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xb2b2b2)}
                                 range:NSMakeRange(2, text.length-2)];
        
        NSString *surplusNumber = [NSString stringWithFormat:@"%@", dict[@"surplusNumber"]];
        NSRange range = NSMakeRange(text.length-1-surplusNumber.length, surplusNumber.length);
        [attributeString addAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xda1202)}
                                 range:range];

        cell.thirdLabel.attributedText = attributeString;
        cell.thirdLabel.numberOfLines = 1;
        
        //原价上的删除线
        CGFloat width = [GetStringWidthAndHeight getStringWidth:[NSString stringWithFormat:@"￥%@", dict[@"marketPrice"]]
                                                         height:30
                                                           font:Font(12)].width;
        
        [cell.secondLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(width, 1));
            make.left.equalTo(cell.thirdLabel).with.offset(27);
            make.bottom.equalTo(cell.thirdLabel).with.offset(-8 );
        }];
        cell.secondLineView.backgroundColor = UIColorFromRGB(0xb2b2b2);
        
        //地址
        [cell.secondImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(cell).with.offset(-15);
            make.left.equalTo(cell.firstLabel);
            make.size.mas_equalTo(CGSizeMake(10.4, 13));
        }];
        cell.secondImageView.image = [UIImage imageNamed:@"locationIcon"];
        
        [cell.fifthLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.secondImageView);
            make.left.equalTo(cell.secondImageView.mas_right).with.offset(5);
        }];
        cell.fifthLabel.numberOfLines = 1;
        cell.fifthLabel.font = Font(12);
        
        cell.fifthLabel.text = @"";
        NSString *simpleAddress = dict[@"simpleAddress"];
        if ([simpleAddress isKindOfClass:[NSNull class]]) {
            cell.fifthLabel.text = @"";
        }else if([simpleAddress isKindOfClass:[NSString class]])
        {
            if (simpleAddress.length > 3) {
                cell.fifthLabel.text = [simpleAddress substringFromIndex:3];
            }
        }
        
        cell.fifthLabel.textColor = UIColorFromRGB(0xb2b2b2);
        
        //分割线
        cell.firstLineView.frame = CGRectMake(0, 123.5, SCREEN_WIDTH, 0.5);
        cell.firstLineView.backgroundColor = UIColorFromRGB(0xeeeeee);
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2)
    {
        ProductInfoViewController *productInfoVC = [[ProductInfoViewController alloc] init];
        
        productInfoVC.hidesBottomBarWhenPushed = YES;
        productInfoVC.check = checkButton;
        productInfoVC.infoDic = self.productList[indexPath.row];
        [self.navigationController pushViewController:productInfoVC animated:YES];
    }
}

#pragma mark Service
//!获取城市列表
- (void)getCityList
{
    NSString *param = Interface_cityList;
    [[BHServiceDataCentre sharedInstance] blHealthRequestByDict:param
                                                     parameters:nil
                                                        showHUD:NO
                                                     controller:self
                                                           type:CC_Interface_cityList
                                             serviceAnswerBlock:^(BOOL isSuccess, id responseMsg,
                                                                  NSInteger type, NSString *errorMsg)
     {
         if (isSuccess && type == CC_Interface_cityList)
         {
             self.cityList = responseMsg[@"content"];
         }
         else if (!isSuccess && type == CC_Interface_cityList)
         {
             
         }
     }];
}

//!获取广告列表
- (void)getBannerList
{
    
    
    NSString *param = Interface_productList([FFConfig currentConfig].cityId);
    [[BHServiceDataCentre sharedInstance] blHealthRequestByDict:param
                                                     parameters:nil
                                                        showHUD:YES
                                                     controller:self
                                                           type:CC_Interface_productList
                                             serviceAnswerBlock:^(BOOL isSuccess, id responseMsg,
                                                                  NSInteger type, NSString *errorMsg)
     {
         if (isSuccess && type == CC_Interface_productList)
         {
             self.bannerView.list = responseMsg[@"content"];
//             [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
//                           withRowAnimation:UITableViewRowAnimationNone];
             [self.tableView reloadData];
             [self getProductList];
         }
         else if (!isSuccess && type == CC_Interface_productList)
         {
             [self.tableView.header endRefreshing];
         }
     }];
}

//!获取产品列表
- (void)getProductList
{
    NSString *i = [NSString stringWithFormat:@"%d",page];
    
    NSString *param = Interface_bannerList(i,(int)self.type ,[FFConfig currentConfig].cityId);
    [[BHServiceDataCentre sharedInstance] blHealthRequestByDict:param
                                                     parameters:nil
                                                        showHUD:YES
                                                     controller:self
                                                           type:CC_Interface_bannerList
                                             serviceAnswerBlock:^(BOOL isSuccess, id responseMsg,
                                                                  NSInteger type, NSString *errorMsg)
     {
         if (isSuccess && type == CC_Interface_bannerList)
         {
             [self.addressArray removeAllObjects];
             [self.vendorArray removeAllObjects];
             [self.nameArray removeAllObjects];
             [self.productList addObjectsFromArray:responseMsg[@"content"]];
             for (NSDictionary *dict in self.productList)
             {
                 [self.addressArray addObject:dict[@"fetchAddress"]];
             }
             for (NSDictionary *dict in self.productList)
             {
                 [self.vendorArray addObject:dict[@"vendor"]];
             }
             for (NSDictionary *dict in self.productList)
             {
                 [self.nameArray addObject:dict[@"name"]];
             }
//             if (![[responseMsg objectForKey:@"content"] count]) {
//                 [self.tableView.footer endRefreshing];
//             }
             
             NSLog(@"%@",responseMsg);
//             [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2]
//                           withRowAnimation:UITableViewRowAnimationNone];
             [self.tableView reloadData];

             [self.tableView.header endRefreshing];
             [self.tableView.footer endRefreshing];
         }
         else if (!isSuccess && type == CC_Interface_bannerList)
         {
             [self.tableView.header endRefreshing];
             [self.tableView.footer endRefreshing];
         }
     }];
}

//!浮窗
- (void)getfloatingWindow
{
    NSString *param = Intrrface_floatWindow;
    [[BHServiceDataCentre sharedInstance] blHealthRequestByDict:param
                                                     parameters:nil
                                                        showHUD:YES
                                                     controller:self
                                                           type:CC_Intrrface_floatWindow
                                             serviceAnswerBlock:^(BOOL isSuccess, id responseMsg,
                                                                  NSInteger type, NSString *errorMsg)
     {
         if (isSuccess && type == CC_Intrrface_floatWindow)
         {
             NSString *str = responseMsg[@"content"][0][@"str"];
             if (![TextFieldCheckAlert isStringNull:str])
             {
                 NSString *imagePath = [baseServerAddress stringByAppendingString:str];
                 NSString *url = responseMsg[@"content"][1][@"str"];
                 
                 FloatingButton *button = [FloatingButton buttonWithType:UIButtonTypeCustom];
                 
                 button.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                 button.url = url;
                 
                 NSURL *imageUrl = [NSURL URLWithString:[imagePath stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

                 [button sd_setBackgroundImageWithURL:imageUrl
                                             forState:UIControlStateHighlighted
                                     placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
                 [button sd_setBackgroundImageWithURL:imageUrl
                                             forState:UIControlStateNormal
                                     placeholderImage:[UIImage imageNamed:@"placeholderImage"]
                                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                [[UIApplication sharedApplication].keyWindow addSubview:button];
                                                
                                                //浮窗三秒后消失
                                                [self performSelector:@selector(hideFloatWindow:) withObject:button afterDelay:6];
                                            }];

                 [button addTarget:self action:@selector(floatWindowClick:) forControlEvents:UIControlEventTouchUpInside];
                 
             }
         }
         else if (!isSuccess && type == CC_Intrrface_floatWindow)
         {
             
         }
     }];
}

#pragma mark delegate
- (void)BannerClick:(NSDictionary *)dict
{
    if ([[dict[@"type"] description] isEqualToString:@"<null>"])
    {
        ProductInfoViewController *productInfoVC = [[ProductInfoViewController alloc] init];
        
        productInfoVC.hidesBottomBarWhenPushed = YES;
        productInfoVC.bannerId = dict[@"id"];
        productInfoVC.banner = @"1";
        productInfoVC.infoDic = dict[@"product"];
        [self.navigationController pushViewController:productInfoVC animated:YES];
    }
    
    else if ([dict[@"type"] integerValue] == 1) {
        NoteViewController *noteVC = [[NoteViewController alloc] init];
        
        noteVC.hidesBottomBarWhenPushed = YES;
        noteVC.infoDic = dict;
        [self.navigationController pushViewController:noteVC animated:YES];
    }

}


#pragma  mark - noti
- (void)reloadCityData:(NSNotification*)noti
{
    [self.productList removeAllObjects];
    page = 1;
}
@end
