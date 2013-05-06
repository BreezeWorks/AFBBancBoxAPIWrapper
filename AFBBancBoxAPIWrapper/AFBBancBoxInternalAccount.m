//
//  AFBBancBoxInternalAccount.m
//  Breeze
//
//  Created by Adam Block on 4/26/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import "AFBBancBoxInternalAccount.h"

@implementation AFBBancBoxInternalAccount

- (id)initWithAccountFromDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.dictionary = dict;
        self.bancBoxId = [dict[@"id"][@"bancBoxId"] longLongValue];
        self.subscriberReferenceId = dict[@"id"][@"subscriberReferenceId"];
        if ([dict[@"routable"][@"credits"] isEqualToString:@"YES"]) {
            self.routableForCredits = YES;
        } else if ([dict[@"routable"][@"credits"] isEqualToString:@"NO"]) {
            self.routableForCredits = NO;
        }
        if ([dict[@"routable"][@"debits"] isEqualToString:@"YES"]) {
            self.routableForDebits = YES;
        } else if ([dict[@"routable"][@"debits"] isEqualToString:@"NO"]) {
            self.routableForDebits = NO;
        }
        self.routingNumber = dict[@"routingNumber"];
        self.accountStatus = dict[@"status"];
        self.accountType = dict[@"accountType"];
        self.title = dict[@"title"];
    }
    return self;
}

+ (AFBBancBoxInternalAccount *)accountFromDictionary:(NSDictionary *)dict
{
    return [[AFBBancBoxInternalAccount alloc] initWithAccountFromDictionary:dict];
}

- (NSDictionary *)idDictionary
{
    NSDictionary *dict = @{ @"bancBoxId": [NSNumber numberWithLongLong:self.bancBoxId], @"subscriberReferenceId": self.subscriberReferenceId };
    return dict;
}

@end
