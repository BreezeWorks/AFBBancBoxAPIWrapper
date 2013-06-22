//
//  AFBBancBoxPayeePayPal.m
//  Breeze
//
//  Created by Adam Block on 4/27/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import "AFBBancBoxPayeePayPal.h"

@implementation AFBBancBoxPayeePayPal

- (id)initWithPayeeFromDictionary:(NSDictionary *)dict
{
    self = [super initWithPayeeFromDictionary:dict];
    if (self) {
        [self extractPropertiesFromDictionary:dict];
    }
    return self;
}

+ (AFBBancBoxPayeePayPal *)payeeFromDictionary:(NSDictionary *)dict
{
    return [[AFBBancBoxPayeePayPal alloc] initWithPayeeFromDictionary:dict];
}

- (void)extractPropertiesFromDictionary:(NSDictionary *)dict
{
    self.payeeType = @"paypal";
    self.id = dict[@"payee"][@"paypal"][@"id"];
}

- (NSDictionary *)dictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionary]];
    [dict addEntriesFromDictionary:@{
                                     @"payee":
                                         @{
                                             self.payeeType:
                                             @{
                                                @"id": self.id
                                             }
                                         }
                                     }];
    return dict;
}

@end
