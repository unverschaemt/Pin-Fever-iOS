//
//  DEImageUtility.h
//  PinFever
//
//  Created by David Ehlen on 29.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DEImageUtility : NSObject

//Crops to size and a specified quality
+(UIImage *)cropToJPEG:(UIImage *)image size:(CGSize)size quality:(CGFloat)quality;

@end
