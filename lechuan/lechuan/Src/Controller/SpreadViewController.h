//
//  SpreadViewController.h
//  lechuan
//
//  Created by Kami Mahou on 15/12/9.
//  Copyright © 2015年 Kami Mahou. All rights reserved.
//

#import "BaseViewController.h"

@interface SpreadViewController : BaseViewController

@property (nonatomic, strong) UITextView *contentTextView;

- (NSMutableAttributedString *)setAttributeString:(NSString *)text;

@end
