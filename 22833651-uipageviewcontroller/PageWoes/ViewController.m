//
//  ViewController.m
//  PageWoes
//
//  Created by Thaddeus on 9/23/15.
//  Copyright © 2015 Bluetoo. All rights reserved.
//

#import "ViewController.h"
#import "ColorNameViewController.h"

/**
 *  This view controller is used to reproduce the issue. To observe the problem, do the following:
 
    **************************************************************************
    ** Normal Case **
    **************************************************************************
    1. Swipe normally - green view will appear and label will update with pageViewController:didFinishAnimating:previousViewControllers:transitionCompleted:
    2. Swipe back to red, label corrently shows red
 
    **************************************************************************
    **  Normal, but two events that are incorrect **
    **************************************************************************
    3. Swipe toward green, but don't let go. After a moment, let go; UIPVC will scroll back to red (correct)
    4. Swipe toward green, but further. Let go, and then grab it again. Pull a little, but then let it return to red (correct - but two events - one completed, one not)
    5. Swipe back to red, label correctly shows red
 
    **************************************************************************
    ** BUG - UIPageViewController.viewControllers will return incorrect set **
    **************************************************************************
    6. Swipe toward green, but further again. Let go, and then grab again. This time, pull again to finish the swipe. Green appears, but red is displayed in the label. BUG.
 */


@interface ViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>
@property (nonatomic, strong) NSArray<ColorNameViewController *>* pages;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) IBOutlet UILabel *status;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.pages = @[
        [[ColorNameViewController alloc] init],
        [[ColorNameViewController alloc] init],
        [[ColorNameViewController alloc] init],
    ];
    
    self.status.text = @"<< drag >>";
    
    self.pages[0].view.backgroundColor = [UIColor redColor];
    self.pages[0].name = @"red";
    
    self.pages[1].view.backgroundColor = [UIColor greenColor];
    self.pages[1].name = @"green";
    
    self.pages[2].view.backgroundColor = [UIColor blueColor];
    self.pages[2].name = @"blue";
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
    
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;

    [self.view insertSubview:self.pageViewController.view belowSubview:self.status];
    
    UIViewController *vc = [self.pages firstObject];
    [self.pageViewController setViewControllers:@[vc]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    NSLog(@"finished=%@ completed=%@", @(finished), @(completed));

    // currentName is pulled from -description on each ColorNameViewController instance.
    NSString *currentName = [[[self.pageViewController viewControllers] firstObject] description];

    
    static NSInteger i = 0;
    i++;
    self.status.text = [NSString stringWithFormat:@"%@: %@ (%@)", NSStringFromSelector(_cmd), currentName, @(i)];
}

#pragma mark - UIPageViewControllerDataSource

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self.pages indexOfObject:(ColorNameViewController *)viewController];
    if(index == 0 || index == NSNotFound)
        return nil;
    
    --index;
    return self.pages[index];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self.pages indexOfObject:(ColorNameViewController *)viewController];
    if(index == NSNotFound)
        return nil;
    
    ++index;
    if(index == self.pages.count)
        return nil;
    
    return self.pages[index];
}

@end
