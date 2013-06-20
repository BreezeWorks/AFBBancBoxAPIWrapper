//
//  AFBBancBoxMerchantData.m
//  AFBBancBoxAPIWrapper
//
//  Created by Adam Block on 5/24/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import "AFBBancBoxMerchantData.h"

NSString* const kBancBoxMerchantOrganizationTypeIndividualSoleProprietorship =  @"INDIVIDUAL_SOLE_PROPRIETORSHIP";
NSString* const kBancBoxMerchantOrganizationTypeCorporation =                   @"CORPORATION";
NSString* const kBancBoxMerchantOrganizationTypeLimitedLiabilityCompany =       @"LIMITED_LIABILITY_COMPANY";
NSString* const kBancBoxMerchantOrganizationTypePartnership =                   @"PARTNERSHIP";
NSString* const kBancBoxMerchantOrganizationTypeAssociationEstateTrust =        @"ASSOCIATION_ESTATE_TRUST";
NSString* const kBancBoxMerchantOrganizationTypeTaxExemptOrganization =         @"TAX_EXEMPT_ORGANIZATION";
NSString* const kBancBoxMerchantOrganizationTypeInternationalOrganization =     @"INTERNATIONAL_ORGANIZATION";
NSString* const kBancBoxMerchantOrganizationTypeGovernmentOrganization =        @"GOVERNMENT_ORGANIZATION";

@implementation AFBBancBoxMerchantData

- (NSDictionary *)dictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *clientIdDict = [NSMutableDictionary dictionary];
    clientIdDict[@"bancBoxId"] = [NSNumber numberWithInteger:self.clientIdBancBoxId];
    clientIdDict[@"subscriberReferenceId"] = self.clientIdSubscriberReferenceId;
    
    NSMutableDictionary *bankBusinessAccountDict = [NSMutableDictionary dictionary];
    bankBusinessAccountDict[@"routingNumber"] = self.bankBusinessAccount.routingNumber;
    bankBusinessAccountDict[@"accountNumber"] = self.bankBusinessAccount.accountNumber;
    bankBusinessAccountDict[@"holderName"] = self.bankBusinessAccount.holderName;
    bankBusinessAccountDict[@"bankAccountType"] = self.bankBusinessAccount.bankAccountType;
    
    NSMutableDictionary *merchantDetailsDict = [NSMutableDictionary dictionary];
    merchantDetailsDict[@"merchantCategoryCode"] = self.merchantCategoryCode;
    merchantDetailsDict[@"maxTransactionAmount"] = [NSNumber numberWithInteger:self.maxTransactionAmount];
    merchantDetailsDict[@"customerServiceNumber"] = self.customerServiceNumber;
    if (self.amexId) merchantDetailsDict[@"amexId"] = self.amexId;
    if (self.discoverId) merchantDetailsDict[@"discoverId"] = self.discoverId;
    merchantDetailsDict[@"softDescriptor"] = self.softDescriptor;
    
    NSMutableDictionary *primaryContactDict = [NSMutableDictionary dictionary];
    primaryContactDict[@"firstName"] = self.primaryContactFirstName;
    primaryContactDict[@"lastName"] = self.primaryContactLastName;
    primaryContactDict[@"phone"] = self.primaryContactPhone;
    primaryContactDict[@"emailAddress"] = self.primaryContactEmailAddress;
    
    dict[@"clientId"] = clientIdDict;
    dict[@"bankBusinessAccount"] = bankBusinessAccountDict;
    dict[@"merchantDetails"] = merchantDetailsDict;
    dict[@"primaryContact"] = primaryContactDict;
    
    dict[@"createCredentials"] = [NSNumber numberWithBool:self.createCredentials];
    dict[@"hasAcceptedCreditCards"] = [NSNumber numberWithBool:self.hasAcceptedCreditCards];
    dict[@"visaAnnualSalesVolume"] = [NSNumber numberWithInteger:self.visaAnnualSalesVolume];
    dict[@"organizationType"] = self.organizationType;
    if (self.taxId) dict[@"taxId"] = self.taxId;
    
    return dict;
}

@end
