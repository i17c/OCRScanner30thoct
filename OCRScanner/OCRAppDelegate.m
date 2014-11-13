//
//  OCRAppDelegate.m
//  OCRScanner
//
//  Created by Mac on 18/09/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import "OCRAppDelegate.h"
#import "OCRViewController.h"
#import "SideMenuViewController.h"
#import "MFSideMenuContainerViewController.h"
#import "OCRContactListViewController.h"
#import "OCRAddInsuranceViewController.h"
#import "OCRAddAppointmentViewController.h"


@implementation OCRAppDelegate

@synthesize imageToProcess;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    SideMenuViewController *leftMenuViewController = [[SideMenuViewController alloc] init];
    MFSideMenuContainerViewController *Container = [MFSideMenuContainerViewController containerWithCenterViewController:[self navigationController] leftMenuViewController:leftMenuViewController];
    imageToProcess = [UIImage imageNamed:@"IMG_0360.JPG"];
    self.window.rootViewController = Container;
    [self.window makeKeyAndVisible];
    return YES;
}
-(NSString *)CleanTextField:(NSString *)TextfieldName
{
    NSString *Cleanvalue = [TextfieldName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return Cleanvalue;
}
-(void)SetUpTabbarControllerwithcenterView :(UIViewController *)CenterView
{
    
    SideMenuViewController *leftSideMenuController = [[SideMenuViewController alloc] init];
    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                    containerWithCenterViewController:[[UINavigationController alloc] initWithRootViewController:CenterView]
                                                    leftMenuViewController:leftSideMenuController];
    self.window.rootViewController = container;
    
}

- (OCRContactListViewController *)LandingController {
    return [[OCRContactListViewController alloc] initWithNibName:@"OCRContactListViewController" bundle:nil];
}

- (UINavigationController *)navigationController {
    return [[UINavigationController alloc]
            initWithRootViewController:[self LandingController]];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
