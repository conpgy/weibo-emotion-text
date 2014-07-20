//
//  GYEmotionTool.m
//  全是微博
//
//  Created by 彭根勇 on 14-7-18.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import "GYEmotionTool.h"
#import "GYEmotion.h"

#define GYRecentEmotionsFilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"recentEmotions.data"]

@implementation GYEmotionTool

/** 默认表情 */
static NSArray *_defaultEmotions;

/** emoji表情 */
static NSArray *_emojiEmotions;

/** 浪小花表情 */
static NSArray *_lxhEmotions;

/** 最近使用表情 */
static NSMutableArray *_recentEmotions;

+(NSArray *)defaultEmotions
{
    if (!_defaultEmotions) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/default/info.plist" ofType:nil];
        _defaultEmotions = [GYEmotion objectArrayWithFile:path];
        [_defaultEmotions makeObjectsPerformSelector:@selector(setDirectory:) withObject:@"EmotionIcons/default"];
    }
    
    return _defaultEmotions;
}

+(NSArray *)emojiEmotions
{
    if (!_emojiEmotions) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/emoji/info.plist" ofType:nil];
        _emojiEmotions = [GYEmotion objectArrayWithFile:path];
        [_emojiEmotions makeObjectsPerformSelector:@selector(setDirectory:) withObject:@"EmotionIcons/emoji"];
    }
    
    return _emojiEmotions;
}

+(NSArray *)lxhEmotions
{
    if (!_lxhEmotions) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/lxh/info.plist" ofType:nil];
        _lxhEmotions = [GYEmotion objectArrayWithFile:path];
        [_lxhEmotions makeObjectsPerformSelector:@selector(setDirectory:) withObject:@"EmotionIcons/lxh"];
    }
    
    return _lxhEmotions;
}

+(NSArray *)recentEmotions
{
    if (!_recentEmotions) {
        _recentEmotions = [NSKeyedUnarchiver unarchiveObjectWithFile:GYRecentEmotionsFilePath];
        
        // 如果从沙盒中没有读取到，则创建一个
        if (!_recentEmotions) {
            _recentEmotions = [NSMutableArray array];
        }
    }
    
    return _recentEmotions;
}

/**
 *  存储表情
 *
 *  @param emotion 表情
 */
+(void)addRecentEmotion:(GYEmotion *)emotion
{
    // 加载最近表情数据
    [self recentEmotions];
    
    // 删除之前的表情
    [_recentEmotions removeObject:emotion];
    
    // 插入表情到第一个
    [_recentEmotions insertObject:emotion atIndex:0];
    
    // 将表情存储到沙盒中
    [NSKeyedArchiver archiveRootObject:_recentEmotions toFile:GYRecentEmotionsFilePath];
}

+(GYEmotion *)emotionWithDesc:(NSString *)desc
{
    __block GYEmotion *foundEmotion = nil;

    // 遍历默认表情数组
    [[self defaultEmotions] enumerateObjectsUsingBlock:^(GYEmotion *emotion, NSUInteger idx, BOOL *stop) {
        if ([emotion.chs isEqualToString:desc] || [emotion.cht isEqualToString:desc]) {
            foundEmotion = emotion;
            *stop = YES;
        }
    }];
    
    if (foundEmotion) return foundEmotion;
    
    // 如果默认表情数组中没有，则在浪小花数组中查找
    [[self lxhEmotions] enumerateObjectsUsingBlock:^(GYEmotion *emotion, NSUInteger idx, BOOL *stop) {
        if ([emotion.chs isEqualToString:desc] || [emotion.cht isEqualToString:desc]) {
            foundEmotion = emotion;
            *stop = YES;
        }
    }];
    
    return foundEmotion;
}

@end
