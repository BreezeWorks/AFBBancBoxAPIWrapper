//
//  AFBBancBoxPaymentItemStatus.h
//  Breeze
//
//  Created by Adam Block on 5/1/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFBBancBoxPaymentItemStatus : NSObject

@property (nonatomic, strong, readonly) NSDictionary *dictionary;
@property (nonatomic) NSInteger statusIdBancBoxId;
@property (nonatomic, strong) NSString *statusIdSubscriberReferenceId;
@property (nonatomic, strong) NSString *transactionStatus;
@property (nonatomic, strong) NSString *messageCode;
@property (nonatomic, strong) NSString *messageDesc;
@property (nonatomic, strong) NSString *errorCode;
@property (nonatomic, strong) NSString *errorMessage;
@property (nonatomic) BOOL itemStatus;
@property (nonatomic, strong) NSString *externalReferenceId;

- (id)initWithPaymentItemStatusFromDictionary:(NSDictionary *)dict;
+ (AFBBancBoxPaymentItemStatus *)paymentItemStatusFromDictionary:(NSDictionary *)dict;

@end
