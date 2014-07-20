//
//  GYTabBar.m
//  全是微博
//
//  Created by 彭根勇 on 14-7-7.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import "GYTabBar.h"

@interface GYTabBar ()

@property (nonatomic, weak) UIButton *plusButton;

@end

@implementation GYTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (!iOS7) {
            self.backgroundImage = [UIImage imageWithName:@"tabbar_background"];
        }
        self.selectionIndicatorImage  = [UIImage imageWithName:@"navigationbar_button_background"];
        
        // 添加加号按钮
        [self addPlusButton];
        
    }
    return self;
}

/**
 *  添加加号按钮
 */
- (void)addPlusButton
{
    UIButton *plusBtn = [[UIButton alloc] init];
    [plusBtn setBackgroundImage:[UIImage imageWithName:@"tabbar_compose_button"] forState:UIControlStateNormal];
    [plusBtn setBackgroundImage:[UIImage imageWithName:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
    [plusBtn setImage:[UIImage imageWithName:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
    [plusBtn setImage:[UIImage imageWithName:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
    // 设置监听器
    [plusBtn addTarget:self action:@selector(plusButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:plusBtn];
    self.plusButton = plusBtn;
}

- (void)plusButtonClick
{
    if ([self.tabBarDelegate respondsToSelector:@selector(tabBarDidClickPlusButton:)]) {
        [self.tabBarDelegate tabBarDidClickPlusButton:self];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    int index = 0;
    CGFloat buttonW = self.width / (self.items.count + 1);
    CGFloat buttonH = self.height;
    
    for (UIView *tabBarButton in self.subviews) {
        if (![tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) continue;
        
        tabBarButton.width = buttonW;
        tabBarButton.height = buttonH;
        
        tabBarButton.y = 0;
        if (index < 2) {
            tabBarButton.x = index * buttonW;
        } else {
            tabBarButton.x = buttonW * (index + 1);
        }
        index++;
    }
    
    // 设置plusButton的frame
    self.plusButton.size = self.plusButton.currentBackgroundImage.size;
    self.plusButton.center = CGPointMake(self.width * 0.5, self.height * 0.5);
}

@end
