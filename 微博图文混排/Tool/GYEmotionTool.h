//
//  GYEmotionTool.h
//  全是微博
//
//  Created by 彭根勇 on 14-7-18.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GYEmotion;

@interface GYEmotionTool : NSObject

/**
 *  默认表情
 */
+ (NSArray *)defaultEmotions;

/**
 *  Emoji表情
 */
+ (NSArray *)emojiEmotions;

/**
 *  浪小花表情
 */
+ (NSArray *)lxhEmotions;

/**
 *  最近使用表情
 */
+ (NSArray *)recentEmotions;

/**
 *  保存最近使用的表情
 */
+ (void)addRecentEmotion:(GYEmotion *)emotion;

/**
 *  根据图片描述找出对应的表情对象
 */
+ (GYEmotion *)emotionWithDesc:(NSString *)desc;

@end
