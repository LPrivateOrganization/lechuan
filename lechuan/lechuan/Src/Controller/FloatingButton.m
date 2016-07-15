//
//  FloatingButton.m
//  lechuan
//
//  Created by bug on 15/12/17.
//  Copyright © 2015年 Kami Mahou. All rights reserved.
//

#import "FloatingButton.h"

@implementation FloatingButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect
{
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame = CGRectMake(SCREEN_WIDTH-100, 64, 100, 50);
    [bt setBackgroundImage:[UIImage imageNamed:@"jumpBtnicon_1"] forState:UIControlStateNormal];
    [bt setBackgroundImage:[UIImage imageNamed:@"jumpBtnicon"] forState:UIControlStateSelected];
    [bt addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:bt];
}

- (void)remove
{
    [self removeFromSuperview];
}

@end
