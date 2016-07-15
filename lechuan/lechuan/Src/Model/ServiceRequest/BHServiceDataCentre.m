//
//  BHServiceDataCentre.m
//  BLHealth
//
//  Created by Kami Mahou on 14-5-22.
//  Copyright (c) 2014年 BLHealth. All rights reserved.
//

#import "BHServiceDataCentre.h"
#import <CommonCrypto/CommonDigest.h>

@interface BHServiceDataCentre()

//@property (nonatomic, strong) AFHTTPRequestOperationManager *createHttpRequest;

@end

@implementation BHServiceDataCentre

#pragma mark
#pragma mark - Init & Dealloc
static BHServiceDataCentre *sharedObj = nil;

#pragma mark Init & Add
+ (BHServiceDataCentre *)sharedInstance
{
    @synchronized (self)
    {
        if (sharedObj == nil)
        {
            [[self alloc] init];
        }
    }
    return sharedObj;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized (self)
    {
        if (sharedObj == nil)
        {
            sharedObj = [super allocWithZone:zone];
            return sharedObj;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)init
{
    @synchronized(self)
    {
        self = [super init];
        return self;
    }
}

- (AFHTTPRequestOperationManager *)createHttpRequest
{
    if (!_createHttpRequest) {
        _createHttpRequest = [AFHTTPRequestOperationManager manager];
    }
    return _createHttpRequest;
}

#pragma mark
#pragma mark - Other Action
- (void)blHealthRequestByDict:(NSString *)serviceParam
                   parameters:(NSDictionary *)parameters
                      showHUD:(BOOL)showHUD
                   controller:(BaseViewController *)viewController
                         type:(NSInteger)type
           serviceAnswerBlock:(BHServiceDataCentreBlock)block
{
    __block NSInteger iType = type;
    __block BHServiceDataCentreBlock tBlock = [block copy];
    __block BaseViewController *tVC = viewController;
    
     NSString *url = [NSString stringWithFormat:@"%@/api/v1/",baseServerAddress];
    
    self.createHttpRequest.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.createHttpRequest.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.createHttpRequest.requestSerializer.timeoutInterval = 15;
    
    AFJSONRequestSerializer *jsonRequestSerializer = [AFJSONRequestSerializer serializer];
    [self.createHttpRequest setRequestSerializer:jsonRequestSerializer];
    
    NSString *token = [FFConfig currentConfig].token;
    [self.createHttpRequest.requestSerializer setValue:token
                                    forHTTPHeaderField:@"X-AUTH-TOKEN"];
    [self.createHttpRequest.requestSerializer setValue:@"application/json"
                                    forHTTPHeaderField:@"Content-Type"];
    
    url = [url stringByAppendingString:serviceParam];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //状态栏显示网络请求
    [Utilities showNetworkActivityIndicator];
    
    MBProgressHUD *hud = nil;
    if (showHUD) {
        hud = [MBProgressHUD showHUDAddedTo:tVC.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"加载中";
    }
//    NSString *jsonString = nil;
//    if (parameters) {
//        jsonString = [self JSONStringWithObject:parameters];
//    }
    [self.createHttpRequest POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (tBlock)
        {
            [hud hide:YES];
            [Utilities hideNetworkActivityIndicator];
            
            NSDictionary *dict = operation.response.allHeaderFields;
            
            if ([responseObject isKindOfClass:[NSData class]])
            {
                NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                if (![TextFieldCheckAlert isStringNull:result])
                {
                    dict = [responseObject objectFromJSONData];
                }
            }
            
            tBlock(YES, dict, iType, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        if (tBlock)
        {
            [Utilities hideNetworkActivityIndicator];
//            hud.labelText = @"加载失败";
            [hud hide:YES];

            tBlock(NO, error, iType, @"连接服务器超时，请重试");
        }
    }];
}

- (void)blHealthRequestStop
{
    [self.createHttpRequest.operationQueue cancelAllOperations];
}

- (NSString *)JSONStringWithObject:(id)object
{
    if (!object) {
        return nil;
    }
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        
        //使用这个方法的返回，我们就可以得到想要的JSON串
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];
        return jsonString;
    }
    
    NSLog(@"%s:%@",__FUNCTION__,error);
    return nil;
}

@end
