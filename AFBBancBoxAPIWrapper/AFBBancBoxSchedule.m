//
//  AFBBancBoxSchedule.m
//  Breeze
//
//  Created by Adam Block on 4/26/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import "AFBBancBoxSchedule.h"

@implementation AFBBancBoxSchedule

- (id)initWithScheduleFromDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.dictionary = dict;
        self.clientIdSubscriberReferenceId = dict[@"clientId"][@"subscriberReferenceId"];
        self.clientIdBancBoxId = [dict[@"clientId"][@"bancBoxId"] integerValue];
        self.type = dict[@"type"];
        self.amount = [dict[@"amount"] doubleValue];
        self.scheduleDate = [self dateFromBancBoxDateString:dict[@"scheduleDate"]];
        self.createdOn = [self dateFromBancBoxDateString:dict[@"createdOn"]];
        self.modifiedOn = [self dateFromBancBoxDateString:dict[@"modifiedOn"]];
        self.status = dict[@"status"];
        self.externalReferenceId = dict[@"externalReferenceId"];
    }
    return self;
}

+ (AFBBancBoxSchedule *)scheduleFromDictionary:(NSDictionary *)dict
{
    return [[AFBBancBoxSchedule alloc] initWithScheduleFromDictionary:dict];
}

- (NSDate *)dateFromBancBoxDateString:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-ddTHH:MM:S"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}

+ (BOOL)fundsRequestStatusIsValid:(NSString *)status
{
    NSSet *fundsRequestsStatuses = [NSSet setWithObjects:@"SCHEDULED", @"COMPLETED", @"FAILED", @"PENDING", @"IN_PROCESS", nil];
    return [fundsRequestsStatuses containsObject:status];
}

+ (BOOL)scheduleStypeIsValid:(NSString *)type
{
    NSSet *scheduleTypes = [NSSet setWithObjects:@"COLLECT", @"SEND", @"TRANSFER", @"FEE", nil];
    return [scheduleTypes containsObject:type];
}

@end
