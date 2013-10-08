//
//  DMViewController.h
//  DMCustomModalViewController
//
//  Created by Thomas Ricouard on 5/3/13.
//  Copyright (c) 2013 Thomas Ricouard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMCustomModalViewController.h"

@interface ViewController : UIViewController <DMCustomViewControllerDelegate>

@property (nonatomic, strong) DMCustomModalViewController *modal;
@end
