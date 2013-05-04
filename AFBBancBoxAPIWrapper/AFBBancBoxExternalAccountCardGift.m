//
//  AFBBancBoxExternalAccountCardGift.m
//  Breeze
//
//  Created by Adam Block on 4/29/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import "AFBBancBoxExternalAccountCardGift.h"

@implementation AFBBancBoxExternalAccountCardGift

- (id)initWithNumber:(NSString *)number pin:(NSString *)pin
{
    self = [super init];
    if (self) {
        self.number = number;
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

- (id)initFactoryWithExternalAccountFromDictionary:(NSDictionary *)dict
{
    [self extractPropertiesFromDictionary:dict];
    return self;
}

- (void)extractPropertiesFromDictionary:(NSDictionary *)dict
{
    self.number = dict[@"account"][@"cardAccount"][@"giftCardAccount"][@"number"];
    self.pin = dict[@"account"][@"cardAccount"][@"giftCardAccount"][@"pin"];
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
                                   @"giftCardAccount": @{
                                           @"number": self.number,
                                           @"pin": self.pin
                                           }
                                   }
                           };
    return dict;
}

@end
