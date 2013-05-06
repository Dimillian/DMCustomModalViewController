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
    [self setupTestUI];
    
    ModalRootViewController *root = [[ModalRootViewController alloc]initWithNibName:nil bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:root];
    _modal = [[DMCustomModalViewController alloc]initWithRootViewController:navController
                                                       parentViewController:self];

    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];


}

- (void)onScalingSlider:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    [self.modal setParentViewScaling:slider.value];
}

- (void)onAnimationSpeedSlider:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    [self.modal setAnimationSpeed:slider.value];
}

- (void)onParentViewYPathSlider:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    [self.modal setParentViewYPath:slider.value];
}

- (void)onModalHeightSlider:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    [self.modal setRootViewControllerHeight:slider.value];
}

- (void)onModalAlphaBackground:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    [self.modal setDraggedRootViewAlphaValue:slider.value];
}

- (void)showModal
{
    [self.modal setDelegate:self];
    [self.modal presentRootViewControllerWithPresentationStyle:DMCustomModalViewControllerPresentPartScreen
                                          controllercompletion:^{
        
    }];
}

- (void)showModalFull
{
    [self.modal setDelegate:self];
    [self.modal setAnimationSpeed:0.25];
    [self.modal presentRootViewControllerWithPresentationStyle:DMCUstomModalViewControllerPresentFullScreen
                                          controllercompletion:^{
        
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


- (void)setupTestUI
{
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
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 235, self.view.frame.size.width - 10, 20)];
    [label setText:@"parent view scaling"];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:label];
    UISlider *slider = [[UISlider alloc]initWithFrame:CGRectMake(10, 250, self.view.frame.size.width - 10, 30)];
    [slider addTarget:self action:@selector(onScalingSlider:) forControlEvents:UIControlEventValueChanged];
    [slider setMaximumValue:1.0];
    [slider setMinimumValue:0.0];
    [slider setValue:0.80 animated:YES];
    [self.view addSubview:slider];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(10, 295, self.view.frame.size.width - 10, 20)];
    [label setText:@"Animation Speed"];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:label];
    
    slider = [[UISlider alloc]initWithFrame:CGRectMake(10, 310, self.view.frame.size.width - 10, 30)];
    [slider addTarget:self action:@selector(onAnimationSpeedSlider:) forControlEvents:UIControlEventValueChanged];
    [slider setMaximumValue:1.0];
    [slider setMinimumValue:0.0];
    [slider setValue:0.30 animated:YES];
    [self.view addSubview:slider];
    
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(10, 350, self.view.frame.size.width - 10, 20)];
    [label setText:@"Parent view Y path"];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:label];
    
    slider = [[UISlider alloc]initWithFrame:CGRectMake(10, 375, self.view.frame.size.width - 10, 30)];
    [slider addTarget:self action:@selector(onParentViewYPathSlider:) forControlEvents:UIControlEventValueChanged];
    [slider setMaximumValue:100.0];
    [slider setMinimumValue:0.0];
    [slider setValue:0.0 animated:YES];
    [self.view addSubview:slider];
    
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(10, 420, self.view.frame.size.width - 10, 20)];
    [label setText:@"Modal height"];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:label];
    
    slider = [[UISlider alloc]initWithFrame:CGRectMake(10, 435, self.view.frame.size.width - 10, 30)];
    [slider addTarget:self action:@selector(onModalHeightSlider:) forControlEvents:UIControlEventValueChanged];
    [slider setMaximumValue:500.0];
    [slider setMinimumValue:0.0];
    [slider setValue:400 animated:YES];
    [self.view addSubview:slider];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(10, 470, self.view.frame.size.width - 10, 20)];
    [label setText:@"Modal alpha when dragged"];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:label];
    
    slider = [[UISlider alloc]initWithFrame:CGRectMake(10, 490, self.view.frame.size.width - 10, 30)];
    [slider addTarget:self action:@selector(onModalAlphaBackground:) forControlEvents:UIControlEventValueChanged];
    [slider setMaximumValue:1.0];
    [slider setMinimumValue:0.0];
    [slider setValue:0.80 animated:YES];
    [self.view addSubview:slider];
}

@end
