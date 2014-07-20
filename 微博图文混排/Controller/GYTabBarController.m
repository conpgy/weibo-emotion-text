//
//  GYTabBarController.m
//  全是微博
//
//  Created by 彭根勇 on 14-7-3.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import "GYTabBarController.h"
#import "GYHomeViewController.h"
#import "GYTabBar.h"
#import "GYSendWeiboController.h"

@interface GYTabBarController ()<GYTabBarDelegate>

@property (nonatomic, weak) UITableViewController *home;
@property (nonatomic, weak) UITableViewController *msg;
@property (nonatomic, weak) UITableViewController *discover;
@property (nonatomic, weak) UITableViewController *profile;

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
    
}

- (void)addChildVcs
{
    GYHomeViewController *home = [[GYHomeViewController alloc] init];
    [self addChildVc:home title:@"首页" imageName:@"tabbar_home" selectedImageName:@"tabbar_home_selected"];
    
    UITableViewController *msg = [[UITableViewController alloc] init];
    [self addChildVc:msg title:@"消息" imageName:@"tabbar_message_center" selectedImageName:@"tabbar_message_center_selected"];
    
    UITableViewController *discover = [[UITableViewController alloc] init];
    [self addChildVc:discover title:@"发现" imageName:@"tabbar_discover" selectedImageName:@"tabbar_discover_selected"];
    
    UITableViewController *profile = [[UITableViewController alloc] init];
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
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
}

#pragma mark - GYTabBarDelegate

-(void)tabBarDidClickPlusButton:(GYTabBar *)tabBar
{
    GYSendWeiboController *composeVc = [[GYSendWeiboController alloc] init];
    composeVc.tabBarController.hidesBottomBarWhenPushed = YES;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:composeVc];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
