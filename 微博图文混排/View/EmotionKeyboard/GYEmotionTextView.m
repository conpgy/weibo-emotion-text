//
//  GYEmotionTextView.m
//  全是微博
//
//  Created by 彭根勇 on 14-7-18.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import "GYEmotionTextView.h"
#import "GYEmotion.h"
#import "GYEmotionAttachment.h"

@implementation GYEmotionTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/**
 *  在微博编辑框添加表情时调用
 *
 *  @param emotion 添加的表情
 */
-(void)appendEmotion:(GYEmotion *)emotion
{
    if (emotion.code) { // Emoji表情
        [self insertText:emotion.emoji];
    } else { // 图片表情
        NSMutableAttributedString *attributeText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        
        // 创建一个带有图片表情的富文本
        GYEmotionAttachment *attachment = [[GYEmotionAttachment alloc] init];
        attachment.emotion = emotion;
        NSString *name = [NSString stringWithFormat:@"%@/%@", emotion.directory, emotion.png];
        attachment.image = [UIImage imageWithName:name];
        attachment.bounds = CGRectMake(0, -3, self.font.lineHeight, self.font.lineHeight);
        NSAttributedString *emotionStr = [NSMutableAttributedString attributedStringWithAttachment: attachment];
        
        // 记录表情的插入位置
        int insertIndex = self.selectedRange.location;
        // 插入表情到光标所在的位置
        [attributeText insertAttributedString:emotionStr atIndex:insertIndex];
        
        // 设置字体
        [attributeText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributeText.length)];
        
        self.attributedText = attributeText;
        
        // 让光标回到新插入表情的后面
        self.selectedRange = NSMakeRange(insertIndex + 1, 0);
    }
    
}

-(NSString *)realText
{
    NSMutableString *string = [NSMutableString string];
    
    // 获得微博编辑框的富文本
    NSAttributedString *attributeText = self.attributedText;
    
    // 遍历富文本，将表情转换为文字描述
    [attributeText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        GYEmotionAttachment *attachment = attrs[@"NSAttachment"];
        if (attachment) {   //有表情
            [string appendString:attachment.emotion.chs];
        } else {    // 没有表情
            // 根据range范围获得富文本的文字内容
            NSString *subStr = [attributeText attributedSubstringFromRange:range].string;
            [string appendString:subStr];
        }
    }];
    
    return string;
}

@end
