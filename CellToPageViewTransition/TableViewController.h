//
//  TableViewController.h
//  CellToPageViewTransition
//
//  Created by Jack Shi on 27/06/2014.
//  Copyright (c) 2014 Jack Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageViewController.h"
#import "CellToPageViewAnimation.h"

@interface TableViewController : UITableViewController<UINavigationControllerDelegate>

@property (nonatomic, strong) UIView *sourceView;

@end
