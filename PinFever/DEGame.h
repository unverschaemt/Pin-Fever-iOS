//
//  DEGame.h
//  PinFever
//
//  Created by David Ehlen on 31.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DEGame : NSObject

@property (nonatomic, copy) NSString *gameId;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *mode;
@property (nonatomic, copy) NSString *matchId;
@property (nonatomic, strong) NSArray *participants;
@property (nonatomic, copy) NSNumber *numberOfPlayers;
@property (nonatomic, copy) NSNumber *minLevel;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, strong) NSArray *turns;
@end
