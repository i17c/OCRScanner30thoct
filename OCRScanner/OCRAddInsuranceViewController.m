//
//  OCRAddInsuranceViewController.m
//  AlbaseNew
//
//  Created by Mac on 03/11/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import "OCRAddInsuranceViewController.h"
#import "UIColor+HexColor.h"
#import "MFSideMenu.h"


@interface OCRAddInsuranceViewController ()


@property (nonatomic,retain) UITableView *InsurenceDataTable;
@property (nonatomic,retain) NSMutableDictionary *InsurenceData;

@property (nonatomic,retain) NSString *Status;
@property (nonatomic,retain) UITextField *StatusTextField;

@property (nonatomic,retain) NSString *PolicyDate;
@property (nonatomic,retain) UITextField *PolicyDateTextField;

@property (nonatomic,retain) NSString *PaidToDate;
@property (nonatomic,retain) UITextField *PaidToDateTextField;

@property (nonatomic,retain) NSString *ModalPremium;
@property (nonatomic,retain) UITextField *ModalPremiumTextField;

@property (nonatomic,retain) NSString *NextModalPremium;
@property (nonatomic,retain) UITextField *NextModalPremiumTextField;

@property (nonatomic,retain) NSString *PayUpDate;
@property (nonatomic,retain) UITextField *PayUpDateTextField;

@property (nonatomic,retain) NSString *MaturityDate;
@property (nonatomic,retain) UITextField *MaturityDateTextField;

@property (nonatomic,retain) NSString *InsuredAddress;
@property (nonatomic,retain) UITextField *InsuredAddressTextField;

@property (nonatomic,retain) NSString *AdjustedPremium;
@property (nonatomic,retain) UITextField *AdjustedPremiumTextField;

@property (nonatomic,retain) NSString *NRIC;
@property (nonatomic,retain) UITextField *NRICTextField;

@property (nonatomic,retain) NSString *IssueAge;
@property (nonatomic,retain) UITextField *IssueAgeTextField;

@property (nonatomic,retain) NSString *Owner;
@property (nonatomic,retain) UITextField *OwnerTextField;

@property (nonatomic,retain) NSString *PaymentMode;
@property (nonatomic,retain) UITextField *PaymentModeTextField;

@property (nonatomic,retain) NSString *PaymentMothod;
@property (nonatomic,retain) UITextField *PaymentMothodTextField;

@property (nonatomic,retain) NSString *BillToDate;
@property (nonatomic,retain) UITextField *BillToDateTextField;

@end

