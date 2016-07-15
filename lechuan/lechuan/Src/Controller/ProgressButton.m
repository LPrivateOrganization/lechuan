//
//  ProgressButton.m
//  lechuan
//
//  Created by Kami Mahou on 15/12/16.
//  Copyright © 2015年 Kami Mahou. All rights reserved.
//

#import "ProgressButton.h"

@implementation ProgressButton

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
    return CGRectMake(contentRect.origin.x, (height-10)/2, 10, 10);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(contentRect.origin.x+10+5, contentRect.origin.y, contentRect.size.width-10-5-contentRect.origin.x, contentRect.size.height);
}

@end
