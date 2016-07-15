//
//  DefaultCell.h
//  BLHealth
//
//  Created by lyywhg on 13-9-16.
//  Copyright (c) 2013年 BLHealth. All rights reserved.
//
#import "RoundRectProgressView.h"

@interface DefaultCell : UITableViewCell

@property (nonatomic, strong) UIView *ViewBack;

@property (nonatomic, strong) UIImageView *firstHttpImageView;
@property (nonatomic, strong) UIImageView *firstImageView;
@property (nonatomic, strong) UIImageView *secondImageView;
@property (nonatomic, strong) UIImageView *thirdImageView;

@property (nonatomic, strong) UITextView *firstTextView;
@property (nonatomic, strong) UILabel *firstLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) UILabel *thirdLabel;
@property (nonatomic, strong) UILabel *fourthLabel;
@property (nonatomic, strong) UILabel *fifthLabel;
@property (nonatomic, strong) UILabel *sixthLabel;
@property (nonatomic, strong) UILabel *seventhLabel;
@property (nonatomic, strong) UILabel *eighthLabel;
@property (nonatomic, strong) UILabel *ninthLabel;
@property (nonatomic, strong) UILabel *tenthLabel;
@property (nonatomic, strong) UILabel *eleventhLabel;
@property (nonatomic, strong) UILabel *twelfthLabel;

@property (nonatomic, strong) UIButton *firstButton;
@property (nonatomic, strong) UIButton *secondButton;
@property (nonatomic, strong) UIButton *thirdButton;

@property (nonatomic, strong) UISwitch *firstSwitch;

@property (nonatomic, strong) RoundRectProgressView *firstProgressView;

@property (nonatomic, strong) UIView *firstLineView;
@property (nonatomic, strong) UIView *secondLineView;

@property (nonatomic, strong) UIView *firstBgView;
@property (nonatomic, strong) UIView *secondBgView;

@property (nonatomic, copy) NSString *cityId;

@end
