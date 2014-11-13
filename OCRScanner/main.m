//
//  main.m
//  OCRScanner
//
//  Created by Mac on 18/09/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OCRAppDelegate.h"

int main(int argc, char * argv[])
{
    
    @try {
        @autoreleasepool {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([OCRAppDelegate class]));
        }
    }
    @catch (NSException *exception) {
        NSLog(@"exception is ==== %@",[NSString stringWithFormat:@"%@",exception]);
    }
    
}
