//
//  DENotificationStylesheet.h
//  PinFever
//
//  Created by David Ehlen on 11.06.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TWMessageBarManager/TWMessageBarManager.h>

@interface DENotificationStylesheet : NSObject <TWMessageBarStyleSheet>

+ (DENotificationStylesheet *)styleSheet;

@end
