//
//  PageViewToCellAnimation.m
//  Steps-iOS
//
//  Created by Jack Shi on 27/06/2014.
//  Copyright (c) 2014 Jack Shi. All rights reserved.
//

#import "PageViewToCellAnimation.h"

#define ALPHA_SHOWN   1.0
#define ALPHA_HIDDEN  0.0

@interface PageViewToCellAnimation()
{
    CGFloat startScale;
    BOOL shouldCompleteTransition;
}

@end

@implementation PageViewToCellAnimation

- (instancetype)initWithNavigationController:(UINavigationController *)controller
{
    self = [super init];
    if (self) {
        self.navigationController = controller;
    }
    return self;
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *pageViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *cellViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *cellView = cellViewController.view;
    UIView *pageView = pageViewController.view;
    
    cellView.frame = [transitionContext finalFrameForViewController:cellViewController];
    
    // add the to cellViewController's view to the intermediate view (where it has to be at the
    // end of the transition anyway). We'll hide it during the transition with
    // a blank view. This ensures that renderInContext of the 'To' view will
    // always render correctly
    [transitionContext.containerView addSubview:cellViewController.view];
    
    CGFloat navigationBarHeight = cellViewController.navigationController.navigationBar.frame.size.height;
    CGFloat cellViewStartPositionY = [UIApplication sharedApplication].statusBarFrame.size.height + navigationBarHeight;
    CGFloat viewWidth = cellView.frame.size.width;
    CGFloat viewHeight = cellView.frame.size.height;
    
    // get the rect of the source cell in the coords of the cell view
    CGRect sourceRect = [cellView convertRect:self.sourceView.bounds fromView:self.sourceView];
    
    // Take a snapshot of the page view and cell view
    // use renderInContext: instead of the new iOS7 snapshot API as that
    // only works for views that are currently visible in the view hierarchy
    UIGraphicsBeginImageContextWithOptions(pageView.bounds.size, pageView.opaque, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [pageView.layer renderInContext:ctx];
    UIImage *pageViewSnapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContextWithOptions(cellView.bounds.size, cellView.opaque, 0);
    ctx = UIGraphicsGetCurrentContext();
    [cellView.layer renderInContext:ctx];
    UIImage *cellViewSnapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // split the image into three parts: above cell, cell and below cell
    UIImage *aboveCellImage = [UIImage splitImage:cellViewSnapshot inRect:CGRectMake(0, 0, cellViewSnapshot.size.width, sourceRect.origin.y)];
    UIImage *cellImage = [UIImage splitImage:cellViewSnapshot inRect:CGRectMake(0, sourceRect.origin.y, cellViewSnapshot.size.width, sourceRect.size.height)];
    UIImage *belowCellImage = [UIImage splitImage:cellViewSnapshot inRect:CGRectMake(0, sourceRect.origin.y + sourceRect.size.height, cellViewSnapshot.size.width, cellViewSnapshot.size.height - sourceRect.origin.y - sourceRect.size.height)];
    
    UIImageView *aboveCellImageView = [[UIImageView alloc] initWithImage:aboveCellImage];
    UIImageView *cellImageView = [[UIImageView alloc] initWithImage:cellImage];
    UIImageView *belowCellImageView = [[UIImageView alloc] initWithImage:belowCellImage];
    
    // image views start position
    CGRect aboveCellImageViewShownFrame = CGRectMake(0, cellViewStartPositionY, cellViewSnapshot.size.width, sourceRect.origin.y);
    CGRect cellImageViewShownFrame = CGRectMake(0, cellViewStartPositionY + sourceRect.origin.y,  sourceRect.size.width, sourceRect.size.height);
    CGRect belowCellImageViewShownFrame = CGRectMake(0, cellViewStartPositionY + sourceRect.origin.y + sourceRect.size.height, cellViewSnapshot.size.width, cellViewSnapshot.size.height - sourceRect.origin.y - sourceRect.size.height);
    
    // image views end position
    CGRect aboveCellImageViewHiddenFrame = aboveCellImageViewShownFrame;
    aboveCellImageViewHiddenFrame.origin.y = cellViewStartPositionY - sourceRect.origin.y;
    
    CGRect cellImageViewHiddenFrame = cellImageViewShownFrame;
    cellImageViewHiddenFrame.origin.y = cellViewStartPositionY;
    
    CGRect belowCellImageViewHiddenFrame = belowCellImageViewShownFrame;
    belowCellImageViewHiddenFrame.origin.y = cellViewStartPositionY + cellViewSnapshot.size.height;
    
    // init image views before animation
    aboveCellImageView.frame = aboveCellImageViewHiddenFrame;
    cellImageView.frame = cellImageViewHiddenFrame;
    belowCellImageView.frame = belowCellImageViewHiddenFrame;
    
    // set cell image view alpha
    cellImageView.alpha = ALPHA_HIDDEN;
    
    // put a overlay to hide from view
    UIView *backgroundView = [[UIView alloc] initWithFrame:transitionContext.containerView.frame];
    backgroundView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    // set up page view
    UIImageView *pageImageView = [[UIImageView alloc] initWithImage:pageViewSnapshot];
    
    CGRect pageViewShownFrame = CGRectMake(cellImageView.frame.origin.x, cellViewStartPositionY + sourceRect.origin.y, viewWidth, viewHeight);
    CGRect pageViewHiddenFrame = pageViewShownFrame;
    pageViewHiddenFrame.origin.y = cellViewStartPositionY;
    pageImageView.frame = pageViewHiddenFrame;
    pageImageView.alpha = ALPHA_SHOWN;
    
    [transitionContext.containerView addSubview:backgroundView];
    [transitionContext.containerView addSubview:aboveCellImageView];
    [transitionContext.containerView addSubview:pageImageView];
    [transitionContext.containerView addSubview:cellImageView];
    [transitionContext.containerView addSubview:belowCellImageView];
    
    NSTimeInterval totalDuration = [self transitionDuration:transitionContext];
    [UIView animateKeyframesWithDuration:totalDuration
                                   delay:0
                                 options:UIViewKeyframeAnimationOptionCalculationModeLinear
                              animations:^{
                                  //                                  fromViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
                                  
                                  aboveCellImageView.frame = aboveCellImageViewShownFrame;
                                  cellImageView.frame = cellImageViewShownFrame;
                                  belowCellImageView.frame = belowCellImageViewShownFrame;
                                  pageImageView.frame = pageViewShownFrame;
                                  
                                  [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.6 animations:^{
                                      pageImageView.alpha = ALPHA_HIDDEN;
                                      cellImageView.alpha = ALPHA_HIDDEN;
                                  }];
                                  [UIView addKeyframeWithRelativeStartTime:0.6 relativeDuration:0.4 animations:^{
                                      cellImageView.alpha = ALPHA_SHOWN;
                                      
                                  }];
                              } completion:^(BOOL finished) {
                                  // remove all the intermediate views from the heirarchy
                                  [backgroundView removeFromSuperview];
                                  [aboveCellImageView removeFromSuperview];
                                  [pageImageView removeFromSuperview];
                                  [cellImageView removeFromSuperview];
                                  [belowCellImageView removeFromSuperview];
                                  
                                  if ([transitionContext transitionWasCancelled]) {
                                      // we added this at the start, so we have to remove it
                                      // if the transition is canccelled
                                      [cellViewController.view removeFromSuperview];
                                      [transitionContext completeTransition:NO];
                                  } else {
                                      [pageViewController.view removeFromSuperview];
                                      [transitionContext completeTransition:YES];
                                  }
                              }];
}

- (void)startInteractiveTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
}

- (void) handlePinch:(UIPinchGestureRecognizer *)recognizer
{
    CGFloat scale = recognizer.scale;
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.interactiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
            startScale = scale;
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case UIGestureRecognizerStateChanged: {
            CGFloat percent = (1.0 - scale / startScale);
            shouldCompleteTransition = (percent > 0.25);
            
            [self.interactiveTransition updateInteractiveTransition: (percent <= 0.0) ? 0.0 : percent];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            if (!shouldCompleteTransition || recognizer.state == UIGestureRecognizerStateCancelled)
                [self.interactiveTransition cancelInteractiveTransition];
            else
                [self.interactiveTransition finishInteractiveTransition];
            self.interactiveTransition = nil;
            break;
        default:
            break;
    }
}

@end
