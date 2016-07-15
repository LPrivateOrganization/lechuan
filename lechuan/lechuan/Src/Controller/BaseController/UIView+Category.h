//
//  UIView+Category.h
//  HeNan
//
//  Created by Kami Mahou on 15/12/2.
//  Copyright © 2015年 Kami Mahou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Category)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign, readonly) CGFloat bottom;

@end
