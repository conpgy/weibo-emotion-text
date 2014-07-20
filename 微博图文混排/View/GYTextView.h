//
//  GYTextView.h
//  全是微博
//
//  Created by 彭根勇 on 14-7-10.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+extension.h"

@interface GYTextView : UITextView

@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;

@end
