//
//  AFBBancBoxPayee.m
//  Breeze
//
//  Created by Adam Block on 4/26/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import "AFBBancBoxPayee.h"
#import "AFBBancBoxPayeeACH.h"
#import "AFBBancBoxPayeeBancBox.h"
#import "AFBBancBoxPayeeCheck.h"
#import "AFBBancBoxPayeePayPal.h"

@implementation AFBBancBoxPayee

- (id)initWithPayeeFromDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self extractCommonElementsFromDictionary:dict idKey:@"id"];
    }
    return self;
}

- (id)initFactoryWithPayeeFromDictionary:(NSDictionary *)dict
{
    id instance = nil;
    if (dict[@"payee"][@"ach"])     instance = [[AFBBancBoxPayeeACH alloc] initFactoryWithPayeeFromDictionary:dict];
    if (dict[@"payee"][@"bancbox"]) instance = [[AFBBancBoxPayeeBancBox alloc] initFactoryWithPayeeFromDictionary:dict];
    if (dict[@"payee"][@"check"])   instance = [[AFBBancBoxPayeeCheck alloc] initFactoryWithPayeeFromDictionary:dict];
    if (dict[@"payee"][@"paypal"])  instance = [[AFBBancBoxPayeePayPal alloc] initFactoryWithPayeeFromDictionary:dict];
    
    NSString *idKey = nil;
    if (dict[@"id"]) idKey = @"id";
    if (dict[@"linkedPayeeId"]) idKey = @"linkedPayeeId";
    
    self = instance;
    [self extractCommonElementsFromDictionary:dict idKey:idKey];
    
    return instance;
}

- (void)extractCommonElementsFromDictionary:(NSDictionary *)dict idKey:(NSString *)idKey
{
    self.dictionary = dict;
    self.payeeIdBancBoxId = [dict[idKey][@"bancBoxId"] integerValue];
    self.payeeIdSubscriberReferenceId = dict[idKey][@"subscriberReferenceId"];
    self.payeeAccountNumber = dict[@"payeeAccountNumber"];
    self.payeeName = dict[@"payeeName"];
    self.memo = dict[@"memo"];
}

- (NSDictionary *)dictionary
{
    NSDictionary *dict = @{
                           @"id": @{
                                   @"bancBoxId": [NSNumber numberWithInteger:self.payeeIdBancBoxId],
                                   @"subscriberReferenceId": self.payeeIdSubscriberReferenceId
                                   },
                           @"payeeAccountNumber": self.payeeAccountNumber,
                           @"payeeName": self.payeeName,
                           @"memo": self.memo
                           };
    return dict;
}

@end
