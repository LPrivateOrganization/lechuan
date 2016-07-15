//
//  DefaultCell.m
//  BLHealth
//
//  Created by lyywhg on 13-9-16.
//  Copyright (c) 2013年 BLHealth. All rights reserved.
//

#import "DefaultCell.h"

@interface DefaultCell()

@end

@implementation DefaultCell

#pragma mark
#pragma mark - Init & Dealloc
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
    }
    return self;
}

#pragma mark
#pragma mark - Init & Add



- (UIImageView *)firstHttpImageView
{
    if (!_firstHttpImageView)
    {
        _firstHttpImageView = [[UIImageView alloc] init];
        _firstHttpImageView.backgroundColor = [UIColor clearColor];
        _firstHttpImageView.layer.masksToBounds = YES;
        [self.ViewBack addSubview:_firstHttpImageView];
    }
    return _firstHttpImageView;
}

- (UIImageView *)firstImageView
{
    if (!_firstImageView)
    {
        _firstImageView = [[UIImageView alloc] init];
        _firstImageView.backgroundColor = [UIColor clearColor];
        [self.ViewBack addSubview:_firstImageView];
    }
    return _firstImageView;
}

- (UIImageView *)secondImageView
{
    if (!_secondImageView)
    {
        _secondImageView = [[UIImageView alloc] init];
        _secondImageView.backgroundColor = [UIColor clearColor];
        [self.ViewBack addSubview:_secondImageView];
    }
    return _secondImageView;
}

- (UIImageView *)thirdImageView
{
    if (!_thirdImageView)
    {
        _thirdImageView = [[UIImageView alloc] init];
        _thirdImageView.backgroundColor = [UIColor clearColor];
        [self.ViewBack addSubview:_thirdImageView];
    }
    return _thirdImageView;
}

- (UITextView *)firstTextView
{
    if (!_firstTextView)
    {
        _firstTextView = [[UITextView alloc] init];
//        _firstTextView.numberOfLines = 0;
        _firstTextView.font = Font(15);
//        _firstTextView.text = @"hehhehe";
        _firstTextView.backgroundColor = [UIColor whiteColor];
        _firstTextView.textColor = [UIColor colorWithRed:51.0/255.0f green:51.0/255.0f blue:51.0/255.0f alpha:1.0f];
        [self.ViewBack addSubview:_firstTextView];
    }
    return _firstTextView;
}

- (UILabel *)firstLabel
{
    if (!_firstLabel)
    {
        _firstLabel = [[UILabel alloc] init];
        _firstLabel.numberOfLines = 0;
        _fifthLabel.font = Font(15);
        _firstLabel.backgroundColor = [UIColor clearColor];
        _firstLabel.textColor = [UIColor colorWithRed:51.0/255.0f green:51.0/255.0f blue:51.0/255.0f alpha:1.0f];
        [self.ViewBack addSubview:_firstLabel];
    }
    return _firstLabel;
}
- (UILabel *)secondLabel
{
    if (!_secondLabel)
    {
        _secondLabel = [[UILabel alloc] init];
        _secondLabel.numberOfLines = 0;
        _secondLabel.backgroundColor = [UIColor clearColor];
        _secondLabel.textColor = [UIColor colorWithRed:85.0/255.0f green:85.0/255.0f blue:85.0/255.0f alpha:1.0f];
        [self.ViewBack addSubview:_secondLabel];
    }
    return _secondLabel;
}
- (UILabel *)thirdLabel
{
    if (!_thirdLabel)
    {
        _thirdLabel = [[UILabel alloc] init];
        _thirdLabel.numberOfLines = 4;
        _thirdLabel.backgroundColor = [UIColor clearColor];
        _thirdLabel.textColor = [UIColor colorWithRed:85.0/255.0f green:85.0/255.0f blue:85.0/255.0f alpha:1.0f];
        [self.ViewBack addSubview:_thirdLabel];
    }
    return _thirdLabel;
}
- (UILabel *)fourthLabel
{
    if (!_fourthLabel)
    {
        _fourthLabel = [[UILabel alloc] init];
        _fourthLabel.numberOfLines = 4;
        _fourthLabel.backgroundColor = [UIColor clearColor];
        _fourthLabel.textColor = [UIColor blackColor];
        [self.ViewBack addSubview:_fourthLabel];
    }
    return _fourthLabel;
}
- (UILabel *)fifthLabel
{
    if (!_fifthLabel)
    {
        _fifthLabel = [[UILabel alloc] init];
        _fifthLabel.numberOfLines = 4;
        _fifthLabel.backgroundColor = [UIColor clearColor];
        _fifthLabel.textColor = [UIColor lightGrayColor];
        [self.ViewBack addSubview:_fifthLabel];
    }
    return _fifthLabel;
}
- (UILabel *)sixthLabel
{
    if (!_sixthLabel) {
        _sixthLabel = [[UILabel alloc] init];
        _sixthLabel.numberOfLines = 0;
        _sixthLabel.backgroundColor = [UIColor clearColor];
        _sixthLabel.textColor = [UIColor lightGrayColor];
        [self.ViewBack addSubview:_sixthLabel];
    }
    return _sixthLabel;
}
- (UILabel *)seventhLabel
{
    if (!_seventhLabel) {
        _seventhLabel = [[UILabel alloc] init];
        _seventhLabel.numberOfLines = 0;
        _seventhLabel.backgroundColor = [UIColor clearColor];
        _seventhLabel.textColor = [UIColor lightGrayColor];
        [self.ViewBack addSubview:_seventhLabel];
    }
    return _seventhLabel;
}

