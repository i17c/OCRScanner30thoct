//
//  OCRAddContactFromOCRViewController.h
//  AlbaseNew
//
//  Created by Mac on 31/10/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {

    DataAditionStatusSimple,
    DataAditionStatusOcr
} PagedataaditionStatus;


#import "OCRDataObjectModel.h"
#import "OCRGlobalMethods.h"

@interface OCRAddContactFromOCRViewController : OCRGlobalMethods <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UITextFieldDelegate>

@property (assign) PagedataaditionStatus dataadtionstatus;
@property (nonatomic,retain) OCRScanDataObjectModel *DataModel;
@property (nonatomic,retain) NSMutableDictionary *DataDictionary;
@end
