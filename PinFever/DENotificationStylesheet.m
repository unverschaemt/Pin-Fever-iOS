//
//  DENotificationStylesheet.m
//  PinFever
//
//  Created by David Ehlen on 11.06.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "DENotificationStylesheet.h"

@implementation DENotificationStylesheet

#pragma mark - Alloc/Init

+ (DENotificationStylesheet *)styleSheet
{
    return [[DENotificationStylesheet alloc] init];
}

#pragma mark - TWMessageBarStyleSheet

- (UIColor *)backgroundColorForMessageType:(TWMessageBarMessageType)type
{
    UIColor *backgroundColor = nil;
    switch (type)
    {
        case TWMessageBarMessageTypeError:
            backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.75];
            break;
        case TWMessageBarMessageTypeSuccess:
            backgroundColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.75];
            break;
        case TWMessageBarMessageTypeInfo:
            backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.7];
            break;
        default:
            break;
    }
    return backgroundColor;
}

- (UIColor *)strokeColorForMessageType:(TWMessageBarMessageType)type
{
    UIColor *strokeColor = nil;
    switch (type)
    {
        case TWMessageBarMessageTypeError:
            strokeColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
            break;
        case TWMessageBarMessageTypeSuccess:
            strokeColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0];
            break;
        case TWMessageBarMessageTypeInfo:
            strokeColor = [UIColor colorWithWhite:1.0 alpha:0.7];
            break;
        default:
            break;
    }
    return strokeColor;
}

- (UIImage *)iconImageForMessageType:(TWMessageBarMessageType)type
{
    return nil;
}

- (UIFont *)titleFontForMessageType:(TWMessageBarMessageType)type
{
    return [UIFont fontWithName:@"AvenirNext-DemiBold" size:16.0f];
}

- (UIFont *)descriptionFontForMessageType:(TWMessageBarMessageType)type
{
    return [UIFont fontWithName:@"AvenirNext-Regular" size:14.0f];
}

- (UIColor *)titleColorForMessageType:(TWMessageBarMessageType)type
{
    return [UIColor blackColor];
}

- (UIColor *)descriptionColorForMessageType:(TWMessageBarMessageType)type
{
    return [UIColor grayColor];
}

@end
