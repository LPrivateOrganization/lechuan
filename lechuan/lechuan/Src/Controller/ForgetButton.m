//
//  ForgetButton.m
//  lechuan
//
//  Created by Kami Mahou on 15/12/9.
//  Copyright © 2015年 Kami Mahou. All rights reserved.
//

#import "ForgetButton.h"

@implementation ForgetButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat height = contentRect.size.height;
    return CGRectMake(contentRect.origin.x, (height-15)/2, 15, 15);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(contentRect.origin.x+15+5, contentRect.origin.y+5, contentRect.size.width-15-5-contentRect.origin.x, contentRect.size.height-5);
}

@end
