//
//  GYTextView.m
//  全是微博
//
//  Created by 彭根勇 on 14-7-10.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import "GYTextView.h"

@interface GYTextView ()

@property (nonatomic, weak) UILabel *placeLabel;


@end

@implementation GYTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 添加placeholder标签
        UILabel *placeLabel = [[UILabel alloc] init];
        [self addSubview:placeLabel];
        self.placeLabel = placeLabel;
        // 设置默认的占位文字
//        placeLabel.text = @"分享新鲜事";
        placeLabel.textColor = [UIColor lightGrayColor];
        placeLabel.numberOfLines = 0;
        
        self.font = [UIFont systemFontOfSize:15];
        
        // 监听通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

-(void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    
    self.placeLabel.text = placeholder;
    
    [self setNeedsLayout];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    self.placeLabel.textColor = _placeholderColor;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置placeholder的frame
    self.placeLabel.x = 5;
    self.placeLabel.y = 8;
    self.placeLabel.width = self.width - 2 * self.placeLabel.x;
    
    CGSize maxSize = CGSizeMake(self.placeLabel.width, MAXFLOAT);
    CGSize placeholderSize = [self.placeholder sizeWithFont:self.placeLabel.font constrainedToSize:maxSize];
    self.placeLabel.height = placeholderSize.height;
}

-(void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    self.placeLabel.font = font;
    
    [self setNeedsLayout];
}

-(void)setText:(NSString *)text
{
    [super setText:text];
    
    [self textDidChange];
}

-(void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    
    [self textDidChange];
}

#pragma mark - 监听文字改变

- (void)textDidChange
{
    self.placeLabel.hidden = self.hasText;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
