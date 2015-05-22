//
//  DECategory.m
//  PinFever
//
//  Created by David Ehlen on 22.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "DECategory.h"

@implementation DECategory


-(id)initWithCategory:(NSString *)categoryName {
    self = [super init];
    if(self) {
        self.categoryName = categoryName;
    }
    return self;
}

@end
