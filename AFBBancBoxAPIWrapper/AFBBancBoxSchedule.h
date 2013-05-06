//
//  AFBBancBoxSchedule.h
//  Breeze
//
//  Created by Adam Block on 4/26/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFBBancBoxSchedule : NSObject

@property (nonatomic, strong) NSDictionary *dictionary;
@property (nonatomic) NSInteger clientIdBancBoxId;
@property (nonatomic, strong) NSString *clientIdSubscriberReferenceId;
@property (nonatomic, strong) NSString *type;
@property (nonatomic) double amount;
@property (nonatomic, strong) NSDate *scheduleDate;
@property (nonatomic, strong) NSDate *modifiedOn;
@property (nonatomic, strong) NSDate *createdOn;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *externalReferenceId;

- (id)initWithScheduleFromDictionary:(NSDictionary *)dict;
+ (AFBBancBoxSchedule *)scheduleFromDictionary:(NSDictionary *)dict;
+ (BOOL)fundsRequestStatusIsValid:(NSString *)status;
+ (BOOL)scheduleStypeIsValid:(NSString *)type;

@end
