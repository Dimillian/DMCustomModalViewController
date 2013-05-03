//
//  DMCustomModalViewController.h
//  DMCustomModalViewController
//
//  Created by Thomas Ricouard on 5/3/13.
//  Copyright (c) 2013 Thomas Ricouard. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DMCustomModalViewControllerPresentationStyle) {
    DMCUstomModalViewControllerPresentFullScreen,
    DMCustomModalViewControllerPresentPartScreen
};

@class DMCustomModalViewController;

@protocol DMCustomViewControllerDelegate <NSObject>
@optional
/**
 If you conform to the DMCustomViewControllerDelegate protocol this delegate method will be called when
 the modal view controller did close.
 */
- (void)customModalViewControllerDidDismiss:(DMCustomModalViewController *)modalViewController;
@end

@interface DMCustomModalViewController : UIViewController

@property (nonatomic, unsafe_unretained) id<DMCustomViewControllerDelegate> delegate;
/**
 The root view controller that will be used as the content for the modal view
 You assign it when you initialize a new DMCustomModalViewController
 */
@property (nonatomic, readonly, strong) UIViewController *rootViewController;
/**
 If you set the DMCustomModalViewControllerPresentationStyle to DMCustomModalViewControllerPresentPartScreen you need
 to set this value to define how much of the modal view you want to show.
 No default value is set
 */
@property (nonatomic) CGFloat rootViewControllerHeight;
/**
 The animation speed
 The default value is 0.30
 */
@property (nonatomic) CGFloat animationSpeed;
/*
 This value is used when aplying CGAffineTransformScale to the parentViewController view 
 for the modal presenting animation. Affect the recoil effect.
 The default value is 0.80
 */
@property (nonatomic) CGFloat parentViewScaling;

/**
 When the presentation style is in DMCustomModalViewControllerPresentPartScreen you can tap
 the visible part of the background view controller to close the modal view
 The default value is YES
 */
@property (nonatomic, getter = isTapParentViewToClose) BOOL tapParentViewToClose;

/**
 Designated initializer, return a new DMCustomModalViewController
 @param rootViewController The view controller used as the content view of the DMCustomModalViewController this is 
 only a container view controller
 @param parentViewController usually the view controller from where you show this modal, DMCustomModalViewController
 will add animations and overlay on its view
 @return a new DMCustomModalViewController
 */
- (id)initWithRootViewController:(UIViewController *)rootViewController
            parentViewController:(UIViewController *)parentViewController;
/**
 Present the modal view controller with the passed view controller as content
 @param presentation style the style of the presentation
 Provide a completion block which is called when the open animation is done
 */
- (void)presentRootViewControllerWithPresentationStyle:(DMCustomModalViewControllerPresentationStyle)presentationStyle
                    controllercompletion:(void (^)(void))completion;
/**
 Dismiss the modal view controller
 Provide a completion block which is called when the close animation is done
 */
- (void)dismissRootViewControllerWithcompletion:(void (^)(void))completion;
@end
