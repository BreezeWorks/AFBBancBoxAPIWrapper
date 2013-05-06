//
//  AFBBancBoxAccountActivity.h
//  Breeze
//
//  Created by Adam Block on 5/1/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFBBancBoxAccountActivity : NSObject

@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, strong) NSString *traceId;
@property (nonatomic, strong) NSDate *activityDate;
@property (nonatomic, strong) NSString *activityDescription;
@property (nonatomic) double debitAmount;
@property (nonatomic) double creditAmount;
@property (nonatomic) double balance;

- (id)initWithActivityFromDictionary:(NSDictionary *)dict;
+ (AFBBancBoxAccountActivity *)activityFromDictionary:(NSDictionary *)dict;
+ (NSDateFormatter *)activityDateFormatter;

@end
