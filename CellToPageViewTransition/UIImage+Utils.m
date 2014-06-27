//
//  UIImage+Utils.m
//  Steps-iOS
//
//  Created by Jack Shi on 8/06/2014.
//  Copyright (c) 2014 Jack Shi. All rights reserved.
//

#import "UIImage+Utils.h"

@implementation UIImage (Utils)

+ (UIImage *)splitImage:(UIImage *)image inRect:(CGRect)rect
{
    CGFloat scale = [UIScreen mainScreen].scale;
    CGImageRef tmpImageRef = image.CGImage;
    CGImageRef splitImageRef = CGImageCreateWithImageInRect(tmpImageRef, CGRectMake(rect.origin.x * scale, rect.origin.y * scale, rect.size.width * scale, rect.size.height * scale));
    UIImage *splitedImage = [UIImage imageWithCGImage:splitImageRef scale:scale orientation:UIImageOrientationUp];
    CGImageRelease(splitImageRef);
    return splitedImage;
}

@end
