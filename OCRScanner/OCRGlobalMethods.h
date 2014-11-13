//
//  OCRGlobalMethods.h
//  OCRScanner
//
//  Created by Mac on 18/09/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCRGlobalMethods : UIViewController
{
    UIImage *image;
    UIImageView *loadingView;
}
- (void)startSpin;
- (void)stopSpin;
@end
