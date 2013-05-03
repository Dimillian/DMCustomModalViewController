DMCustomModalViewController
===========================
**Beta**: This class is only a tiny part of what I want to do, later I'll provide a better implementation and interface, more animations, customizations etc…
Today it works but not provide all the options and nice feature I want to.

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

Within your `UIViewController` subclass that is used as the root view controller of the modal view, you can access the `parentViewController` which should be an instance of `DMCustomModalViewController`.
You could simply do something like this

	- (void)dismissModal
	{
    	DMCustomModalViewController *modal = (DMCustomModalViewController *)self.parentViewController;
    	[modal dismissRootViewControllerWithcompletion:^{
        
    	}];
	}
	
I know you should not dismiss your modal view from within itself, but I'll provide a better implementation with a later version. 

###Delegate

`DMCustomViewController` currently provide one delegate method to inform you when it was dismissed.

	@protocol DMCustomViewControllerDelegate <NSObject>
	@optional
	- (void)customModalViewControllerDidDismiss:(DMCustomModalViewController *)modalViewController;
	@end

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



