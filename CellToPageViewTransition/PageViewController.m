//
//  PageViewController.m
//  CellToPageViewTransition
//
//  Created by Jack Shi on 27/06/2014.
//  Copyright (c) 2014 Jack Shi. All rights reserved.
//

#import "PageViewController.h"

@interface PageViewController ()

@end

@implementation PageViewController
{
    NSMutableArray *viewControllers;
    PageViewToCellAnimation *pageViewToCellAnimation;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < self.data.count; i++) {
        [controllers addObject:[NSNull null]];
    }
    viewControllers = controllers;
    
    self.swipeView = [[SwipeView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.swipeView.backgroundColor = [UIColor clearColor];
    self.swipeView.delegate = self;
    self.swipeView.dataSource = self;
    self.swipeView.currentPage = self.currentPage;
    [self.view addSubview:self.swipeView];
    self.view.backgroundColor = [UIColor clearColor];
    
    pageViewToCellAnimation = [[PageViewToCellAnimation alloc] initWithNavigationController:self.navigationController];
    
    // setup a pinch gesture recognizer and make the target the custom transition handler
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:pageViewToCellAnimation action:@selector(handlePinch:)];
    [self.view addGestureRecognizer:pinchRecognizer];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Set outself as the navigation controller's delegate so we're asked for a transitioning object
    self.navigationController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Stop being the navigation controller's delegate
    if (self.navigationController.delegate == self) {
        self.navigationController.delegate = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Swipe View Delegate
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    //return the total number of items in the carousel
    return [self.data count];
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UIViewController *controller = [viewControllers objectAtIndex:index];
    if ((NSNull *)controller == [NSNull null]) {
        controller = [[UIViewController alloc] init];
        switch (index) {
            case 0:
                controller.view.backgroundColor = [UIColor redColor];
                break;
            case 1:
                controller.view.backgroundColor = [UIColor blueColor];
                break;
            case 2:
                controller.view.backgroundColor = [UIColor orangeColor];
                break;
            default:
                break;
        }
        [viewControllers replaceObjectAtIndex:index withObject:controller];
    }
    
    return controller.view;
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView
{
    return self.swipeView.bounds.size;
}


#pragma mark - Navigation Controller Delegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    // Check if we're transitioning from this view controller to PageViewController
    if (fromVC == self && [toVC isKindOfClass:[TableViewController class]]) {
        // As user may swipe the page view, find out the indexPath that animation should return to
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.swipeView.currentPage inSection:0];;
        [((TableViewController *)toVC).tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        pageViewToCellAnimation.sourceView = [((TableViewController *)toVC).tableView cellForRowAtIndexPath:indexPath];
        return pageViewToCellAnimation;
    }
    else {
        return nil;
    }
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    // Check if this is for PageViewToCellAnimationcustom transition
    if ([animationController isKindOfClass:[PageViewToCellAnimation class]]) {
        return ((PageViewToCellAnimation *)animationController).interactiveTransition;
    }
    return nil;
    
}

@end
