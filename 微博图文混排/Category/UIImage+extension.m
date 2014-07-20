//
//  UIImage+extension.m
//  全是微博
//
//  Created by 彭根勇 on 14-7-3.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import "UIImage+extension.h"

@implementation UIImage (extension)

+ (UIImage *)imageWithName:(NSString *)imageName
{
    UIImage *image = nil;
    
    if (iOS7) {
        NSString *name = [imageName stringByAppendingString:@"_os7"];
        image = [UIImage imageNamed:name];
    }
    
    if (image == nil) {
        image = [UIImage imageNamed:imageName];
    }
    
    return image;
}

+(UIImage *)resizedImage:(NSString *)name
{
    UIImage *image = [UIImage imageWithName:name];
    
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}

@end
