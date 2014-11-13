//
//  OCRViewController.m
//  OCRScanner
//
//  Created by Mac on 18/09/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import "OCRViewController.h"
#import "OCRGlobalMethods.h"
#import "MFSideMenu.h"
#import "UIColor+HexColor.h"
#import "ImageViewController.h"

@interface OCRViewController ()

@end

@implementation OCRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self.navigationController navigationBar] setHidden:YES];
    
    UIView *HeaderView = (UIView *)[self.view viewWithTag:110];
    [HeaderView setBackgroundColor:[UIColor colorFromHex:0x1EBBFE]];
    
    UIButton *SetButton = (UIButton *)[self.view viewWithTag:111];
    
    [SetButton setBackgroundImage:[UIImage imageNamed:@"nav2"] forState:UIControlStateNormal];
    [SetButton setBackgroundImage:[UIImage imageNamed:@"nav2"] forState:UIControlStateHighlighted];
    [SetButton setBackgroundImage:[UIImage imageNamed:@"nav2"] forState:UIControlStateSelected];
    [SetButton setBackgroundImage:[UIImage imageNamed:@"nav2"] forState:UIControlStateApplication];
    
    [SetButton addTarget:self action:@selector(leftSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *ScanButton = (UIButton *)[self.view viewWithTag:987];
    [ScanButton addTarget:self action:@selector(OpenScanner:) forControlEvents:UIControlEventTouchUpInside];
}
-(IBAction)OpenScanner:(id)sender
{
    ImageViewController *ImageView = [[ImageViewController alloc] init];
    [self.navigationController pushViewController:ImageView animated:YES];
}
-(void)Opensidebar
{
    NSLog(@"Opensidebar");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)leftSideMenuButtonPressed:(id)sender {
    
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        NSLog(@"Menu bar button prassed..");
    }];
    
}

@end
