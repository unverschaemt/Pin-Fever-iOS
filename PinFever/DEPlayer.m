//
//  DEPlayer.m
//  PinFever
//
//  Created by David Ehlen on 21.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "DEPlayer.h"

@implementation DEPlayer


#define kEncodeIdKey               @"kEncodeIdKey"
#define kEncodeDisplayNameKey      @"kEncodeDisplayNameKey"
#define kEncodeEmailKey            @"kEncodeEmailKey"
#define kEncodeLevelKey            @"kEncodeLevelKey"
#define kEncodeAvatarImgKey        @"kEncodeAvatarImgKey"



#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.playerId   forKey:kEncodeIdKey];
    [aCoder encodeObject:self.displayName forKey:kEncodeDisplayNameKey];
    [aCoder encodeObject:self.email forKey:kEncodeEmailKey];
    [aCoder encodeObject:self.level forKey:kEncodeLevelKey];
    [aCoder encodeObject:UIImagePNGRepresentation(self.avatarImg) forKey:kEncodeAvatarImgKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init]))
    {
        self.playerId = [aDecoder decodeObjectForKey:kEncodeIdKey];
        self.displayName = [aDecoder decodeObjectForKey:kEncodeDisplayNameKey];
        self.email   = [aDecoder decodeObjectForKey:kEncodeEmailKey];
        self.level   = [aDecoder decodeObjectForKey:kEncodeLevelKey];
        self.avatarImg = [UIImage imageWithData:[aDecoder decodeObjectForKey:kEncodeAvatarImgKey]];
    }
    return self;
}


@end
