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
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float maxHeight = size.height;
    float maxWidth = size.width;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    
    if (actualHeight > maxHeight || actualWidth > maxWidth){
        if(imgRatio < maxRatio){
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio){
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else{
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, quality);
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithData:imageData];
}

@end
