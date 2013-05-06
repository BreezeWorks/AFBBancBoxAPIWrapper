//
//  AFBBancBoxExternalAccountBank.m
//  Breeze
//
//  Created by Adam Block on 4/29/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import "AFBBancBoxExternalAccountBank.h"

NSString * const BancBoxExternalAccountBankTypeSaving =     @"SAVING";
NSString * const BancBoxExternalAccountBankTypeChecking =   @"CHECKING";

@implementation AFBBancBoxExternalAccountBank

- (id)initWithRoutingNumber:(NSString *)routingNumber accountNumber:(NSString *)accountNumber holderName:(NSString *)holderName bankAccountType:(NSString *)bankAccountType
{
    self = [super init];
    if (self) {
        self.routingNumber = routingNumber;
        self.accountNumber = accountNumber;
        self.holderName = holderName;
        self.bankAccountType = bankAccountType;
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

+ (AFBBancBoxExternalAccountBank *)externalAccountFromDictionary:(NSDictionary *)dict
{
    AFBBancBoxExternalAccountBank *account = [[AFBBancBoxExternalAccountBank alloc] initWithExternalAccountFromDictionary:dict];
    return account;
}

- (void)extractPropertiesFromDictionary:(NSDictionary *)dict
{
    self.routingNumber = dict[@"account"][@"bankAccount"][@"routingNumber"];
    self.accountNumber = dict[@"account"][@"bankAccount"][@"accountNumber"];
    self.holderName = dict[@"account"][@"bankAccount"][@"holderName"];
    self.bankAccountType = dict[@"account"][@"bankAccount"][@"bankAccountType"];
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
                           @"bankAccount":
                                @{
                                    @"routingNumber": self.routingNumber,
                                    @"accountNumber": self.accountNumber,
                                    @"holderName": self.holderName,
                                    @"bankAccountType": self.bankAccountType
                                }
                            };
    return dict;
}

@end
