

#import "RecognitionViewController.h"
#import "UIColor+HexColor.h"
#import "MFSideMenu.h"
#import "OCRDataObjectModel.h"
#import "OCRAddContactFromOCRViewController.h"
#import "XMLReader.h"

//// Name of application you created
//static NSString* MyApplicationID = @"ALBase Productivity App";
//// Password should be sent to your e-mail after application was created
//static NSString* MyPassword = @"fEsmI+dHga6isFwquJhsI/Fy";

// Name of application you created
static NSString* MyApplicationID = @"ApplicationIOS";
// Password should be sent to your e-mail after application was created
static NSString* MyPassword = @"vX2K8RDJBACmw7YseRIb+1AI";

static NSString *StatusRecognisationString = @"Contract";
static NSString *PolicyRecognisationString = @"Paid";

@implementation RecognitionViewController

@synthesize textView;
@synthesize statusLabel;
@synthesize statusIndicator;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}
- (RecognitionViewController *) initXMLParser
{
    self= [super init];
    appdelegate = (OCRAppDelegate *)[[UIApplication sharedApplication] delegate];
    return self;
}
#pragma mark - View lifecycle

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
	// Do any additional setup after loading the view, typically from a nib.
}
- (void)leftSideMenuButtonPressed:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        NSLog(@"Menu bar button prassed..");
    }];
}
- (void)viewDidUnload
{
	[self setTextView:nil];
	[self setStatusLabel:nil];
	[self setStatusIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	textView.hidden = YES;
    textView.editable = NO;
	statusLabel.hidden = NO;
	statusIndicator. hidden = NO;
	
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	statusLabel.text = @"Loading image...";
	
	UIImage* image = [(OCRAppDelegate*)[[UIApplication sharedApplication] delegate] imageToProcess];
	
	Client *client = [[Client alloc] initWithApplicationID:MyApplicationID password:MyPassword];
	[client setDelegate:self];
	
	if([[NSUserDefaults standardUserDefaults] stringForKey:@"installationID"] == nil) {
		NSString* deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
		
		NSLog(@"First run: obtaining installation ID..");
		NSString* installationID = [client activateNewInstallation:deviceID];
		NSLog(@"Done. Installation ID is \"%@\"", installationID);
		
		[[NSUserDefaults standardUserDefaults] setValue:installationID forKey:@"installationID"];
	}
	
	NSString* installationID = [[NSUserDefaults standardUserDefaults] stringForKey:@"installationID"];
	
	client.applicationID = [client.applicationID stringByAppendingString:installationID];
	
	ProcessingParams* params = [[ProcessingParams alloc] init];
	
    NSLog(@"params --- %@",[params urlString]);
    
	[client processImage:image withParams:params];
	
	statusLabel.text = @"Uploading image...";
	
    [super viewDidAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return NO;
}

#pragma mark - ClientDelegate implementation

- (void)clientDidFinishUpload:(Client *)sender
{
	statusLabel.text = @"Processing image...";
}

- (void)clientDidFinishProcessing:(Client *)sender
{
	statusLabel.text = @"Downloading result...";
}

//-(NSMutableDictionary *)BusinessLogic:(NSString *)DownloadedData
//{
//    
//    NSLog(@"DownloadedData ======== %@",DownloadedData);
//    
//    NSMutableDictionary *DataObject = [[NSMutableDictionary alloc] init];
//    NSArray *DataFieldArray = [[NSArray alloc] initWithObjects:@"Status",@"PolicyDate",@"PaidToDate",
//                               @"ModalPremium",@"NextModalPremium",@"PayUpDate",@"MaturityDate",
//                               @"InsuredAddress",@"AdjustedPremium",@"Gender",@"Name",@"NRIC",@"DOB",
//                               @"IssueAge",@"Owner",@"PaymentMode",@"PaymentMothod",@"BillToDate",nil];
//    
//    /* Initialize Data Dictionary */
//
//    for (int i =0; i<[DataFieldArray count]-1; i++) {
//        
//        [DataObject setValue:@"" forKey:[DataFieldArray objectAtIndex:i]];
//    }
//    
//    /* Value Explode Start */
//    
//    @try {
//        @try {
//            
//            NSArray *DataArray = [DownloadedData componentsSeparatedByString:@"\t"];
//            
//            NSLog(@"DataArray ---- %@",DataArray);
//            
//            
//            /*
//             * Try to fetch the value of @status
//             * Search contain is @Statue and @Status
//             * If data is comming in sigle line then @resultsone will be containing value.
//             * If value doesn't found, assign main array value as indexed in 17
//             */
//            
////            @try {
////                
////                NSPredicate *p1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Statue"];
////                NSPredicate *p2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Status"];
////                NSPredicate *placesPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[p1, p2]];
////                
////                NSArray *resultsone = [DataArray filteredArrayUsingPredicate:placesPredicate];
////                if ([resultsone count] > 0) {
////                    NSArray *DataArrayStatusOne = [[resultsone objectAtIndex:0] componentsSeparatedByString:StatusRecognisationString];
////                    if (DataArrayStatusOne.count > 0) {
////                        NSArray *DataArrayStatustwo = [[DataArrayStatusOne objectAtIndex:0] componentsSeparatedByString:@": "];
////                        [DataObject setObject:(DataArrayStatustwo.count > 0)?[[[DataArrayStatustwo objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\t" withString:@" "] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]:@"" forKey:@"Status"];
////                    } else {
////                        [DataObject setObject:@"" forKey:@"Status"];
////                    }
////                }
////            } @catch (NSException *exception) {
////                @try {
////                    NSArray *ArrayOne = [[DataArray objectAtIndex:15] componentsSeparatedByString:@":"];
////                    [DataObject setObject:([ArrayOne count]>0)?[ArrayOne objectAtIndex:1]:[DataArray objectAtIndex:17] forKey:@"Status"];
////                }
////                @catch (NSException *exception) {
////                    @throw [NSException exceptionWithName:@"Status Creation"
////                                                   reason:@"Status Creation Error"
////                                                 userInfo:nil];
////                }
////            }
////            
////            
////            /*
////             * Try to fetch the value of @Policy date
////             * Search contain is @Policy Dato and @Policy Date
////             * If data is comming in sigle line then @resultsone will be containing value.
////             * If value doesn't found, assign main array value as indexed in 17
////             */
////            
////            
////            @try {
////                
////                NSPredicate *p1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Policy Dato"];
////                NSPredicate *p2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Policy Date"];
////                NSPredicate *placesPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[p1, p2]];
////                
////                NSArray *resultsone = [DataArray filteredArrayUsingPredicate:placesPredicate];
////                if ([resultsone count] > 0) {
////                    
////                    NSArray *DataArrayStatusOne = [[resultsone objectAtIndex:0] componentsSeparatedByString:PolicyRecognisationString];
////                    if (DataArrayStatusOne.count > 0) {
////                        NSArray *DataArrayStatustwo = [[DataArrayStatusOne objectAtIndex:0] componentsSeparatedByString:@": "];
////                        [DataObject setObject:(DataArrayStatustwo.count > 0)?[[[DataArrayStatustwo objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\t" withString:@" "] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]:@"" forKey:@"PolicyDate"];
////                        
////                    } else {
////                        [DataObject setObject:@"" forKey:@"PolicyDate"];
////                    }
////                }
////            } @catch (NSException *exception) {
////                @try {
////                    NSArray *ArrayOne = [[DataArray objectAtIndex:16] componentsSeparatedByString:@":"];
////                    [DataObject setObject:([ArrayOne count]>0)?[ArrayOne objectAtIndex:1]:[DataArray objectAtIndex:17] forKey:@"PolicyDate"];
////                }
////                @catch (NSException *exception) {
////                    @throw [NSException exceptionWithName:@"PolicyDate Creation"
////                                                   reason:@"PolicyDate Creation Error"
////                                                 userInfo:nil];
////                }
////            }
////            
////            /*
////             * Try to fetch the value of @Policy date
////             * Search contain is @Policy Dato and @Policy Date
////             * If data is comming in sigle line then @resultsone will be containing value.
////             * If value doesn't found, assign main array value as indexed in 17
////             */
////            
////            
////            @try {
////                NSPredicate *p1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Paid To Date"];
////                NSPredicate *p2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Paid To Dato"];
////                NSPredicate *placesPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[p1, p2]];
////                
////                NSArray *resultsone = [DataArray filteredArrayUsingPredicate:placesPredicate];
////                if ([resultsone count] > 0) {
////                    
////                    NSArray *DataArrayStatusOne = [[resultsone objectAtIndex:0] componentsSeparatedByString:@":"];
////                    if (DataArrayStatusOne.count > 0) {
////                        [DataObject setObject:[DataArrayStatusOne objectAtIndex:2] forKey:@"PaidToDate"];
////                    } else {
////                        [DataObject setObject:@"" forKey:@"PaidToDate"];
////                    }
////                }
////            } @catch (NSException *exception) {
////                @throw [NSException exceptionWithName:@"PaidToDate Creation"
////                                               reason:@"PaidToDate Creation Error"
////                                             userInfo:nil];
////            }
////            
////            /*
////             * Try to fetch the value of @Policy date
////             * Search contain is @Policy Dato and @Policy Date
////             * If data is comming in sigle line then @resultsone will be containing value.
////             * If value doesn't found, assign main array value as indexed in 17
////             */
////            
////            
////            @try {
////                
////                NSPredicate *p1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Modal Premium"];
////                NSPredicate *p2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Model Premium"];
////                NSPredicate *p3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Model Premium"];
////                NSPredicate *placesPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[p1, p2, p3]];
////                
////                NSArray *resultsone = [DataArray filteredArrayUsingPredicate:placesPredicate];
////                if ([resultsone count] > 0) {
////                    
////                    //NSLog(@"resultsone ---- %@",resultsone);
////                    
////                    NSArray *DataArrayStatusOne = [[resultsone objectAtIndex:0] componentsSeparatedByString:@"Next Modal Premium"];
////                    if (DataArrayStatusOne.count > 0) {
////                        NSArray *DataArrayStatustwo = [[DataArrayStatusOne objectAtIndex:0] componentsSeparatedByString:@": "];
////                        [DataObject setObject:(DataArrayStatustwo.count > 0)?[[[DataArrayStatustwo objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\t" withString:@" "] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]:@"" forKey:@"ModalPremium"];
////                        
////                        NSArray *DataArrayStatust = [[DataArrayStatusOne objectAtIndex:1] componentsSeparatedByString:@": "];
////                        [DataObject setObject:(DataArrayStatust.count > 0)?[[[DataArrayStatust objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\t" withString:@" "] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]:@"" forKey:@"NextModalPremium"];
////                        
////                    } else {
////                        [DataObject setObject:@"" forKey:@"ModalPremium"];
////                        [DataObject setObject:@"" forKey:@"NextModalPremium"];
////                    }
////                }
////                
////            } @catch (NSException *exception) {
////                
////                @try {
////                    NSArray *ArrayOne = [[DataArray objectAtIndex:16] componentsSeparatedByString:@":"];
////                    [DataObject setObject:([ArrayOne count]>0)?[ArrayOne objectAtIndex:1]:[DataArray objectAtIndex:17] forKey:@"PolicyDate"];
////                }
////                @catch (NSException *exception) {
////                    @throw [NSException exceptionWithName:@"ModalPremium and NextModalPremium Creation"
////                                                   reason:@"ModalPremium and NextModalPremium Creation Error"
////                                                 userInfo:nil];
////                }
////            }
////            
////            /*
////             * Try to fetch the value of @Policy date
////             * Search contain is @Policy Dato and @Policy Date
////             * If data is comming in sigle line then @resultsone will be containing value.
////             * If value doesn't found, assign main array value as indexed in 17
////             */
////            
////            
////            @try {
////                
////                NSPredicate *p1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Maturity Date"];
////                NSPredicate *p2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Maturity Data"];
////                NSPredicate *p3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Maturity Dato"];
////                NSPredicate *placesPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[p1, p2, p3]];
////                
////                NSArray *resultsone = [DataArray filteredArrayUsingPredicate:placesPredicate];
////                if ([resultsone count] > 0) {
////                    NSArray *DataArrayStatusOne = [[resultsone objectAtIndex:0] componentsSeparatedByString:@"Maturity Date"];
////                    if (DataArrayStatusOne.count > 0) {
////                        NSArray *DataArrayStatustwo = [[DataArrayStatusOne objectAtIndex:0] componentsSeparatedByString:@": "];
////                        [DataObject setObject:(DataArrayStatustwo.count > 0)?[[[DataArrayStatustwo objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\t" withString:@" "] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]:@"" forKey:@"PayUpDate"];
////                        
////                        NSArray *DataArrayStatust = [[DataArrayStatusOne objectAtIndex:1] componentsSeparatedByString:@": "];
////                        [DataObject setObject:(DataArrayStatust.count > 0)?[[[DataArrayStatust objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\t" withString:@" "] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]:@"" forKey:@"MaturityDate"];
////                        
////                    } else {
////                        [DataObject setObject:@"" forKey:@"PayUpDate"];
////                        [DataObject setObject:@"" forKey:@"MaturityDate"];
////                    }
////                }
////                
////            } @catch (NSException *exception) {
////                @throw [NSException exceptionWithName:@"PayUpDate and MaturityDate Creation"
////                                               reason:@"PayUpDate and MaturityDate Creation Error"
////                                             userInfo:nil];
////            }
////            
////            /*
////             * Try to fetch the value of @Policy date
////             * Search contain is @Policy Dato and @Policy Date
////             * If data is comming in sigle line then @resultsone will be containing value.
////             * If value doesn't found, assign main array value as indexed in 17
////             */
////            
////            
////            @try {
////                
////                NSPredicate *p1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Insured Address"];
////                NSPredicate *p2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Insured Addross"];
////                NSPredicate *p3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Insurod Address"];
////                NSPredicate *placesPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[p1, p2, p3]];
////                
////                NSArray *resultsone = [DataArray filteredArrayUsingPredicate:placesPredicate];
////                if ([resultsone count] > 0) {
////                    NSArray *DataArrayStatusOne = [[resultsone objectAtIndex:0] componentsSeparatedByString:@"Adjusted Premium"];
////                    
////                    if (DataArrayStatusOne.count > 0) {
////                        NSArray *DataArrayStatustwo = [[DataArrayStatusOne objectAtIndex:0] componentsSeparatedByString:@": "];
////                        [DataObject setObject:(DataArrayStatustwo.count > 0)?[[[DataArrayStatustwo objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\t" withString:@" "] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]:@"" forKey:@"InsuredAddress"];
////                        
////                        NSArray *DataArrayStatust = [[DataArrayStatusOne objectAtIndex:1] componentsSeparatedByString:@": "];
////                        [DataObject setObject:(DataArrayStatust.count > 0)?[[[DataArrayStatust objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\t" withString:@" "] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]:@"" forKey:@"AdjustedPremium"];
////                        
////                    } else {
////                        [DataObject setObject:@"" forKey:@"InsuredAddress"];
////                        [DataObject setObject:@"" forKey:@"AdjustedPremium"];
////                    }
////                }
////                
////            } @catch (NSException *exception) {
////                @throw [NSException exceptionWithName:@"InsuredAddress and AdjustedPremium Creation"
////                                               reason:@"InsuredAddress and AdjustedPremium Creation Error"
////                                             userInfo:nil];
////            }
////            
////            /*
////             * Try to fetch the value of @Policy date
////             * Search contain is @Policy Dato and @Policy Date
////             * If data is comming in sigle line then @resultsone will be containing value.
////             * If value doesn't found, assign main array value as indexed in 17
////             */
////            
////            
////            @try {
////                
////                NSPredicate *p1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Gender"];
////                NSPredicate *p2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Gonder"];
////                NSPredicate *p3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Gendor"];
////                NSPredicate *placesPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[p1, p2, p3]];
////                
////                NSArray *resultsone = [DataArray filteredArrayUsingPredicate:placesPredicate];
////                if ([resultsone count] > 0) {
////                    
////                    NSArray *DataArrayStatusOne = [[resultsone objectAtIndex:0] componentsSeparatedByString:@":"];
////                    if (DataArrayStatusOne.count > 0) {
////                        
////                        [DataObject setObject:[DataArrayStatusOne lastObject] forKey:@"Gender"];
////                    } else {
////                        [DataObject setObject:@"" forKey:@"Gender"];
////                    }
////                }
////                
////            } @catch (NSException *exception) {
////                @throw [NSException exceptionWithName:@"Gender Creation"
////                                               reason:@"Gender Creation Error"
////                                             userInfo:nil];
////            }
////            
////            /*
////             * Try to fetch the value of @Policy date
////             * Search contain is @Policy Dato and @Policy Date
////             * If data is comming in sigle line then @resultsone will be containing value.
////             * If value doesn't found, assign main array value as indexed in 17
////             */
////            
////            
////            @try {
////                
////                NSPredicate *p1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"NRIC No"];
////                NSPredicate *p2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"NRIC Na"];
////                NSPredicate *placesPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[p1, p2]];
////                
////                NSArray *resultsone = [DataArray filteredArrayUsingPredicate:placesPredicate];
////                if ([resultsone count] > 0) {
////                    
////                    NSArray *DataArrayStatusOne = [[resultsone objectAtIndex:0] componentsSeparatedByString:@":"];
////                    if ([DataArrayStatusOne count]>0) {
////                        [DataObject setObject:[DataArrayStatusOne lastObject] forKey:@"NRIC"];
////                    } else {
////                        [DataObject setObject:@"" forKey:@"NRIC"];
////                    }
////                }
////                
////            } @catch (NSException *exception) {
////                @throw [NSException exceptionWithName:@"NRIC Creation"
////                                               reason:@"NRIC Creation Error"
////                                             userInfo:nil];
////            }
////            
////
////            /*
////             * Try to fetch the value of @Policy date
////             * Search contain is @Policy Dato and @Policy Date
////             * If data is comming in sigle line then @resultsone will be containing value.
////             * If value doesn't found, assign main array value as indexed in 17
////             */
////            
////            
////            @try {
////                
////                NSPredicate *p1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Issue Age"];
////                NSPredicate *p2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Issue Ago"];
////                NSPredicate *p3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Issuo Age"];
////                
////                NSPredicate *placesPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[p1, p2, p3]];
////                
////                NSArray *resultsone = [DataArray filteredArrayUsingPredicate:placesPredicate];
////                if ([resultsone count] > 0) {
////                    
////                    //NSLog(@"resultsone ---- %@",resultsone);
////                    
////                    NSArray *DataArrayStatusOne = [[resultsone objectAtIndex:0] componentsSeparatedByString:@"\t"];
////                    if ([DataArrayStatusOne count]>0) {
////                        [DataObject setObject:[DataArrayStatusOne lastObject] forKey:@"IssueAge"];
////                    } else {
////                        [DataObject setObject:@"" forKey:@"IssueAge"];
////                    }
////                }
////                
////            } @catch (NSException *exception) {
////                @throw [NSException exceptionWithName:@"IssueAge Creation"
////                                               reason:@"IssueAge Creation Error"
////                                             userInfo:nil];
////            }
////            
////            /*
////             * Try to fetch the value of @Policy date
////             * Search contain is @Policy Dato and @Policy Date
////             * If data is comming in sigle line then @resultsone will be containing value.
////             * If value doesn't found, assign main array value as indexed in 17
////             */
////            
////            
////            @try {
////                
////                NSPredicate *p1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Owner"];
////                NSPredicate *p2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Ownor"];
////                
////                NSPredicate *placesPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[p1, p2]];
////                NSArray *resultsone = [DataArray filteredArrayUsingPredicate:placesPredicate];
////                if ([resultsone count] > 0) {
////                    
////                    NSArray *DataArrayStatusOne = [[resultsone objectAtIndex:1] componentsSeparatedByString:@":"];
////                    if ([DataArrayStatusOne count]>0) {
////                        [DataObject setObject:[DataArrayStatusOne objectAtIndex:1] forKey:@"Owner"];
////                    } else {
////                        [DataObject setObject:@"" forKey:@"Owner"];
////                    }
////                }
////                
////            } @catch (NSException *exception) {
////                @throw [NSException exceptionWithName:@"Owner Creation"
////                                               reason:@"Owner Creation Error"
////                                             userInfo:nil];
////            }
////            
////            /*
////             * Try to fetch the value of @Policy date
////             * Search contain is @Policy Dato and @Policy Date
////             * If data is comming in sigle line then @resultsone will be containing value.
////             * If value doesn't found, assign main array value as indexed in 17
////             */
////            
////            
////            @try {
////                
////                NSPredicate *p1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Payment Mode"];
////                NSPredicate *p2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Payment Modo"];
////                
////                NSPredicate *placesPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[p1, p2]];
////                
////                NSArray *resultsone = [DataArray filteredArrayUsingPredicate:placesPredicate];
////                if ([resultsone count] > 0) {
////                    
////                    NSArray *DataArrayStatusOne = [[resultsone objectAtIndex:0] componentsSeparatedByString:@"\t"];
////                    if ([DataArrayStatusOne count]>0) {
////                        [DataObject setObject:[DataArrayStatusOne objectAtIndex:1] forKey:@"PaymentMode"];
////                    } else {
////                        [DataObject setObject:@"" forKey:@"PaymentMode"];
////                    }
////                }
////                
////            } @catch (NSException *exception) {
////                @throw [NSException exceptionWithName:@"Payment Mode Creation"
////                                               reason:@"Payment Mode Creation Error"
////                                             userInfo:nil];
////            }
////            
////            /*
////             * Try to fetch the value of @Policy date
////             * Search contain is @Policy Dato and @Policy Date
////             * If data is comming in sigle line then @resultsone will be containing value.
////             * If value doesn't found, assign main array value as indexed in 17
////             */
////            
////            
////            @try {
////                
////                NSPredicate *p1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Payment Method"];
////                NSPredicate *p2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Payment Mothod"];
////                
////                NSPredicate *placesPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[p1, p2]];
////                
////                NSArray *resultsone = [DataArray filteredArrayUsingPredicate:placesPredicate];
////                if ([resultsone count] > 0) {
////                    
////                    NSArray *DataArrayStatusOne = [[resultsone objectAtIndex:0] componentsSeparatedByString:@"\t"];
////                    if ([DataArrayStatusOne count]>0) {
////                        [DataObject setObject:[DataArrayStatusOne lastObject] forKey:@"PaymentMothod"];
////                    } else {
////                        [DataObject setObject:@"" forKey:@"PaymentMothod"];
////                    }
////                }
////                
////            } @catch (NSException *exception) {
////                @throw [NSException exceptionWithName:@"Payment Method Creation"
////                                               reason:@"Payment Method Creation Error"
////                                             userInfo:nil];
////            }
////            
////            /*
////             * Try to fetch the value of @Policy date
////             * Search contain is @Policy Dato and @Policy Date
////             * If data is comming in sigle line then @resultsone will be containing value.
////             * If value doesn't found, assign main array value as indexed in 17
////             */
////            
////            
////            @try {
////                
////                NSPredicate *p1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Bill To Dato"];
////                NSPredicate *p2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Bill To Date"];
////                
////                NSPredicate *placesPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[p1, p2]];
////                
////                NSArray *resultsone = [DataArray filteredArrayUsingPredicate:placesPredicate];
////                if ([resultsone count] > 0) {
////                    
////                    NSArray *DataArrayStatusOne = [[resultsone objectAtIndex:0] componentsSeparatedByString:@"\t"];
////                    if ([DataArrayStatusOne count]>0) {
////                        [DataObject setObject:[DataArrayStatusOne objectAtIndex:3] forKey:@"BillToDate"];
////                    } else {
////                        [DataObject setObject:@"" forKey:@"BillToDate"];
////                    }
////                }
////                
////            } @catch (NSException *exception) {
////                @throw [NSException exceptionWithName:@"Bill To Date Creation"
////                                               reason:@"Bill To Date Creation Error"
////                                             userInfo:nil];
////            }
//            
//           
//            /*
//             * Try to fetch the value of @Policy date
//             * Search contain is @Policy Dato and @Policy Date
//             * If data is comming in sigle line then @resultsone will be containing value.
//             * If value doesn't found, assign main array value as indexed in 17
//             */
//            
//            
//            @try {
//                
//                NSPredicate *p1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Dato of Birth"];
//                NSPredicate *p2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Date of Birth"];
//                NSPredicate *placesPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[p1, p2]];
//                
//                NSArray *resultsone = [DataArray filteredArrayUsingPredicate:placesPredicate];
//                
//                NSLog(@"resultsone date of birth ==== %@",resultsone);
//                
//                if ([resultsone count] > 0) {
//                    
//                    NSArray *DataArrayStatusOne = [[resultsone objectAtIndex:0] componentsSeparatedByString:@"\t"];
//                    
//                    NSLog(@"Date of Birth ---- %@",DataArrayStatusOne);
//                    
//                    
//                    if ([DataArrayStatusOne count]>0) {
//                        [DataObject setObject:[DataArrayStatusOne objectAtIndex:1] forKey:@"DOB"];
//                    } else {
//                        [DataObject setObject:@"" forKey:@"DOB"];
//                    }
//                }
//                
//            } @catch (NSException *exception) {
//                
//                NSLog(@"i am here in exception part");
////                @throw [NSException exceptionWithName:@"DOB Creation"
////                                               reason:@"DOB Creation Error"
////                                             userInfo:nil];
//            }
//
//            
//            
//            @try {
//                
//                NSPredicate *p1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Namo"];
//                NSPredicate *p2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Name"];
//                NSPredicate *p3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Nome"];
//                NSPredicate *placesPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[p1, p2, p3]];
//                
//                NSArray *resultsone = [DataArray filteredArrayUsingPredicate:placesPredicate];
//                
//                if ([resultsone count] > 0) {
//                    
//                    NSLog(@"Name fetch step one resultsone>0");
//                    
//                    NSArray *DataArrayStatusOne = [[resultsone objectAtIndex:0] componentsSeparatedByString:@":"];
//                    
//                    if ([DataArrayStatusOne count]>0) {
//                        
//                        NSLog(@"Name fetch step two DataArrayStatusOne>0");
//                        
//                        NSArray *DataArrayStatusOne1 = [[DataArrayStatusOne objectAtIndex:1] componentsSeparatedByString:@"\t"];
//                        
//                        if (DataArrayStatusOne1.count > 0) {
//                            
//                            NSLog(@"Name fetch step three DataArrayStatusOne1>0");
//                            
//                            [DataObject setObject:[DataArrayStatusOne1 objectAtIndex:0] forKey:@"Name"];
//                        } else {
//                            
//                            NSLog(@"Name fetch step three DataArrayStatusOne1<0");
//                            
//                            [DataObject setObject:[DataArray objectAtIndex:40] forKey:@"Name"];
//                        }
//                    } else {
//                        NSLog(@"Name fetch step two DataArrayStatusOne<0");
//                        
//                        [DataObject setObject:[DataArray objectAtIndex:40] forKey:@"Name"];
//                    }
//                } else {
//                    NSLog(@"Name fetch step one resultsone<0");
//                }
//                
//            } @catch (NSException *exception) {
//                @try {
//                    NSLog(@"Name fetch step catche try");
//                    
//                    NSPredicate *p1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @": "];
//                    NSPredicate *placesPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[p1]];
//                    NSArray *resultsone = [DataArray filteredArrayUsingPredicate:placesPredicate];
//                    NSLog(@"resultsone data array --- %@",resultsone);
//                    
//                    NSArray *ArrayNamo = [[resultsone objectAtIndex:9] componentsSeparatedByString:@"/t"];
//                    
//                    [DataObject setObject:[ArrayNamo objectAtIndex:1] forKey:@"Name"];
//                    
//                }
//                @catch (NSException *exception) {
//                    
//                    NSLog(@"Name fetch step catche exception");
//                    [DataObject setObject:[DataArray objectAtIndex:40] forKey:@"Name"];
//                }
//            }
////            
//        }
//        @catch (NSException *exception) {
//            @throw [NSException exceptionWithName:@"1St Step Array Creation"
//                                           reason:@"1St Step Array Creation Error"
//                                         userInfo:nil];
//        }
//        
//            
//    }
//    @catch (NSException *exception) {
//        NSLog(@"Final Exception is --- %@",[NSString stringWithFormat:@"%@",exception]);
//    }
//    
//    return DataObject;
//}
-(NSMutableDictionary *)BusinessLogic:(NSString *)DownloadedData
{
    
    NSLog(@"DownloadedData ======== %@",DownloadedData);
    
    NSMutableDictionary *DataObject = [[NSMutableDictionary alloc] init];
    NSArray *DataFieldArray = [[NSArray alloc] initWithObjects:@"Status",@"PolicyDate",@"PaidToDate",
                               @"ModalPremium",@"NextModalPremium",@"PayUpDate",@"MaturityDate",
                               @"InsuredAddress",@"AdjustedPremium",@"Gender",@"Name",@"NRIC",@"DOB",
                               @"IssueAge",@"Owner",@"PaymentMode",@"PaymentMothod",@"BillToDate",nil];
    
    /* Initialize Data Dictionary */
    
    for (int i =0; i<[DataFieldArray count]-1; i++) {
        
        [DataObject setValue:@"" forKey:[DataFieldArray objectAtIndex:i]];
    }
    
    /* Value Explode Start */
    
    @try {
        
        /* *************************************************************************
         Section To Split result data into array -- Start
         ************************************************************************* */
        
        @try {
            
            NSLog(@"DownloadedData ---- %@",DownloadedData);
            
           // exit(0);
            
            NSArray *DataArray = [DownloadedData componentsSeparatedByString:@"\n"];
            NSLog(@"DataArray ---- %@",DataArray);
            NSLog(@"DataArray Count ---- %lu",(unsigned long)[DataArray count]);
            NSLog(@"Directory seperated by : %@",[DataArray componentsJoinedByString:@": "]);
            
            /* *************************************************************************
             Section To check status data from array -- Start
             ************************************************************************* */
            
            @try {
                
                NSPredicate *Statusp1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Statue"];
                NSPredicate *Statusp2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Status"];
                NSPredicate *Statusp3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Stetue"];
                NSPredicate *Statusp4 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Stetus"];
                
                NSPredicate *StatusPredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[Statusp1, Statusp2, Statusp3 ,Statusp4]];
                NSArray *Statusresultsone       = [DataArray filteredArrayUsingPredicate:StatusPredicate];
                
                if ([Statusresultsone count] > 0)
                {
                    NSArray *FinalSplitedArray = [[Statusresultsone objectAtIndex:0] componentsSeparatedByString:@"\t"];
                    
                    if ([FinalSplitedArray count]>0) {
                        
                        [DataObject setObject:[FinalSplitedArray objectAtIndex:1] forKey:@"Status"];
                        
                    } else {
                        
                        [DataObject setObject:@"Not Found" forKey:@"Status"];
                    }
                }
                else
                {
                    [DataObject setObject:@"Not Found" forKey:@"Status"];
                }
                
            } @catch (NSException *exception) {
                
                [DataObject setObject:@"Not Found" forKey:@"Status"];
                
                @throw [NSException exceptionWithName:@"Status Creation Error"
                                               reason:[NSString stringWithFormat:@"%@",exception]
                                             userInfo:nil];
            }
            
            /* *************************************************************************
             Section To check status data from array -- End
             ************************************************************************* */
            
            /* *************************************************************************
             Section To check name data from array -- Start
             ************************************************************************* */
            
            @try {
                
                NSPredicate *Namep1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Name"];
                NSPredicate *Namep2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Nemo"];
                NSPredicate *Namep3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Nomo"];
                NSPredicate *Namep4 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Neme"];
                NSPredicate *Namep5 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Nome"];
                NSPredicate *Namep6 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Homo"];
                NSPredicate *Namep7 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Nnmo"];
                NSPredicate *Namep8 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Nsmo"];
                NSPredicate *Namep9 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Namo"];
                
                NSPredicate *NamePredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[Namep1, Namep2, Namep3 ,Namep4,Namep5,Namep6,Namep7,Namep8,Namep9]];
                NSArray *Nameresultsone       = [DataArray filteredArrayUsingPredicate:NamePredicate];
                
                NSLog(@"Nameresultsone === %@",Nameresultsone);
                
                if ([Nameresultsone count] > 0)
                {
                    NSArray *FinalSplitedArray = [[Nameresultsone objectAtIndex:0] componentsSeparatedByString:@"\t"];
                    
                    NSLog(@"FinalSplitedArray === %@",FinalSplitedArray);
                    
                    if ([FinalSplitedArray count]>0) {
                        
                        [DataObject setObject:[FinalSplitedArray objectAtIndex:1] forKey:@"Name"];
                        
                    } else {
                        
                        [DataObject setObject:@"Not Found" forKey:@"Name"];
                    }
                }
                else
                {
                    [DataObject setObject:@"Not Found" forKey:@"Name"];
                }
                
            } @catch (NSException *exception) {
                
                [DataObject setObject:@"Not Found" forKey:@"Name"];
                
                @throw [NSException exceptionWithName:@"Name Creation Error"
                                               reason:[NSString stringWithFormat:@"%@",exception]
                                             userInfo:nil];
            }
            
            /* *************************************************************************
             Section To check name data from array -- End
             ************************************************************************* */
            
            /* *************************************************************************
             Section To check Date of Birth data from array -- Start
             ************************************************************************* */
            
            @try {
                
                NSPredicate *DOBp1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Date of Birth"];
                NSPredicate *DOBp2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Dato of Birth"];
                NSPredicate *DOBp3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Dote of Birth"];
                NSPredicate *DOBp4 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Doto of Birth"];
                
                NSPredicate *DOBPredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[DOBp1, DOBp2, DOBp3 ,DOBp4]];
                NSArray *DOBresultsone       = [DataArray filteredArrayUsingPredicate:DOBPredicate];
                
                NSLog(@"DOBresultsone === %@",DOBresultsone);
                
                if ([DOBresultsone count] > 0)
                {
                    NSArray *FinalSplitedArray = [[DOBresultsone objectAtIndex:0] componentsSeparatedByString:@"\t"];
                    
                    NSLog(@"FinalSplitedArray === %@",FinalSplitedArray);
                    
                    if ([FinalSplitedArray count]>0) {
                        
                        [DataObject setObject:[FinalSplitedArray objectAtIndex:1] forKey:@"DOB"];
                        
                    } else {
                        
                        [DataObject setObject:@"Not Found" forKey:@"DOB"];
                    }
                }
                else
                {
                    [DataObject setObject:@"Not Found" forKey:@"DOB"];
                }
                
            } @catch (NSException *exception) {
                
                [DataObject setObject:@"Not Found" forKey:@"DOB"];
                
                @throw [NSException exceptionWithName:@"DOB Creation Error"
                                               reason:[NSString stringWithFormat:@"%@",exception]
                                             userInfo:nil];
            }
            
            /* *************************************************************************
             Section To check Date of Birth data from array -- End
             ************************************************************************* */
            
            /* *************************************************************************
             Section To check NRIC No data from array -- Start
             ************************************************************************* */
            
            @try {
                
                NSPredicate *NRICp1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"NRIC No"];
                NSPredicate *NRICp2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"NRIC Na"];
                NSPredicate *NRICp3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"NRIC Ne"];
                
                NSPredicate *NRICPredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[NRICp1, NRICp2, NRICp3]];
                NSArray *NRICresultsone       = [DataArray filteredArrayUsingPredicate:NRICPredicate];
                
                NSLog(@"NRICresultsone === %@",NRICresultsone);
                
                if ([NRICresultsone count] > 0)
                {
                    NSArray *FinalSplitedArray = [[NRICresultsone objectAtIndex:0] componentsSeparatedByString:@"\t"];
                    
                    NSLog(@"FinalSplitedArray === %@",FinalSplitedArray);
                    
                    if ([FinalSplitedArray count]>0) {
                        
                        [DataObject setObject:[FinalSplitedArray objectAtIndex:1] forKey:@"NRIC"];
                        
                    } else {
                        
                        [DataObject setObject:@"Not Found" forKey:@"NRIC"];
                    }
                }
                else
                {
                    [DataObject setObject:@"Not Found" forKey:@"NRIC"];
                }
                
            } @catch (NSException *exception) {
                
                [DataObject setObject:@"Not Found" forKey:@"NRIC"];
                
                @throw [NSException exceptionWithName:@"NRIC Creation Error"
                                               reason:[NSString stringWithFormat:@"%@",exception]
                                             userInfo:nil];
            }
            
            /* *************************************************************************
             Section To check NRIC No data from array -- End
             ************************************************************************* */
            
            
            /* *************************************************************************
             Section To check Gender data from array -- Start
             ************************************************************************* */
            
            @try {
                
                NSPredicate *Genderp1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Gender"];
                NSPredicate *Genderp2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Gendor"];
                NSPredicate *Genderp3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Gonder"];
                NSPredicate *Genderp4 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Gondor"];
                
                NSPredicate *GenderPredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[Genderp1, Genderp2, Genderp3,Genderp4]];
                NSArray *Genderresultsone       = [DataArray filteredArrayUsingPredicate:GenderPredicate];
                
                NSLog(@"NRICresultsone === %@",Genderresultsone);
                
                if ([Genderresultsone count] > 0)
                {
                    NSArray *FinalSplitedArray = [[Genderresultsone objectAtIndex:0] componentsSeparatedByString:@"\t"];
                    
                    NSLog(@"FinalSplitedArray === %@",FinalSplitedArray);
                    
                    if ([FinalSplitedArray count]>0) {
                        
                        [DataObject setObject:[FinalSplitedArray objectAtIndex:3] forKey:@"Gender"];
                        
                    } else {
                        
                        [DataObject setObject:@"Not Found" forKey:@"Gender"];
                    }
                }
                else
                {
                    [DataObject setObject:@"Not Found" forKey:@"Gender"];
                }
                
            } @catch (NSException *exception) {
                
                [DataObject setObject:@"Not Found" forKey:@"Gender"];
                
                @throw [NSException exceptionWithName:@"Gender Creation Error"
                                               reason:[NSString stringWithFormat:@"%@",exception]
                                             userInfo:nil];
            }
            
            /* *************************************************************************
             Section To check Gender data from array -- End
             ************************************************************************* */
            
            
            /* *************************************************************************
             Section To check Owner data from array -- Start
             ************************************************************************* */
            
            @try {
                
                NSPredicate *Ownerp1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Owner"];
                NSPredicate *Ownerp2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Ownor"];
                NSPredicate *Ownerp3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Owoer"];
                NSPredicate *Ownerp4 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Owoor"];
                
                NSPredicate *OwnerPredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[Ownerp1, Ownerp2, Ownerp3,Ownerp4]];
                NSArray *Ownerresultsone       = [DataArray filteredArrayUsingPredicate:OwnerPredicate];
                
                NSLog(@"Ownerresultsone === %@",Ownerresultsone);
                
                if ([Ownerresultsone count] > 0)
                {
                    NSArray *FinalSplitedArray = [[Ownerresultsone objectAtIndex:1] componentsSeparatedByString:@"\t"];
                    
                    NSLog(@"FinalSplitedArray === %@",FinalSplitedArray);
                    
                    if ([FinalSplitedArray count]>0) {
                        
                        [DataObject setObject:[FinalSplitedArray objectAtIndex:1] forKey:@"Owner"];
                        
                    } else {
                        
                        [DataObject setObject:@"Not Found" forKey:@"Owner"];
                    }
                }
                else
                {
                    [DataObject setObject:@"Not Found" forKey:@"Owner"];
                }
                
            } @catch (NSException *exception) {
                
                [DataObject setObject:@"this is blank value Owner" forKey:@"Owner"];
                
                @throw [NSException exceptionWithName:@"Owner Creation Error"
                                               reason:[NSString stringWithFormat:@"%@",exception]
                                             userInfo:nil];
            }
            
            /* *************************************************************************
             Section To check Owner data from array -- End
             ************************************************************************* */
            
            
            /* *************************************************************************
             Section To check Policy Date data from array -- Start
             ************************************************************************* */
            
            @try {
                
                NSPredicate *PolicyDatep1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Policy Dato"];
                NSPredicate *PolicyDatep2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Policy Date"];
                NSPredicate *PolicyDatep3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Policy Doto"];
                NSPredicate *PolicyDatep4 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Policy Dote"];
                
                NSPredicate *PolicyDatePredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[PolicyDatep1, PolicyDatep2, PolicyDatep3,PolicyDatep4]];
                NSArray *PolicyDateresultsone       = [DataArray filteredArrayUsingPredicate:PolicyDatePredicate];
                
                NSLog(@"PolicyDateresultsone === %@",PolicyDateresultsone);
                
                if ([PolicyDateresultsone count] > 0)
                {
                    NSArray *FinalSplitedArray = [[PolicyDateresultsone objectAtIndex:0] componentsSeparatedByString:@"\t"];
                    
                    NSLog(@"FinalSplitedPolicyDateArray === %@",FinalSplitedArray);
                    
                    if ([FinalSplitedArray count]>0) {
                        
                        [DataObject setObject:[FinalSplitedArray objectAtIndex:1] forKey:@"PolicyDate"];
                        
                    } else {
                        
                        [DataObject setObject:@"Not Found" forKey:@"PolicyDate"];
                    }
                }
                else
                {
                    [DataObject setObject:@"Not Found" forKey:@"PolicyDate"];
                }
                
            } @catch (NSException *exception) {
                
                [DataObject setObject:@"Not Found" forKey:@"PolicyDate"];
                
                @throw [NSException exceptionWithName:@"PolicyDate Creation Error"
                                               reason:[NSString stringWithFormat:@"%@",exception]
                                             userInfo:nil];
            }
            
            /* *************************************************************************
             Section To check Policy Date data from array -- End
             ************************************************************************* */
            
            /* *************************************************************************
             Section To check Paid To Date data from array -- Start
             ************************************************************************* */
            
            
            @try {
                
                NSPredicate *PaidToDatep1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Paid To Date"];
                NSPredicate *PaidToDatep2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Paid To Dato"];
                NSPredicate *PaidToDatep3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Paid To Dote"];
                NSPredicate *PaidToDatep4 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Paid To Doto"];
                
                NSPredicate *PaidToDatePredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[PaidToDatep1, PaidToDatep2, PaidToDatep3,PaidToDatep4]];
                NSArray *PaidToDateresultsone       = [DataArray filteredArrayUsingPredicate:PaidToDatePredicate];
                
                NSLog(@"PaidToDateresultsone === %@",PaidToDateresultsone);
                
                if ([PaidToDateresultsone count] > 0)
                {
                    NSArray *FinalSplitedArray = [[PaidToDateresultsone objectAtIndex:0] componentsSeparatedByString:@"\t"];
                    
                    NSLog(@"PaidToDateSplitedArray === %@",FinalSplitedArray);
                    
                    if ([FinalSplitedArray count]>0) {
                        
                        [DataObject setObject:[FinalSplitedArray objectAtIndex:3] forKey:@"PaidToDate"];
                        
                    } else {
                        
                        [DataObject setObject:@"Not Found" forKey:@"PaidToDate"];
                    }
                }
                else
                {
                    [DataObject setObject:@"Not Found" forKey:@"PaidToDate"];
                }
                
            } @catch (NSException *exception) {
                
                [DataObject setObject:@"Not Found" forKey:@"PaidToDate"];
                
                @throw [NSException exceptionWithName:@"PaidToDate Creation Error"
                                               reason:[NSString stringWithFormat:@"%@",exception]
                                             userInfo:nil];
            }
            
            /* *************************************************************************
             Section To check Paid to Date data from array -- End
             ************************************************************************* */
            
            /* *************************************************************************
             Section To check Model Premium data from array -- Start
             ************************************************************************* */
            
            @try {
                
                NSPredicate *ModalPremiump1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Modal Premium"];
                NSPredicate *ModalPremiump2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Modol Premium"];
                NSPredicate *ModalPremiump3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Modal Premiom"];
                NSPredicate *ModalPremiump4 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Modal Promium"];
                
                NSPredicate *ModalPremiumPredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[ModalPremiump1, ModalPremiump2, ModalPremiump3,ModalPremiump4]];
                NSArray *ModalPremiumresultsone       = [DataArray filteredArrayUsingPredicate:ModalPremiumPredicate];
                
                NSLog(@"ModalPremiumresultsone === %@",ModalPremiumresultsone);
                
                if ([ModalPremiumresultsone count] > 0)
                {
                    NSArray *FinalSplitedArray = [[ModalPremiumresultsone objectAtIndex:0] componentsSeparatedByString:@"\t"];
                    
                    NSLog(@"ModalPremiumSplitedArray === %@",FinalSplitedArray);
                    
                    if ([FinalSplitedArray count]>0) {
                        
                        [DataObject setObject:[FinalSplitedArray objectAtIndex:1] forKey:@"ModalPremium"];
                        
                    } else {
                        
                        [DataObject setObject:@"Not Found" forKey:@"ModalPremium"];
                    }
                }
                else
                {
                    [DataObject setObject:@"Not Found" forKey:@"ModalPremium"];
                }
                
            } @catch (NSException *exception) {
                
                [DataObject setObject:@"Not Found" forKey:@"ModalPremium"];
                
                @throw [NSException exceptionWithName:@"ModalPremium Creation Error"
                                               reason:[NSString stringWithFormat:@"%@",exception]
                                             userInfo:nil];
            }
            
            
            /* *************************************************************************
             Section To check Model Premium data from array -- End
             ************************************************************************* */
            
            /* *************************************************************************
             Section To check Next Model Premium data from array -- Start
             ************************************************************************* */
            
            @try {
                
                NSPredicate *NextModalPremiump1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Next Modal Premiom"];
                NSPredicate *NextModalPremiump2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Next Modal Premium"];
                NSPredicate *NextModalPremiump3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Next Modol Premium"];
                NSPredicate *NextModalPremiump4 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Noxt Modal Premium"];
                
                NSPredicate *NextModalPremiumPredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[NextModalPremiump1, NextModalPremiump2, NextModalPremiump3,NextModalPremiump4]];
                NSArray *NextModalPremiumresultsone       = [DataArray filteredArrayUsingPredicate:NextModalPremiumPredicate];
                
                NSLog(@"NextModalPremiumresultsone === %@",NextModalPremiumresultsone);
                
                if ([NextModalPremiumresultsone count] > 0)
                {
                    NSArray *FinalSplitedArray = [[NextModalPremiumresultsone objectAtIndex:0] componentsSeparatedByString:@"\t"];
                    
                    NSLog(@"FinalSplitedArrayNextModalPremium === %@",FinalSplitedArray);
                    
                    if ([FinalSplitedArray count]>0) {
                        
                        [DataObject setObject:[FinalSplitedArray objectAtIndex:3] forKey:@"NextModalPremium"];
                        
                    } else {
                        
                        [DataObject setObject:@"Not Found" forKey:@"NextModalPremium"];
                    }
                }
                else
                {
                    [DataObject setObject:@"Not Found" forKey:@"NextModalPremium"];
                }
                
            } @catch (NSException *exception) {
                
                [DataObject setObject:@"Not Found" forKey:@"NextModalPremium"];
                
                @throw [NSException exceptionWithName:@"NextModalPremium Creation Error"
                                               reason:[NSString stringWithFormat:@"%@",exception]
                                             userInfo:nil];
            }
            
            
            /* *************************************************************************
             Section To check Next Model Premium data from array -- End
             ************************************************************************* */
            
            /* *************************************************************************
             Section To check Pay Update data from array -- Start
             ************************************************************************* */
            
            @try {
                
                NSPredicate *PayUpDatep1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Pay Up Dato"];
                NSPredicate *PayUpDatep2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Pay Up Date"];
                NSPredicate *PayUpDatep3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Pay Up Dote"];
                NSPredicate *PayUpDatep4 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Pay Up Dete"];
                
                NSPredicate *PayUpDatePredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[PayUpDatep1, PayUpDatep2, PayUpDatep3,PayUpDatep4]];
                NSArray *PayUpDateresultsone       = [DataArray filteredArrayUsingPredicate:PayUpDatePredicate];
                
                NSLog(@"PayUpDateresultsone === %@",PayUpDateresultsone);
                
                if ([PayUpDateresultsone count] > 0)
                {
                    NSArray *FinalSplitedArray = [[PayUpDateresultsone objectAtIndex:0] componentsSeparatedByString:@"\t"];
                    
                    NSLog(@"FinalSplitedArrayPayUpDate === %@",FinalSplitedArray);
                    
                    if ([FinalSplitedArray count]>0) {
                        
                        [DataObject setObject:[FinalSplitedArray objectAtIndex:1] forKey:@"PayUpDate"];
                        
                    } else {
                        
                        [DataObject setObject:@"Not Found" forKey:@"PayUpDate"];
                    }
                }
                else
                {
                    [DataObject setObject:@"Not Found" forKey:@"PayUpDate"];
                }
                
            } @catch (NSException *exception) {
                
                [DataObject setObject:@"Not Found" forKey:@"PayUpDate"];
                
                @throw [NSException exceptionWithName:@"PayUpDate Creation Error"
                                               reason:[NSString stringWithFormat:@"%@",exception]
                                             userInfo:nil];
            }
            
            /* *************************************************************************
             Section To check Pay Update data from array -- End
             ************************************************************************* */
            
            /* *************************************************************************
             Section To check maturity Date data from array -- Start
             ************************************************************************* */
            
            @try {
                
                NSPredicate *MaturityDatep1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Maturity Date"];
                NSPredicate *MaturityDatep2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Maturity Dato"];
                NSPredicate *MaturityDatep3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Maturity Dote"];
                NSPredicate *MaturityDatep4 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Maturity Dete"];
                NSPredicate *MaturityDatep5 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Maturity Doto"];
                
                NSPredicate *MaturityDatePredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[MaturityDatep1, MaturityDatep2, MaturityDatep3,MaturityDatep4,MaturityDatep5]];
                NSArray *MaturityDateresultsone       = [DataArray filteredArrayUsingPredicate:MaturityDatePredicate];
                
                NSLog(@"MaturityDateresultsone === %@",MaturityDateresultsone);
                
                if ([MaturityDateresultsone count] > 0)
                {
                    NSArray *FinalSplitedArray = [[MaturityDateresultsone objectAtIndex:0] componentsSeparatedByString:@"\t"];
                    
                    NSLog(@"FinalSplitedArrayMaturityDate === %@",FinalSplitedArray);
                    
                    if ([FinalSplitedArray count]>0) {
                        
                        [DataObject setObject:[FinalSplitedArray objectAtIndex:3] forKey:@"MaturityDate"];
                        
                    } else {
                        
                        [DataObject setObject:@"Not Found" forKey:@"MaturityDate"];
                    }
                }
                else
                {
                    [DataObject setObject:@"Not Found" forKey:@"MaturityDate"];
                }
                
            } @catch (NSException *exception) {
                
                [DataObject setObject:@"Not Found" forKey:@"MaturityDate"];
                
                @throw [NSException exceptionWithName:@"MaturityDate Creation Error"
                                               reason:[NSString stringWithFormat:@"%@",exception]
                                             userInfo:nil];
            }
            
            /* *************************************************************************
             Section To check maturity Date data from array -- End
             ************************************************************************* */
            
            /* *************************************************************************
             Section To check Insured Address data from array -- Start
             ************************************************************************* */
            
            @try {
                
                NSPredicate *InsuredAddressp1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Insured Address"];
                NSPredicate *InsuredAddressp2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Insured Addross"];
                NSPredicate *InsuredAddressp3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Insured Addreso"];
                NSPredicate *InsuredAddressp4 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Insured Addreoo"];
                
                NSPredicate *InsuredAddressPredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[InsuredAddressp1, InsuredAddressp2, InsuredAddressp3,InsuredAddressp4]];
                NSArray *InsuredAddressresultsone       = [DataArray filteredArrayUsingPredicate:InsuredAddressPredicate];
                
                NSLog(@"InsuredAddressresultsone === %@",InsuredAddressresultsone);
                
                if ([InsuredAddressresultsone count] > 0)
                {
                    NSArray *FinalSplitedArray = [[InsuredAddressresultsone objectAtIndex:0] componentsSeparatedByString:@"\t"];
                    
                    NSLog(@"FinalSplitedArrayInsuredAddress === %@",FinalSplitedArray);
                    
                    if ([FinalSplitedArray count]>0) {
                        
                        [DataObject setObject:[FinalSplitedArray objectAtIndex:1] forKey:@"InsuredAddress"];
                        
                    } else {
                        
                        [DataObject setObject:@"Not Found" forKey:@"InsuredAddress"];
                    }
                }
                else
                {
                    [DataObject setObject:@"Not Found" forKey:@"InsuredAddress"];
                }
                
            } @catch (NSException *exception) {
                
                [DataObject setObject:@"Not Found" forKey:@"InsuredAddress"];
                
                @throw [NSException exceptionWithName:@"InsuredAddress Creation Error"
                                               reason:[NSString stringWithFormat:@"%@",exception]
                                             userInfo:nil];
            }
            
            
            /* *************************************************************************
             Section To check Insured Address data from array -- End
             ************************************************************************* */
            
            /* *************************************************************************
             Section To check Adjust Premium data from array -- Start
             ************************************************************************* */
            
            @try {
                
                NSPredicate *AdjustedPremiump1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Adjusted Premiom"];
                NSPredicate *AdjustedPremiump2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Adjusted Promiom"];
                NSPredicate *AdjustedPremiump3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Adjusted Promium"];
                NSPredicate *AdjustedPremiump4 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Adjusted Premium"];
                
                NSPredicate *AdjustedPremiumPredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[AdjustedPremiump1, AdjustedPremiump2, AdjustedPremiump3,AdjustedPremiump4]];
                NSArray *AdjustedPremiumresultsone       = [DataArray filteredArrayUsingPredicate:AdjustedPremiumPredicate];
                
                NSLog(@"AdjustedPremiumresultsone === %@",AdjustedPremiumresultsone);
                
                if ([AdjustedPremiumresultsone count] > 0)
                {
                    NSArray *FinalSplitedArray = [[AdjustedPremiumresultsone objectAtIndex:0] componentsSeparatedByString:@"\t"];
                    
                    NSLog(@"FinalSplitedArrayAdjustedPremium === %@",FinalSplitedArray);
                    
                    if ([FinalSplitedArray count]>0) {
                        
                        [DataObject setObject:[FinalSplitedArray objectAtIndex:3] forKey:@"AdjustedPremium"];
                        
                    } else {
                        
                        [DataObject setObject:@"Not Found" forKey:@"AdjustedPremium"];
                    }
                }
                else
                {
                    [DataObject setObject:@"Not Found" forKey:@"AdjustedPremium"];
                }
                
            } @catch (NSException *exception) {
                
                [DataObject setObject:@"Not Found" forKey:@"AdjustedPremium"];
                
                @throw [NSException exceptionWithName:@"AdjustedPremium Creation Error"
                                               reason:[NSString stringWithFormat:@"%@",exception]
                                             userInfo:nil];
            }
            
            
            /* *************************************************************************
             Section To check Adjust Premium data from array -- End
             ************************************************************************* */
            
            /* *************************************************************************
             Section To check Issue Age data from array -- Start
             ************************************************************************* */
            
            @try {
                
                NSPredicate *IssueAgep1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Issue Age"];
                NSPredicate *IssueAgep2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Issue Ago"];
                NSPredicate *IssueAgep3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Issuo Age"];
                NSPredicate *IssueAgep4 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Issuo Ago"];
                NSPredicate *IssueAgep5 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Issoo Ago"];
                
                NSPredicate *IssueAgePredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[IssueAgep1, IssueAgep2, IssueAgep3,IssueAgep4,IssueAgep5]];
                NSArray *IssueAgeresultsone       = [DataArray filteredArrayUsingPredicate:IssueAgePredicate];
                
                NSLog(@"IssueAgeresultsone === %@",IssueAgeresultsone);
                
                if ([IssueAgeresultsone count] > 0)
                {
                    NSArray *FinalSplitedArray = [[IssueAgeresultsone objectAtIndex:0] componentsSeparatedByString:@"\t"];
                    
                    NSLog(@"FinalSplitedArrayIssueAgeresultsone === %@",FinalSplitedArray);
                    
                    if ([FinalSplitedArray count]>0) {
                        
                        [DataObject setObject:[FinalSplitedArray objectAtIndex:3] forKey:@"IssueAge"];
                        
                    } else {
                        
                        [DataObject setObject:@"Not Found" forKey:@"IssueAge"];
                    }
                }
                else
                {
                    [DataObject setObject:@"Not Found" forKey:@"IssueAge"];
                }
                
            } @catch (NSException *exception) {
                
                [DataObject setObject:@"Not Found" forKey:@"IssueAge"];
                
                @throw [NSException exceptionWithName:@"IssueAge Creation Error"
                                               reason:[NSString stringWithFormat:@"%@",exception]
                                             userInfo:nil];
            }
            
            /* *************************************************************************
             Section To check Issue Age data from array -- End
             ************************************************************************* */
            
            
            /* *************************************************************************
             Section To check Payment Mode data from array -- Start
             ************************************************************************* */
            
            @try {
                
                NSPredicate *PaymentModep1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Payment Mode"];
                NSPredicate *PaymentModep2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Payment Modo"];
                NSPredicate *PaymentModep3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Payment Mede"];
                NSPredicate *PaymentModep4 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Payment Made"];
                
                NSPredicate *PaymentModePredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[PaymentModep1, PaymentModep2, PaymentModep3,PaymentModep4]];
                NSArray *PaymentModeresultsone       = [DataArray filteredArrayUsingPredicate:PaymentModePredicate];
                
                NSLog(@"PaymentModeresultsone === %@",PaymentModeresultsone);
                
                if ([PaymentModeresultsone count] > 0)
                {
                    NSArray *FinalSplitedArray = [[PaymentModeresultsone objectAtIndex:0] componentsSeparatedByString:@"\t"];
                    
                    NSLog(@"FinalSplitedArrayPaymentMode === %@",FinalSplitedArray);
                    
                    if ([FinalSplitedArray count]>0) {
                        
                        [DataObject setObject:[FinalSplitedArray objectAtIndex:1] forKey:@"PaymentMode"];
                        
                    } else {
                        
                        [DataObject setObject:@"Not Found" forKey:@"PaymentMode"];
                    }
                }
                else
                {
                    [DataObject setObject:@"Not Found" forKey:@"PaymentMode"];
                }
                
            } @catch (NSException *exception) {
                
                [DataObject setObject:@"Not Found" forKey:@"PaymentMode"];
                
                @throw [NSException exceptionWithName:@"PaymentMode Creation Error"
                                               reason:[NSString stringWithFormat:@"%@",exception]
                                             userInfo:nil];
            }
            
            /* *************************************************************************
             Section To check Payment Mode data from array -- End
             ************************************************************************* */
            
            /* *************************************************************************
             Section To check payment Method data from array -- Start
             ************************************************************************* */
            
            @try {
                
                NSPredicate *PaymentMothodp1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Payment Method"];
                NSPredicate *PaymentMothodp2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Payment Mothod"];
                NSPredicate *PaymentMothodp3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Paymont Method"];
                NSPredicate *PaymentMothodp4 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Paymont Mothod"];
                
                NSPredicate *PaymentMothodPredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[PaymentMothodp1, PaymentMothodp2, PaymentMothodp3,PaymentMothodp4]];
                NSArray *PaymentMothodresultsone       = [DataArray filteredArrayUsingPredicate:PaymentMothodPredicate];
                
                NSLog(@"PaymentMothodresultsone === %@",PaymentMothodresultsone);
                
                if ([PaymentMothodresultsone count] > 0)
                {
                    NSArray *FinalSplitedArray = [[PaymentMothodresultsone objectAtIndex:0] componentsSeparatedByString:@"\t"];
                    
                    NSLog(@"FinalSplitedArrayPaymentMothod === %@",FinalSplitedArray);
                    
                    if ([FinalSplitedArray count]>0) {
                        
                        [DataObject setObject:[FinalSplitedArray objectAtIndex:3] forKey:@"PaymentMothod"];
                        
                    } else {
                        
                        [DataObject setObject:@"Not Found" forKey:@"PaymentMothod"];
                    }
                }
                else
                {
                    [DataObject setObject:@"Not Found" forKey:@"PaymentMothod"];
                }
                
            } @catch (NSException *exception) {
                
                [DataObject setObject:@"Not Found" forKey:@"PaymentMothod"];
                
                @throw [NSException exceptionWithName:@"PaymentMothod Creation Error"
                                               reason:[NSString stringWithFormat:@"%@",exception]
                                             userInfo:nil];
            }
            
            
            /* *************************************************************************
             Section To check payment Method data from array -- End
             ************************************************************************* */
            
            /* *************************************************************************
             Section To check Bill To Date data from array -- Start
             ************************************************************************* */
            
            @try {
                
                NSPredicate *BillToDatep1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Bill To Date"];
                NSPredicate *BillToDatep2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Bill To Dato"];
                NSPredicate *BillToDatep3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Bill To Dote"];
                NSPredicate *BillToDatep4 = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"Bill To Dete"];
                
                NSPredicate *BillToDatePredicate    = [NSCompoundPredicate orPredicateWithSubpredicates:@[BillToDatep1, BillToDatep2, BillToDatep3,BillToDatep4]];
                NSArray *BillToDateresultsone       = [DataArray filteredArrayUsingPredicate:BillToDatePredicate];
                
                NSLog(@"BillToDateresultsone === %@",BillToDateresultsone);
                
                if ([BillToDateresultsone count] > 0)
                {
                    NSArray *FinalSplitedArray = [[BillToDateresultsone objectAtIndex:0] componentsSeparatedByString:@"\t"];
                    
                    NSLog(@"FinalSplitedArrayBillToDate === %@",FinalSplitedArray);
                    
                    if ([FinalSplitedArray count]>0) {
                        
                        [DataObject setObject:[FinalSplitedArray objectAtIndex:3] forKey:@"BillToDate"];
                        
                    } else {
                        
                        [DataObject setObject:@"Not Found" forKey:@"BillToDate"];
                    }
                }
                else
                {
                    [DataObject setObject:@"Not Found" forKey:@"BillToDate"];
                }
                
            } @catch (NSException *exception) {
                
                [DataObject setObject:@"Not Found" forKey:@"BillToDate"];
                
                @throw [NSException exceptionWithName:@"BillToDate Creation Error"
                                               reason:[NSString stringWithFormat:@"%@",exception]
                                             userInfo:nil];
            }
            
            /* *************************************************************************
             Section To check Bill to date data from array -- End
             ************************************************************************* */
            
            
        }
        @catch (NSException *exception) {
            @throw [NSException exceptionWithName:@"Array Generation Error"
                                           reason:[NSString stringWithFormat:@"%@",exception]
                                         userInfo:nil];
        }
        
        /* *************************************************************************
         Section To Split result data into array -- End
         ************************************************************************* */
        
    }
    @catch (NSException *exception) {
        NSLog(@"Final Exception is --- %@",[NSString stringWithFormat:@"%@",exception]);
    }
    
    NSLog(@"DataObject ------ %@",DataObject);
    
    return DataObject;
}
- (void)client:(Client *)sender didFinishDownloadData:(NSData *)downloadedData
{
    
	statusLabel.hidden = YES;
    
	statusIndicator.hidden = YES;
	
	textView.hidden = NO;
	
	NSString* result = [[NSString alloc] initWithData:downloadedData encoding:NSUTF8StringEncoding];
	
	textView.text = result;
    
    NSArray *ImageDataArray =[result componentsSeparatedByString:@"\n"];
    
    NSLog(@"result ----- %@",ImageDataArray);
    
    NSLog(@"ImageDataArray count --- %lu",(unsigned long)[ImageDataArray count]);
    
   
    
  //  NSMutableDictionary *DataContainDictionary = [[NSMutableDictionary alloc] init];
    
//    /*
//     * Try to fetch the value of @status
//     * Search contain is @Statue and @Status
//     * If data is comming in sigle line then @resultsone will be containing value.
//     * If value doesn't found, assign main array value as indexed in 17
//     */
//    
//    @try {
//    
//        NSPredicate *p1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Statue"];
//        NSPredicate *p2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Status"];
//        NSPredicate *placesPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[p1, p2]];
//    
//        NSArray *resultsone = [DataArray filteredArrayUsingPredicate:placesPredicate];
//        if ([resultsone count] > 0) {
//            NSLog(@"resultsone ---- %@",resultsone);
//            
//            NSArray *DataArrayStatusOne = [[resultsone objectAtIndex:0] componentsSeparatedByString:StatusRecognisationString];
//            if (DataArrayStatusOne.count > 0) {
//                NSArray *DataArrayStatustwo = [[DataArrayStatusOne objectAtIndex:0] componentsSeparatedByString:@": "];
//                [DataContainDictionary setObject:(DataArrayStatustwo.count > 0)?[[[DataArrayStatustwo objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\t" withString:@" "] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]:@"" forKey:@"Status"];
//            } else {
//                [DataContainDictionary setObject:@"" forKey:@"Status"];
//            }
//        }
//    } @catch (NSException *exception) {
//        
//        NSLog(@"Data manipulation Error for Status");
//        
//        NSArray *ArrayOne = [[DataArray objectAtIndex:15] componentsSeparatedByString:@":"];
//        
//        NSLog(@"ArrayOne ---- %@",ArrayOne);
//        
//        [DataContainDictionary setObject:([ArrayOne count]>0)?[ArrayOne objectAtIndex:1]:[DataArray objectAtIndex:17] forKey:@"Status"];
//    }
//
//    /*
//     * Try to fetch the value of @Policy date
//     * Search contain is @Policy Dato and @Policy Date
//     * If data is comming in sigle line then @resultsone will be containing value.
//     * If value doesn't found, assign main array value as indexed in 17
//     */
//    
//    
//    @try {
//        
//        NSPredicate *p1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Policy Dato"];
//        NSPredicate *p2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Policy Date"];
//        NSPredicate *placesPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[p1, p2]];
//        
//        NSArray *resultsone = [DataArray filteredArrayUsingPredicate:placesPredicate];
//        if ([resultsone count] > 0) {
//            
//            NSArray *DataArrayStatusOne = [[resultsone objectAtIndex:0] componentsSeparatedByString:PolicyRecognisationString];
//            if (DataArrayStatusOne.count > 0) {
//                NSArray *DataArrayStatustwo = [[DataArrayStatusOne objectAtIndex:0] componentsSeparatedByString:@": "];
//                [DataContainDictionary setObject:(DataArrayStatustwo.count > 0)?[[[DataArrayStatustwo objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\t" withString:@" "] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]:@"" forKey:@"PolicyDate"];
//                
//                
//            } else {
//                [DataContainDictionary setObject:@"" forKey:@"PolicyDate"];
//            }
//        }
//    } @catch (NSException *exception) {
//        
//        NSLog(@"Data manipulation Error for Status");
//        
//        NSArray *ArrayOne = [[DataArray objectAtIndex:16] componentsSeparatedByString:@":"];
//        
//        NSLog(@"ArrayOne ---- %@",ArrayOne);
//    
//        [DataContainDictionary setObject:([ArrayOne count]>0)?[ArrayOne objectAtIndex:1]:[DataArray objectAtIndex:17] forKey:@"PolicyDate"];
//    }
//    
//    /*
//     * Try to fetch the value of @Policy date
//     * Search contain is @Policy Dato and @Policy Date
//     * If data is comming in sigle line then @resultsone will be containing value.
//     * If value doesn't found, assign main array value as indexed in 17
//     */
//    
//    
//    @try {
//        
//        NSPredicate *p1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Paid To Date"];
//        NSPredicate *p2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Paid To Dato"];
//        NSPredicate *placesPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[p1, p2]];
//        
//        NSArray *resultsone = [DataArray filteredArrayUsingPredicate:placesPredicate];
//        if ([resultsone count] > 0) {
//            
//            NSArray *DataArrayStatusOne = [[resultsone objectAtIndex:0] componentsSeparatedByString:@":"];
//            NSLog(@"DataArrayStatusOne ---- %@",DataArrayStatusOne);
//            
//            if (DataArrayStatusOne.count > 0) {
//                
//                [DataContainDictionary setObject:[DataArrayStatusOne objectAtIndex:2] forKey:@"PaidToDate"];
//            } else {
//                [DataContainDictionary setObject:@"" forKey:@"PaidToDate"];
//            }
//        }
//    } @catch (NSException *exception) {
//        
//        NSLog(@"Data manipulation Error for Paid To Date");
//        [DataContainDictionary setObject:@"" forKey:@"PaidToDate"];
//    }
//    
//    /*
//     * Try to fetch the value of @Policy date
//     * Search contain is @Policy Dato and @Policy Date
//     * If data is comming in sigle line then @resultsone will be containing value.
//     * If value doesn't found, assign main array value as indexed in 17
//     */
//    
//    
//    @try {
//        
//        NSPredicate *p1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Modal Premium"];
//        NSPredicate *p2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Model Premium"];
//        NSPredicate *p3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Model Premium"];
//        NSPredicate *placesPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[p1, p2, p3]];
//        
//        NSArray *resultsone = [DataArray filteredArrayUsingPredicate:placesPredicate];
//        if ([resultsone count] > 0) {
//            
//            //NSLog(@"resultsone ---- %@",resultsone);
//            
//            NSArray *DataArrayStatusOne = [[resultsone objectAtIndex:0] componentsSeparatedByString:@"Next Modal Premium"];
//            if (DataArrayStatusOne.count > 0) {
//                NSArray *DataArrayStatustwo = [[DataArrayStatusOne objectAtIndex:0] componentsSeparatedByString:@": "];
//                [DataContainDictionary setObject:(DataArrayStatustwo.count > 0)?[[[DataArrayStatustwo objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\t" withString:@" "] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]:@"" forKey:@"ModalPremium"];
//                
//                NSArray *DataArrayStatust = [[DataArrayStatusOne objectAtIndex:1] componentsSeparatedByString:@": "];
//                [DataContainDictionary setObject:(DataArrayStatust.count > 0)?[[[DataArrayStatust objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\t" withString:@" "] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]:@"" forKey:@"NextModalPremium"];
//                
//            } else {
//                [DataContainDictionary setObject:@"" forKey:@"ModalPremium"];
//                [DataContainDictionary setObject:@"" forKey:@"NextModalPremium"];
//            }
//        }
//        
//    } @catch (NSException *exception) {
//        
//        NSLog(@"Data manipulation Error for Status");
//        
//        NSArray *ArrayOne = [[DataArray objectAtIndex:16] componentsSeparatedByString:@":"];
//        
//        NSLog(@"ArrayOne ---- %@",ArrayOne);
//        
//        [DataContainDictionary setObject:([ArrayOne count]>0)?[ArrayOne objectAtIndex:1]:[DataArray objectAtIndex:17] forKey:@"PolicyDate"];
//    }
//    
//    /*
//     * Try to fetch the value of @Policy date
//     * Search contain is @Policy Dato and @Policy Date
//     * If data is comming in sigle line then @resultsone will be containing value.
//     * If value doesn't found, assign main array value as indexed in 17
//     */
//    
//    
//    @try {
//        
//        NSPredicate *p1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Maturity Date"];
//        NSPredicate *p2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Maturity Data"];
//        NSPredicate *p3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Maturity Dato"];
//        NSPredicate *placesPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[p1, p2, p3]];
//        
//        NSArray *resultsone = [DataArray filteredArrayUsingPredicate:placesPredicate];
//        if ([resultsone count] > 0) {
//            
//            //NSLog(@"resultsone ---- %@",resultsone);
//            
//            NSArray *DataArrayStatusOne = [[resultsone objectAtIndex:0] componentsSeparatedByString:@"Maturity Date"];
//            
//            //NSLog(@"DataArrayStatusOne ---- %@",DataArrayStatusOne);
//            
//            if (DataArrayStatusOne.count > 0) {
//                NSArray *DataArrayStatustwo = [[DataArrayStatusOne objectAtIndex:0] componentsSeparatedByString:@": "];
//                [DataContainDictionary setObject:(DataArrayStatustwo.count > 0)?[[[DataArrayStatustwo objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\t" withString:@" "] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]:@"" forKey:@"PayUpDate"];
//                
//                NSArray *DataArrayStatust = [[DataArrayStatusOne objectAtIndex:1] componentsSeparatedByString:@": "];
//                [DataContainDictionary setObject:(DataArrayStatust.count > 0)?[[[DataArrayStatust objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\t" withString:@" "] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]:@"" forKey:@"MaturityDate"];
//                
//            } else {
//                [DataContainDictionary setObject:@"" forKey:@"PayUpDate"];
//                [DataContainDictionary setObject:@"" forKey:@"MaturityDate"];
//            }
//        }
//        
//    } @catch (NSException *exception) {
//        
//        NSLog(@"Data manipulation Error for MaturityDate");
//        
////        NSArray *ArrayOne = [[DataArray objectAtIndex:16] componentsSeparatedByString:@":"];
////        
////        NSLog(@"ArrayOne ---- %@",ArrayOne);
////        
////        [DataContainDictionary setObject:([ArrayOne count]>0)?[ArrayOne objectAtIndex:1]:[DataArray objectAtIndex:17] forKey:@"PolicyDate"];
//        
//    }
//    
//    /*
//     * Try to fetch the value of @Policy date
//     * Search contain is @Policy Dato and @Policy Date
//     * If data is comming in sigle line then @resultsone will be containing value.
//     * If value doesn't found, assign main array value as indexed in 17
//     */
//    
//    
//    @try {
//        
//        NSPredicate *p1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Insured Address"];
//        NSPredicate *p2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Insured Addross"];
//        NSPredicate *p3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Insurod Address"];
//        NSPredicate *placesPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[p1, p2, p3]];
//        
//        NSArray *resultsone = [DataArray filteredArrayUsingPredicate:placesPredicate];
//        if ([resultsone count] > 0) {
//            
//            //NSLog(@"resultsone ---- %@",resultsone);
//            
//            NSArray *DataArrayStatusOne = [[resultsone objectAtIndex:0] componentsSeparatedByString:@"Adjusted Premium"];
//            
//            //NSLog(@"DataArrayStatusOne ---- %@",DataArrayStatusOne);
//            
//            if (DataArrayStatusOne.count > 0) {
//                NSArray *DataArrayStatustwo = [[DataArrayStatusOne objectAtIndex:0] componentsSeparatedByString:@": "];
//                [DataContainDictionary setObject:(DataArrayStatustwo.count > 0)?[[[DataArrayStatustwo objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\t" withString:@" "] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]:@"" forKey:@"InsuredAddress"];
//                
//                NSArray *DataArrayStatust = [[DataArrayStatusOne objectAtIndex:1] componentsSeparatedByString:@": "];
//                [DataContainDictionary setObject:(DataArrayStatust.count > 0)?[[[DataArrayStatust objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\t" withString:@" "] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]:@"" forKey:@"AdjustedPremium"];
//                
//            } else {
//                [DataContainDictionary setObject:@"" forKey:@"InsuredAddress"];
//                [DataContainDictionary setObject:@"" forKey:@"AdjustedPremium"];
//            }
//        }
//        
//    } @catch (NSException *exception) {
//        
//        NSLog(@"Data manipulation Error for Insured Address");
//        
//        //        NSArray *ArrayOne = [[DataArray objectAtIndex:16] componentsSeparatedByString:@":"];
//        //
//        //        NSLog(@"ArrayOne ---- %@",ArrayOne);
//        //
//        //        [DataContainDictionary setObject:([ArrayOne count]>0)?[ArrayOne objectAtIndex:1]:[DataArray objectAtIndex:17] forKey:@"PolicyDate"];
//        
//    }
//    
//    
//# warning For personal Details
//    
//    /*
//     * Try to fetch the value of @Policy date
//     * Search contain is @Policy Dato and @Policy Date
//     * If data is comming in sigle line then @resultsone will be containing value.
//     * If value doesn't found, assign main array value as indexed in 17
//     */
//    
//    
//    @try {
//        
//        NSPredicate *p1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Gender"];
//        NSPredicate *p2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Gonder"];
//        NSPredicate *p3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Gendor"];
//        NSPredicate *placesPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[p1, p2, p3]];
//        
//        NSArray *resultsone = [DataArray filteredArrayUsingPredicate:placesPredicate];
//        if ([resultsone count] > 0) {
//            
//            //NSLog(@"resultsone ---- %@",resultsone);
//            
//            NSArray *DataArrayStatusOne = [[resultsone objectAtIndex:0] componentsSeparatedByString:@":"];
//            
//            if (DataArrayStatusOne.count > 0) {
//                
//                [DataContainDictionary setObject:[DataArrayStatusOne lastObject] forKey:@"Gender"];
//            } else {
//                [DataContainDictionary setObject:@"" forKey:@"Gender"];
//            }
//        }
//        
//    } @catch (NSException *exception) {
//        
//        NSLog(@"Data manipulation Error for Insured Gender");
//        
//    }
//    
//# warning For name
//    
//    /*
//     * Try to fetch the value of @Policy date
//     * Search contain is @Policy Dato and @Policy Date
//     * If data is comming in sigle line then @resultsone will be containing value.
//     * If value doesn't found, assign main array value as indexed in 17
//     */
//    
//    
//    @try {
//        
//        NSPredicate *p1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Namo"];
//        NSPredicate *p2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Name"];
//        NSPredicate *p3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Nome"];
//        NSPredicate *placesPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[p1, p2, p3]];
//        
//        NSArray *resultsone = [DataArray filteredArrayUsingPredicate:placesPredicate];
//        if ([resultsone count] > 0) {
//            
//            //NSLog(@"resultsone ---- %@",resultsone);
//            
//            NSArray *DataArrayStatusOne = [[resultsone objectAtIndex:0] componentsSeparatedByString:@":"];
//            if ([DataArrayStatusOne count]>0) {
//                NSArray *DataArrayStatusOne1 = [[DataArrayStatusOne objectAtIndex:1] componentsSeparatedByString:@"\t"];
//                if (DataArrayStatusOne1.count > 0) {
//                    [DataContainDictionary setObject:[DataArrayStatusOne1 objectAtIndex:0] forKey:@"Name"];
//                } else {
//                    [DataContainDictionary setObject:@"" forKey:@"Name"];
//                }
//            } else {
//                [DataContainDictionary setObject:@"" forKey:@"Name"];
//            }
//        }
//        
//    } @catch (NSException *exception) {
//        
//        NSLog(@"Data manipulation Error for Insured Name");
//        
//    }
//    
//# warning For NRIC Number
//    
//    /*
//     * Try to fetch the value of @Policy date
//     * Search contain is @Policy Dato and @Policy Date
//     * If data is comming in sigle line then @resultsone will be containing value.
//     * If value doesn't found, assign main array value as indexed in 17
//     */
//    
//    
//    @try {
//        
//        NSPredicate *p1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"NRIC No"];
//        NSPredicate *p2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"NRIC Na"];
//        NSPredicate *placesPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[p1, p2]];
//        
//        NSArray *resultsone = [DataArray filteredArrayUsingPredicate:placesPredicate];
//        if ([resultsone count] > 0) {
//            
//            //NSLog(@"resultsone ---- %@",resultsone);
//            
//            NSArray *DataArrayStatusOne = [[resultsone objectAtIndex:0] componentsSeparatedByString:@":"];
//            if ([DataArrayStatusOne count]>0) {
//                [DataContainDictionary setObject:[DataArrayStatusOne lastObject] forKey:@"NRIC"];
//            } else {
//                [DataContainDictionary setObject:@"" forKey:@"NRIC"];
//            }
//        }
//        
//    } @catch (NSException *exception) {
//        
//        NSLog(@"Data manipulation Error for Insured NRIC");
//        
//    }
//    
//# warning For Dato of Birth
//    
//    /*
//     * Try to fetch the value of @Policy date
//     * Search contain is @Policy Dato and @Policy Date
//     * If data is comming in sigle line then @resultsone will be containing value.
//     * If value doesn't found, assign main array value as indexed in 17
//     */
//    
//    
//    @try {
//        
//        NSPredicate *p1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Dato of Birth"];
//        NSPredicate *p2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Date of Birth"];
//        NSPredicate *placesPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[p1, p2]];
//        
//        NSArray *resultsone = [DataArray filteredArrayUsingPredicate:placesPredicate];
//        if ([resultsone count] > 0) {
//            
//            //NSLog(@"resultsone ---- %@",resultsone);
//            
//            NSArray *DataArrayStatusOne = [[resultsone objectAtIndex:0] componentsSeparatedByString:@"\t"];
//            NSLog(@"Date of Birth ---- %@",DataArrayStatusOne);
//            if ([DataArrayStatusOne count]>0) {
//                [DataContainDictionary setObject:[DataArrayStatusOne objectAtIndex:1] forKey:@"DOB"];
//            } else {
//                [DataContainDictionary setObject:@"" forKey:@"DOB"];
//            }
//        }
//        
//    } @catch (NSException *exception) {
//        
//        NSLog(@"Data manipulation Error for Insured DOB");
//        
//    }
//    
//# warning For Issue Age
//    
//    /*
//     * Try to fetch the value of @Policy date
//     * Search contain is @Policy Dato and @Policy Date
//     * If data is comming in sigle line then @resultsone will be containing value.
//     * If value doesn't found, assign main array value as indexed in 17
//     */
//    
//    
//    @try {
//        
//        NSPredicate *p1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Issue Age"];
//        NSPredicate *p2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Issue Ago"];
//        NSPredicate *p3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Issuo Age"];
//        
//        NSPredicate *placesPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[p1, p2, p3]];
//        
//        NSArray *resultsone = [DataArray filteredArrayUsingPredicate:placesPredicate];
//        if ([resultsone count] > 0) {
//            
//            //NSLog(@"resultsone ---- %@",resultsone);
//            
//            NSArray *DataArrayStatusOne = [[resultsone objectAtIndex:0] componentsSeparatedByString:@"\t"];
//            NSLog(@"Issue Age ---- %@",DataArrayStatusOne);
//            if ([DataArrayStatusOne count]>0) {
//                [DataContainDictionary setObject:[DataArrayStatusOne lastObject] forKey:@"IssueAge"];
//            } else {
//                [DataContainDictionary setObject:@"" forKey:@"IssueAge"];
//            }
//        }
//        
//    } @catch (NSException *exception) {
//        
//        NSLog(@"Data manipulation Error for IssueAge");
//        
//    }
//    
//# warning For Owner
//    
//    /*
//     * Try to fetch the value of @Policy date
//     * Search contain is @Policy Dato and @Policy Date
//     * If data is comming in sigle line then @resultsone will be containing value.
//     * If value doesn't found, assign main array value as indexed in 17
//     */
//    
//    
//    @try {
//        
//        NSPredicate *p1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Owner"];
//        NSPredicate *p2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Ownor"];
//        
//        NSPredicate *placesPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[p1, p2]];
//        
//        NSArray *resultsone = [DataArray filteredArrayUsingPredicate:placesPredicate];
//        if ([resultsone count] > 0) {
//            
//            NSLog(@"resultsone ---- %@",resultsone);
//            
//            NSArray *DataArrayStatusOne = [[resultsone objectAtIndex:1] componentsSeparatedByString:@":"];
//            NSLog(@"Owner ---- %@",DataArrayStatusOne);
//            if ([DataArrayStatusOne count]>0) {
//                [DataContainDictionary setObject:[DataArrayStatusOne objectAtIndex:1] forKey:@"Owner"];
//            } else {
//                [DataContainDictionary setObject:@"" forKey:@"Owner"];
//            }
//        }
//        
//    } @catch (NSException *exception) {
//        
//        NSLog(@"Data manipulation Error for Owner");
//        
//    }
//    
//    
//# warning For payment Mode
//    
//    /*
//     * Try to fetch the value of @Policy date
//     * Search contain is @Policy Dato and @Policy Date
//     * If data is comming in sigle line then @resultsone will be containing value.
//     * If value doesn't found, assign main array value as indexed in 17
//     */
//    
//    
//    @try {
//        
//        NSPredicate *p1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Payment Mode"];
//        NSPredicate *p2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Payment Modo"];
//        
//        NSPredicate *placesPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[p1, p2]];
//        
//        NSArray *resultsone = [DataArray filteredArrayUsingPredicate:placesPredicate];
//        if ([resultsone count] > 0) {
//            
//            NSLog(@"Payment Mode ---- %@",resultsone);
//            
//            NSArray *DataArrayStatusOne = [[resultsone objectAtIndex:0] componentsSeparatedByString:@"\t"];
//            NSLog(@"Payment Mode one ---- %@",DataArrayStatusOne);
//            if ([DataArrayStatusOne count]>0) {
//                [DataContainDictionary setObject:[DataArrayStatusOne objectAtIndex:1] forKey:@"PaymentMode"];
//            } else {
//                [DataContainDictionary setObject:@"" forKey:@"PaymentMode"];
//            }
//        }
//        
//    } @catch (NSException *exception) {
//        
//        NSLog(@"Data manipulation Error for PaymentMode");
//        
//        NSLog(@"--------------------- %@",[DataArray objectAtIndex:50]);
//        
//        [DataContainDictionary setObject:[DataArray objectAtIndex:50] forKey:@"PaymentMode"];
//    }
//
//# warning For payment method
//    
//    /*
//     * Try to fetch the value of @Policy date
//     * Search contain is @Policy Dato and @Policy Date
//     * If data is comming in sigle line then @resultsone will be containing value.
//     * If value doesn't found, assign main array value as indexed in 17
//     */
//    
//    
//    @try {
//        
//        NSPredicate *p1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Payment Method"];
//        NSPredicate *p2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Payment Mothod"];
//        
//        NSPredicate *placesPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[p1, p2]];
//        
//        NSArray *resultsone = [DataArray filteredArrayUsingPredicate:placesPredicate];
//        if ([resultsone count] > 0) {
//            
//            NSLog(@"Payment Mothod ---- %@",resultsone);
//            
//            NSArray *DataArrayStatusOne = [[resultsone objectAtIndex:0] componentsSeparatedByString:@"\t"];
//            NSLog(@"Payment Mothod one ---- %@",DataArrayStatusOne);
//            if ([DataArrayStatusOne count]>0) {
//                [DataContainDictionary setObject:[DataArrayStatusOne lastObject] forKey:@"PaymentMothod"];
//            } else {
//                [DataContainDictionary setObject:@"" forKey:@"PaymentMothod"];
//            }
//        }
//        
//    } @catch (NSException *exception) {
//        
//        NSLog(@"Data manipulation Error for PaymentMothod");
//        
//    }
//# warning For payment method
//    
//    /*
//     * Try to fetch the value of @Policy date
//     * Search contain is @Policy Dato and @Policy Date
//     * If data is comming in sigle line then @resultsone will be containing value.
//     * If value doesn't found, assign main array value as indexed in 17
//     */
//    
//    
//    @try {
//        
//        NSPredicate *p1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Bill To Dato"];
//        NSPredicate *p2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Bill To Date"];
//        
//        NSPredicate *placesPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[p1, p2]];
//        
//        NSArray *resultsone = [DataArray filteredArrayUsingPredicate:placesPredicate];
//        if ([resultsone count] > 0) {
//            
//            NSLog(@"Bill To Date ---- %@",resultsone);
//            
//            NSArray *DataArrayStatusOne = [[resultsone objectAtIndex:0] componentsSeparatedByString:@"\t"];
//            NSLog(@"Bill To Date one ---- %@",DataArrayStatusOne);
//            if ([DataArrayStatusOne count]>0) {
//                [DataContainDictionary setObject:[DataArrayStatusOne objectAtIndex:3] forKey:@"BillToDate"];
//            } else {
//                [DataContainDictionary setObject:@"" forKey:@"BillToDate"];
//            }
//        }
//        
//    } @catch (NSException *exception) {
//        
//        NSLog(@"Data manipulation Error for BillToDate");
//        
//    }
    
//    @try {
//        
//        NSPredicate *p1 = [NSPredicate predicateWithFormat:@"ANY SELF CONTAINS %@", @"Statue"];
//        NSPredicate *p2 = [NSPredicate predicateWithFormat:@"ANY SELF CONTAINS %@", @"Status"];
//        NSPredicate *placesPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[p1, p2]];
//        
//        NSArray *resultsone = [DataArray filteredArrayUsingPredicate:placesPredicate];
//         NSLog(@"resultsone ---- %@",resultsone);
//        
//        
//    }
//    @catch (NSException *exception) {
//        NSLog(@"Data manipulation Error");
//    }

//    @try {
//    
//    
//    
//    
//    
//    /*
//     Data look for Status
//     First Seperating context is "Contract Despatch Date"
//     Second Seperating context is ": "
//     */
//    
//    if ([[DataArray objectAtIndex:7] rangeOfString:StatusRecognisationString].location == NSNotFound) {
//        [DataContainDictionary setObject:@"" forKey:@"Status"];
//    } else {
//        NSArray *DataArrayStatusOne = [[DataArray objectAtIndex:7] componentsSeparatedByString:StatusRecognisationString];
//        if (DataArrayStatusOne.count > 0) {
//            NSArray *DataArrayStatustwo = [[DataArrayStatusOne objectAtIndex:0] componentsSeparatedByString:@": "];
//            [DataContainDictionary setObject:(DataArrayStatustwo.count > 0)?[[[DataArrayStatustwo objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\t" withString:@" "] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]:@"" forKey:@"Status"];
//        } else {
//            [DataContainDictionary setObject:@"" forKey:@"Status"];
//        }
//    }
//    
//    /*
//     Data look for Status
//     First Seperating context is "Contract Despatch Date"
//     Second Seperating context is ": "
//     */
//    
//    if ([[DataArray objectAtIndex:8] rangeOfString:@"Paid To Date"].location == NSNotFound) {
//        
//        [DataContainDictionary setObject:@"" forKey:@"PolicyDate"];
//        [DataContainDictionary setObject:@"" forKey:@"PaidToDate"];
//        
//    } else {
//        
//        NSArray *DataArrayPolicyDateOne = [[DataArray objectAtIndex:8] componentsSeparatedByString:@"Paid To Date"];
//        if (DataArrayPolicyDateOne.count > 0) {
//            
//            NSArray *DataArrayPolicyDatetwo = [[DataArrayPolicyDateOne objectAtIndex:0] componentsSeparatedByString:@": "];
//            [DataContainDictionary setObject:(DataArrayPolicyDatetwo.count > 0)?[[[DataArrayPolicyDatetwo objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\t" withString:@" "] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]:@"" forKey:@"PolicyDate"];
//            
//            NSArray *DataArrayPaidToDatetwo = [[DataArrayPolicyDateOne objectAtIndex:1] componentsSeparatedByString:@": "];
//            [DataContainDictionary setObject:(DataArrayPaidToDatetwo.count > 0)?[[[DataArrayPaidToDatetwo objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\t" withString:@" "] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]:@"" forKey:@"PaidToDate"];
//            
//        } else {
//            
//            [DataContainDictionary setObject:@"" forKey:@"PolicyDate"];
//            [DataContainDictionary setObject:@"" forKey:@"PaidToDate"];
//        }
//    }
//    
//    /*
//     Data look for Status
//     First Seperating context is "Contract Despatch Date"
//     Second Seperating context is ": "
//     */
//    
//    if ([[DataArray objectAtIndex:11] rangeOfString:@"Next Modal Premium"].location == NSNotFound) {
//        
//        [DataContainDictionary setObject:@"" forKey:@"ModalPremium"];
//        [DataContainDictionary setObject:@"" forKey:@"NextModalPremium"];
//        
//    } else {
//        
//        NSArray *DataArrayModalPremiumOne = [[DataArray objectAtIndex:11] componentsSeparatedByString:@"Next Modal Premium"];
//        
//        if (DataArrayModalPremiumOne.count > 0) {
//            
//            NSArray *DataArrayModalPremiumtwo = [[DataArrayModalPremiumOne objectAtIndex:0] componentsSeparatedByString:@": "];
//            [DataContainDictionary setObject:(DataArrayModalPremiumtwo.count > 0)?[[[DataArrayModalPremiumtwo objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\t" withString:@" "] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]:@"" forKey:@"ModalPremium"];
//            
//            NSArray *DataArrayNextModalPremiumtwo = [[DataArrayModalPremiumOne objectAtIndex:1] componentsSeparatedByString:@": "];
//            [DataContainDictionary setObject:(DataArrayNextModalPremiumtwo.count > 0)?[[[DataArrayNextModalPremiumtwo objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\t" withString:@" "] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]:@"" forKey:@"NextModalPremium"];
//            
//        } else {
//            
//            [DataContainDictionary setObject:@"" forKey:@"ModalPremium"];
//            [DataContainDictionary setObject:@"" forKey:@"NextModalPremium"];
//        }
//    }
//    
//    /*
//     Data look for Status
//     First Seperating context is "Contract Despatch Date"
//     Second Seperating context is ": "
//     */
//    
//    if ([[DataArray objectAtIndex:12] rangeOfString:@"Maturity Date"].location == NSNotFound) {
//        
//        [DataContainDictionary setObject:@"" forKey:@"PayUpDate"];
//        [DataContainDictionary setObject:@"" forKey:@"MaturityDate"];
//        
//    } else {
//        
//        NSArray *DataArrayPayUpDateOne = [[DataArray objectAtIndex:12] componentsSeparatedByString:@"Maturity Date"];
//        
//        if (DataArrayPayUpDateOne.count > 0) {
//            
//            NSArray *DataArrayPayUpDatetwo = [[DataArrayPayUpDateOne objectAtIndex:0] componentsSeparatedByString:@": "];
//            [DataContainDictionary setObject:(DataArrayPayUpDatetwo.count > 0)?[[[DataArrayPayUpDatetwo objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\t" withString:@" "] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]:@"" forKey:@"PayUpDate"];
//            
//            NSArray *DataArrayMaturityDatetwo = [[DataArrayPayUpDateOne objectAtIndex:1] componentsSeparatedByString:@": "];
//            [DataContainDictionary setObject:(DataArrayMaturityDatetwo.count > 0)?[[[DataArrayMaturityDatetwo objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\t" withString:@" "] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]:@"" forKey:@"MaturityDate"];
//            
//        } else {
//            
//            [DataContainDictionary setObject:@"" forKey:@"PayUpDate"];
//            [DataContainDictionary setObject:@"" forKey:@"MaturityDate"];
//        }
//    }
//    
//    /*
//     Data look for Status
//     First Seperating context is "Contract Despatch Date"
//     Second Seperating context is ": "
//     */
//    
//    if ([[DataArray objectAtIndex:13] rangeOfString:@"Adjusted Premium"].location == NSNotFound) {
//        
//        [DataContainDictionary setObject:@"" forKey:@"InsuredAddress"];
//        
//    } else {
//        
//        NSArray *DataArrayInsuredAddressOne = [[DataArray objectAtIndex:13] componentsSeparatedByString:@"Adjusted Premium"];
//        
//        if (DataArrayInsuredAddressOne.count > 0) {
//            
//            NSArray *DataArrayInsuredAddresstwo = [[DataArrayInsuredAddressOne objectAtIndex:0] componentsSeparatedByString:@": "];
//            [DataContainDictionary setObject:(DataArrayInsuredAddresstwo.count >0)?[[[DataArrayInsuredAddresstwo objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\t" withString:@" "] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]:@" " forKey:@"InsuredAddress"];
//            
//        } else {
//            
//            [DataContainDictionary setObject:@"" forKey:@"InsuredAddress"];
//        }
//    }
//    
//    /*
//     Data look for Status
//     First Seperating context is "Contract Despatch Date"
//     Second Seperating context is ": "
//     */
//    
//    @try {
//        if ([[DataArray objectAtIndex:17] rangeOfString:@"Gender"].location == NSNotFound) {
//            
//            [DataContainDictionary setObject:@"" forKey:@"Name"];
//            [DataContainDictionary setObject:@"" forKey:@"Gender"];
//            
//        } else {
//            
//            NSArray *DataArrayNameOne = [[DataArray objectAtIndex:16] componentsSeparatedByString:@"Gender"];
//            
//            if (DataArrayNameOne.count > 0) {
//                
//                NSArray *DataArrayNametwo = [[DataArrayNameOne objectAtIndex:0] componentsSeparatedByString:@": "];
//                [DataContainDictionary setObject:(DataArrayNametwo.count >0)?[[[DataArrayNametwo objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\t" withString:@" "] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]:@"" forKey:@"Name"];
//                
//                NSArray *DataArrayGendertwo = [[DataArrayNameOne objectAtIndex:1] componentsSeparatedByString:@": "];
//                [DataContainDictionary setObject:(DataArrayGendertwo.count >0)?[DataArrayGendertwo objectAtIndex:1]:@"" forKey:@"Gender"];
//                
//            } else {
//                
//                [DataContainDictionary setObject:@"" forKey:@"Name"];
//                [DataContainDictionary setObject:@"" forKey:@"Gender"];
//            }
//        }
//    }
//    @catch (NSException *exception) {
//        NSLog(@"Array breaking error");
//    }
//    
////
////    /*
////     Data look for Status
////     First Seperating context is "Contract Despatch Date"
////     Second Seperating context is ": "
////     */
////    
//    NSArray *DataArrayNRIC = [[DataArray objectAtIndex:18] componentsSeparatedByString:@": "];
//    [DataContainDictionary setObject:(DataArrayNRIC.count >0)?[[[DataArrayNRIC objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\t" withString:@" "] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]:@"" forKey:@"NRIC"];
////
////    /*
////     Data look for Status
////     First Seperating context is "Contract Despatch Date"
////     Second Seperating context is ": "
////     */
////    
////    
//    @try {
//        if ([[DataArray objectAtIndex:18] rangeOfString:@"Issue Age"].location == NSNotFound) {
//            
//            [DataContainDictionary setObject:@"" forKey:@"Dateofbirth"];
//            [DataContainDictionary setObject:@"" forKey:@"IssueAge"];
//            
//        } else {
//            
//            NSArray *DataArrayDateofbirthOne = [[DataArray objectAtIndex:18] componentsSeparatedByString:@"Issue Age"];
//            
//            if (DataArrayDateofbirthOne.count > 0) {
//                
//                NSArray *DataArrayDateofbirthtwo = [[DataArrayDateofbirthOne objectAtIndex:0] componentsSeparatedByString:@": "];
//                [DataContainDictionary setObject:(DataArrayDateofbirthtwo.count >0)?[[[DataArrayDateofbirthtwo objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\t" withString:@" "] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]:@"" forKey:@"Dateofbirth"];
//                
//                NSArray *DataArrayIssueAgetwo = [[DataArrayDateofbirthOne objectAtIndex:1] componentsSeparatedByString:@": "];
//                [DataContainDictionary setObject:(DataArrayIssueAgetwo.count >0)?[[[DataArrayIssueAgetwo objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\t" withString:@" "] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]:@"" forKey:@"IssueAge"];
//                
//            } else {
//                
//                [DataContainDictionary setObject:@"" forKey:@"Dateofbirth"];
//                [DataContainDictionary setObject:@"" forKey:@"IssueAge"];
//            }
//        }
//    }
//    @catch (NSException *exception) {
//        NSLog(@"error");
//    }
////
////    /*
////     Data look for Status
////     First Seperating context is "Contract Despatch Date"
////     Second Seperating context is ": "
////     */
////    
//    NSArray *DataArrayOwner = [[DataArray objectAtIndex:20] componentsSeparatedByString:@": "];
//    [DataContainDictionary setObject:(DataArrayOwner.count >0)?[[[DataArrayOwner objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\t" withString:@" "] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]:@"" forKey:@"Owner"];
////
////    /*
////     Data look for Status
////     First Seperating context is "Contract Despatch Date"
////     Second Seperating context is ": "
////     */
////    
//    if ([[DataArray objectAtIndex:22] rangeOfString:@"Payment Method"].location == NSNotFound) {
//        
//        [DataContainDictionary setObject:@"" forKey:@"paymentmode"];
//        [DataContainDictionary setObject:@"" forKey:@"PaymentMethod"];
//        
//    } else {
//        
//        NSArray *DataArraypaymentmodeOne = [[DataArray objectAtIndex:22] componentsSeparatedByString:@"Payment Method"];
//        
//        if (DataArraypaymentmodeOne.count > 0) {
//            
//            NSArray *DataArraypaymentmodetwo = [[DataArraypaymentmodeOne objectAtIndex:0] componentsSeparatedByString:@": "];
//            [DataContainDictionary setObject:(DataArraypaymentmodetwo.count > 0)?[[[DataArraypaymentmodetwo objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\t" withString:@" "] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]:@"" forKey:@"paymentmode"];
//            
//            NSArray *DataArrayPaymentMethodtwo = [[DataArraypaymentmodeOne objectAtIndex:1] componentsSeparatedByString:@": "];
//            [DataContainDictionary setObject:(DataArrayPaymentMethodtwo.count >0)?[DataArrayPaymentMethodtwo objectAtIndex:1]:@"" forKey:@"PaymentMethod"];
//            
//        } else {
//            
//            [DataContainDictionary setObject:@"" forKey:@"paymentmode"];
//            [DataContainDictionary setObject:@"" forKey:@"PaymentMethod"];
//        }
//    }
////
////    /*
////     Data look for Status
////     First Seperating context is "Contract Despatch Date"
////     Second Seperating context is ": "
////     */
////
//    
//    @try {
//        NSArray *DataArrayBUIToDateOne = [[DataArray objectAtIndex:24] componentsSeparatedByString:@"Bill To Date"];
//        if (DataArrayBUIToDateOne.count > 0) {
//            
//            NSArray *DataArrayBUIToDatetwo = [[DataArrayBUIToDateOne objectAtIndex:1] componentsSeparatedByString:@": "];
//            [DataContainDictionary setObject:(DataArrayBUIToDatetwo.count >0)?[DataArrayBUIToDatetwo objectAtIndex:1]:@"" forKey:@"billtodate"];
//        } else {
//            [DataContainDictionary setObject:@"" forKey:@"billtodate"];
//        }
//    }
//    @catch (NSException *exception) {
//        NSLog(@"Error");
//        [DataContainDictionary setObject:@"" forKey:@"billtodate"];
//    }
//        
//    }
//    @catch (NSException *exception) {
//        NSLog(@"-------------- %@",[NSString stringWithFormat:@"%@",exception]);
//    }
   // NSLog(@"DataContainDictionary ---- %@",DataContainDictionary);
    
    
//    NSString *newString = [[result componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@"^^^^^^^"];
//    
//    NSArray *ComponentSeperatedByString = [newString componentsSeparatedByString:@"^^^^^^^^^^^^^^"];
//    NSMutableArray *DataDictionary = [[NSMutableArray alloc] init];
//    
//    for (int i =0; i<[ComponentSeperatedByString count]-1; i++) {
//        [DataDictionary addObject:[ComponentSeperatedByString objectAtIndex:i]];
//    }
//    NSLog(@"DataDictionary == %@",DataDictionary);
//    
//    NSPredicate *G1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @":"];
//    NSPredicate *NamePredicateG1 = [NSCompoundPredicate orPredicateWithSubpredicates:@[G1]];
//    NSArray *resultsoneG1 = [DataDictionary filteredArrayUsingPredicate:NamePredicateG1];
//    
//    NSLog(@"resultsoneG1 === %@",resultsoneG1);
//    
//    NSPredicate *p1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Namo"];
//    NSPredicate *p2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Name"];
//    NSPredicate *p3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Nemo"];
//    NSPredicate *p4 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Neme"];
//    NSPredicate *p5 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", @"Homo"];
//    NSPredicate *NamePredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[p1,p2,p3,p4,p5]];
//    NSArray *resultsone = [DataDictionary filteredArrayUsingPredicate:NamePredicate];
//    
//    NSLog(@"resultsone --- %@",resultsone);
//    NSString *UserName = nil;
//    
//    if ([resultsone count] > 0) {
//        
//        NSLog(@"name found");
//        NSLog(@"resultsone === %@",[resultsone objectAtIndex:0]);
//        
//        NSArray *NameArray = [[resultsone objectAtIndex:0] componentsSeparatedByString:@"\t"];
//        NSLog(@"------yahoo------- %@",NameArray);
//        
//        if ([NameArray count]>1) {
//            UserName = [NameArray objectAtIndex:1];
//        } else {
//            if ([resultsoneG1 count]>13) {
//                UserName = [resultsoneG1 objectAtIndex:14];
//            } else {
//                UserName = [resultsoneG1 objectAtIndex:7];
//            }
//        }
//        
//        NSLog(@"UserName --- %@",UserName);
//        
//    } else {
//        NSLog(@"name not found");
//    }
    
    

    NSMutableDictionary *DataContainDictionary = [[NSMutableDictionary alloc] init];
    DataContainDictionary = [self BusinessLogic:result];
    
    
    NSLog(@"DataContainDictionary ------ %@",result);
    
   // exit(0);
    
    NSString *NewString = [NSString stringWithFormat:@"%@",DataContainDictionary];
    textView.text = NewString;
    
    
    OCRScanDataObjectModel *ScandataObject = [[OCRScanDataObjectModel alloc] initWithStatus:[DataContainDictionary objectForKey:@"Status"] PolicyDate:[DataContainDictionary objectForKey:@"PolicyDate"] PaidToDate:[DataContainDictionary objectForKey:@"PaidToDate"] ModalPremium:[DataContainDictionary objectForKey:@"ModalPremium"] NextModalPremium:[DataContainDictionary objectForKey:@"NextModalPremium"] PayUpDate:[DataContainDictionary objectForKey:@"PayUpDate"] MaturityDate:[DataContainDictionary objectForKey:@"MaturityDate"] InsuredAddress:[DataContainDictionary objectForKey:@"InsuredAddress"] AdjustedPremium:[DataContainDictionary objectForKey:@"AdjustedPremium"] Gender:[DataContainDictionary objectForKey:@"Gender"] Name:[DataContainDictionary objectForKey:@"Name"] NRIC:[DataContainDictionary objectForKey:@"NRIC"] DOB:[DataContainDictionary objectForKey:@"DOB"] IssueAge:[DataContainDictionary objectForKey:@"IssueAge"] Owner:[DataContainDictionary objectForKey:@"Owner"] PaymentMode:[DataContainDictionary objectForKey:@"PaymentMode"] PaymentMothod:[DataContainDictionary objectForKey:@"PaymentMothod"] BillToDate:[DataContainDictionary objectForKey:@"BillToDate"]];
    
    OCRAddContactFromOCRViewController *AddContact = [[OCRAddContactFromOCRViewController alloc] initWithNibName:@"OCRAddContactFromOCRViewController" bundle:nil];
    [AddContact setDataadtionstatus:DataAditionStatusOcr];
    [AddContact setDataModel:ScandataObject];
    [self.navigationController pushViewController:AddContact animated:YES];
    
    NSString *FinalString = [NSString stringWithFormat:@"%@",DataContainDictionary];
    textView.text = FinalString;
}

- (void)client:(Client *)sender didFailedWithError:(NSError *)error
{
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
													message:[error localizedDescription]
												   delegate:nil 
										  cancelButtonTitle:@"Cancel" 
										  otherButtonTitles:nil, nil];
	
	[alert show];
	
	statusLabel.text = [error localizedDescription];
	statusIndicator.hidden = YES;
}

@end
