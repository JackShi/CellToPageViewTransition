//
//  TableViewController.m
//  CellToPageViewTransition
//
//  Created by Jack Shi on 27/06/2014.
//  Copyright (c) 2014 Jack Shi. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()
{
    NSArray *data;
}

@end

@implementation TableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    data = @[@"Red Color", @"Blue Color", @"Orange Color"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    // Configure the cell...
    cell.textLabel.text = data[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.sourceView = [self.tableView cellForRowAtIndexPath:indexPath];

    PageViewController *pageViewController = [[PageViewController alloc] init];
    pageViewController.data = data;
    pageViewController.currentPage = indexPath.row;
    self.navigationController.delegate = self;
    [self.navigationController pushViewController:pageViewController animated:YES];
}

#pragma mark - Navigation Controller Delegate
-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                 animationControllerForOperation:(UINavigationControllerOperation)operation
                                              fromViewController:(UIViewController *)fromVC
                                                toViewController:(UIViewController *)toVC
{
    // Check if we're transitioning from this view controller to StepPageViewController
    if (fromVC == self && [toVC isKindOfClass:[PageViewController class]]) {
        CellToPageViewAnimation *cellToPageViewAnimation = [[CellToPageViewAnimation alloc] init];
        cellToPageViewAnimation.sourceView = self.sourceView;
        return cellToPageViewAnimation;
    }
    return nil;
}



@end
