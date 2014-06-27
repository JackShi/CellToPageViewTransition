//
//  PageViewToCellAnimation.h
//  Steps-iOS
//
//  Created by Jack Shi on 27/06/2014.
//  Copyright (c) 2014 Jack Shi. All rights reserved.
//

#import "BaseAnimation.h"
#import "UIImage+Utils.h"

@interface PageViewToCellAnimation : BaseAnimation <UIViewControllerInteractiveTransitioning>

- (instancetype)initWithNavigationController:(UINavigationController *)controller;

@property (nonatomic, assign) UINavigationController *navigationController;
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactiveTransition;
@property (nonatomic, assign, getter = isInteractive) BOOL interactive;

@property (nonatomic, strong) UIView *sourceView;

@end
