//
//  GYTextAttachment.m
//  全是微博
//
//  Created by 彭根勇 on 14-7-19.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import "GYEmotionAttachment.h"
#import "GYEmotion.h"

@implementation GYEmotionAttachment

-(void)setEmotion:(GYEmotion *)emotion
{
    _emotion = emotion;
    
    self.image = [UIImage imageWithName:[NSString stringWithFormat:@"%@/%@", emotion.directory, emotion.png]];
}

@end
