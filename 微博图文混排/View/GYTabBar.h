//
//  GYTabBar.h
//  全是微博
//
//  Created by 彭根勇 on 14-7-7.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYTabBar;

@protocol GYTabBarDelegate <NSObject>

@optional
- (void)tabBarDidClickPlusButton:(GYTabBar *)tabBar;

@end

@interface GYTabBar : UITabBar

@property (nonatomic, weak) id<GYTabBarDelegate> tabBarDelegate;

@end
