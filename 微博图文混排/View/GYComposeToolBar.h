//
//  GYComposeToolBar.h
//  全是微博
//
//  Created by 彭根勇 on 14-7-10.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    GYComposeToolBarButtonTypeCamera,   // 相机
    GYComposeToolBarButtonTypePicture,  // 相册
    GYComposeToolBarButtonTypeMention,  // 提到@
    GYComposeToolBarButtonTypeTrend,  // 话题
    GYComposeToolBarButtonTypeEmotion,  // 表情
} GYComposeToolBarButtonType;

@class GYComposeToolBar;

@protocol GYComposeToolBarDelegate <NSObject>

@optional

- (void)composeToolBar:(GYComposeToolBar *)toolBar DidClickButton:(GYComposeToolBarButtonType)buttonType;

@end

@interface GYComposeToolBar : UIView

@property (nonatomic, weak) id<GYComposeToolBarDelegate> delegate;

@end
