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
    if (_dictionary) return _dictionary;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.referenceId) dict[@"referenceId"] = self.referenceId;
    if (self.amount) dict[@"amount"] = [NSNumber numberWithDouble:self.amount];
    if (self.memo) dict[@"memo"] = self.memo;
    if (self.scheduleDate) dict[@"scheduleDate"] = [[self paymentItemDateFormatter] stringFromDate:self.scheduleDate];
    
    _dictionary = dict;
    return dict;
}

- (NSDateFormatter *)paymentItemDateFormatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    return dateFormatter;
}

@end
