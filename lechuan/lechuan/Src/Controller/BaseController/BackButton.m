//
//  BackButton.m
//  lechuan
//
//  Created by Kami Mahou on 15/12/9.
//  Copyright © 2015年 Kami Mahou. All rights reserved.
//

#import "BackButton.h"

@implementation BackButton

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
    return CGRectMake(contentRect.origin.x, (height-12)/2, 6.5, 12);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(contentRect.origin.x+6.5+5, contentRect.origin.y, contentRect.size.width-6.5-5-contentRect.origin.x, contentRect.size.height);
}

@end
