//
//  LoginTextField.m
//  lechuan
//
//  Created by Kami Mahou on 15/12/9.
//  Copyright © 2015年 Kami Mahou. All rights reserved.
//

#import "LoginTextField.h"

@implementation LoginTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x+50*autoSizeScaleX, bounds.origin.y, bounds.size.width-(bounds.origin.x+50*autoSizeScaleX)-15, bounds.size.height);
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x+50*autoSizeScaleX, bounds.origin.y, bounds.size.width-(bounds.origin.x+50*autoSizeScaleX)-15, bounds.size.height);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x+50*autoSizeScaleX, bounds.origin.y, bounds.size.width-(bounds.origin.x+50*autoSizeScaleX)-15, bounds.size.height);
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    return CGRectMake(20*autoSizeScaleX, (bounds.size.height-15*autoSizeScaleY)/2, 13*autoSizeScaleX, 15*autoSizeScaleY);
}

@end
