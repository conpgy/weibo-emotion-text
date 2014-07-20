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

@interface GYHomeViewController ()

/**
 *  展示微博的标签
 */
@property (nonatomic, weak) UILabel *statusLabel;

@end

@implementation GYHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 添加一个textLabel用来存放微博
    UILabel *statusLabel = [[UILabel alloc] init];
    self.statusLabel = statusLabel;
    
    // 设置相关属性
    [self.view addSubview:statusLabel];
    statusLabel.frame = CGRectMake(0, 64, 320, 320);
    statusLabel.font = GYStatusTextFont;
    statusLabel.numberOfLines = 0;
    statusLabel.backgroundColor = [UIColor lightGrayColor];
    
    // 监听微博发送通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayStatus:) name:GYSendWeiboNotification object:nil];
}

- (void)displayStatus:(NSNotification *)note
{
    NSString *status = note.userInfo[GYStatusContent];
    NSLog(@"%@", status);
    
    // 将带有表情描述的普通文本转换为富文本
    self.statusLabel.attributedText = [self attributeTextWithText:status];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  将带有表情描述的普通文本转换为富文本
 */
- (NSAttributedString *)attributeTextWithText:(NSString *)text
{
    NSMutableAttributedString *attributeText = [[NSMutableAttributedString alloc] init];
    
    // 根据本文计算出匹配结果
    NSArray *regexResults = [self regexResultsWithText:text];
    
    // 根据匹配结果拼接文本
    [regexResults enumerateObjectsUsingBlock:^(GYRegexResult *regexResult, NSUInteger idx, BOOL *stop) {
        if (regexResult.isEmotion) {    // 表情
            GYEmotionAttachment *attachment = [[GYEmotionAttachment alloc] init];
            attachment.emotion = [GYEmotionTool emotionWithDesc:regexResult.string];
            attachment.bounds = CGRectMake(0, -3, GYStatusTextFont.lineHeight, GYStatusTextFont.lineHeight);
            NSAttributedString *subStr = [NSAttributedString attributedStringWithAttachment:attachment];
            
            [attributeText appendAttributedString:subStr];
        } else {    // 非表情, 普通文本
            NSMutableAttributedString *subStr = [[NSMutableAttributedString alloc] initWithString:regexResult.string];
            
            [attributeText appendAttributedString:subStr];
        }
    }];
    
    
    // 设置字体
    [attributeText addAttribute:NSFontAttributeName value:GYStatusTextFont range:NSMakeRange(0, attributeText.length)];
    
    return attributeText;
}

/**
 *  根据文本计算出匹配结果
 *
 *  @param text 文本
 *
 *  @return 匹配结果数组
 */
- (NSArray *)regexResultsWithText:(NSString *)text
{
    // 存储匹配结果
    NSMutableArray *results = [NSMutableArray array];
    
    // 设置表情匹配格式
    NSString *emotionRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    
    //遍历文本，根据表情格式匹配表情
    [text enumerateStringsMatchedByRegex:emotionRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        
        GYRegexResult *regexR = [[GYRegexResult alloc] init];
        regexR.string = *capturedStrings;
        regexR.range = *capturedRanges;
        regexR.emotion = YES;
        
        [results addObject:regexR];
    }];
    
    //遍历文本，根据表情格式匹配非表情
    [text enumerateStringsSeparatedByRegex:emotionRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        
        GYRegexResult *regexR = [[GYRegexResult alloc] init];
        regexR.string = *capturedStrings;
        regexR.range = *capturedRanges;
        regexR.emotion = NO;
        
        [results addObject:regexR];
    }];
    
    // 对匹配结果进行排序,(根据range的location，从小到大)
    [results sortUsingComparator:^NSComparisonResult(GYRegexResult *r1, GYRegexResult *r2) {
        int loc1 = r1.range.location;
        int loc2 = r2.range.location;
        
        return [@(loc1) compare:@(loc2)];
    }];
    
    return results;
}

@end
