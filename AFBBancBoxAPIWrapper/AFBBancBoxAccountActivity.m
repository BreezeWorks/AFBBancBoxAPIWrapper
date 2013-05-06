//
//  AFBBancBoxAccountActivity.m
//  Breeze
//
//  Created by Adam Block on 5/1/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import "AFBBancBoxAccountActivity.h"

@implementation AFBBancBoxAccountActivity

- (id)initWithActivityFromDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.traceId = dict[@"traceId"];
        self.activityDate = [[self activityDateFormatter] dateFromString:dict[@"activtyDate"]];
        self.activityDescription = dict[@"description"];
        self.debitAmount = [dict[@"debitAmount"] doubleValue];
        self.creditAmount = [dict[@"creditAmount"] doubleValue];
        self.balance = [dict[@"balance"] doubleValue];
    }
    return self;
}

+ (AFBBancBoxAccountActivity *)activityFromDictionary:(NSDictionary *)dict
{
    return [[AFBBancBoxAccountActivity alloc] initWithActivityFromDictionary:dict];
}

- (NSDateFormatter *)activityDateFormatter
{
    return [AFBBancBoxAccountActivity activityDateFormatter];
}

+ (NSDateFormatter *)activityDateFormatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-DD"];
    return dateFormatter;
}

@end
