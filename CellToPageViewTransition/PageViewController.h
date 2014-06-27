//
//  PageViewController.h
//  CellToPageViewTransition
//
//  Created by Jack Shi on 27/06/2014.
//  Copyright (c) 2014 Jack Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeView.h"
#import "PageViewToCellAnimation.h"
#import "TableViewController.h"

@interface PageViewController : UIViewController <SwipeViewDataSource, SwipeViewDelegate, UINavigationControllerDelegate>

@property (nonatomic, assign) id<GestureRecognizerDelegate> gestureRecognizerDelegate;
@property (nonatomic, strong) SwipeView *swipeView;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, assign) NSInteger currentPage;


@end
