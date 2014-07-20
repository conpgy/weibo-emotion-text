//
//  GYEmotionDefault.h
//  全是微博
//
//  Created by 彭根勇 on 14-7-16.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYEmotion : NSObject<NSCoding>

/**
 *  表情文字
 */
@property (nonatomic, copy) NSString *chs;

/**
 *  表情文字(繁体)
 */
@property (nonatomic, copy) NSString *cht;

/**
 *  表情图片
 */
@property (nonatomic, copy) NSString *png;

/**
 *  表情编码
 */
@property (nonatomic, copy) NSString *code;

/**
 *  表情所在的目录
 */
@property (nonatomic, copy) NSString *directory;

/**
 *  Emoji表情字符
 */
@property (nonatomic, copy) NSString *emoji;


@end
