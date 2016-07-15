//
//  GetStringWidthAndHeight.m
//  DZB
//
//  Created by 两元鱼 on 14-8-6.
//  Copyright (c) 2014年 FFLtd. All rights reserved.
//

#import "GetStringWidthAndHeight.h"

@implementation GetStringWidthAndHeight

+ (CGSize)getStringHeight:(NSString *)stringText width:(NSInteger)sWidth font:(UIFont *)theFont
{
    if (theFont == nil)
    {
        theFont = [UIFont systemFontOfSize:15];
    }
    if ([stringText respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:theFont, NSParagraphStyleAttributeName:paragraphStyle.copy};

        CGRect rectName = [stringText boundingRectWithSize:CGSizeMake(sWidth, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        CGSize sizeName;
        sizeName.width = ceil(rectName.size.width);
        sizeName.height = ceil(rectName.size.height);
        return sizeName;
    }
    return CGSizeZero;
}
+ (CGSize)getStringWidth:(NSString *)stringText height:(NSInteger)sHeight font:(UIFont *)theFont
{
    if (theFont == nil)
    {
        theFont = [UIFont systemFontOfSize:15];
    }
    if ([stringText respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:theFont, NSParagraphStyleAttributeName:paragraphStyle.copy};
        
        CGRect rectName = [stringText boundingRectWithSize:CGSizeMake(999, sHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        CGSize sizeName;
        sizeName.width = ceil(rectName.size.width);
        sizeName.height = ceil(rectName.size.height);
        return sizeName;
    }
    return CGSizeZero;
}
+ (CGSize)getStringSize:(NSString *)stringText font:(UIFont *)theFont
{
    if (theFont == nil)
    {
        theFont = [UIFont systemFontOfSize:15];
    }
    if ([stringText respondsToSelector:@selector(sizeWithAttributes:)])
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:theFont, NSParagraphStyleAttributeName:paragraphStyle.copy};
        
        CGSize sizeName = [stringText sizeWithAttributes:attributes ];
        return sizeName;
    }
    return CGSizeZero;
}

@end
