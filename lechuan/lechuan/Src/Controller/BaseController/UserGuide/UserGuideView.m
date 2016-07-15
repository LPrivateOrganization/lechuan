//
//  UserGuideView.m
//  XinJiang
//
//  Created by Kami Mahou on 15/9/7.
//  Copyright (c) 2015年 Kami Mahou. All rights reserved.
//

#import "UserGuideView.h"

@implementation UserGuideView

- (instancetype)init
{
    if (self = [super init])
    {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.delegate = self;
        UITapGestureRecognizer *tagGer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changePage)];
        [self addGestureRecognizer:tagGer];
        
        NSString *phone = @"";
        if (isIPhone4)
        {
            phone = @"-4s";
        }
        else
        {
            phone = @"-6p";
        }
        NSArray *imageArray = @[[@"userGuide_1" stringByAppendingString:phone],
                                [@"userGuide_2" stringByAppendingString:phone],
                                [@"userGuide_3" stringByAppendingString:phone],
                                [@"userGuide_4" stringByAppendingString:phone]];
        for (int i = 0; i < imageArray.count; i++)
        {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageArray[i]]];
            imageView.frame = CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            
            [self addSubview:imageView];
            
            if (i == imageArray.count-1)
            {
                CGFloat y;
                CGFloat width;
                CGFloat height;
                
                if (isIPhone4)
                {
                    y = 388;
                    width = 130;
                    height = 41;
                }
                else
                {
                    y = 555*autoSizeScaleY;
                    width = 153*autoSizeScaleX;
                    height = 50*autoSizeScaleY;
                }
                UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
                bt.frame = CGRectMake((SCREEN_WIDTH-width)/2, y, width, height);
                [bt addTarget:self action:@selector(intoAction) forControlEvents:UIControlEventTouchUpInside];
                imageView.userInteractionEnabled = YES;
                [imageView addSubview:bt];
            }
        }
        self.contentSize = CGSizeMake(SCREEN_WIDTH*imageArray.count, SCREEN_HEIGHT);
    }
    return self;
}

- (void)intoAction
{
    [(AppDelegate *)[UIApplication sharedApplication].delegate showTabBar];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ( scrollView.contentOffset.x > scrollView.contentSize.width - scrollView.frame.size.width + 70)
    {
//        [self.superVC.view removeFromSuperview];
            [(AppDelegate *)[UIApplication sharedApplication].delegate showTabBar];
    }
}


- (void)changePage
{
    CGPoint point = self.contentOffset;
    point.x = point.x + self.frame.size.width;
    self.contentOffset = point;
    
}

@end
