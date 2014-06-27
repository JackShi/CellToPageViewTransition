//
//  BaseAnimation.m
//  Steps-iOS
//
//  Created by Jack Shi on 26/06/2014.
//  Copyright (c) 2014 Jack Shi. All rights reserved.
//

#import "BaseAnimation.h"

@implementation BaseAnimation

#pragma mark - UIViewControllerAnimatedTransitioning

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    NSAssert(NO, @"animateTransition: should be handled by subclass of BaseAnimation");
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 1.0;
}

-(void)handlePinch:(UIPinchGestureRecognizer *)pinch {
    NSAssert(NO, @"handlePinch: should be handled by a subclass of BaseAnimation");
}

@end
