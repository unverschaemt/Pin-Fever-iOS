//
//  DEAnimator.h
//  PinFever
//
//  Created by David Ehlen on 28.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PlayerCollectionViewCell.h"

@interface DEAnimator : NSObject

-(void)startShivering:(PlayerCollectionViewCell *)cell;
-(void)stopShivering:(PlayerCollectionViewCell *)cell;

@end
