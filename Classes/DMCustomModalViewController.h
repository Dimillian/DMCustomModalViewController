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
 The default value is 400.0
 */
@property (nonatomic) CGFloat rootViewControllerHeight;
/**
 The animation speed
 The default value is 0.30
 */
@property (nonatomic) CGFloat animationSpeed;
/**
 This value is used when aplying CGAffineTransformScale to the parentViewController view 
 for the modal presenting animation. Affect the recoil effect.
 The default value is 0.80
 */
@property (nonatomic) CGFloat parentViewScaling;

/**
 This value is used when scaling the parent view, you can define how much the parent view Y axis
 will be modified when scaled.
 The default value is 0.0 so the Y axis is not modified during the scaling
 */
@property (nonatomic) CGFloat parentViewYPath;

/**
 When the presentation style is set to DMCustomModalViewControllerPresentPartScreen you can tap
 the visible part of the background view controller to close the modal view
 The default value is YES
 */
@property (nonatomic, getter = isTapParentViewToClose) BOOL tapParentViewToClose;

/**
 When the presensation style is set to DMCustomModalViewControllerPresentPartScreen you can drag the 
 navigation bar of your root view controller (if any navigation bar) to close it
 The default value is YES
 */
@property (nonatomic, getter = isDragRootViewNavigationBar) BOOL dragRootViewNavigationBar;

/**
 if dragRootViewNavigationBar is set to YES you can set the alpha value of the root view when dragged
 the default value is 0.8
 */
@property (nonatomic) CGFloat draggedRootViewAlphaValue;

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

//Add access to DMCustomModalViewController from within your UIViewController
@interface UIViewController (UIViewControllerCustomModalItem)
/**
 Not nil if you're accessing this property from within a UIViewController which have for parent an instance
of DMCustomModalViewController
 */
@property (nonatomic, strong, readonly) DMCustomModalViewController *customModalViewController;

@end
