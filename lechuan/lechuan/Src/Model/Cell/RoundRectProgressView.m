//
//  RoundRectProgressView.m
//  ecmc
//
//  Created by qihaijun on 10/9/14.
//  Copyright (c) 2014 cp9. All rights reserved.
//

#import "RoundRectProgressView.h"
#import <QuartzCore/QuartzCore.h>

@implementation RoundRectProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _progressTintColor = [UIColor blueColor];
        _trackTintColor = [UIColor lightGrayColor];
        _borderColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    float p = self.progress;
    if (p < 0) {
        p = 0;
    } else if (p > 1.0f) {
        p = 1.0f;
    }
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    UIBezierPath *backgroundPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:rect.size.height/2];
    CGContextAddPath(context, backgroundPath.CGPath);
    CGContextSetFillColorWithColor(context, self.trackTintColor.CGColor);
    CGContextFillPath(context);
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:rect.size.height/2];
    CGContextAddPath(context, borderPath.CGPath);
    CGContextSetStrokeColorWithColor(context, self.borderColor.CGColor);
    CGContextSetLineWidth(context, .5f);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    UIBezierPath *progressPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width*p, rect.size.height) cornerRadius:rect.size.height/2];
    CGContextAddPath(context, progressPath.CGPath);
    CGContextSetFillColorWithColor(context, self.progressTintColor.CGColor);
    CGContextFillPath(context);
    CGContextRestoreGState(context);
}

@end
