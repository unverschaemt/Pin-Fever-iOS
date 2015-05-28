//
//  DEAnimator.m
//  PinFever
//
//  Created by David Ehlen on 28.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "DEAnimator.h"

@implementation DEAnimator

#define kWiggleBounceY 2.0f
#define kWiggleBounceDuration 0.12
#define kWiggleBounceDurationVariance 0.025

#define kWiggleRotateAngle 0.08f
#define kWiggleRotateDuration 0.1
#define kWiggleRotateDurationVariance 0.025


#pragma mark -
#pragma mark Delete Animations

-(CAAnimation*)rotationAnimation {
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.values = @[@(-kWiggleRotateAngle), @(kWiggleRotateAngle)];
    
    animation.autoreverses = YES;
    animation.duration = [self randomizeInterval:kWiggleRotateDuration
                                    withVariance:kWiggleRotateDurationVariance];
    animation.repeatCount = HUGE_VALF;
    
    return animation;
}

-(CAAnimation*)bounceAnimation {
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.values = @[@(kWiggleBounceY), @(0.0)];
    
    animation.autoreverses = YES;
    animation.duration = [self randomizeInterval:kWiggleBounceDuration
                                    withVariance:kWiggleBounceDurationVariance];
    animation.repeatCount = HUGE_VALF;
    
    return animation;
}

-(NSTimeInterval)randomizeInterval:(NSTimeInterval)interval withVariance:(double)variance {
    double random = (arc4random_uniform(1000) - 500.0) / 500.0;
    return interval + variance * random;
}

-(void)startShivering:(PlayerCollectionViewCell *)cell {
    [UIView animateWithDuration:0
                     animations:^{
                         [cell.layer addAnimation:[self rotationAnimation] forKey:@"rotation"];
                         [cell.layer addAnimation:[self bounceAnimation] forKey:@"bounce"];
                         cell.transform = CGAffineTransformIdentity;
                     }];
}

-(void)stopShivering:(PlayerCollectionViewCell *)cell {
    [cell.layer removeAnimationForKey:@"rotation"];
    [cell.layer removeAnimationForKey:@"bounce"];
}

@end
