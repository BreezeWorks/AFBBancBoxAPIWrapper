//
//  AFBBancBoxExternalAccountCardCredit.m
//  Breeze
//
//  Created by Adam Block on 4/29/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import "AFBBancBoxExternalAccountCardCredit.h"

@implementation AFBBancBoxExternalAccountCardCredit

- (id)initWithExternalAccountFromDictionary:(NSDictionary *)dict
{
    self = [super initWithExternalAccountFromDictionary:dict];
    if (self) {
        [self extractPropertiesFromDictionary:dict];
    }
    return self;
}

- (void)extractPropertiesFromDictionary:(NSDictionary *)dict
{
    self.tokenizedId = dict[@"account"][@"cardAccount"][@"creditCardAccount"][@"tokenizedId"];
    self.cardNumber = dict[@"account"][@"cardAccount"][@"creditCardAccount"][@"creditCardDetails"][@"number"];
    self.expiryDate = dict[@"account"][@"cardAccount"][@"creditCardAccount"][@"creditCardDetails"][@"expiryDate"];
    self.creditCardType = dict[@"account"][@"cardAccount"][@"creditCardAccount"][@"creditCardDetails"][@"type"];
    self.name = dict[@"account"][@"cardAccount"][@"creditCardAccount"][@"creditCardDetails"][@"name"];
    self.cvv = dict[@"account"][@"cardAccount"][@"creditCardAccount"][@"creditCardDetails"][@"cvv"];
    self.addressLine1 = dict[@"account"][@"cardAccount"][@"creditCardAccount"][@"creditCardDetails"][@"address"][@"line1"];
    self.addressLine2 = dict[@"account"][@"cardAccount"][@"creditCardAccount"][@"creditCardDetails"][@"address"][@"line2"];
    self.addressCity = dict[@"account"][@"cardAccount"][@"creditCardAccount"][@"creditCardDetails"][@"address"][@"city"];
    self.addressState = dict[@"account"][@"cardAccount"][@"creditCardAccount"][@"creditCardDetails"][@"address"][@"state"];
    self.addressZipcode = dict[@"account"][@"cardAccount"][@"creditCardAccount"][@"creditCardDetails"][@"address"][@"zipcode"];
}

+ (AFBBancBoxExternalAccountCardCredit *)externalAccountFromDictionary:(NSDictionary *)dict
{
    AFBBancBoxExternalAccountCardCredit *account = [[AFBBancBoxExternalAccountCardCredit alloc] initWithExternalAccountFromDictionary:dict];
    return account;
}

- (NSDictionary *)dictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionary]];
    dict[@"account"] = [self accountDetailsDictionary];
    return dict;
}

- (NSDictionary *)accountDetailsDictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"cardAccount"] = [NSMutableDictionary dictionary];
    dict[@"cardAccount"][@"creditCardAccount"] = [NSMutableDictionary dictionary];
    if (self.tokenizedId) dict[@"cardAccount"][@"creditCardAccount"][@"tokenizedId"] = self.tokenizedId;
    
    NSMutableDictionary *creditCardDetails = [NSMutableDictionary dictionary];
    creditCardDetails[@"number"] = self.cardNumber;
    creditCardDetails[@"expiryDate"] = self.expiryDate;
    creditCardDetails[@"type"] = self.creditCardType;
    creditCardDetails[@"name"] = self.name;
    creditCardDetails[@"cvv"] = self.cvv;
    
    NSMutableDictionary *address = [NSMutableDictionary dictionary];
    if (self.addressLine1) address[@"line1"] = self.addressLine1;
    if (self.addressLine2) address[@"line2"] = self.addressLine2;
    if (self.addressCity) address[@"city"] = self.addressCity;
    if (self.addressState) address[@"state"] = self.addressState;
    if (self.addressZipcode) address[@"zipcode"] = self.addressZipcode;
    
    creditCardDetails[@"address"] = address;
    dict[@"cardAccount"][@"creditCardAccount"][@"creditCardDetails"] = creditCardDetails;
    
    return dict;
}

@end
