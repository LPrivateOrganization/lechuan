//
//  ContactCustomerViewController.m
//  lechuan
//
//  Created by bug on 15/12/11.
//  Copyright © 2015年 Kami Mahou. All rights reserved.
//

#import "ContactCustomerViewController.h"

@interface ContactCustomerViewController ()

@property (nonatomic, strong) NSMutableArray *buttonArray;

@end

@implementation ContactCustomerViewController

#pragma mark Init && Add
- (instancetype)init
{
    if (self = [super init]) {
        [self setTopViewWithTitle:@"联系客服"];
    }
    return self;
}

- (NSMutableArray *)buttonArray
{
    if (!_buttonArray) {
        _buttonArray = [[NSMutableArray alloc] init];
    }
    return _buttonArray;
}

#pragma mark System Action
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setFrame];
}

#pragma mark otherAction
- (void)setFrame
{
    NSDictionary *text1 = @{@"productName":@"客服电话",
                            @"productVendorName":@"182 - 4717 - 1818"};
    NSDictionary *text2 = [NSDictionary dictionaryWithObjectsAndKeys:@"客服QQ",@"productName",@"1627362930",@"productVendorName", nil];
    NSDictionary *text3 = [NSDictionary dictionaryWithObjectsAndKeys:@"客服微信",@"productName",@"S08Y20",@"productVendorName", nil];
    NSArray *textArray = @[text1, text2, text3];
    
    NSInteger width = 0;
    for (int i = 0; i < 3; i++)
    {
        UIButton *button = [[UIButton alloc] init];
        
        if (i == 0)
        {
            width = 20*autoSizeScaleX;
        }
        else if (i == 1)
        {
            width = 30*autoSizeScaleX;
        }
        else if (i == 2)
        {
            width = 45*autoSizeScaleX;
        }
        button.frame = CGRectMake((SCREEN_WIDTH-width)/2, 64+28*autoSizeScaleY+141*autoSizeScaleY*i, width, 37*autoSizeScaleY);
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ContactCustomer-%d", i]] forState:UIControlStateNormal];
//        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ContactCustomer-%d", i]] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        
        [self.view addSubview:button];
        [self.buttonArray addObject:button];
        
        NSDictionary *dict = textArray[i];
        UILabel *label = [[UILabel alloc] init];
        
        [self.view addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(button.mas_bottom).with.offset(11*autoSizeScaleY);
            make.centerX.equalTo(button);
        }];
        
        NSString *title = [NSString stringWithFormat:@"%@\n%@", dict[@"productName"], dict[@"productVendorName"]];
        NSMutableAttributedString *titleAttributeString = [[NSMutableAttributedString alloc] initWithString:title];
        
        [titleAttributeString addAttribute:NSFontAttributeName
                                     value:Font(15*autoSizeScaleY)
                                     range:NSMakeRange(0, [dict[@"productName"] length])];
        [titleAttributeString addAttribute:NSFontAttributeName
                                     value:Font(11*autoSizeScaleY)
                                     range:NSMakeRange([dict[@"productName"] length]+1, [dict[@"productVendorName"] length])];
        [titleAttributeString addAttribute:NSForegroundColorAttributeName
                                     value:[UIColor blackColor]
                                     range:NSMakeRange(0, [dict[@"productName"] length])];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:4];
        [titleAttributeString addAttribute:NSParagraphStyleAttributeName
                                     value:paragraphStyle
                                     range:NSMakeRange(0, title.length)];
        
        label.textColor = UIColorFromRGB(0x939393);
        label.numberOfLines = 0;
        label.attributedText = titleAttributeString;
        label.textAlignment = NSTextAlignmentCenter;
        
        if (i < 2)
        {
            UIImageView *lineImage = [[UIImageView alloc] init];
            
            [self.view addSubview:lineImage];
            
            [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 0.5*autoSizeScaleY));
                make.bottom.equalTo(label.mas_bottom).with.offset(25*autoSizeScaleY);
                make.left.equalTo(self.view).with.offset(0);
            }];
            
            lineImage.image = [UIImage imageNamed:@"lineImage"];
        }
    }
}

- (void)buttonClick:(UIButton *)bt
{
    for (UIButton *button in self.buttonArray)
    {
        if (button.tag == bt.tag) {
            button.selected = YES;
        }
        else
        {
            button.selected = NO;
        }
    }
    if (bt.tag == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://18247171818"]];
    }
}

@end
