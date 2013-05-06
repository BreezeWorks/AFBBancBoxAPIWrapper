//
//  AFBBancBoxExternalAccountCardDebit.m
//  Breeze
//
//  Created by Adam Block on 4/29/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import "AFBBancBoxExternalAccountCardDebit.h"

@implementation AFBBancBoxExternalAccountCardDebit

- (id)initWithNumber:(NSString *)number debitCardType:(NSString *)debitCardType pin:(NSString *)pin
{
    self = [super init];
    if (self) {
        self.number = number;
        self.debitCardType = debitCardType;
        self.pin = pin;
    }
    return self;
}

- (id)initWithExternalAccountFromDictionary:(NSDictionary *)dict
{
    self = [super initWithExternalAccountFromDictionary:dict];
    if (self) {
        [self extractPropertiesFromDictionary:dict];
    }
    return self;
}

+ (AFBBancBoxExternalAccountCardDebit *)externalAccountFromDictionary:(NSDictionary *)dict
{
    AFBBancBoxExternalAccountCardDebit *account = [[AFBBancBoxExternalAccountCardDebit alloc] initWithExternalAccountFromDictionary:dict];
    return account;
}

- (void)extractPropertiesFromDictionary:(NSDictionary *)dict
{
    self.number = dict[@"account"][@"cardAccount"][@"debitCardAccount"][@"number"];
    self.debitCardType = dict[@"account"][@"cardAccount"][@"debitCardAccount"][@"type"];
    self.pin = dict[@"account"][@"cardAccount"][@"debitCardAccount"][@"pin"];
}

- (NSDictionary *)dictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionary]];
    dict[@"account"] = [self accountDetailsDictionary];
    return dict;
}

- (NSDictionary *)accountDetailsDictionary
{
    NSDictionary *dict = @{
                           @"cardAccount": @{
                                   @"debitCardAccount": @{
                                           @"number": self.number,
                                           @"type": self.debitCardType,
                                           @"pin": self.pin }
                                   }
                           };
    return dict;
}

@end
