//
//  AFBBancBoxPayeeCheck.m
//  Breeze
//
//  Created by Adam Block on 4/27/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import "AFBBancBoxPayeeCheck.h"

@implementation AFBBancBoxPayeeCheck

- (id)initWithPayeeFromDictionary:(NSDictionary *)dict
{
    self = [super initWithPayeeFromDictionary:dict];
    if (self) {
        [self extractPropertiesFromDictionary:dict];
    }
    return self;
}

+ (AFBBancBoxPayeeCheck *)payeeFromDictionary:(NSDictionary *)dict
{
    return [[AFBBancBoxPayeeCheck alloc] initWithPayeeFromDictionary:dict];
}

- (void)extractPropertiesFromDictionary:(NSDictionary *)dict
{
    self.payeeType = @"check";
    self.name = dict[@"payee"][@"check"][@"name"];
    self.addressLine1 = dict[@"payee"][@"check"][@"address"][@"line1"];
    self.addressLine2 = dict[@"payee"][@"check"][@"address"][@"line2"];
    self.addressCity = dict[@"payee"][@"check"][@"address"][@"city"];
    self.addressState = dict[@"payee"][@"check"][@"address"][@"state"];
    self.addressZipCode = dict[@"payee"][@"check"][@"address"][@"zipcode"];
}

- (NSDictionary *)dictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionary]];
    [dict addEntriesFromDictionary:@{
                                     @"payee":
                                     @{
                                         self.payeeType:
                                         @{
                                             @"name": self.name,
                                             @"address":
                                             @{
                                                 @"line1": self.addressLine1,
                                                 @"line2": self.addressLine2,
                                                 @"city": self.addressCity,
                                                 @"state": self.addressState,
                                                 @"zipcode": self.addressZipCode
                                             }
                                         }
                                     }
                                    }];
    return dict;
}

@end
