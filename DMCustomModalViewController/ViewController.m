//
//  DMViewController.m
//  DMCustomModalViewController
//
//  Created by Thomas Ricouard on 5/3/13.
//  Copyright (c) 2013 Thomas Ricouard. All rights reserved.
//

#import "ViewController.h"
#import "DMCustomModalViewController.h"
#import "ModalRootViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(10, 100, 150, 100)];
    [button setTitle:@"Present modal part" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showModal) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button2 setFrame:CGRectMake(165, 100, 150, 100)];
    [button2 setTitle:@"Present modal full" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(showModalFull) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];

    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];


}

- (void)showModal
{
    ModalRootViewController *root = [[ModalRootViewController alloc]initWithNibName:nil bundle:nil];
    _partModal = [[DMCustomModalViewController alloc]initWithRootViewController:root
                                                                                   parentViewController:self];
    [self.partModal setDelegate:self];
    self.partModal.rootViewControllerHeight = 350;
    [self.partModal presentRootViewControllerWithPresentationStyle:DMCustomModalViewControllerPresentPartScreen controllercompletion:^{
        
    }];
}

- (void)showModalFull
{
    ModalRootViewController *root = [[ModalRootViewController alloc]initWithNibName:nil bundle:nil];
    _fullScreenModal = [[DMCustomModalViewController alloc]initWithRootViewController:root
                                                                                   parentViewController:self];
    [self.fullScreenModal setDelegate:self];
    [self.fullScreenModal presentRootViewControllerWithPresentationStyle:DMCUstomModalViewControllerPresentFullScreen controllercompletion:^{
        
    }];
}

#pragma mark - Custom modal delegate
- (void)customModalViewControllerDidDismiss:(DMCustomModalViewController *)modalViewController
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
