//
//  GYEmotionGlassView.m
//  全是微博
//
//  Created by 彭根勇 on 14-7-17.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import "GYEmotionGlassView.h"
#import "GYEmotionView.h"
#import "GYEmotion.h"

@interface GYEmotionGlassView ()
@property (weak, nonatomic) IBOutlet GYEmotionView *emotionView;

@end

@implementation GYEmotionGlassView

+(instancetype)glassView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"GYEmotionGlassView" owner:nil options:nil] lastObject];
}

-(void)showFromEmotionView:(GYEmotionView *)fromEmotionView
{
    if (fromEmotionView == nil) return;
    
    self.emotionView.emotion = fromEmotionView.emotion;
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self];
    
    CGFloat centerX = fromEmotionView.center.x;
    CGFloat centerY = fromEmotionView.center.y - self.height * 0.5;
    CGPoint center = CGPointMake(centerX, centerY);
    self.center = [window convertPoint:center fromView:fromEmotionView.superview];
}

-(void)dismiss
{
    [self removeFromSuperview];
}

@end