- (UILabel *)eighthLabel
{
    if (!_eighthLabel) {
        _eighthLabel = [[UILabel alloc] init];
        _eighthLabel.font = [UIFont systemFontOfSize:13];
        [self.ViewBack addSubview:_eighthLabel];
    }
    return _eighthLabel;
}
- (UILabel *)ninthLabel
{
    if (!_ninthLabel) {
        _ninthLabel = [[UILabel alloc] init];
        _ninthLabel.font = [UIFont systemFontOfSize:13];
        [self.ViewBack addSubview:_ninthLabel];
    }
    return _ninthLabel;
}
- (UILabel *)tenthLabel
{
    if (!_tenthLabel) {
        _tenthLabel = [[UILabel alloc] init];
        _tenthLabel.font = [UIFont systemFontOfSize:13];
        [self.ViewBack addSubview:_tenthLabel];
    }
    return _tenthLabel;
}
- (UILabel *)eleventhLabel
{
    if (!_eleventhLabel) {
        _eleventhLabel = [[UILabel alloc] init];
        _eleventhLabel.font = [UIFont systemFontOfSize:13];
        [self.ViewBack addSubview:_eleventhLabel];
    }
    return _eleventhLabel;
}
- (UILabel *)twelfthLabel
{
    if (!_twelfthLabel) {
        _twelfthLabel = [[UILabel alloc] init];
        _twelfthLabel.font = [UIFont systemFontOfSize:13];
        [self.ViewBack addSubview:_twelfthLabel];
    }
    return _twelfthLabel;
}
-(UIView*)ViewBack
{
    if(!_ViewBack)
    {
        _ViewBack=[[UIView alloc]init];
        _ViewBack.userInteractionEnabled = YES;
        _ViewBack.backgroundColor = [UIColor whiteColor];
//        _ViewBack.frame = self.frame;
        
        [self addSubview:_ViewBack];
    }
    return _ViewBack;
}

- (UIButton *)firstButton
{
    if (!_firstButton) {
        _firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_firstButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.ViewBack addSubview:_firstButton];
    }
    return _firstButton;
}
- (UIButton *)secondButton
{
    if (!_secondButton) {
        _secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.ViewBack addSubview:_secondButton];
    }
    return _secondButton;
}
- (UIButton *)thirdButton
{
    if (!_thirdButton) {
        _thirdButton = [[UIButton alloc] init];
        [self.ViewBack addSubview:_thirdButton];
    }
    return _thirdButton;
}

- (UIView *)firstLineView
{
    if (!_firstLineView) {
        _firstLineView = [[UIView alloc] init];
        _firstLineView.backgroundColor = UIColorFromRGB(0xcccccc);
        [self.ViewBack addSubview:_firstLineView];
    }
    return _firstLineView;
}

- (UIView *)secondLineView
{
    if (!_secondLineView) {
        _secondLineView = [[UIView alloc] init];
        _secondLineView.backgroundColor = UIColorFromRGB(0xcccccc);
        [self.ViewBack addSubview:_secondLineView];
    }
    return _secondLineView;
}

- (UIView *)firstBgView
{
    if (!_firstBgView) {
        _firstBgView = [[UIView alloc] init];
        _firstBgView.backgroundColor = [UIColor whiteColor];
        [self.ViewBack addSubview:_firstBgView];
    }
    return _firstBgView;
}

- (UIView *)secondBgView
{
    if (!_secondBgView) {
        _secondBgView = [[UIView alloc] init];
        _secondBgView.backgroundColor = [UIColor whiteColor];
        [self.ViewBack addSubview:_secondBgView];
    }
    return _secondBgView;
}

- (UISwitch*)firstSwitch
{
    if (!_firstSwitch)
    {
        _firstSwitch= [[UISwitch alloc] init];
        _firstSwitch.enabled = YES;
//        _firstSwitch.on = YES;
//        _firstSwitch.onTintColor = DefaultBlueColor;
        [self.ViewBack addSubview:_firstSwitch];
    }
    return _firstSwitch;
}

- (RoundRectProgressView *)firstProgressView
{
    if (!_firstProgressView) {
        _firstProgressView = [[RoundRectProgressView alloc] initWithFrame:CGRectZero];
        _firstProgressView.layer.cornerRadius = 2.0f;
        _firstProgressView.trackTintColor = UIColorFromRGB(0xe0e0e0);
        [self.ViewBack addSubview:_firstProgressView];
    }
    return _firstProgressView;
}

@end
