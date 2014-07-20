//
//  GYEmotionView.m
//  全是微博
//
//  Created by 彭根勇 on 14-7-17.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import "GYEmotionView.h"
#import "GYEmotion.h"

@implementation GYEmotionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

-(void)setEmotion:(GYEmotion *)emotion
{
    _emotion = emotion;
    
    if (emotion.code) {
        // 取消动画效果
        [UIView setAnimationsEnabled:NO];
        
        [self setImage:nil forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:32];
        [self setTitle:emotion.emoji forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        //0.1s后再次开启动画
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView setAnimationsEnabled:YES];
        });
    } else {
        [self setTitle:nil forState:UIControlStateNormal];
        NSString *name = [NSString stringWithFormat:@"%@/%@", emotion.directory, emotion.png];
        UIImage *image = [UIImage imageNamed:name];
        if (iOS7) {
            image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        [self setImage:image forState:UIControlStateNormal];
    }
}

@end
