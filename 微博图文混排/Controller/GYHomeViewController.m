//
//  GYHomeViewController.m
//  微博图文混排
//
//  Created by 彭根勇 on 14-7-19.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import "GYHomeViewController.h"
#import "GYEmotionAttachment.h"
#import "RegexKitLite.h"
#import "GYEmotionTool.h"
#import "GYRegexResult.h"
#import "GYStatusView.h"

@interface GYHomeViewController ()

@end

@implementation GYHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 添加一个statusView
    GYStatusView *statusView = [[GYStatusView alloc] init];
    statusView.frame = self.view.bounds;
    [self.view addSubview:statusView];
}

@end
