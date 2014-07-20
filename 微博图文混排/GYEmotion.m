//
//  GYEmotionDefault.m
//  全是微博
//
//  Created by 彭根勇 on 14-7-16.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import "GYEmotion.h"
#import "NSString+Emoji.h"

@implementation GYEmotion

-(void)setCode:(NSString *)code
{
    _code = code;
    
    if(code == nil) return;
    self.emoji = [NSString emojiWithStringCode:code];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.chs = [aDecoder decodeObjectForKey:@"chs"];
        self.cht = [aDecoder decodeObjectForKey:@"cht"];
        self.png = [aDecoder decodeObjectForKey:@"png"];
        self.emoji = [aDecoder decodeObjectForKey:@"emoji"];
        self.code = [aDecoder decodeObjectForKey:@"code"];
        self.directory = [aDecoder decodeObjectForKey:@"directory"];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.chs forKey:@"chs"];
    [aCoder encodeObject:self.cht forKey:@"cht"];
    [aCoder encodeObject:self.png forKey:@"png"];
    [aCoder encodeObject:self.emoji forKey:@"emoji"];
    [aCoder encodeObject:self.code forKey:@"code"];
    [aCoder encodeObject:self.directory forKey:@"directory"];
}

/**
 *  两个对象进行比较
 */
-(BOOL)isEqual:(GYEmotion *)otherEmotion
{
    if (otherEmotion.code) {
        return [self.code isEqualToString:otherEmotion.code];
    } else {
        return ([self.png isEqualToString:otherEmotion.png] && [self.chs isEqualToString:otherEmotion.chs] && [self.cht isEqualToString:otherEmotion.cht]);
    }
}

@end
