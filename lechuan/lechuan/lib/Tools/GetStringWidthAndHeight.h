//
//  GetStringWidthAndHeight.h
//  DZB
//
//  Created by 两元鱼 on 14-8-6.
//  Copyright (c) 2014年 FFLtd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetStringWidthAndHeight : NSObject

+ (CGSize)getStringHeight:(NSString *)stringText width:(NSInteger)sWidth font:(UIFont *)theFont;
+ (CGSize)getStringWidth:(NSString *)stringText height:(NSInteger)sHeight font:(UIFont *)theFont;
+ (CGSize)getStringSize:(NSString *)stringText font:(UIFont *)theFont;

@end
