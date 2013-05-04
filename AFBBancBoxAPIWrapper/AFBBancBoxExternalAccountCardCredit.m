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

- (id)initFactoryWithExternalAccountFromDictionary:(NSDictionary *)dict
{
    [self extractPropertiesFromDictionary:dict];
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

- (NSDictionary *)dictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionary]];
    dict[@"account"] = [self accountDetailsDictionary];
    return dict;
}

- (NSDictionary *)accountDetailsDictionary
{
    NSDictionary *dict = @{ @"cardAccount":
                                @{ @"creditCardAccount":
                                       @{ @"tokenizedId": self.tokenizedId,
                                          @"creditCardDetails":
                                              @{ @"number": self.cardNumber,
                                                 @"expiryDate": self.expiryDate,
                                                 @"type": self.creditCardType,
                                                 @"name": self.name,
                                                 @"cvv": self.cvv,
                                                 @"address": @{
                                                         @"line1": self.addressLine1,
                                                         @"line2": self.addressLine2,
                                                         @"city": self.addressCity,
                                                         @"state": self.addressState,
                                                         @"zipcode": self.addressZipcode }
                                                 }
                                          }
                                   }
                            };
    return dict;
}

@end
