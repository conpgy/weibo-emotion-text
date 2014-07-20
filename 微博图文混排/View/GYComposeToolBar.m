//
//  GYComposeToolBar.m
//  全是微博
//
//  Created by 彭根勇 on 14-7-10.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import "GYComposeToolBar.h"

@interface GYComposeToolBar ()

@property (nonatomic, strong) GYComposeToolBar *toolBar;

@end

@implementation GYComposeToolBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithName:@"compose_toolbar_background"]];
        
        // 添加子控件
        [self addButtonWithImage:@"compose_camerabutton_background" hightImage:@"compose_camerabutton_background_highlighted" tag:GYComposeToolBarButtonTypeCamera];
        [self addButtonWithImage:@"compose_toolbar_picture" hightImage:@"compose_toolbar_picture_highlighted" tag:GYComposeToolBarButtonTypePicture];
        [self addButtonWithImage:@"compose_trendbutton_background" hightImage:@"compose_trendbutton_background_highlighted" tag:GYComposeToolBarButtonTypeTrend];
        [self addButtonWithImage:@"compose_mentionbutton_background" hightImage:@"compose_mentionbutton_background_highlighted" tag:GYComposeToolBarButtonTypeMention];
        [self addButtonWithImage:@"compose_emoticonbutton_background" hightImage:@"compose_emoticonbutton_background_highlighted" tag:GYComposeToolBarButtonTypeEmotion];
    }
    return self;
}

- (void)addButtonWithImage:(NSString *)imageName hightImage:(NSString *)highImage tag:(GYComposeToolBarButtonType)tag
{
    UIButton *button = [[UIButton alloc] init];
    
    // 设置属性
    [button setImage:[UIImage imageWithName:imageName]forState:UIControlStateNormal];
    [button setImage:[UIImage imageWithName:highImage] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;
    
    // 添加到self中
    [self addSubview:button];
}

/**
 *  监听按钮点击
 */

- (void)buttonClick:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(composeToolBar:DidClickButton:)]) {
        [self.delegate composeToolBar:self DidClickButton:button.tag];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    int count = self.subviews.count;
    CGFloat buttonW = self.width / count;
    CGFloat buttonH = self.height;
    
    for (int i = 0; i < count; i++) {
        UIButton *btn = self.subviews[i];
        btn.x = i * buttonW;
        btn.y = 0;
        btn.width = buttonW;
        btn.height = buttonH;
    }
}

@end
