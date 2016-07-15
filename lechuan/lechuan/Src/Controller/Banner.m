//
//  Banner.m
//  LeChuan
//
//  Created by Kami Mahou on 15/12/8.
//  Copyright © 2015年 tianhy. All rights reserved.
//

#import "Banner.h"
#import "UIButton+WebCache.h"
#import "NoteViewController.h"

BOOL enableAutoScroll;
NSTimer *timer;

@interface Banner () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation Banner

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        
        _scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.height);
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        
        _pageControl.frame = CGRectMake(0, self.height-15, SCREEN_WIDTH, 10);
        _pageControl.hidesForSinglePage = YES;
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.currentPageIndicatorTintColor = UIColorFromRGB(0xfe3045);
        
        [self addSubview:_pageControl];
    }
    return _pageControl;
}

- (void)setList:(NSArray *)list
{
    _list = list;
    
    
    for (UIView *view in self.scrollView.subviews)
    {
        [view removeFromSuperview];
    }
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*(list.count > 5 ? 5:list.count) , self.height);
    self.pageControl.numberOfPages = list.count>5? 5:list.count;
    //创建按钮
    for (int i = 0; i < list.count&&i<5; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
        button.frame = CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, self.height);
        button.tag = i;
        NSString *url = [[baseServerAddress stringByAppendingString:list[i][@"imagePath"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [button sd_setBackgroundImageWithURL:[NSURL URLWithString:url]
                                    forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonCLick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.scrollView addSubview:button];
    }
    [self bringSubviewToFront:self.pageControl];
    [self setAutoScroll:YES];
}

#pragma mark Other Action
- (void)buttonCLick:(UIButton *)button
{
    if (_delegate && [_delegate respondsToSelector:@selector(BannerClick:)]) {
        [_delegate BannerClick:_list[button.tag]];
    }
}

- (void)scrollToPage:(NSUInteger)index
{
    NSInteger totalPage = self.pageControl.numberOfPages;
    if (index >= totalPage) {
        index = totalPage - 1;
    }
    CGRect rect = CGRectMake(index * CGRectGetWidth(self.scrollView.frame), 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
    [self.scrollView scrollRectToVisible:rect animated:index];
    self.pageControl.currentPage = index;
}

- (void)setAutoScroll:(BOOL)enable
{
        if (!timer) {
            timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(tick:) userInfo:nil repeats:YES];
        }
     else if (timer && timer.isValid)
         {
            [timer invalidate];
            timer = nil;
         }
    
}

- (void)tick:(NSTimer *)sender
{
    NSInteger totalPage = self.pageControl.numberOfPages;
    NSInteger currentPage = self.pageControl.currentPage + 1;
    if (currentPage >= totalPage) {
        currentPage = 0;
    }
    else
    {
        self.pageControl.currentPage++;
    }
    
    [self scrollToPage:currentPage];
}
#pragma mark delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = scrollView.contentOffset.x/SCREEN_WIDTH;
}

@end
