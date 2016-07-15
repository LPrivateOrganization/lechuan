//
//  RoundRectProgressView.h
//  ecmc
//
//  Created by qihaijun on 10/9/14.
//  Copyright (c) 2014 cp9. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundRectProgressView : UIView

@property (nonatomic, strong) UIColor *progressTintColor;
@property (nonatomic, strong) UIColor *trackTintColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) float progress;

@end
