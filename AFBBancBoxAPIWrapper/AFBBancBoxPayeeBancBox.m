//
//  AFBBancBoxPayeeBancBox.m
//  Breeze
//
//  Created by Adam Block on 4/27/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import "AFBBancBoxPayeeBancBox.h"

@implementation AFBBancBoxPayeeBancBox

- (id)initWithPayeeFromDictionary:(NSDictionary *)dict
{
    self = [super initWithPayeeFromDictionary:dict];
    if (self) {
        [self extractPropertiesFromDictionary:dict];
    }
    return self;
}

+ (AFBBancBoxPayeeBancBox *)payeeFromDictionary:(NSDictionary *)dict
{
    return [[AFBBancBoxPayeeBancBox alloc] initWithPayeeFromDictionary:dict];
}

- (void)extractPropertiesFromDictionary:(NSDictionary *)dict
{
    self.payeeType = @"bancbox";
    self.bancboxPayeeId = [dict[@"payee"][@"bancbox"][@"bancboxPayeeId"] integerValue];
}

- (NSDictionary *)dictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionary]];
    [dict addEntriesFromDictionary:@{
                                     @"payee":
                                         @{
                                         self.payeeType:
                                             @{
                                                @"bancboxPayeeId": [NSNumber numberWithInteger:self.bancboxPayeeId]
                                             }
                                         }
                                     }];
    return dict;
}

@end
