//
//  CellToPageViewAnimation.m
//  Steps-iOS
//
//  Created by Jack Shi on 26/06/2014.
//  Copyright (c) 2014 Jack Shi. All rights reserved.
//

#import "CellToPageViewAnimation.h"

#define ALPHA_SHOWN   1.0
#define ALPHA_HIDDEN  0.0

@interface CellToPageViewAnimation()

@end

@implementation CellToPageViewAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *cellViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *pageViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *cellView = cellViewController.view;
    UIView *pageView = pageViewController.view;
    
    pageView.frame = [transitionContext finalFrameForViewController:pageViewController];
    
    // add the to pageViewController view to the intermediate view (where it has to be at the
    // end of the transition anyway). We'll hide it during the transition with
    // a blank view. This ensures that renderInContext of the 'To' view will
    // always render correctly
    [transitionContext.containerView addSubview:pageViewController.view];
    
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
    aboveCellImageView.frame = aboveCellImageViewShownFrame;
    cellImageView.frame = cellImageViewShownFrame;
    belowCellImageView.frame = belowCellImageViewShownFrame;
    
    // set cell image view alpha
    cellImageView.alpha = ALPHA_SHOWN;
    
    // put a overlay to hide from view
    UIView *backgroundView = [[UIView alloc] initWithFrame:transitionContext.containerView.frame];
    backgroundView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    // set up page view
    UIImageView *pageImageView = [[UIImageView alloc] initWithImage:pageViewSnapshot];
    
    CGRect pageViewShownFrame = CGRectMake(cellImageView.frame.origin.x, cellViewStartPositionY + sourceRect.origin.y, viewWidth, viewHeight);
    CGRect pageViewHiddenFrame = pageViewShownFrame;
    pageViewHiddenFrame.origin.y = cellViewStartPositionY;
    pageImageView.frame = pageViewShownFrame;
    pageImageView.alpha = ALPHA_HIDDEN;
    
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
                                  
                                  aboveCellImageView.frame = aboveCellImageViewHiddenFrame;
                                  cellImageView.frame = cellImageViewHiddenFrame;
                                  belowCellImageView.frame = belowCellImageViewHiddenFrame;
                                  pageImageView.frame = pageViewHiddenFrame;
                                  
                                  [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:.4 animations:^{
                                      cellImageView.alpha = ALPHA_HIDDEN;
                                      pageImageView.alpha = ALPHA_HIDDEN;
                                  }];
                                  [UIView addKeyframeWithRelativeStartTime:0.4 relativeDuration:0.6 animations:^{
                                      pageImageView.alpha = ALPHA_SHOWN;
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
                                      [pageViewController.view removeFromSuperview];
                                      [transitionContext completeTransition:NO];
                                  } else {
                                      [cellViewController.view removeFromSuperview];
                                      [transitionContext completeTransition:YES];
                                  }
                                  
                              }];
}

@end
