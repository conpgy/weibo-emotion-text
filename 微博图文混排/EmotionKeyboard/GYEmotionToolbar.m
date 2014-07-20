//
//  GYEmotionToolbar.m
//  全是微博
//
//  Created by 彭根勇 on 14-7-16.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import "GYEmotionToolbar.h"

#define GYEmotionToolbarButtonMaxCount 4

@interface GYEmotionToolbar ()

@property (nonatomic, weak) UIButton *selectedBtn;

@property (nonatomic, weak) UIButton *defaultBtn;


@end

@implementation GYEmotionToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 添加四个按钮
        [self setupBtnWithTitle:@"最近" type:GYEmotionToolbarButtonTypeRecent];
        UIButton *defaultBtn = [self setupBtnWithTitle:@"默认" type:GYEmotionToolbarButtonTypeDefault];
        self.defaultBtn = defaultBtn;
        [self setupBtnWithTitle:@"Emoji" type:GYEmotionToolbarButtonTypeEmoji];
        [self setupBtnWithTitle:@"浪小花" type:GYEmotionToolbarButtonTypeLxh];
        
        // 监听表情选中的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelected:) name:GYEmotionDidSelectedNotification object:nil];
    }
    return self;
}

- (void)emotionDidSelected:(NSNotification *)note
{
    if (self.selectedBtn.tag == GYEmotionToolbarButtonTypeRecent) {
        [self buttonSelected:self.selectedBtn];
    }
}

-(void)setDelegate:(id<GYEmotionToolbarDelegate>)delegate
{
    _delegate = delegate;
    
    [self buttonSelected:self.defaultBtn];
}

- (UIButton *)setupBtnWithTitle:(NSString *)title type:(GYEmotionToolbarButtonType)type
{
    UIButton *button = [[UIButton alloc] init];
    button.tag = type;
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    
    // 添加按钮
    [self addSubview:button];
    
    // 设置背景图片
    int count = self.subviews.count;
    if (count == 1) {   // 第一个按钮zz
        [button setBackgroundImage:[UIImage resizedImage:@"compose_emotion_table_left_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage resizedImage:@"compose_emotion_table_left_selected"] forState:UIControlStateSelected];
    } else if (count == GYEmotionToolbarButtonMaxCount){    // 最后一个按钮
        [button setBackgroundImage:[UIImage resizedImage:@"compose_emotion_table_right_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage resizedImage:@"compose_emotion_table_right_selected"] forState:UIControlStateSelected];
    } else {
        [button setBackgroundImage:[UIImage resizedImage:@"compose_emotion_table_mid_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage resizedImage:@"compose_emotion_table_mid_selected"] forState:UIControlStateSelected];
    }
    
    // 设置监听器
    [button addTarget:self action:@selector(buttonSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置按钮的frame
    CGFloat buttonW = self.width / GYEmotionToolbarButtonMaxCount;
    CGFloat buttonH = self.height;
    
    for (int i = 0; i < GYEmotionToolbarButtonMaxCount; i++) {
        UIButton *button = self.subviews[i];
        button.x = i * buttonW;
        button.y = 0;
        button.width = buttonW;
        button.height = buttonH;
    }
}

#pragma mark - 监听按钮点击

- (void)buttonSelected:(UIButton *)button
{
    self.selectedBtn.selected = NO;
    button.selected = YES;
    self.selectedBtn = button;
    
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(emotionToolbar:DidSelectedBtn:)]) {
        [self.delegate emotionToolbar:self DidSelectedBtn:button.tag];
    }
}

@end
