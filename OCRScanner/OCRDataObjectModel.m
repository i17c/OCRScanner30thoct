//
//  OCRDataObjectModel.m
//  OCRScanner
//
//  Created by Mac on 18/09/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import "OCRDataObjectModel.h"

@implementation OCRUserDataObjectModel

-(id)initWithFirstname:(NSString *)ParamFirstname Lastname:(NSString *)ParamLastname DateOfBirth:(NSString *)ParamDateOfBirth UserPhoneNumber:(NSString *)ParamUserPhoneNumber Useremail:(NSString *)ParamUseremail Gender:(NSString *)ParamGender ProfileImage:(NSString *)ParamProfileImage UserId:(NSString *)ParamUserId
{
    self = [super init];
    if (self) {
        self.Firstname          = ParamFirstname;
        self.Lastname           = ParamLastname;
        self.DateOfBirth        = ParamDateOfBirth;
        self.UserPhoneNumber    = ParamUserPhoneNumber;
        self.Useremail          = ParamUseremail;
        self.Gender             = ParamGender;
        self.Fullname           = [NSString stringWithFormat:@"%@ %@",ParamFirstname,ParamLastname];
        self.ProfileImage       = ParamProfileImage;
        self.UserId             = ParamUserId;
    }
    return self;
}
@end


@implementation OCRNoteDataObjectModel

-(id)initWithNoteId:(NSString *)ParamNoteId NoteAddedDate:(NSString *)ParamNoteAddedDate NoteDetails:(NSString *)ParamNoteDetails
{
    self = [super init];
    if (self) {
        self.NoteId         = ParamNoteId;
        self.NoteAddedDate  = ParamNoteAddedDate;
        self.NoteDetails    = ParamNoteDetails;
    }
    return self;
}

@end

@implementation OCRAppointmentDataObjectModel

-(id)initWithAppointmentID:     (NSString *)ParamAppointmentID
        Appointmentaddedon:     (NSString *)ParamAppointmentaddedon
                      Note:     (NSString *)ParamNote
      ApponitmentStartDate:     (NSString *)ParamApponitmentStartDate
        ApponitmentEndDate:     (NSString *)ParamApponitmentEndDate
       ApponitmentDuration:     (NSString *)ParamApponitmentDuration
         Apponitmentstatus:     (NSString *)ParamApponitmentstatus
          AppointmentTitle:     (NSString *)ParamAppointmentTitle
           AppointmentWith:     (NSString *)ParamAppointmentWith
       AppointmentWithname:     (NSString *)ParamAppointmentWithname
      AppointmentStartTime:     (NSString *)ParamAppointmentStartTime
        AppointmentEndtime:     (NSString *)ParamAppointmentEndtime
{
    self = [super init];
    if(self)
    {
        self.AppointmentID          = ParamAppointmentID;
        self.Appointmentaddedon     = ParamAppointmentaddedon;
        self.Note                   = ParamNote;
        self.ApponitmentStartDate   = ParamApponitmentStartDate;
        self.ApponitmentEndDate     = ParamApponitmentEndDate;
        self.ApponitmentDuration    = ParamApponitmentDuration;
        self.Apponitmentstatus      = ParamApponitmentstatus;
        self.AppointmentTitle       = ParamAppointmentTitle;
        self.AppointmentWith        = ParamAppointmentWith;
        self.AppointmentWithname    = ParamAppointmentWithname;
        self.AppointmentStartTime   = ParamAppointmentStartTime;
        self.AppointmentEndtime     = ParamAppointmentEndtime;
    }
    return self;
}


@end

@implementation OCRScanDataObjectModel

-(id)initWithStatus:(NSString *)ParamStatus PolicyDate:(NSString *)ParamPolicyDate PaidToDate:(NSString *)ParamPaidToDate ModalPremium:(NSString *)ParamModalPremium NextModalPremium:(NSString *)NextModalPremium PayUpDate:(NSString *)ParamPayUpDate MaturityDate:(NSString *)ParamMaturityDate InsuredAddress:(NSString *)ParamInsuredAddress AdjustedPremium:(NSString *)ParamAdjustedPremium Gender:(NSString *)ParamGender Name:(NSString *)ParamName NRIC:(NSString *)ParamNRIC DOB:(NSString *)ParamDOB IssueAge:(NSString *)ParamIssueAge Owner:(NSString *)ParamOwner PaymentMode:(NSString *)ParamPaymentMode PaymentMothod:(NSString *)ParamPaymentMothod BillToDate:(NSString *)ParamBillToDate
{
    self = [super init];
    if(self)
    {
        self.Status             = ParamStatus;
        self.PolicyDate         = ParamPolicyDate;
        self.PaidToDate         = ParamPaidToDate;
        self.ModalPremium       = ParamModalPremium;
        self.NextModalPremium   = NextModalPremium;
        self.PayUpDate          = ParamPayUpDate;
        self.MaturityDate       = ParamMaturityDate;
        self.InsuredAddress     = ParamInsuredAddress;
        self.AdjustedPremium    = ParamAdjustedPremium;
        self.Gender             = ParamGender;
        self.Name               = ParamName;
        self.NRIC               = ParamNRIC;
        self.DOB                = ParamDOB;
        self.IssueAge           = ParamIssueAge;
        self.Owner              = ParamOwner;
        self.PaymentMode        = ParamPaymentMode;
        self.PaymentMothod      = ParamPaymentMothod;
        self.BillToDate         = ParamBillToDate;
    }
    return self;
}

@end