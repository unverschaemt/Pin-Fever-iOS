//
//  DEUtility.m
//  PinFever
//
//  Created by David Ehlen on 01.06.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "DEUtility.h"

@implementation DEUtility


+ (NSDate*) dateFromJSONString:(NSString *)dateString
{
    NSCharacterSet *charactersToRemove = [[ NSCharacterSet decimalDigitCharacterSet ] invertedSet ];
    NSString* milliseconds = [dateString stringByTrimmingCharactersInSet:charactersToRemove];
    
    if (milliseconds != nil && ![milliseconds isEqualToString:@"62135596800000"]) {
        NSTimeInterval  seconds = [milliseconds doubleValue] / 1000;
        return [NSDate dateWithTimeIntervalSince1970:seconds];
    }
    return nil;
}

@end
