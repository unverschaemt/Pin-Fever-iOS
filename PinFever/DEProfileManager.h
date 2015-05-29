//
//  DEProfileManager.h
//  PinFever
//
//  Created by David Ehlen on 29.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DEPlayer.h"

@interface DEProfileManager : NSObject

@property (nonatomic, strong) DEPlayer *me;

+ (id)sharedManager;

@end
