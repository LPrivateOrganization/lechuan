//
//  LTools.h
//  lechuan
//
//  Created by lichaowei on 16/7/14.
//  Copyright © 2016年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTools : NSObject

+ (id)shareInstance;

/**
 *  分享各个平台
 *
 *  @param snsName               平台name
 *  @param shareTitle            标题
 *  @param shareText             摘要
 *  @param shareImage            图片
 *  @param shareUrl              链接
 *  @param presentViewController 模态viewController
 */
- (void)autoShareToSnsName:(NSString *)snsName
                shareTitle:(NSString *)shareTitle
                 shareText:(NSString *)shareText
                shareImage:(id)shareImage
                  shareUrl:(NSString *)shareUrl
     presentViewController:(UIViewController *)presentViewController;

/**
 *  分享是否成功
 *
 *  @param success
 */
- (void)shareResultIsSuccess:(BOOL)success;

@end
