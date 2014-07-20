//
//  GYEmotionGlassView.h
//  全是微博
//
//  Created by 彭根勇 on 14-7-17.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYEmotionView;

@interface GYEmotionGlassView : UIView

+ (instancetype)glassView;

-(void)dismiss;

- (void)showFromEmotionView:(GYEmotionView *)fromEmotionView;
@end
