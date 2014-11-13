//
//  OCRDataObjectModel.h
//  OCRScanner
//
//  Created by Mac on 18/09/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCRUserDataObjectModel : NSObject

@property (nonatomic,retain) NSString *UserId;
@property (nonatomic,retain) NSString *Firstname;
@property (nonatomic,retain) NSString *Lastname;
@property (nonatomic,retain) NSString *DateOfBirth;
@property (nonatomic,retain) NSString *UserPhoneNumber;
@property (nonatomic,retain) NSString *Useremail;
@property (nonatomic,retain) NSString *Gender;
@property (nonatomic,retain) NSString *Fullname;
@property (nonatomic,retain) NSString *ProfileImage;

-(id)initWithFirstname:(NSString *)ParamFirstname
              Lastname:(NSString *)ParamLastname
           DateOfBirth:(NSString *)ParamDateOfBirth
       UserPhoneNumber:(NSString *)ParamUserPhoneNumber
             Useremail:(NSString *)ParamUseremail
                Gender:(NSString *)ParamGender
          ProfileImage:(NSString *)ParamProfileImage
                UserId:(NSString *)ParamUserId;

@end


@interface OCRNoteDataObjectModel : NSObject

@property (nonatomic,retain) NSString *NoteId;
@property (nonatomic,retain) NSString *NoteAddedDate;
@property (nonatomic,retain) NSString *NoteDetails;

-(id)initWithNoteId:(NSString *)ParamNoteId
      NoteAddedDate:(NSString *)ParamNoteAddedDate
        NoteDetails:(NSString *)ParamNoteDetails;
@end

@interface OCRAppointmentDataObjectModel : NSObject

@property (nonatomic,retain) NSString *AppointmentID;
@property (nonatomic,retain) NSString *Appointmentaddedon;
@property (nonatomic,retain) NSString *Note;
@property (nonatomic,retain) NSString *ApponitmentStartDate;
@property (nonatomic,retain) NSString *ApponitmentEndDate;
@property (nonatomic,retain) NSString *ApponitmentDuration;
@property (nonatomic,retain) NSString *Apponitmentstatus;
@property (nonatomic,retain) NSString *AppointmentTitle;
@property (nonatomic,retain) NSString *AppointmentWith;
@property (nonatomic,retain) NSString *AppointmentWithname;
@property (nonatomic,retain) NSString *AppointmentStartTime;
@property (nonatomic,retain) NSString *AppointmentEndtime;

-(id)initWithAppointmentID:     (NSString *)ParamAppointmentID
        Appointmentaddedon:     (NSString *)ParamAppointmentaddedon
                      Note:     (NSString *)ParamNote
        ApponitmentStartDate:   (NSString *)ParamApponitmentStartDate
        ApponitmentEndDate:     (NSString *)ParamApponitmentEndDate
        ApponitmentDuration:    (NSString *)ParamApponitmentDuration
        Apponitmentstatus:      (NSString *)ParamApponitmentstatus
        AppointmentTitle:       (NSString *)ParamAppointmentTitle
        AppointmentWith:        (NSString *)ParamAppointmentWith
        AppointmentWithname:    (NSString *)ParamAppointmentWithname
        AppointmentStartTime:   (NSString *)ParamAppointmentStartTime
        AppointmentEndtime:     (NSString *)ParamAppointmentEndtime;

@end

@interface OCRScanDataObjectModel : NSObject

@property (nonatomic,retain) NSString *Status;
@property (nonatomic,retain) NSString *PolicyDate;
@property (nonatomic,retain) NSString *PaidToDate;
@property (nonatomic,retain) NSString *ModalPremium;
@property (nonatomic,retain) NSString *NextModalPremium;
@property (nonatomic,retain) NSString *PayUpDate;
@property (nonatomic,retain) NSString *MaturityDate;
@property (nonatomic,retain) NSString *InsuredAddress;
@property (nonatomic,retain) NSString *AdjustedPremium;
@property (nonatomic,retain) NSString *Gender;
@property (nonatomic,retain) NSString *Name;
@property (nonatomic,retain) NSString *NRIC;
@property (nonatomic,retain) NSString *DOB;
@property (nonatomic,retain) NSString *IssueAge;
@property (nonatomic,retain) NSString *Owner;
@property (nonatomic,retain) NSString *PaymentMode;
@property (nonatomic,retain) NSString *PaymentMothod;
@property (nonatomic,retain) NSString *BillToDate;

-(id)initWithStatus:     (NSString *)ParamStatus
         PolicyDate:     (NSString *)ParamPolicyDate
         PaidToDate:     (NSString *)ParamPaidToDate
       ModalPremium:     (NSString *)ParamModalPremium
   NextModalPremium:     (NSString *)NextModalPremium
          PayUpDate:     (NSString *)ParamPayUpDate
       MaturityDate:     (NSString *)ParamMaturityDate
     InsuredAddress:     (NSString *)ParamInsuredAddress
    AdjustedPremium:     (NSString *)ParamAdjustedPremium
             Gender:     (NSString *)ParamGender
               Name:     (NSString *)ParamName
               NRIC:     (NSString *)ParamNRIC
                DOB:     (NSString *)ParamDOB
           IssueAge:     (NSString *)ParamIssueAge
              Owner:     (NSString *)ParamOwner
        PaymentMode:     (NSString *)ParamPaymentMode
      PaymentMothod:     (NSString *)ParamPaymentMothod
         BillToDate:     (NSString *)ParamBillToDate;
@end