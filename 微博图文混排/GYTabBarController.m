//
//  GYTabBarController.m
//  全是微博
//
//  Created by 彭根勇 on 14-7-3.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import "GYTabBarController.h"
#import "GYNavigationController.h"
#import "GYHomeViewController.h"
#import "GYMessageViewController.h"
#import "GYDiscoverViewController.h"
#import "GYProfileViewController.h"
#import "GYTabBar.h"
#import "GYComposeViewController.h"
#import "GYUnreadCountParam.h"
#import "GYUnreadCountResult.h"
#import "GYAccountTool.h"
#import "GYAccount.h"
#import "GYUserTool.h"

@interface GYTabBarController ()<GYTabBarDelegate>

@property (nonatomic, weak) GYHomeViewController *home;
@property (nonatomic, weak) GYMessageViewController *msg;
@property (nonatomic, weak) GYDiscoverViewController *discover;
@property (nonatomic, weak) GYProfileViewController *profile;

@end

@implementation GYTabBarController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addChildVcs];
    
    // 设置tabBar为自定义的GYTabBar
    GYTabBar *customTabBar = [[GYTabBar alloc] init];
    customTabBar.tabBarDelegate = self;
    [self setValue:customTabBar forKeyPath:@"tabBar"];
    
    // 利用定时器获得用户的未读数
    NSTimer *timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(getUnreadCount) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

/**
 *  得到未读数
 */

- (void)getUnreadCount
{
    // 设置请求参数
    GYUnreadCountParam *param = [GYUnreadCountParam param];
    param.uid = [GYAccountTool account].uid;
    
    // 获得未读数
    [GYUserTool unreadCountWithParam:param success:^(GYUnreadCountResult *result) {
        // 显示微博未读数
        if (result.status == 0) {
            self.home.tabBarItem.badgeValue = nil;
        } else {
            self.home.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", result.status];
        }
        
        // 显示消息未读数
        if (result.messageCount == 0) {
            self.msg.tabBarItem.badgeValue = nil;
        } else {
            self.msg.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", result.messageCount];
        }
        
        // 显示新粉丝数
        if (result.follower == 0) {
            self.profile.tabBarItem.badgeValue = nil;
        } else {
            self.profile.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", result.follower];
        }
        
        // 在图标上显示所有的未读数
        [UIApplication sharedApplication].applicationIconBadgeNumber = result.totalCount;
    } failure:^(NSError *error) {
        GYLog(@"获得未读数失败%@", error);
    }];
}

- (void)addChildVcs
{
    GYHomeViewController *home = [[GYHomeViewController alloc] init];
    self.home = home;
    [self addChildVc:home title:@"首页" imageName:@"tabbar_home" selectedImageName:@"tabbar_home_selected"];
    
    GYMessageViewController *msg = [[GYMessageViewController alloc] init];
    self.msg = msg;
    [self addChildVc:msg title:@"消息" imageName:@"tabbar_message_center" selectedImageName:@"tabbar_message_center_selected"];
    
    GYDiscoverViewController *discover = [[GYDiscoverViewController alloc] init];
    self.discover = discover;
    [self addChildVc:discover title:@"发现" imageName:@"tabbar_discover" selectedImageName:@"tabbar_discover_selected"];
    
    GYProfileViewController *profile = [[GYProfileViewController alloc] init];
    self.profile = profile;
    [self addChildVc:profile title:@"我" imageName:@"tabbar_profile" selectedImageName:@"tabbar_profile_selected"];
}

- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    childVc.title = title;
    
    childVc.tabBarItem.image = [UIImage imageWithName:imageName];
    UIImage *selectedImage = [UIImage imageWithName:selectedImageName];
    
    // 这只tabBarButton的文字属性
    [childVc.tabBarItem setTitleTextAttributes:@{UITextAttributeFont: [UIFont systemFontOfSize:10], UITextAttributeTextColor: [UIColor blackColor]} forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:@{UITextAttributeFont: [UIFont systemFontOfSize:10], UITextAttributeTextColor: [UIColor orangeColor]} forState:UIControlStateSelected];
    
    if (iOS7) {
        // 声明这张图片为原图，不要渲染
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    childVc.tabBarItem.selectedImage = selectedImage;
    
    GYNavigationController *nav = [[GYNavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
}

#pragma mark - GYTabBarDelegate

-(void)tabBarDidClickPlusButton:(GYTabBar *)tabBar
{
    GYComposeViewController *composeVc = [[GYComposeViewController alloc] init];
    GYNavigationController *nav = [[GYNavigationController alloc] initWithRootViewController:composeVc];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
