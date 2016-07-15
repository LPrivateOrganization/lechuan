//
//  ProductTypeButton.m
//  lechuan
//
//  Created by Kami Mahou on 15/12/8.
//  Copyright © 2015年 Kami Mahou. All rights reserved.
//

#import "ProductTypeButton.h"

@implementation ProductTypeButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat width = 57*autoSizeScaleX;
    CGFloat height = 57*autoSizeScaleX;
    CGFloat x = (contentRect.size.width-width)/2;
    CGFloat y = contentRect.origin.y + 10*autoSizeScaleX;

    return CGRectMake(x, y, width, height);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat x = contentRect.origin.x;
    CGFloat y = contentRect.origin.y + (57+10)*autoSizeScaleX;
    CGFloat width = contentRect.size.width;
    CGFloat height = 26*autoSizeScaleX;
    
    return CGRectMake(x, y, width, height);
}

@end
