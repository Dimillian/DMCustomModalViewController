DMCustomModalViewController
===========================
DMCustomModalViewController is a  `UIViewController` subclass which take a root view controller and present it modally with a nice animation (a la gmail).

You should not subclass it, it act as a container view controller that you can directly instantiate and use. 

##Features

`DMCustomModalViewController` provide a quick and an easy solution to display modal view controller with a nice animation. It have an option to display the modal view controller not full screen and keeping the current view controller in the background with a nice overlay on it. 

1. 2 ways of presenting it, fullscreen or not full screen.
2. Nice animations!
3. Keep the current context and display the view in background and add an onverlay on it.
4. More to come.


##How to use it

**TL;DR:** Look at the example provided. 

1. Add DMCustomModalViewController.h and .m from the **classes/** folder to your Xcode project.
2. Add QuartzCore.framework to "Link Binary With Libraries" (.xcodeproj -> Build Phases)
3. Import `DMCustomModalViewController.h`where you want to use it. 

###Full Screen

	ModalRootViewController *root = [[ModalRootViewController alloc]initWithNibName:nil bundle:nil];
    _fullScreenModal = [[DMCustomModalViewController alloc]initWithRootViewController:root
                                                                                   parentViewController:self];
    [self.fullScreenModal setDelegate:self];
    [self.fullScreenModal presentRootViewControllerWithPresentationStyle:DMCUstomModalViewControllerPresentFullScreen controllercompletion:^{
        
    }];
    
###Part screen

![image](https://raw.github.com/Dimillian/DMCustomModalViewController/master/screen1.png)


    ModalRootViewController *root = [[ModalRootViewController alloc]initWithNibName:nil bundle:nil];
    _partModal = [[DMCustomModalViewController alloc]initWithRootViewController:root
                                                                                   parentViewController:self];
    [self.partModal setDelegate:self];
    self.partModal.rootViewControllerHeight = 350;
    [self.partModal presentRootViewControllerWithPresentationStyle:DMCustomModalViewControllerPresentPartScreen controllercompletion:^{
        
    }];
    
If you are not presenting it fullscreen you need to set the `rootViewControllerHeight` property. This value will be used to know how much of your `rootViewController` need to be displayed

###Dismiss
`DMCustomModalViewController` provide a built in category, just import the **.h** of `DMCustomModalViewController` in your `rootViewController` you passed to the instance of `DMCustomModalViewController`, you will have access to a new property `customModalViewController`. You can then freely dismiss the modal from itself. 

 	[self.customModalViewController dismissRootViewControllerWithcompletion:^{

    }];
   
   
A better implementation would be to build yourself some `delegate` for your `rootViewController`, so the controller which fired the modal would be also responsible for dismissing it.
	

###Delegate

`DMCustomViewController` currently provide one delegate method to inform you when it was dismissed.

	@protocol DMCustomViewControllerDelegate <NSObject>
	@optional
	- (void)customModalViewControllerDidDismiss:(DMCustomModalViewController *)modalViewController;
	@end

###Customization
You can customize the animation speed by setting the property `CGFloat animationSpeed` before presenting the modal view controller
The default value is 0.30

You can also customize the scaling of the parent controller view when the modal view is presented. It will affect the recoil effect. For that modify the property `CGFloat parentViewScaling` the default value is 0.80.

Also by default when you tap on the parent view when the modal is not presented full screen it will close it, you can turn it off by setting `tapParentViewToClose` to `NO`.

If you `rootViewController` view have a navigation bar you'll be able to drag the navigation bar if `dragRootViewNavigationBar` is set to YES (by default it is set to YES). Work only when the modal view is not presented full screen.

There are some other properties for you to play with.

The example provide sliders on the UI to better understand the effect of each property.
Just run it in the simulator :)

## Licensing 
Copyright (C) 2013 by Thomas Ricouard. 

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.



