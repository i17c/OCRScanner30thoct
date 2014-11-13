//
//  OCRAddContactFromOCRViewController.m
//  AlbaseNew
//
//  Created by Mac on 31/10/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import "OCRAddContactFromOCRViewController.h"
#import "OCRAddInsuranceViewController.h"
#import "UIColor+HexColor.h"
#import "MFSideMenu.h"

@interface OCRAddContactFromOCRViewController ()

@property (nonatomic,retain) NSString *FirstName;
@property (nonatomic,retain) UITextField *FirstnameTextField;

@property (nonatomic,retain) NSString *LastName;
@property (nonatomic,retain) UITextField *LastnameTextField;

@property (nonatomic,retain) NSString *UserDateOfBirth;
@property (nonatomic,retain) UITextField *DateOfBirthTextField;

@property (nonatomic,retain) NSString *Gender;
@property (nonatomic,retain) UITextField *GenderTextField;

@property (nonatomic,retain) NSString *Email;
@property (nonatomic,retain) UITextField *EmailTextField;

@property (nonatomic,retain) NSString *UserProfileImage;
@property (nonatomic,retain) UIImageView *UserProfileImageView;

@property (nonatomic,retain) NSString *PhoneNumber;
@property (nonatomic,retain) UITextField *PhoneNumberTextField;


@property (nonatomic,retain) UITableView *AddContactTableView;
@end

@implementation OCRAddContactFromOCRViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self=(IsIphone5)?[super initWithNibName:@"OCRAddContactFromOCRViewController" bundle:nil]:[super initWithNibName:@"OCRAddContactFromOCRViewController4s" bundle:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"DataDictionary ---------------- %@",_DataDictionary);
    
    [[self.navigationController navigationBar] setHidden:YES];
    
    UIView *HeaderView = (UIView *)[self.view viewWithTag:110];
    [HeaderView setBackgroundColor:[UIColor colorFromHex:0x1EBBFE]];
    
    UILabel *Titlelabel = (UILabel *)[self.view viewWithTag:888];
    [Titlelabel setText:@"Add Contact"];
    [Titlelabel setTextColor:[UIColor whiteColor]];
    [Titlelabel setFont:[UIFont fontWithName:@"Helvetica" size:18.0f]];
    
    UIButton *SetButton = (UIButton *)[self.view viewWithTag:111];
    [SetButton addTarget:self action:@selector(leftSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *NextButton = (UIButton *)[self.view viewWithTag:564];
    [NextButton addTarget:self action:@selector(RightSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    _AddContactTableView = (UITableView *)[self.view viewWithTag:752];
    [_AddContactTableView setDelegate:self];
    [_AddContactTableView setDataSource:self];
    
}
-(IBAction)RightSideMenuButtonPressed:(id)sender
{
    OCRAddInsuranceViewController *Addinsurence = [[OCRAddInsuranceViewController alloc] initWithNibName:@"OCRAddInsuranceViewController" bundle:nil];
    Addinsurence.DataModel = self.DataModel;
    [self.navigationController pushViewController:Addinsurence animated:YES];
}
#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
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
    
    if (section == 0 || section == 1 || section == 3 || section == 5) {
        return 44;
    } else {
        return 0;
    }
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
            [Footerlabel setText:@"Select switch if Firstname isn't right"];
            break;
        case 1:
            [Footerlabel setText:@"Select switch if Lastname isn't right"];
            break;
        case 3:
            [Footerlabel setText:@"Select switch if Date of Birth isn't right"];
            break;
        case 5:
            [Footerlabel setText:@"Switch is green for male and white for female"];
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
                [_AddContactTableView setContentOffset:CGPointMake(0, 80)];
                break;
            case 52147:
                [_AddContactTableView setContentOffset:CGPointMake(0, 120)];
                break;
            case 52148:
                [_AddContactTableView setContentOffset:CGPointMake(0, 140)];
                break;
            case 52149:
                [_AddContactTableView setContentOffset:CGPointMake(0, 290)];
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
        [_AddContactTableView setContentOffset:CGPointMake(0, 0)];
    } completion:nil];
    [textField resignFirstResponder];
    return YES;
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
    
    if (indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 3) {
        
        UISwitch *dataSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(260, 10, 70, 30)];
        [dataSwitch setBackgroundColor:[UIColor clearColor]];
        [dataSwitch setTag:(12546+indexPath.section)];
        [dataSwitch addTarget:self action:@selector(switchIsChanged:) forControlEvents:UIControlEventValueChanged];
        [dataSwitch setUserInteractionEnabled:YES];
        [cell.contentView addSubview:dataSwitch];
    }
    
    if (indexPath.section == 0) {
        
        _FirstnameTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 250, 50)];
        [_FirstnameTextField setBackgroundColor:[UIColor whiteColor]];
        [_FirstnameTextField setEnabled:NO];
        [_FirstnameTextField setTag:52145];
        [_FirstnameTextField setTextColor:[UIColor darkGrayColor]];
        [_FirstnameTextField setFont:[UIFont fontWithName:@"Helvetica" size:13.0f]];
        [_FirstnameTextField setDelegate:self];
        [cell.contentView addSubview:_FirstnameTextField];
        
        @try {
            NSString *UserFullName = [self CleanTextField:[_DataModel Name]];
            NSString *newString = [UserFullName stringByReplacingOccurrencesOfString:@": " withString:@"" options: NSRegularExpressionSearch range:NSMakeRange(0, UserFullName.length)];
            
            NSArray *NameSplit      = [newString componentsSeparatedByString:@" "];
            [_FirstnameTextField setText:[NameSplit objectAtIndex:0]];
        }
        @catch (NSException *exception) {
            NSLog(@"first name Split exception");
        }
        
    } else if (indexPath.section == 1) {
        
        _LastnameTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 250, 50)];
        [_LastnameTextField setBackgroundColor:[UIColor whiteColor]];
        [_LastnameTextField setEnabled:NO];
        [_LastnameTextField setTag:52146];
        [_LastnameTextField setTextColor:[UIColor darkGrayColor]];
        [_LastnameTextField setFont:[UIFont fontWithName:@"Helvetica" size:13.0f]];
        [_LastnameTextField setDelegate:self];
        [cell.contentView addSubview:_LastnameTextField];
        
        @try {
            NSString *UserFullName = [self CleanTextField:[_DataModel Name]];
            NSLog(@"username ===== %@",[_DataModel Name]);
            
            NSString *newString = [UserFullName stringByReplacingOccurrencesOfString:@": " withString:@"" options: NSRegularExpressionSearch range:NSMakeRange(0, UserFullName.length)];
            
            NSArray *NameSplit      = [newString componentsSeparatedByString:@" "];
            NSLog(@"NameSplit ---- %@",NameSplit);
            NSArray *SecondndNameSplit = [UserFullName componentsSeparatedByString:[NameSplit objectAtIndex:0]];
            [_LastnameTextField setText:[SecondndNameSplit objectAtIndex:1]];
           
        }
        @catch (NSException *exception) {
            NSLog(@"second name Split exception");
        }
        
    } else if (indexPath.section == 2) {
        
        _PhoneNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 250, 50)];
        [_PhoneNumberTextField setBackgroundColor:[UIColor whiteColor]];
        [_PhoneNumberTextField setEnabled:YES];
        [_PhoneNumberTextField setDelegate:self];
        [_PhoneNumberTextField setTag:52147];
        [_PhoneNumberTextField setPlaceholder:@"Add Phonenumber"];
        [_PhoneNumberTextField setTextColor:[UIColor darkGrayColor]];
        [_PhoneNumberTextField setFont:[UIFont fontWithName:@"Helvetica" size:13.0f]];
        [cell.contentView addSubview:_PhoneNumberTextField];
        
    } else if (indexPath.section == 3) {
        
        _DateOfBirthTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 250, 50)];
        [_DateOfBirthTextField setBackgroundColor:[UIColor whiteColor]];
        [_DateOfBirthTextField setEnabled:NO];
        [_DateOfBirthTextField setTag:52148];
        [_DateOfBirthTextField setTextColor:[UIColor darkGrayColor]];
        [_DateOfBirthTextField setFont:[UIFont fontWithName:@"Helvetica" size:13.0f]];
        [cell.contentView addSubview:_DateOfBirthTextField];
        
        @try {
            NSString *CleanedString = [self RemoveSpecialCharacterFromString:[self CleanTextField:[_DataModel DOB]]];
            NSLog(@"CleanedString ===== %@",CleanedString);
            NSArray *DOBArray = [CleanedString componentsSeparatedByString:@"-"];
            NSLog(@"DOBArray ===== %@",DOBArray);
            NSString *DateOfBirth = nil;
            
            if ([[DOBArray objectAtIndex:1] rangeOfString:@"Jan"
                                                  options:NSRegularExpressionSearch|NSCaseInsensitiveSearch].location
                != NSNotFound)
            {
                DateOfBirth = @"01";
            } else if ([[DOBArray objectAtIndex:1] rangeOfString:@"Feb"
                                                         options:NSRegularExpressionSearch|NSCaseInsensitiveSearch].location
                       != NSNotFound)
            {
                DateOfBirth = @"02";
            } else if ([[DOBArray objectAtIndex:1] rangeOfString:@"March"
                                                         options:NSRegularExpressionSearch|NSCaseInsensitiveSearch].location
                       != NSNotFound)
            {
                DateOfBirth = @"03";
            } else if ([[DOBArray objectAtIndex:1] rangeOfString:@"April"
                                                         options:NSRegularExpressionSearch|NSCaseInsensitiveSearch].location
                       != NSNotFound)
            {
                DateOfBirth = @"04";
            } else if ([[DOBArray objectAtIndex:1] rangeOfString:@"May"
                                                         options:NSRegularExpressionSearch|NSCaseInsensitiveSearch].location
                       != NSNotFound)
            {
                DateOfBirth = @"05";
            } else if ([[DOBArray objectAtIndex:1] rangeOfString:@"June"
                                                         options:NSRegularExpressionSearch|NSCaseInsensitiveSearch].location
                       != NSNotFound)
            {
                DateOfBirth = @"06";
            } else if ([[DOBArray objectAtIndex:1] rangeOfString:@"July"
                                                         options:NSRegularExpressionSearch|NSCaseInsensitiveSearch].location
                       != NSNotFound)
            {
                DateOfBirth = @"07";
            } else if ([[DOBArray objectAtIndex:1] rangeOfString:@"Aug"
                                                         options:NSRegularExpressionSearch|NSCaseInsensitiveSearch].location
                       != NSNotFound)
            {
                DateOfBirth = @"08";
            } else if ([[DOBArray objectAtIndex:1] rangeOfString:@"Sep"
                                                         options:NSRegularExpressionSearch|NSCaseInsensitiveSearch].location
                       != NSNotFound)
            {
                DateOfBirth = @"09";
            } else if ([[DOBArray objectAtIndex:1] rangeOfString:@"Oct"
                                                         options:NSRegularExpressionSearch|NSCaseInsensitiveSearch].location
                       != NSNotFound)
            {
                DateOfBirth = @"10";
            } else if ([[DOBArray objectAtIndex:1] rangeOfString:@"Nov"
                                                         options:NSRegularExpressionSearch|NSCaseInsensitiveSearch].location
                       != NSNotFound)
            {
                DateOfBirth = @"11";
            } else if ([[DOBArray objectAtIndex:1] rangeOfString:@"Dec"
                                                         options:NSRegularExpressionSearch|NSCaseInsensitiveSearch].location
                       != NSNotFound)
            {
                DateOfBirth = @"12";
            } else {
                DateOfBirth = @"00";
            }
            
            NSString *SplitedYear = [self CleanTextField:[DOBArray objectAtIndex:2]];
            NSString *yeardata = nil;
            if ([SplitedYear intValue]<30) {
                yeardata = [NSString stringWithFormat:@"20%d",[SplitedYear intValue]];
            } else {
                yeardata = [NSString stringWithFormat:@"19%d",[SplitedYear intValue]];
            }
            
            NSString *FullDateOfBirth = [NSString stringWithFormat:@"%@-%@-%@",[DOBArray objectAtIndex:0],DateOfBirth,yeardata];
            
            [_DateOfBirthTextField setDelegate:self];
            [_DateOfBirthTextField setText:FullDateOfBirth];
        }
        @catch (NSException *exception) {
            [_DateOfBirthTextField setText:@"00-00-0000"];
        }
        
    } else if (indexPath.section ==4) {
        
        _EmailTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 250, 50)];
        [_EmailTextField setBackgroundColor:[UIColor whiteColor]];
        [_EmailTextField setTextColor:[UIColor darkGrayColor]];
        [_EmailTextField setPlaceholder:@"Add Email"];
        [_EmailTextField setEnabled:YES];
        [_EmailTextField setTag:52149];
        [_EmailTextField setDelegate:self];
        [_EmailTextField setFont:[UIFont fontWithName:@"Helvetica" size:13.0f]];
        [cell.contentView addSubview:_EmailTextField];
        
    } else if (indexPath.section == 5) {
        
        _GenderTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 250, 50)];
        [_GenderTextField setBackgroundColor:[UIColor whiteColor]];
        [_GenderTextField setEnabled:NO];
        [_GenderTextField setTag:52150];
        [_GenderTextField setTextColor:[UIColor darkGrayColor]];
        [_GenderTextField setFont:[UIFont fontWithName:@"Helvetica" size:13.0f]];
        [_GenderTextField setDelegate:self];
        [_GenderTextField setText:[_DataModel Gender]];
        [cell.contentView addSubview:_GenderTextField];
        
    }
    
    return cell;
}
-(NSString *)RemoveSpecialCharacterFromString:(NSString *)DataString
{
    NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789-abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"] invertedSet];
    NSString *resultString = [[DataString componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
    
    return resultString;
    
}
-(IBAction)switchIsChanged:(UISwitch *)sender
{
    if (sender.tag == 12546) {
        if ([sender isOn]){
            [_FirstnameTextField setEnabled:YES];
        } else {
            [_FirstnameTextField setEnabled:NO];
        }
    } else if (sender.tag == 12547) {
        if ([sender isOn]){
            [_LastnameTextField setEnabled:YES];
        } else {
            [_LastnameTextField setEnabled:NO];
        }
    } else if (sender.tag == 12548) {
        if ([sender isOn]){
            [_PhoneNumberTextField setEnabled:YES];
        } else {
            [_PhoneNumberTextField setEnabled:NO];
        }
    } else if (sender.tag == 12549) {
        if ([sender isOn]){
            [_DateOfBirthTextField setEnabled:YES];
        } else {
            [_DateOfBirthTextField setEnabled:NO];
        }
    } else if (sender.tag == 12550) {
        if ([sender isOn]){
            [_EmailTextField setEnabled:YES];
        } else {
            [_EmailTextField setEnabled:NO];
        }
    }
}
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
        [TitleLabel setText:@"First name"];
    } else if (section == 1) {
        [TitleLabel setText:@"Last name"];
    } else if (section == 2) {
        [TitleLabel setText:@"Phone Number"];
    } else if (section == 3) {
        [TitleLabel setText:@"Date of Birth"];
    } else if (section == 4) {
        [TitleLabel setText:@"Email"];
    }
    return Headerview;
}

#pragma mark -
#pragma mark Table view delegate

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
