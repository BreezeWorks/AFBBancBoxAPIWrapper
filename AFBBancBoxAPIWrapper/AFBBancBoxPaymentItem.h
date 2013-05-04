//
//  AFBBancBoxPaymentItem.h
//  Breeze
//
//  Created by Adam Block on 4/27/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFBBancBoxPaymentItem : NSObject

@property (nonatomic, strong, readonly) NSDictionary *dictionary;
@property (nonatomic, strong) NSString *referenceId;
@property (nonatomic) double amount;
@property (nonatomic, strong) NSString *memo;
@property (nonatomic, strong) NSDate *scheduleDate;

- (id)initWithPaymentItemFromDictionary:(NSDictionary *)dict;
- (id)initWithPaymentAmount:(double)amount scheduleDate:(NSDate *)scheduleDate referenceId:(NSString *)referenceId memo:(NSString *)memo;

@end
