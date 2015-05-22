//
//  DECategory.h
//  PinFever
//
//  Created by David Ehlen on 22.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DECategory : NSObject

@property (nonatomic,copy) NSString *categoryName;

-(id)initWithCategory:(NSString *)categoryName;

@end