@implementation OCRAddInsuranceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self=(IsIphone5)?[super initWithNibName:@"OCRAddInsuranceViewController" bundle:nil]:[super initWithNibName:@"OCRAddInsuranceViewController4s" bundle:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self.navigationController navigationBar] setHidden:YES];
    
    UIView *HeaderView = (UIView *)[self.view viewWithTag:110];
    [HeaderView setBackgroundColor:[UIColor colorFromHex:0x1EBBFE]];
    
    UILabel *Titlelabel = (UILabel *)[self.view viewWithTag:888];
    [Titlelabel setText:@"Add Insurence Data"];
    [Titlelabel setTextColor:[UIColor whiteColor]];
    [Titlelabel setFont:[UIFont fontWithName:@"Helvetica" size:18.0f]];
    
    UIButton *SetButton = (UIButton *)[self.view viewWithTag:111];
    [SetButton addTarget:self action:@selector(leftSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    _InsurenceDataTable = (UITableView *)[self.view viewWithTag:752];
    [_InsurenceDataTable setDelegate:self];
    [_InsurenceDataTable setDataSource:self];
}
#pragma mark -
#pragma mark Table view delegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *Headerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    [Headerview setBackgroundColor:[UIColor clearColor]];
    UILabel *TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, Headerview.frame.size.width, 15)];
    [TitleLabel setBackgroundColor:[UIColor clearColor]];
    [TitleLabel setTextColor:[UIColor darkGrayColor]];
    [TitleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
    [Headerview addSubview:TitleLabel];
    if (section == 0) {
        [TitleLabel setText:@"Status"];
    } else if (section == 1) {
        [TitleLabel setText:@"Policy Date"];
    } else if (section == 2) {
        [TitleLabel setText:@"Paid To Date"];
    } else if (section == 3) {
        [TitleLabel setText:@"Modal Premium"];
    } else if (section == 4) {
        [TitleLabel setText:@"Next Modal Premium"];
    } else if (section == 5) {
        [TitleLabel setText:@"Pay Up Date"];
    } else if (section == 6) {
        [TitleLabel setText:@"Maturity Date"];
    } else if (section == 7) {
        [TitleLabel setText:@"Insured Address"];
    } else if (section == 8) {
        [TitleLabel setText:@"Adjusted Premium"];
    } else if (section == 9) {
        [TitleLabel setText:@"NRIC"];
    } else if (section == 10) {
        [TitleLabel setText:@"Issue Age"];
    } else if (section == 11) {
        [TitleLabel setText:@"Owner"];
    } else if (section == 12) {
        [TitleLabel setText:@"Payment Mode"];
    } else if (section == 13) {
        [TitleLabel setText:@"Payment Mothod"];
    } else if (section == 14) {
        [TitleLabel setText:@"Bill To Date"];
    }
    return Headerview;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    //cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",[ContactList Firstname],[ContactList Lastname]];
    [cell.textLabel setTextColor:[UIColor darkGrayColor]];
    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:13.0f]];
    
    UISwitch *dataSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(260, 10, 70, 30)];
    [dataSwitch setBackgroundColor:[UIColor clearColor]];
    [dataSwitch setTag:(12546+indexPath.section)];
    [dataSwitch addTarget:self action:@selector(switchIsChanged:) forControlEvents:UIControlEventValueChanged];
    [dataSwitch setUserInteractionEnabled:YES];
    [cell.contentView addSubview:dataSwitch];
    
    _StatusTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 250, 50)];
    
    switch (indexPath.section) {
         
        case 0:
        {
            _StatusTextField = [self SetTextFieldIntoTable:52145 uiview:cell.contentView WithTextValue:[_DataModel Status]];
            [_StatusTextField setDelegate:self];
            break;
        }
        case 1:
        {
            _PolicyDateTextField = [self SetTextFieldIntoTable:52146 uiview:cell.contentView WithTextValue:[_DataModel PolicyDate]];
            [_PolicyDateTextField setDelegate:self];
            break;
        }
        case 2:
        {
            _PaidToDateTextField = [self SetTextFieldIntoTable:52147 uiview:cell.contentView WithTextValue:[_DataModel PaidToDate]];
            [_PaidToDateTextField setDelegate:self];
            break;
        }
        case 3:
        {
            _ModalPremiumTextField = [self SetTextFieldIntoTable:52148 uiview:cell.contentView WithTextValue:[_DataModel ModalPremium]];
            [_ModalPremiumTextField setDelegate:self];
            break;
        }
        case 4:
        {
            _NextModalPremiumTextField = [self SetTextFieldIntoTable:52149 uiview:cell.contentView WithTextValue:[_DataModel NextModalPremium]];
            [_NextModalPremiumTextField setDelegate:self];
            break;
        }
        case 5:
        {
            _PayUpDateTextField = [self SetTextFieldIntoTable:52150 uiview:cell.contentView WithTextValue:[_DataModel PayUpDate]];
            [_PayUpDateTextField setDelegate:self];
            break;
        }
        case 6:
        {
            _MaturityDateTextField = [self SetTextFieldIntoTable:52151 uiview:cell.contentView WithTextValue:[_DataModel MaturityDate]];
            [_MaturityDateTextField setDelegate:self];
            break;
        }
        case 7:
        {
            _InsuredAddressTextField = [self SetTextFieldIntoTable:52152 uiview:cell.contentView WithTextValue:[_DataModel InsuredAddress]];
            [_InsuredAddressTextField setDelegate:self];
             break;
        }
        case 8:
        {
            _AdjustedPremiumTextField = [self SetTextFieldIntoTable:52153 uiview:cell.contentView WithTextValue:[_DataModel AdjustedPremium]];
            [_AdjustedPremiumTextField setDelegate:self];
            break;
        }
        case 9:
        {
            _NRICTextField = [self SetTextFieldIntoTable:52154 uiview:cell.contentView WithTextValue:[_DataModel NRIC]];
            [_NRICTextField setDelegate:self];
            break;
        }
        case 10:
        {
            _IssueAgeTextField = [self SetTextFieldIntoTable:52155 uiview:cell.contentView WithTextValue:[_DataModel IssueAge]];
            [_IssueAgeTextField setDelegate:self];
            break;
        }
        case 11:
        {
            _OwnerTextField = [self SetTextFieldIntoTable:52156 uiview:cell.contentView WithTextValue:[_DataModel Owner]];
            [_OwnerTextField setDelegate:self];
            break;
        }
        case 12:
        {
            _PaymentModeTextField = [self SetTextFieldIntoTable:52157 uiview:cell.contentView WithTextValue:[_DataModel PaymentMode]];
            [_PaymentModeTextField setDelegate:self];
            break;
        }
        case 13:
        {
            _PaymentMothodTextField = [self SetTextFieldIntoTable:52158 uiview:cell.contentView WithTextValue:[_DataModel PaymentMothod]];
            [_PaymentMothodTextField setDelegate:self];
            break;
        }
        case 14:
        {
            _BillToDateTextField = [self SetTextFieldIntoTable:52159 uiview:cell.contentView WithTextValue:[_DataModel BillToDate]];
            [_BillToDateTextField setDelegate:self];
            break;
        }
    }
    
    return cell;
}
-(UITextField *)SetTextFieldIntoTable:(int)Textfieldtag uiview:(UIView *)ParentView WithTextValue:(NSString *)Textvalue
{
    UITextField *dataTextfield = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 250, 50)];
    [dataTextfield setBackgroundColor:[UIColor whiteColor]];
    [dataTextfield setEnabled:NO];
    [dataTextfield setTag:Textfieldtag];
    [dataTextfield setTextColor:[UIColor darkGrayColor]];
    [dataTextfield setFont:[UIFont fontWithName:@"Helvetica" size:13.0f]];
    [dataTextfield setText:Textvalue];
    [ParentView addSubview:dataTextfield];
    return dataTextfield;
}
-(IBAction)switchIsChanged:(UISwitch *)sender
{
    if (sender.tag == 12546) {
        if ([sender isOn]){
            [_StatusTextField setEnabled:YES];
        } else {
            [_StatusTextField setEnabled:NO];
        }
    } else if (sender.tag == 12547) {
        if ([sender isOn]){
            [_PolicyDateTextField setEnabled:YES];
        } else {
            [_PolicyDateTextField setEnabled:NO];
        }
    } else if (sender.tag == 12548) {
        if ([sender isOn]){
            [_PaidToDateTextField setEnabled:YES];
        } else {
            [_PaidToDateTextField setEnabled:NO];
        }
    } else if (sender.tag == 12549) {
        if ([sender isOn]){
            [_ModalPremiumTextField setEnabled:YES];
        } else {
            [_ModalPremiumTextField setEnabled:NO];
        }
    } else if (sender.tag == 12550) {
        if ([sender isOn]){
            [_NextModalPremiumTextField setEnabled:YES];
        } else {
            [_NextModalPremiumTextField setEnabled:NO];
        }
    }
    else if (sender.tag == 12551) {
        if ([sender isOn]){
            [_PayUpDateTextField setEnabled:YES];
        } else {
            [_PayUpDateTextField setEnabled:NO];
        }
    }  else if (sender.tag == 12552) {
        if ([sender isOn]){
            [_MaturityDateTextField setEnabled:YES];
        } else {
            [_MaturityDateTextField setEnabled:NO];
        }
    }  else if (sender.tag == 12553) {
        if ([sender isOn]){
            [_InsuredAddressTextField setEnabled:YES];
        } else {
            [_InsuredAddressTextField setEnabled:NO];
        }
    }  else if (sender.tag == 12554) {
        if ([sender isOn]){
            [_AdjustedPremiumTextField setEnabled:YES];
        } else {
            [_AdjustedPremiumTextField setEnabled:NO];
        }
    }  else if (sender.tag == 12555) {
        if ([sender isOn]){
            [_NRICTextField setEnabled:YES];
        } else {
            [_NRICTextField setEnabled:NO];
        }
    }  else if (sender.tag == 12556) {
        if ([sender isOn]){
            [_IssueAgeTextField setEnabled:YES];
        } else {
            [_IssueAgeTextField setEnabled:NO];
        }
    }
    else if (sender.tag == 12557) {
        if ([sender isOn]){
            [_OwnerTextField setEnabled:YES];
        } else {
            [_OwnerTextField setEnabled:NO];
        }
    }  else if (sender.tag == 12558) {
        if ([sender isOn]){
            [_PaymentModeTextField setEnabled:YES];
        } else {
            [_PaymentModeTextField setEnabled:NO];
        }
    }  else if (sender.tag == 12559) {
        if ([sender isOn]){
            [_PaymentMothodTextField setEnabled:YES];
        } else {
            [_PaymentMothodTextField setEnabled:NO];
        }
    }  else if (sender.tag == 12560) {
        if ([sender isOn]){
            [_BillToDateTextField setEnabled:YES];
        } else {
            [_BillToDateTextField setEnabled:NO];
        }
    }
}
#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 15;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
-(NSString *)CleanTextField:(NSString *)TextfieldName
{
    NSString *Cleanvalue = [TextfieldName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return Cleanvalue;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *viewFotter = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [viewFotter setBackgroundColor:[UIColor clearColor]];
    
    /*
     */
    
    UILabel *Footerlabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 200, 40)];
    [Footerlabel setBackgroundColor:[UIColor clearColor]];
    [Footerlabel setTextColor:[UIColor darkGrayColor]];
    [Footerlabel setTextAlignment:NSTextAlignmentRight];
    [Footerlabel setNumberOfLines:0];
    [Footerlabel setFont:[UIFont fontWithName:@"Helvetica" size:11.0f]];
    [viewFotter addSubview:Footerlabel];
    
    
    switch (section) {
        case 0:
            [Footerlabel setText:@"Select switch if Status isn't right"];
            break;
        case 1:
            [Footerlabel setText:@"Select switch if Policy Date isn't right"];
            break;
        case 2:
            [Footerlabel setText:@"Select switch if Paid To Date isn't right"];
            break;
        case 3:
            [Footerlabel setText:@"Select switch if Modal Premium isn't right"];
            break;
        case 4:
            [Footerlabel setText:@"Select switch if Next Modal Premium isn't right"];
            break;
        case 5:
            [Footerlabel setText:@"Select switch if Pay Up Date isn't right"];
            break;
        case 6:
            [Footerlabel setText:@"Select switch if Maturity Date isn't right"];
            break;
        case 7:
            [Footerlabel setText:@"Select switch if Insured Address isn't right"];
            break;
        case 8:
            [Footerlabel setText:@"Select switch if Adjusted Premium isn't right"];
            break;
        case 9:
            [Footerlabel setText:@"Select switch if NRIC isn't right"];
            break;
        case 10:
            [Footerlabel setText:@"Select switch if Issue Age isn't right"];
            break;
        case 11:
            [Footerlabel setText:@"Select switch if Owner isn't right"];
            break;
        case 12:
            [Footerlabel setText:@"Select switch if Payment Mode isn't right"];
            break;
        case 13:
            [Footerlabel setText:@"Select switch if Payment Mothod isn't right"];
            break;
        case 14:
            [Footerlabel setText:@"Select switch if Bill To Date isn't right"];
            break;
        default:
            [Footerlabel setText:@""];
            break;
    }
    /*
     */
    
    return viewFotter;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:1.0 animations:^(void){
        switch (textField.tag) {
            case 52146:
                [_InsurenceDataTable setContentOffset:CGPointMake(0, 80)];
                break;
            case 52147:
                [_InsurenceDataTable setContentOffset:CGPointMake(0, 120)];
                break;
            case 52148:
                [_InsurenceDataTable setContentOffset:CGPointMake(0, 140)];
                break;
            case 52149:
                [_InsurenceDataTable setContentOffset:CGPointMake(0, 290)];
                break;
        }
    } completion:nil];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}
- (BOOL) textFieldShouldReturn:(UITextField*)textField {
    
    [UIView animateWithDuration:1.0 animations:^(void){
        [_InsurenceDataTable setContentOffset:CGPointMake(0, 0)];
    } completion:nil];
    [textField resignFirstResponder];
    
    return YES;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)leftSideMenuButtonPressed:(id)sender {
    
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        NSLog(@"Menu bar button prassed..");
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
