//
//  DEProfileManager.m
//  PinFever
//
//  Created by David Ehlen on 29.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "DEProfileManager.h"

@implementation DEProfileManager

+ (id)sharedManager {
    static DEProfileManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

@end
