//
//  PlaceholderTextView.h
//  BLHealth
//
//  Created by lyywhg on 11-12-10.
//  Copyright (c) 2011年 BH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceholderTextView : UITextView 
{
    NSString    *_placeholder;
    
    UIColor     *_placeholderColor;
    
    UILabel     *_placeHolderLabel;
}

@property(nonatomic,retain) UILabel     *placeHolderLabel;
@property(nonatomic,retain) NSString    *placeholder;
@property(nonatomic,retain) UIColor     *placeholderColor;

- (void)textChanged:(NSNotification*)notification;

@end
