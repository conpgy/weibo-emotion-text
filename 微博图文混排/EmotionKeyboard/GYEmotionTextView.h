//
//  GYEmotionTextView.h
//  全是微博
//
//  Created by 彭根勇 on 14-7-18.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import "GYTextView.h"
@class GYEmotion;

@interface GYEmotionTextView : GYTextView

/**
 *  给文本添加表情
 */
- (void)appendEmotion:(GYEmotion *)emotion;

/**
 *  微博文字内容，如果文本中有富文本，则会将富文本转换为文字描述
 */
- (NSString *)realText;

@end
