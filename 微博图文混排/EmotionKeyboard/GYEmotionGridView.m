//
//  GYEmotionGridView.m
//  全是微博
//
//  Created by 彭根勇 on 14-7-17.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import "GYEmotionGridView.h"
#import "GYEmotionView.h"
#import "GYEmotion.h"
#import "GYEmotionGlassView.h"
#import "GYEmotionTool.h"

@interface GYEmotionGridView ()

@property (nonatomic, weak) UIButton *deleteBtn;
@property (nonatomic, strong) NSMutableArray *emotionViews;

/**
 *  放大镜
 */
@property (nonatomic, strong) GYEmotionGlassView *glassView;

@end

@implementation GYEmotionGridView

#pragma mark - 懒加载

-(GYEmotionGlassView *)glassView
{
    if (!_glassView) {
        _glassView = [GYEmotionGlassView glassView];
    }
    
    return _glassView;
}

-(NSMutableArray *)emotionViews
{
    if (!_emotionViews) {
        _emotionViews = [NSMutableArray array];
    }
    
    return _emotionViews;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 添加一个删除按钮
        UIButton *deleteBtn = [[UIButton alloc] init];
        [deleteBtn setImage:[UIImage imageWithName:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [deleteBtn setImage:[UIImage imageWithName:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
        [self addSubview:deleteBtn];
        self.deleteBtn = deleteBtn;
        // 设置监听器
        [deleteBtn addTarget:self action:@selector(deleteBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        
        // 添加长按手势
        UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:longPressGes];
    }
    return self;
}

-(void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    int count = emotions.count;
    
    // 添加表情
    for (int i = 0; i < count; i++) {
        GYEmotion *emotion = emotions[i];
        
        GYEmotionView *emotionView = nil;
        if (i < self.emotionViews.count) {
            emotionView = self.emotionViews[i];
        } else {
            emotionView = [[GYEmotionView alloc] init];
            [self addSubview:emotionView];
            [self.emotionViews addObject:emotionView];
            
            // 设置监听器
            [emotionView addTarget:self action:@selector(emotionViewSelected:) forControlEvents:UIControlEventTouchUpInside];
        }
        emotionView.emotion = emotion;
        
        emotionView.hidden = NO;
    }
    
    // 隐藏多余的子控件
    for (int i = count; i < self.emotionViews.count; i++) {
        GYEmotionView *emotionView = self.emotionViews[i];
        emotionView.hidden = YES;
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    // 布局表情控件
    CGFloat horizonalInset = 10;
    CGFloat verticalInset = 15;
    CGFloat emotionViewW = (self.width - 2 * horizonalInset) / GYEmotionMaxCols;
    CGFloat emotionViewH = (self.height - verticalInset) / GYEmotionMaxRows;
    for (int i = 0; i < self.emotions.count; i++) {
        GYEmotionView *emotionView = self.emotionViews[i];
        emotionView.width = emotionViewW;
        emotionView.height = emotionViewH;
        emotionView.x = horizonalInset + (i % GYEmotionMaxCols) * emotionView.width;
        emotionView.y = verticalInset + (i / GYEmotionMaxCols) * emotionView.height;
    }
    
    // 设置删除按钮
    self.deleteBtn.width = emotionViewW;
    self.deleteBtn.height = emotionViewH;
    self.deleteBtn.x = self.width - horizonalInset - self.deleteBtn.width;
    self.deleteBtn.y = self.height - self.deleteBtn.height;
}

#pragma mark - 监听表情点击

- (void)emotionViewSelected:(GYEmotionView *)emotionView
{
    [self.glassView showFromEmotionView:emotionView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.glassView dismiss];
    });
    
    // 选中表情
    [self selectedEmotion:emotionView.emotion];
}

# pragma mark - 监听长按手势

- (void)longPress:(UILongPressGestureRecognizer *)longPressGes
{
    // 获得触摸点
    CGPoint point = [longPressGes locationInView:longPressGes.view];
    
    // 检测触摸点在哪个表情上
    GYEmotionView *emotionView = [self emotionViewWithPoint:point];
    
    if (longPressGes.state == UIGestureRecognizerStateEnded) {
        // 隐藏放大镜
        [self.glassView dismiss];
        
        // 选中表情
        [self selectedEmotion:emotionView.emotion];
    } else {
        // 显示放大镜
        [self.glassView showFromEmotionView:emotionView];
    }
    
}

/**
 *  根据触摸点返回对应的表情控件
 */
- (GYEmotionView *)emotionViewWithPoint:(CGPoint)point
{
    __block GYEmotionView *foundEmotionView = nil;
    
    [self.emotionViews enumerateObjectsUsingBlock:^(GYEmotionView *emotionView, NSUInteger idx, BOOL *stop) {
        if (CGRectContainsPoint(emotionView.frame, point)) {
            foundEmotionView = emotionView;
            *stop = YES;
        }
    }];
    
    return foundEmotionView;
}

/**
 *  选中表情
 */

- (void)selectedEmotion:(GYEmotion *)emotion
{
    if(emotion == nil) return;
    
    // 保存到最近使用
    [GYEmotionTool addRecentEmotion:emotion];
    
    // 发出一个选中表情的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:GYEmotionDidSelectedNotification object:nil userInfo:@{GYSelectedEmotion: emotion}];
}

#pragma mark - 监听删除按钮

- (void)deleteBtnDidClick
{
    // 发出一个删除点击的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:GYEmotionKeyboardDidClickDeleteButtonNotification object:nil userInfo:nil];
}

@end
