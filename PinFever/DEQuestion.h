//
//  DEQuestion.h
//  PinFever
//
//  Created by David Ehlen on 02.06.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DEAnswer.h"

@interface DEQuestion : NSObject

@property (nonatomic, copy) NSString *question;
@property (nonatomic, strong) DEAnswer *answer;
@property (nonatomic, copy) NSString *categoryId;
@end
