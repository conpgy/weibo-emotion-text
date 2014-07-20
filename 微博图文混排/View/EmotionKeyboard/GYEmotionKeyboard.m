//
//  GYEmotionKeyboard.m
//  全是微博
//
//  Created by 彭根勇 on 14-7-16.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import "GYEmotionKeyboard.h"
#import "GYEmotionListView.h"
#import "GYEmotionToolbar.h"
#import "GYEmotion.h"
#import "GYEmotionTool.h"

@interface GYEmotionKeyboard ()<GYEmotionToolbarDelegate>

/**
 *  表情列表视图
 */
@property (nonatomic, weak) GYEmotionListView *listView;

/**
 *  底部工具条
 */
@property (nonatomic, weak) GYEmotionToolbar *toolbar;

@end

@implementation GYEmotionKeyboard

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithName:@"emoticon_keyboard_background"]];
        // 添加列表视图
        GYEmotionListView *listView = [[GYEmotionListView alloc] init];
        [self addSubview:listView];
        self.listView = listView;
        
        // 添加底部工具条
        GYEmotionToolbar *toolbar = [[GYEmotionToolbar alloc] init];
        [self addSubview:toolbar];
        toolbar.delegate = self;
        self.toolbar = toolbar;
    }
    return self;
}

+(instancetype)keyboard
{
    return [[self alloc] init];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    // 计算底部工具条的frame
    self.toolbar.width = self.width;
    self.toolbar.height = 35;
    self.toolbar.x = 0;
    self.toolbar.y = self.height - self.toolbar.height;
    
    // 计算表情列表视图的frame
    self.listView.x = 0;
    self.listView.y = 0;
    self.listView.width = self.width;
    self.listView.height = self.toolbar.y;
}

#pragma mark - GYEmotionToolbarDelegate

-(void)emotionToolbar:(GYEmotionToolbar *)toolbar DidSelectedBtn:(GYEmotionToolbarButtonType)type
{
    switch (type) {
        case GYEmotionToolbarButtonTypeDefault:
            self.listView.emotions = [GYEmotionTool defaultEmotions];
            break;
        case GYEmotionToolbarButtonTypeEmoji:
            self.listView.emotions = [GYEmotionTool emojiEmotions];
            break;
        case GYEmotionToolbarButtonTypeLxh:
            self.listView.emotions = [GYEmotionTool lxhEmotions];
            break;
        case GYEmotionToolbarButtonTypeRecent:
            self.listView.emotions = [GYEmotionTool recentEmotions];
            break;
            
        default:
            break;
    }
}

@end
