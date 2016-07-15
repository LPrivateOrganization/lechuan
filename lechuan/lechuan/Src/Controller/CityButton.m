//
//  CityButton.m
//  lechuan
//
//  Created by Kami Mahou on 15/12/8.
//  Copyright © 2015年 Kami Mahou. All rights reserved.
//

#import "CityButton.h"

@implementation CityButton

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
    return CGRectMake(contentRect.origin.x, (height-6.5)/2, 12, 6.5);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(contentRect.origin.x+12+5, contentRect.origin.y, contentRect.size.width-12-5-contentRect.origin.x, contentRect.size.height);
}

@end
