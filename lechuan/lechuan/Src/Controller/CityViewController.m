//
//  CityViewController.m
//  lechuan
//
//  Created by Kami Mahou on 15/12/14.
//  Copyright © 2015年 Kami Mahou. All rights reserved.
//

#import "CityViewController.h"
#import "CoreLocation/CoreLocation.h"

@interface CityViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSDictionary *test;
@property (nonatomic, strong) NSArray *sectionTitles;

@end

@implementation CityViewController

#pragma mark Init && Add
-(instancetype)init
{
    if (self = [super init]) {
        [self setTopViewWithTitle:@"选择城市"];
    }
    return self;
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 10.0f;
    }
    return _locationManager;
}

#pragma mark System Action
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.locationManager startUpdatingLocation];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-64));
        make.top.equalTo(self.view).with.offset(64);
        make.left.equalTo(self.view).with.offset(0);
    }];
    
    self.sectionTitles = [[NSArray alloc] initWithObjects:@"A", @"B", @"C", @"E", @"H", @"T", @"W", @"X", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Other Action
//定位代理经纬度回调
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [self.locationManager stopUpdatingLocation];
    
    NSLog(@"%@",[NSString stringWithFormat:@"经度:%3.5f\n纬度:%3.5f",newLocation.coordinate.latitude,newLocation.coordinate.longitude]);
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            
            self.test = [placemark addressDictionary];
            [self.tableView reloadData];
            //  Country(国家)  City(城市)  State(区)
            NSLog(@"%@", self.test[@"City"]);
            //            self.cityArray;
        }
    }];
}

#pragma mark TableView DataSource && Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3+self.cityArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

// 索引目录
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionTitles;
}

//// 点击目录
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
//    // 获取所点目录对应的indexPath值
    NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:index+5 inSection:0];
//
//    // 让table滚动到对应的indexPath位置
    [tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//
    [self showHUDText:[NSString stringWithFormat:@"%@",self.sectionTitles[index]] delay:2];
    return index;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    DefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[DefaultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0)
    {
        cell.backgroundColor = UIColorFromRGB(0xededed);
        cell.firstLabel.text = @"当前定位城市";
        cell.firstLabel.frame = CGRectMake(0, 0, cell.width, cell.height);
        cell.firstLabel.textColor = [UIColor blackColor];
    }
    else if (indexPath.row == 1)
    {
        cell.backgroundColor = [UIColor whiteColor];
        cell.firstLabel.text = [NSString stringWithFormat:@"%@",self.test[@"City"]];
        if ([cell.firstLabel.text isEqualToString:@"(null)"])
        {
            cell.firstLabel.text = @"正在获取···";
        }
        cell.firstLabel.frame = CGRectMake(0, 0, cell.width, cell.height);
        cell.firstLabel.textColor = [UIColor blackColor];
    }
    else if (indexPath.row == 2)
    {
        cell.backgroundColor = UIColorFromRGB(0xededed);
        cell.firstLabel.text = @"全部城市";
        cell.firstLabel.frame = CGRectMake(0, 0, cell.width, cell.height);
        cell.firstLabel.textColor = [UIColor blackColor];
    }
    else
    {
        cell.backgroundColor = [UIColor whiteColor];
        cell.firstLabel.text = self.cityArray[indexPath.row-3][@"name"];
        cell.firstLabel.frame = CGRectMake(0, 0, cell.width, cell.height);
        
        cell.firstLabel.textColor = [UIColor blackColor];
        cell.secondLabel.hidden = YES;
        cell.cityId = self.cityArray[indexPath.row-3][@"id"];
    } 
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cityId = [(DefaultCell *)[tableView cellForRowAtIndexPath:indexPath] cityId];

    if (indexPath.row == 1) {
        cityId = self.cityArray[5][@"id"];
    }
    NSString *cityName = [[(DefaultCell *)[tableView cellForRowAtIndexPath:indexPath] firstLabel] text];

    NSArray *textArray = @[@"正在获取···", @"全部城市", @"当前定位城市"];
    if ([textArray containsObject:cityName])
    {
        return;
    }
    
    [FFConfig currentConfig].cityName = cityName;
    [FFConfig currentConfig].cityId = cityId;
    [self.navigationController popViewControllerAnimated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshData" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshCityData" object:nil];
}

@end
