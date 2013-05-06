//
//  AFBBancBoxPayeeACH.m
//  Breeze
//
//  Created by Adam Block on 4/27/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import "AFBBancBoxPayeeACH.h"

@implementation AFBBancBoxPayeeACH

- (id)initWithPayeeFromDictionary:(NSDictionary *)dict
{
    self = [super initWithPayeeFromDictionary:dict];
    if (self) {
        [self extractPropertiesFromDictionary:dict];
    }
    return self;
}

+ (AFBBancBoxPayeeACH *)payeeFromDictionary:(NSDictionary *)dict
{
    return [[AFBBancBoxPayeeACH alloc] initWithPayeeFromDictionary:dict];
}

- (void)extractPropertiesFromDictionary:(NSDictionary *)dict
{
    self.payeeType = @"ach";
    self.routingNumber = dict[@"payee"][@"ach"][@"routingNumber"];
    self.accountNumber = dict[@"payee"][@"ach"][@"accountNumber"];
    self.holderName = dict[@"payee"][@"ach"][@"holderName"];
    self.bankAccountType = dict[@"payee"][@"ach"][@"bankAccountType"];
}

- (NSDictionary *)dictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionary]];
    [dict addEntriesFromDictionary:@{
                                    @"payee":
                                        @{
                                            self.payeeType:
                                            @{
                                                @"routingNumber": self.routingNumber,
                                                @"accountNumber": self.accountNumber,
                                                @"holderName": self.holderName,
                                                @"bankAccountType": self.bankAccountType
                                            }
                                        }
                                    }];
    return dict;
}

@end
