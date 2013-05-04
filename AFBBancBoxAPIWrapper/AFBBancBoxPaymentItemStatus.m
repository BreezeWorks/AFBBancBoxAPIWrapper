//
//  AFBBancBoxPaymentItemStatus.m
//  Breeze
//
//  Created by Adam Block on 5/1/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import "AFBBancBoxPaymentItemStatus.h"

@implementation AFBBancBoxPaymentItemStatus

- (id)initWithPaymentItemStatusFromDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.statusIdBancBoxId = [dict[@"id"][@"bancBoxId"] integerValue];
        self.statusIdSubscriberReferenceId = dict[@"id"][@"subscriberReferenceId"];
        self.transactionStatus = dict[@"status"];
        self.messageCode = dict[@"messageCode"];
        self.messageDesc = dict[@"messageDesc"];
        self.errorCode = dict[@"code"];
        self.errorMessage = dict[@"message"];
        self.itemStatus = [dict[@"itemStatus"] boolValue];
        self.externalReferenceId = dict[@"externalReferenceId"];
    }
    return self;
}

@end
