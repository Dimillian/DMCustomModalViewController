//
//  DMCustomModalViewController.m
//  DMCustomModalViewController
//
//  Created by Thomas Ricouard on 5/3/13.
//  Copyright (c) 2013 Thomas Ricouard. All rights reserved.
//

#import "DMCustomModalViewController.h"
#import <QuartzCore/QuartzCore.h>

const CGFloat KZposition = -4000;
const CGFloat kDeep = 0.80;

@interface DMCustomModalViewController ()

@property (nonatomic, weak) UIViewController *fromViewController;
@property (nonatomic, strong, readwrite) UIView *overlayView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UINavigationBar *contentNavBar;
@property (nonatomic) CGPoint initialPoint;
@property (nonatomic) DMCustomModalViewControllerPresentationStyle currentPresentationStyle;
- (void)onTapGesture;
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
        _animationSpeed = 0.30;
        _tapParentViewToClose = YES;
        _dragRootViewNavigationBar = YES;
        _parentViewScaling = kDeep;
        _parentViewYPath = 0.0;
        _rootViewControllerHeight = 400.0;
        _draggedRootViewAlphaValue = 0.80;
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
    [self.rootViewController didMoveToParentViewController:self];
    [self.rootViewController.view setFrame:frame];
    for (UIView *view in self.rootViewController.view.subviews) {
        if ([view isKindOfClass:[UINavigationBar class]]) {
            _panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self
                                                                action:@selector(onPanGesture:)];
            _contentNavBar = (UINavigationBar *)view;
            [self.contentNavBar addGestureRecognizer:self.panGesture];
            [self.panGesture setEnabled:self.isDragRootViewNavigationBar];
            [self.contentNavBar setUserInteractionEnabled:YES];
        }
    }
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
        if (self.isTapParentViewToClose) {
            _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapGesture)];
            [self.tapGesture setNumberOfTapsRequired:1],
            [self.overlayView addGestureRecognizer:self.tapGesture];
            [self.overlayView setUserInteractionEnabled:YES];
        }
    };
    void (^scaleView) (void) = ^{
        CGAffineTransform xForm = primaryView.transform;
        primaryView.transform = CGAffineTransformScale(xForm, _parentViewScaling, _parentViewScaling);
        CGRect frame = primaryView.frame;
        frame.origin.y -= self.parentViewYPath;
        [primaryView setFrame:frame];
    };
    primaryView.window.backgroundColor = [UIColor blackColor];
    [UIView animateWithDuration:_animationSpeed
                     animations:modifyAngle
                     completion:^(BOOL finished) {
                         if (finished) {
                             [UIView animateWithDuration:_animationSpeed
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
                                     [UIView animateWithDuration:_animationSpeed animations:^{
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
        CGRect frame = primaryView.frame;
        frame.origin.y += self.parentViewYPath;
        [primaryView setFrame:frame];
    };
    
    void (^animationBlock) (void) = ^{
        [UIView animateWithDuration:_animationSpeed
                              delay:0.05
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:modifyAngle
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:_animationSpeed
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
        primaryView.transform =  CGAffineTransformScale(primaryView.transform, _parentViewScaling, _parentViewScaling);
    }
    
    dispatch_time_t modalDelay =
    dispatch_time(DISPATCH_TIME_NOW, 20000000);
    dispatch_after(modalDelay, dispatch_get_main_queue(), animationBlock);
    

}

#pragma mark - setter
- (void)setTapParentViewToClose:(BOOL)tapParentViewToClose
{
    _tapParentViewToClose = tapParentViewToClose;
    [self.tapGesture setEnabled:tapParentViewToClose];
}

- (void)setDragRootViewNavigationBar:(BOOL)dragRootViewNavigationBar
{
    _dragRootViewNavigationBar = dragRootViewNavigationBar;
    [self.panGesture setEnabled:dragRootViewNavigationBar];
}

#pragma mark - gesture
- (void)onTapGesture
{
    [self dismissRootViewControllerWithcompletion:^{
        
    }];
}

- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *piece = gestureRecognizer.view;
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
        
        piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width,
                                              locationInView.y / piece.bounds.size.height);
        piece.center = locationInSuperview;
    }
}


-(void)onPanGesture:(UIPanGestureRecognizer *)reconizer
{
    [self adjustAnchorPointForGestureRecognizer:reconizer];
    UIView *draggableView = self.rootViewController.view;
    if (reconizer.state == UIGestureRecognizerStateBegan) {
        _initialPoint = draggableView.layer.position;
        [UIView animateWithDuration:0.2 animations:^{
            draggableView.alpha = _draggedRootViewAlphaValue;
        }];
        
    }
    else if (reconizer.state == UIGestureRecognizerStateChanged){
        CGPoint translation = [reconizer translationInView:[draggableView superview]];
        [draggableView setCenter:CGPointMake([draggableView center].x ,
                                             [draggableView center].y + translation.y)];
        [reconizer setTranslation:CGPointZero inView:[draggableView superview]];
        
    }
    else if (reconizer.state == UIGestureRecognizerStateEnded ||
             reconizer.state == UIGestureRecognizerStateCancelled){
        CGRect frame = draggableView.frame;
        if (frame.origin.y > _rootViewControllerHeight/2) {
            [self dismissRootViewControllerWithcompletion:^{
                draggableView.layer.position = _initialPoint;
                draggableView.alpha = 1.0;
            }];
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                draggableView.layer.position = _initialPoint;
                draggableView.alpha = 1.0;
            }];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
