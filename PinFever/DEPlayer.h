//
//  DEPlayer.h
//  PinFever
//
//  Created by David Ehlen on 21.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKIT/UIKIT.h>

@interface DEPlayer : NSObject <NSCoding>

@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, copy) NSString *playerId;
@property (nonatomic, strong) NSNumber *level;
@property (nonatomic, strong) UIImage *avatarImg;
@end
