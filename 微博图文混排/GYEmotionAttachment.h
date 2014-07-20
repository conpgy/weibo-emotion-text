//
//  GYTextAttachment.h
//  全是微博
//
//  Created by 彭根勇 on 14-7-19.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYEmotion;

@interface GYEmotionAttachment : NSTextAttachment

/**
 *  表情
 */
@property (nonatomic, strong) GYEmotion *emotion;

@end
