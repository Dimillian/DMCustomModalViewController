//
//  DMModalRootViewController.m
//  DMCustomModalViewController
//
//  Created by Thomas Ricouard on 5/3/13.
//  Copyright (c) 2013 Thomas Ricouard. All rights reserved.
//

#import "ModalRootViewController.h"
#import "DMCustomModalViewController.h"

@interface ModalRootViewController ()

@end

@implementation ModalRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor yellowColor]];
    UINavigationBar *navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(dismissModal)];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Title"];
    item.rightBarButtonItem = rightButton;
    item.hidesBackButton = YES;
    [navBar pushNavigationItem:item animated:NO];
    [self.view addSubview:navBar];

	// Do any additional setup after loading the view.
}

- (void)dismissModal
{
    //if you import DMCustomModalViewController.h in you modal root controller it add some magic to it
    //you can freely access your DMCustomModalViewController
    [self.customModalViewController dismissRootViewControllerWithcompletion:^{

    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
