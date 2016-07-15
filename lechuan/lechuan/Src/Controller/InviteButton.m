//
//  InviteButton.m
//  lechuan
//
//  Created by Kami Mahou on 15/12/10.
//  Copyright © 2015年 Kami Mahou. All rights reserved.
//

#import "InviteButton.h"

@implementation InviteButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake((contentRect.size.width-52*autoSizeScaleY)/2, contentRect.origin.y, 52*autoSizeScaleY, 52*autoSizeScaleY);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(contentRect.origin.x, contentRect.origin.y+contentRect.size.height-15*autoSizeScaleY, contentRect.size.width, 15*autoSizeScaleY);
}

@end
