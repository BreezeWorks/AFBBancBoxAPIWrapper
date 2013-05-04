//
//  AFBBancBoxExternalAccountPaypal.m
//  Breeze
//
//  Created by Adam Block on 4/29/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import "AFBBancBoxExternalAccountPaypal.h"

@implementation AFBBancBoxExternalAccountPaypal

- (id)initWithId:(NSString *)paypalId
{
    self = [super init];
    if (self) {
        self.paypalId = paypalId;
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
    self.paypalId = dict[@"account"][@"paypalAccount"][@"id"];
}

- (NSDictionary *)dictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionary]];
    dict[@"account"] = [self accountDetailsDictionary];
    return dict;
}

- (NSDictionary *)accountDetailsDictionary
{
    NSDictionary *dict = @{ @"paypalAccount": @{ @"id": self.paypalId } };
    return dict;
}

@end
