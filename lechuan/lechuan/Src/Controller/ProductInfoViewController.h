//
//  ProductInfoViewController.h
//  lechuan
//
//  Created by Kami Mahou on 15/12/14.
//  Copyright © 2015年 Kami Mahou. All rights reserved.
//

#import "BaseViewController.h"

@interface ProductInfoViewController : BaseViewController

@property (nonatomic, strong) NSDictionary *infoDic;
@property (nonatomic, assign) BOOL check;
@property (nonatomic, strong) NSString *banner;
@property (nonatomic, strong) NSString *bannerId;

@end
