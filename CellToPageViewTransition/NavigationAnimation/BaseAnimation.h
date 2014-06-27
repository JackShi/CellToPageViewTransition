//  BaseAnimation.h
//  Steps-iOS
//
//  Created by Jack Shi on 26/06/2014.
//  Copyright (c) 2014 Jack Shi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GestureRecognizerDelegate <NSObject>

- (void)handlePinch:(UIPinchGestureRecognizer *)gestureRecognizer;

@end

@interface BaseAnimation : NSObject <UIViewControllerAnimatedTransitioning, GestureRecognizerDelegate>

@end
