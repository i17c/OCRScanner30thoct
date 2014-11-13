//
//  OCRAddInsuranceViewController.h
//  AlbaseNew
//
//  Created by Mac on 03/11/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCRDataObjectModel.h"
#import "OCRGlobalMethods.h"


@interface OCRAddInsuranceViewController : OCRGlobalMethods <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UITextFieldDelegate>

@property (nonatomic,retain) OCRScanDataObjectModel *DataModel;
@end
