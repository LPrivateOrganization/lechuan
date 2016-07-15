//
//  UITableView+Category.m
//  HeNan
//
//  Created by Kami Mahou on 15/12/1.
//  Copyright © 2015年 Kami Mahou. All rights reserved.
//

#import "UITableView+Category.h"

@implementation UITableView (Category)

- (void)setMjHeaderController:(UIViewController *)target Selector:(SEL)selector
{
    self.header = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:selector];
}

@end
