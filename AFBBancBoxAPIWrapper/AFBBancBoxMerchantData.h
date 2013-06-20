//
//  AFBBancBoxMerchantData.h
//  AFBBancBoxAPIWrapper
//
//  Created by Adam Block on 5/24/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFBBancBoxExternalAccountBank.h"

extern NSString* const kBancBoxMerchantOrganizationTypeIndividualSoleProprietorship;
extern NSString* const kBancBoxMerchantOrganizationTypeCorporation;
extern NSString* const kBancBoxMerchantOrganizationTypeLimitedLiabilityCompany;
extern NSString* const kBancBoxMerchantOrganizationTypePartnership;
extern NSString* const kBancBoxMerchantOrganizationTypeAssociationEstateTrust;
extern NSString* const kBancBoxMerchantOrganizationTypeTaxExemptOrganization;
extern NSString* const kBancBoxMerchantOrganizationTypeInternationalOrganization;
extern NSString* const kBancBoxMerchantOrganizationTypeGovernmentOrganization;

@interface AFBBancBoxMerchantData : NSObject

@property (nonatomic) NSInteger clientIdBancBoxId;
@property (nonatomic, strong) NSString *clientIdSubscriberReferenceId;
@property (nonatomic, strong) AFBBancBoxExternalAccountBank *bankBusinessAccount;
@property (nonatomic, strong) NSString *merchantCategoryCode;
@property (nonatomic) NSInteger maxTransactionAmount;
@property (nonatomic, strong) NSString *customerServiceNumber;
@property (nonatomic, strong) NSString *amexId;
@property (nonatomic, strong) NSString *discoverId;
@property (nonatomic, strong) NSString *softDescriptor;
@property (nonatomic, strong) NSString *primaryContactFirstName;
@property (nonatomic, strong) NSString *primaryContactLastName;
@property (nonatomic, strong) NSString *primaryContactPhone;
@property (nonatomic, strong) NSString *primaryContactEmailAddress;
@property (nonatomic) BOOL createCredentials;
@property (nonatomic) BOOL hasAcceptedCreditCards;
@property (nonatomic) NSInteger visaAnnualSalesVolume;
@property (nonatomic, strong) NSString *organizationType;
@property (nonatomic, strong) NSString *taxId;

- (NSDictionary *)dictionary;
- (NSDictionary *)detailsDictionary;

@end
