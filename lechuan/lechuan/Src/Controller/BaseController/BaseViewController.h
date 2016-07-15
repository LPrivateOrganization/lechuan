//
//  NeedInheritViewController.h
//  BLHealth
//
//  Created by lyywhg on 10-10-11.
//  Copyright 2010 BLHealth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableView+Category.h"
#import "UIView+Category.h"
#import "UIImage+Tint.h"
#import "DefaultCell.h"
#import "BackButton.h"
#import "MBProgressHUD.h"

@interface BaseViewController : UIViewController <UINavigationControllerDelegate ,UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, assign) CGFloat TopHeight;
@property (nonatomic, strong) BackButton *backBtn;
@property (nonatomic, strong) UILabel *topTitleLabel;
@property (nonatomic, strong) UIImageView *topTitleView;
@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *groupTableView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *loadingImageView;


/*
 设置TopView
 默认 没有右边按钮
 背景色统一 DefaultColor
 */
- (void)setTopViewWithTitle:(NSString*)title;
/*
 设置TopView
 WithRightImage :右侧按钮图片(默认显示)
 */
- (void)setTopViewWithTitle:(NSString*)title
             WithRightImage:(NSString*)imgName;
/*
 设置TopView
 WithLeftImage :左侧按钮图片
 */
- (void)setTopViewWithTitle:(NSString*)title
              WithLeftImage:(NSString*)imgName;
/*
 设置TopView
 WithLeftImage :左侧按钮图片
 WithRightImage :右侧按钮图片(默认显示)
 */
- (void)setTopViewWithTitle:(NSString*)title
              WithLeftImage:(NSString*)leftimgName
             WithRightImage:(NSString*)rightimgName;
/*
 设置TopView
 WithRightText :右侧文字
 */
- (void)setTopViewWithTitle:(NSString*)title
              WithRightText:(NSString*)text;
/*
 设置TopView
 color : TopView背景色
 */
- (void)setTopViewWithTitle:(NSString*)title
                  WithColor:(UIColor*)bgColor;
/*
 设置TopView
 WithRightImage :右侧按钮图片
 bgColor : TopView背景色
 */
- (void)setTopViewWithTitle:(NSString*)title
             WithRightImage:(NSString*)imgName
                  WithColor:(UIColor*)bgColor;
/*
 设置TopView
 默认 没有右边按钮  没有
 背景色统一 DefaultColor
 */
- (void)setTopViewWithTitle:(NSString*)title
                withLeftBtn:(NSString *)btnImage;

/*
 设置TopView  中间两个label 上下结构的
 默认 有右边按钮
 背景色统一 DefaultColor
 */
- (void)setTopViewWithTitle:(NSString*)title
                andRightBtn:(NSString *)rightBtnName;

/*
 提示语
*/
- (void)giveTipString:(NSString *)tipString;

- (void)showHUDText:(NSString *)text delay:(NSTimeInterval)delay;

//左侧按钮
- (void)backAction;

@end