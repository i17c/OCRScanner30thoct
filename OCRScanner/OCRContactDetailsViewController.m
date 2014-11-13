//
//  OCRContactDetailsViewController.m
//  OCRScanner
//
//  Created by Mac on 23/10/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import "OCRContactDetailsViewController.h"
#import "OCRContactListViewController.h"
#import "UIColor+HexColor.h"
#import <CoreTelephony/CTCarrier.h>
#import <MessageUI/MessageUI.h>

@interface OCRContactDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate>
@property (nonatomic,retain) UITableView *ContactDetailsTable;
@property(readonly, retain) CTCarrier *subscriberCellularProvider;
@end

@implementation OCRContactDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self=(IsIphone5)?[super initWithNibName:@"OCRContactDetailsViewController" bundle:nil]:[super initWithNibName:@"OCRContactDetailsViewController4s" bundle:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self.navigationController navigationBar] setHidden:YES];
    
    UIView *HeaderView = (UIView *)[self.view viewWithTag:110];
    [HeaderView setBackgroundColor:[UIColor colorFromHex:0x1EBBFE]];
    
    UILabel *Titlelabel = (UILabel *)[self.view viewWithTag:888];
    [Titlelabel setText:@"Contact Details"];
    [Titlelabel setTextColor:[UIColor whiteColor]];
    [Titlelabel setFont:[UIFont fontWithName:@"Helvetica" size:18.0f]];
    
    UIButton *SetButton = (UIButton *)[self.view viewWithTag:111];    
    [SetButton addTarget:self action:@selector(BackviewClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _ContactDetailsTable = (UITableView *)[self.view viewWithTag:752];
    [_ContactDetailsTable setDelegate:self];
    [_ContactDetailsTable setDataSource:self];
    
    UIButton *CallUser = (UIButton *)[self.view viewWithTag:321];
    [CallUser addTarget:self action:@selector(GoForCall:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *SMSUser = (UIButton *)[self.view viewWithTag:322];
    [SMSUser addTarget:self action:@selector(GoForSMS:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *MailUser = (UIButton *)[self.view viewWithTag:323];
    [MailUser addTarget:self action:@selector(GoForMail:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(IBAction)GoForSMS:(id)sender
{
}
-(IBAction)GoForMail:(id)sender
{
    MFMailComposeViewController *comp=[[MFMailComposeViewController alloc]init];
    [comp setMailComposeDelegate:self];
    if([MFMailComposeViewController canSendMail]) {
        NSLog(@"useremail --- %@",[_UserDataObject Useremail]);
        [comp setToRecipients:[NSArray arrayWithObjects:[_UserDataObject Useremail], nil]];
        [comp setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:comp animated:YES completion:nil];
    }
    else {
        UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:@"Sorry" message:@"Your device havn't capable to send mail." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alrt show];
    }
}
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}
-(IBAction)GoForCall:(id)sender
{
    NSString *mnc = [_subscriberCellularProvider mobileNetworkCode];
    if ([mnc length] == 0) {
        
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support Call!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        
    } else {
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",[_UserDataObject UserPhoneNumber]]]];
    }
}
-(IBAction)leftSideMenuButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
        [TitleLabel setText:@"Basic Information"];
    } else if (section == 1) {
        [TitleLabel setText:@"Email"];
    } else if (section == 2) {
        [TitleLabel setText:@"Phone Number"];
    } else if (section == 3) {
        [TitleLabel setText:@"Date of Birth"];
    }
    return Headerview;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 100.0f;
    } else {
        return 50.0f;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *TableCell = [[UITableViewCell alloc] init];
    if (indexPath.section == 0) {
        UIImageView *ProfileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 65, 65)];
        [ProfileImageView setImage:[UIImage imageNamed:@"noimageprof.png"]];
        [TableCell addSubview:ProfileImageView];
        
        UILabel *UserNamelabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 220, 30)];
        [UserNamelabel setTextAlignment:NSTextAlignmentLeft];
        [UserNamelabel setTextColor:[UIColor darkGrayColor]];
        [UserNamelabel setText:[NSString stringWithFormat:@"%@ %@",[_UserDataObject Firstname],[_UserDataObject Lastname]]];
        [UserNamelabel setFont:[UIFont fontWithName:@"Helvetica" size:15.0f]];
        [TableCell addSubview:UserNamelabel];
    } else if (indexPath.section == 1) {
        [TableCell.textLabel setText:[_UserDataObject Useremail]];
    } else if (indexPath.section == 2) {
        [TableCell.textLabel setText:[_UserDataObject UserPhoneNumber]];
    } else if (indexPath.section == 3) {
        [TableCell.textLabel setText:[_UserDataObject DateOfBirth]];
    }
    [TableCell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:15.0f]];
    [TableCell.textLabel setTextColor:[UIColor darkGrayColor]];
    return TableCell;
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(IBAction)BackviewClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
