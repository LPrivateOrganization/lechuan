//
//  Banner.h
//  LeChuan
//
//  Created by Kami Mahou on 15/12/8.
//  Copyright © 2015年 tianhy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  BannerDelegate <NSObject>

- (void)BannerClick:(NSDictionary *)dict;

@end

@interface Banner : UIView

@property (nonatomic, weak) id <BannerDelegate> delegate;
@property (nonatomic, strong) NSArray *list;

@end
