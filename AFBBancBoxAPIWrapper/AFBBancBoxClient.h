//
//  AFBBancBoxClient.h
//  Breeze
//
//  Created by Adam Block on 4/26/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const BancBoxClientStatusActive;
extern NSString * const BancBoxClientStatusInactive;
extern NSString * const BancBoxClientStatusSuspended;
extern NSString * const BancBoxClientStatusDeleted;
extern NSString * const BancBoxClientStatusCancelled;
extern NSString * const BancBoxClientCipStatusVerified;
extern NSString * const BancBoxClientCipStatusUnverified;
extern NSString * const BancBoxClientCipStatusIgnored;
extern NSString * const BancBoxClientCipStatusRejected;

extern NSString * const kBancBoxErrorCodeBadClientStatus;
extern NSString * const kBancBoxErrorMessageBadClientStatus;

@interface AFBBancBoxClient : NSObject

@property (nonatomic, strong) NSDictionary *dictionary;
@property (nonatomic) NSInteger clientIdBancBoxId;
@property (nonatomic, strong) NSString *clientIdSubscriberReferenceId;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *middleInitial;
@property (nonatomic, strong) NSString *ssn;
@property (nonatomic, strong) NSDate *dob;
@property (nonatomic, strong) NSString *addressLine1;
@property (nonatomic, strong) NSString *addressLine2;
@property (nonatomic, strong) NSString *addressCity;
@property (nonatomic, strong) NSString *addressState;
@property (nonatomic, strong) NSString *addressZipCode;
@property (nonatomic, strong) NSString *homePhone;
@property (nonatomic, strong) NSString *mobilePhone;
@property (nonatomic, strong) NSString *workPhone;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *clientStatus;
@property (nonatomic, strong) NSString *cipStatus;

- (id)initWithClientFromDictionary:(NSDictionary *)dict;
+ (AFBBancBoxClient *)clientFromDictionary:(NSDictionary *)dict;
- (NSString *)description;
- (NSDictionary *)dictionaryForCreate;
- (NSDictionary *)dictionaryForUpdate;
+ (BOOL)clientStatusIsValid:(NSString *)status;
+ (BOOL)cipStatusIsValid:(NSString *)status;
- (NSDateFormatter *)birthdateDateFormatter;

@end
