//
//  LocationButton.m
//  lechuan
//
//  Created by Kami Mahou on 15/12/8.
//  Copyright © 2015年 Kami Mahou. All rights reserved.
//

#import "LocationButton.h"

@implementation LocationButton

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
    return CGRectMake(contentRect.size.width-contentRect.origin.x-14, (height-14)/2, 14, 14);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(contentRect.origin.x, contentRect.origin.y, contentRect.size.width-14-5-contentRect.origin.x, contentRect.size.height);
}

@end
