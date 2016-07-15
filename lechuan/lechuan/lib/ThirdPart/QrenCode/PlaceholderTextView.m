//
//  PlaceholderTextView.m
//  BLHealth
//
//  Created by lyywhg on 11-12-10.
//  Copyright (c) 2011年 BH. All rights reserved.
//

#import "PlaceholderTextView.h"

@implementation PlaceholderTextView
@synthesize placeholder = _placeholder;
@synthesize placeholderColor = _placeholderColor;
@synthesize placeHolderLabel = _placeHolderLabel;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setPlaceholder:@""];
    [self setPlaceholderColor:[UIColor lightGrayColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (id)initWithFrame:(CGRect)frame
{
    if( (self = [super initWithFrame:frame]) )
    {
        [self setPlaceholder:@""];
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)textChanged:(NSNotification *)notification
{
    if([[self placeholder] length] == 0)
    {
        return;
    }
    
    if([[self text] length] == 0)
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    else
    {
        [[self viewWithTag:999] setAlpha:0];
    }
}

- (void)setPlaceholder:(NSString *)placeholder
{
    if (_placeholder != placeholder) 
    {
        _placeholder = placeholder;
        
        [self.placeHolderLabel removeFromSuperview];
        
        self.placeHolderLabel = nil;
        
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    if( [[self placeholder] length] > 0 )
    {
        if ( _placeHolderLabel == nil )
        {
            _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(4,8,self.bounds.size.width - 8,0)];
            [self addSubview:_placeHolderLabel];

            [_placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).with.offset(8);
                make.left.equalTo(self).with.offset(4);
                make.right.equalTo(self.mas_left).with.offset(self.bounds.size.width - 8);
            }];
//            _placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            _placeHolderLabel.numberOfLines = 0;
            _placeHolderLabel.font = self.font;
            _placeHolderLabel.backgroundColor = [UIColor clearColor];
            _placeHolderLabel.textColor = self.placeholderColor;
            _placeHolderLabel.alpha = 0;
            _placeHolderLabel.tag = 999;
            if (![[FFConfig currentConfig].bunderPath isEqualToString:@"zh-Hans"])
            {
                _placeHolderLabel.textAlignment = NSTextAlignmentRight;
            }
            [self sendSubviewToBack:_placeHolderLabel];
        }
        
        _placeHolderLabel.text = self.placeholder;
//        [_placeHolderLabel sizeToFit];
    }
    
    if( [[self text] length] == 0 && [[self placeholder] length] > 0 )
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    
    [super drawRect:rect];
}

@end
