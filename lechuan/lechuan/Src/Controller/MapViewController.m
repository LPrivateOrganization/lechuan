//
//  MapViewController.m
//  lechuan
//
//  Created by Kami Mahou on 15/12/14.
//  Copyright © 2015年 Kami Mahou. All rights reserved.
//

#import "MapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>


@interface MapViewController ()<AMapSearchDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic,strong) AMapSearchAPI *search;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger poiIndex;
@property (nonatomic, strong) NSMutableArray *altitudeArray;

@property (nonatomic, strong) NSMutableArray *addressArray;
@property (nonatomic, strong) NSMutableArray *vendorArray;
@property (nonatomic, strong) NSMutableArray *nameArray;
@property (nonatomic, strong) NSMutableArray *useVendorArray;
@property (nonatomic, strong) NSMutableArray *useNameArray;
@property (nonatomic, strong) NSMutableArray *useAddressArray;

@end

@implementation MapViewController

#pragma mark Init && Add
//- (instancetype)init
//{
//    if (self = [super init]) {
//        [self setTopViewWithTitle:@""];
//    }
//    return self;
//}

- (NSMutableArray *)altitudeArray
{
    if (!_altitudeArray) {
        _altitudeArray = [NSMutableArray array];
    }
    return _altitudeArray;
}

- (NSMutableArray *)addressArray
{
    if (!_addressArray)
    {
        _addressArray = [NSMutableArray array];
    }
    return _addressArray;
}

- (NSMutableArray *)vendorArray
{
    if (!_vendorArray)
    {
        _vendorArray = [NSMutableArray array];
    }
    return _vendorArray;
}

- (NSMutableArray *)nameArray
{
    if (!_nameArray)
    {
        _nameArray = [NSMutableArray array];
    }
    return _nameArray;
}

- (NSMutableArray *)useNameArray
{
    if (!_useNameArray)
    {
        _useNameArray = [NSMutableArray array];
    }
    return _useNameArray;
}

- (NSMutableArray *)useVendorArray
{
    if (!_useVendorArray)
    {
        _useVendorArray = [NSMutableArray array];
    }
    return _useVendorArray;
}

- (NSMutableArray *)useAddressArray
{
    if (!_useAddressArray)
    {
        _useAddressArray = [NSMutableArray array];
    }
    return _useAddressArray;
}

#pragma mark System Action
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.addressArray removeAllObjects];
    
    self.index = 0;
    self.poiIndex = 0;
    // Do any additional setup after loading the view.
    [self setTopViewWithTitle:@""];
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _mapView.showsUserLocation = YES;
    [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //地图跟着位置移动
    _mapView.delegate = self;
    
    [self.view addSubview:_mapView];
    [self getProductInfo];
}


- (void)setFrame
{

    
    [AMapSearchServices sharedServices].apiKey = @"ec59da5fd6eeee28f486f6fda61438c4";
    
    //初始化检索对象
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
    //构造AMapGeocodeSearchRequest对象，address为必选项，city为可选项
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    
    geo.address = self.addressArray[self.index];
    //发起正向地理编码
    [_search AMapGeocodeSearch:geo];
    

}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    
}

//实现正向地理编码的回调函数
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    if (self.index == self.addressArray.count-1)
    {
        self.poiIndex = self.altitudeArray.count;
        [self poiSearch];
    }
    else if(response.geocodes.count == 0)
    {
        self.index++;
        [self setFrame];

    }
    else
    {
        AMapGeocode *geocode = [response.geocodes firstObject];
        [self.altitudeArray addObject:geocode.location];
        [self.useVendorArray addObject:self.vendorArray[self.index]];
        [self.useNameArray addObject:self.nameArray[self.index]];
        [self.useAddressArray addObject:self.addressArray[self.index]];
        self.index = self.index +1;
        if (self.index < self.addressArray.count)
        {
            [self setFrame];
        }
    }

}

- (void)poiSearch
{
    for (int i = 0 ; i < self.poiIndex; i++)
    {
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        AMapGeoPoint *point = self.altitudeArray[i];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(point.latitude,point.longitude);
        pointAnnotation.title = [NSString stringWithFormat:@"%@-%@",self.useVendorArray[i],self.useNameArray[i]];
        pointAnnotation.subtitle = [NSString stringWithFormat:@"%@",self.useAddressArray[i]];
        
        [_mapView addAnnotation:pointAnnotation];
    }
}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        
        return annotationView;
    }
    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Service
//!获取城市列表
- (void)getProductInfo
{
    NSString *param = Interface_mapProductInfo([FFConfig currentConfig].cityId);
    [[BHServiceDataCentre sharedInstance] blHealthRequestByDict:param
                                                     parameters:nil
                                                        showHUD:NO
                                                     controller:self
                                                           type:CC_Interface_mapProductInfo
                                             serviceAnswerBlock:^(BOOL isSuccess, id responseMsg,
                                                                  NSInteger type, NSString *errorMsg)
     {
         if (isSuccess && type == CC_Interface_mapProductInfo)
         {
             for (NSDictionary *dict in responseMsg)
             {
                 [self.addressArray addObject:dict[@"fetchAddress"]];
                 [self.nameArray addObject:dict[@"name"]];
                 [self.vendorArray addObject:dict[@"vendor"]];
             }
             [self setFrame];
         }
     }];
}

@end
