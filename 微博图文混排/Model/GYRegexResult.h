//
//  GYRegexResult.h
//  全是微博
//
//  Created by 彭根勇 on 14-7-19.
//  Copyright (c) 2014年 conpgy. All rights reserved.
// 用来封装一个匹配结果

#import <Foundation/Foundation.h>

@interface GYRegexResult : NSObject

/**
 *  匹配到的字符串
 */
@property (nonatomic, copy) NSString *string;

/**
 *  匹配的范围
 */
@property (nonatomic, assign) NSRange range;

/**
 *  是否为表情
 */
@property (nonatomic, assign, getter = isEmotion) BOOL emotion;


@end
