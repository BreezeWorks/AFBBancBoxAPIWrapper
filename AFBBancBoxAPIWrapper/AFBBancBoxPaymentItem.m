//
//  AFBBancBoxPaymentItem.m
//  Breeze
//
//  Created by Adam Block on 4/27/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import "AFBBancBoxPaymentItem.h"

@interface AFBBancBoxPaymentItem()

@property (nonatomic, strong) NSDictionary *dictionary;

@end

@implementation AFBBancBoxPaymentItem

- (id)initWithPaymentItemFromDictionary:(NSDictionary *)dict;
{
    self = [super init];
    if (self) {
        self.dictionary = dict;
        self.referenceId = dict[@"referenceId"];
        self.amount = [dict[@"amount"] doubleValue];
        self.memo = dict[@"memo"];
        self.scheduleDate = [[self paymentItemDateFormatter] dateFromString:dict[@"scheduleDate"]];
    }
    return self;
}

- (id)initWithPaymentAmount:(double)amount scheduleDate:(NSDate *)scheduleDate referenceId:(NSString *)referenceId memo:(NSString *)memo
{
    self = [super init];
    if (self) {
        self.referenceId = referenceId;
        self.amount = amount;
        self.memo = memo;
        self.scheduleDate = scheduleDate;
    }
    return self;
}

// PaymentItems may or may not be created via initWithPaymentItemFromDictionary:. If not, we need to create the dictionary
// so it can be passed as a param to the JSON serializer

- (NSDictionary *)dictionary
{
    if (self.dictionary) return self.dictionary;
    NSDictionary *dict = @{
                           @"referenceId": self.referenceId,
                           @"amount": [NSNumber numberWithDouble:self.amount],
                           @"memo": self.memo,
                           @"scheduleDate": [[self paymentItemDateFormatter] stringFromDate:self.scheduleDate]
                           };
    self.dictionary = dict;
    return dict;
}

- (NSDateFormatter *)paymentItemDateFormatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-DD"];
    return dateFormatter;
}

@end
