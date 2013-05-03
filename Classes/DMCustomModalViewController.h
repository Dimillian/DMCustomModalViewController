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
- (void)customModalViewControllerDidDismiss:(DMCustomModalViewController *)modalViewController;
@end

@interface DMCustomModalViewController : UIViewController

@property (nonatomic, readonly, strong) UIViewController *rootViewController;
@property (nonatomic) CGFloat rootViewControllerHeight;
@property (nonatomic, unsafe_unretained) id<DMCustomViewControllerDelegate> delegate;

- (id)initWithRootViewController:(UIViewController *)rootViewController
            parentViewController:(UIViewController *)parentViewController;
- (void)presentRootViewControllerWithPresentationStyle:(DMCustomModalViewControllerPresentationStyle)presentationStyle
                    controllercompletion:(void (^)(void))completion;
- (void)dismissRootViewControllerWithcompletion:(void (^)(void))completion;
@end
