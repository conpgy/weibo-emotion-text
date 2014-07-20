//
//  GYEmotionToolbar.h
//  全是微博
//
//  Created by 彭根勇 on 14-7-16.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYEmotionToolbar;

typedef enum {
    GYEmotionToolbarButtonTypeRecent,
    GYEmotionToolbarButtonTypeDefault,
    GYEmotionToolbarButtonTypeEmoji,
    GYEmotionToolbarButtonTypeLxh
}GYEmotionToolbarButtonType;

@protocol GYEmotionToolbarDelegate <NSObject>

- (void)emotionToolbar:(GYEmotionToolbar *)toolbar DidSelectedBtn:(GYEmotionToolbarButtonType)type;

@end

@interface GYEmotionToolbar : UIView

@property (nonatomic, weak) id<GYEmotionToolbarDelegate> delegate;


@end
