//
//  DEImageUtility.m
//  PinFever
//
//  Created by David Ehlen on 29.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "DEImageUtility.h"

@implementation DEImageUtility


+(UIImage *)cropToJPEG:(UIImage *)image size:(CGSize)size quality:(CGFloat)quality {
    //TODO: resize to size
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    newImage = [UIImage imageWithData:UIImageJPEGRepresentation(newImage, quality)];
    
    return newImage;
}

@end
