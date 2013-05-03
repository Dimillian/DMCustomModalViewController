//
//  DMCustomModalViewController.m
//  DMCustomModalViewController
//
//  Created by Thomas Ricouard on 5/3/13.
//  Copyright (c) 2013 Thomas Ricouard. All rights reserved.
//

#import "DMCustomModalViewController.h"
#import <QuartzCore/QuartzCore.h>

const CGFloat kAnimationDurationZPosition = 0.3;
const CGFloat kAnimationDurationScaling = 0.3;
const CGFloat kAnimationDurationShowingView = 0.3;
const CGFloat KZposition = -4000;
const CGFloat kDeep = 0.80;

@interface DMCustomModalViewController ()

@property (nonatomic, weak) UIViewController *fromViewController;
@property (nonatomic, strong, readwrite) UIView *overlayView;
@property (nonatomic) DMCustomModalViewControllerPresentationStyle currentPresentationStyle;
@end

@implementation DMCustomModalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
            parentViewController:(UIViewController *)parentViewController
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _rootViewController = rootViewController;
        _fromViewController = parentViewController;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.rootViewController willMoveToParentViewController:self];
    [self addChildViewController:self.rootViewController];
    [self.view addSubview:self.rootViewController.view];
    CGRect frame = self.rootViewController.view.frame;
    frame.origin.y = 0;
    [self.rootViewController.view setFrame:frame];
    [self.rootViewController didMoveToParentViewController:self];
}


- (void)presentRootViewControllerWithPresentationStyle:(DMCustomModalViewControllerPresentationStyle)presentationStyle
                                  controllercompletion:(void (^)(void))completion
{
    _currentPresentationStyle = presentationStyle;
    UIView *primaryView = self.fromViewController.view;
    
    void (^modifyAngle) (void) = ^{
        CGRect oFrame = CGRectMake(0, 0, primaryView.frame.size.width,
                                   primaryView.frame.size.height);
        _overlayView = [[UIView alloc]initWithFrame:oFrame];
        [self.overlayView setBackgroundColor:[UIColor blackColor]];
        [self.overlayView setAlpha:0.0];
        [self.overlayView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|
         UIViewAutoresizingFlexibleWidth];
        CALayer *layer = primaryView.layer;
        layer.zPosition = KZposition;
        CATransform3D rotationAndPerspectiveTransform = layer.transform;
        rotationAndPerspectiveTransform.m34 = 1.0 / -300;
        layer.transform = CATransform3DRotate(rotationAndPerspectiveTransform,
                                              2.0f * M_PI / 180.0f,
                                              1.0f,
                                              0.0f,
                                              0.0f);
        [primaryView addSubview:self.overlayView];
        [self.overlayView setAlpha:0.2];
    };
    void (^scaleView) (void) = ^{
        CGAffineTransform xForm = primaryView.transform;
        primaryView.transform = CGAffineTransformScale(xForm, kDeep, kDeep);
    };
    primaryView.window.backgroundColor = [UIColor blackColor];
    [UIView animateWithDuration:kAnimationDurationZPosition
                     animations:modifyAngle
                     completion:^(BOOL finished) {
                         if (finished) {
                             [UIView animateWithDuration:kAnimationDurationScaling
                                                   delay:0.0
                                                 options:UIViewAnimationOptionCurveEaseIn
                                              animations:scaleView
                                              completion:NULL];
                             void (^modalBlock) (void);
                             if (presentationStyle == DMCUstomModalViewControllerPresentFullScreen) {
                                modalBlock = ^{
                                     [self.fromViewController
                                      presentViewController:self animated:YES completion:^{
                                          completion();
                                      }];
                                 };
                             }
                             else if (presentationStyle == DMCustomModalViewControllerPresentPartScreen){
                                 
                                 modalBlock = ^{
                                     self.fromViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
                                     [self.fromViewController
                                      presentViewController:self animated:NO completion:^{
                       
                                      }];
                                     __block CGRect frame = self.view.frame;
                                     frame.origin.y = frame.size.height + 30;
                                     [self.view setFrame:frame];
                                     [UIView animateWithDuration:kAnimationDurationShowingView animations:^{
                                         frame.origin.y = frame.size.height - self.rootViewControllerHeight;
                                         [self.view setFrame:frame];
                                     }completion:^(BOOL finished) {
                                        completion();
                                     }];
                                 };
                             }
                             
                             dispatch_time_t modalDelay =
                             dispatch_time(DISPATCH_TIME_NOW, 10000000);
                             dispatch_after(modalDelay, dispatch_get_main_queue(), modalBlock);
                             
                         }
                     }];

}

- (void)dismissRootViewControllerWithcompletion:(void (^)(void))completion
{
    UIView *primaryView = self.fromViewController.view;

    void (^modifyAngle) (void) = ^{
        CALayer *layer = primaryView.layer;
        layer.zPosition = KZposition;
        CATransform3D rotationAndPerspectiveTransform = layer.transform;
        rotationAndPerspectiveTransform.m34 = 1.0 / 300;
        layer.transform = CATransform3DRotate(rotationAndPerspectiveTransform,
                                              -3.0f * M_PI / 180.0f,
                                              1.0f,
                                              0.0f,
                                              0.0f);
        
    };
    
    void (^scaleView) (void) = ^{
        [self.overlayView setAlpha:0.0];
        primaryView.transform =  CGAffineTransformScale(primaryView.transform, 1.0, 1.0);
    };
    
    void (^animationBlock) (void) = ^{
        [UIView animateWithDuration:kAnimationDurationZPosition
                              delay:0.05
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:modifyAngle
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:kAnimationDurationScaling
                                              animations:scaleView
                                              completion:^(BOOL finished) {
                                                  if (finished)
                                                      [self.overlayView removeFromSuperview];
                                                  self.fromViewController.modalPresentationStyle = UIModalPresentationFullScreen;
                                                  if ([self.delegate respondsToSelector:@selector(customModalViewControllerDidDismiss:)]) {
                                                      [self.delegate customModalViewControllerDidDismiss:self];
                                                  }
                                                  completion();
                                              }];
                         }];
        
    };
    
    [self.fromViewController
     dismissViewControllerAnimated:YES completion:^{
         
     }];
    
    if (_currentPresentationStyle == DMCUstomModalViewControllerPresentFullScreen) {
        primaryView.transform =  CGAffineTransformScale(primaryView.transform, kDeep, kDeep);
    }
    
    dispatch_time_t modalDelay =
    dispatch_time(DISPATCH_TIME_NOW, 20000000);
    dispatch_after(modalDelay, dispatch_get_main_queue(), animationBlock);
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
