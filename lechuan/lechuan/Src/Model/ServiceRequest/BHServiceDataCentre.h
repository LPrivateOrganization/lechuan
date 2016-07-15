//
//  BHServiceDataCentre.h
//  BLHealth
//
//  Created by Kami Mahou on 14-5-22.
//  Copyright (c) 2014年 BLHealth. All rights reserved.
//
//  新服务请求类


#import "KeychainContext.h"
#import "AFHTTPRequestOperationManager.h"

#define T_REQUEST_CACHE @"t_req_cache"
//键值
#define K_phoneNum @"phoneNum"
#define K_URL @"url"
#define K_PARAM @"param"
#define K_RSP @"rsp"
#define K_STAMP @"stamp"

//消息缓存失效时间
#define EXPIRY_TIME 900
#define S_DATEFORMAT @"yyyyMMddHHmmss"

#if NS_BLOCKS_AVAILABLE
typedef void (^BHServiceDataCentreBlock)(BOOL, id , NSInteger, NSString *);
#endif

@interface BHServiceDataCentre : NSObject

@property (nonatomic, strong) AFHTTPRequestOperationManager *createHttpRequest;

+ (BHServiceDataCentre *)sharedInstance;

- (void)blHealthRequestStop;

- (void)blHealthRequestByDict:(NSString *)serviceParam
                   parameters:(NSDictionary *)parameters
                      showHUD:(BOOL)showHUD
                   controller:(BaseViewController *)viewController
                         type:(NSInteger)type
           serviceAnswerBlock:(BHServiceDataCentreBlock)block;

@end