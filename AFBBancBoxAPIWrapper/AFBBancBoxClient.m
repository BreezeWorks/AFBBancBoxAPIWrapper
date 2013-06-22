//
//  AFBBancBoxClient.m
//  Breeze
//
//  Created by Adam Block on 4/26/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import "AFBBancBoxClient.h"
#import "AFBBancBoxPerson.h"

NSString * const BancBoxClientStatusActive =        @"ACTIVE";
NSString * const BancBoxClientStatusInactive =      @"INACTIVE";
NSString * const BancBoxClientStatusSuspended =     @"SUSPENDED";
NSString * const BancBoxClientStatusDeleted =       @"DELETED";
NSString * const BancBoxClientStatusCancelled =     @"CANCELLED";
NSString * const BancBoxClientCipStatusVerified =   @"VERIFIED";
NSString * const BancBoxClientCipStatusUnverified = @"UNVERIFIED";
NSString * const BancBoxClientCipStatusIgnored =    @"IGNORED";
NSString * const BancBoxClientCipStatusRejected =   @"REJECTED";

// Internal error responses
NSString * const kBancBoxErrorCodeBadClientStatus = @"AFB-BB-001";
NSString * const kBancBoxErrorMessageBadClientStatus = @"Client status is not one of: 'ACTIVE', 'INACTIVE', 'SUSPENDED','DELETED'";

@implementation AFBBancBoxClient

- (id)initWithClientFromDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.dictionary = dict;
        self.clientIdSubscriberReferenceId = dict[@"clientId"][@"subscriberReferenceId"];
        self.clientIdBancBoxId = [dict[@"clientId"][@"bancBoxId"] integerValue];
        self.firstName = dict[@"firstName"];
        self.lastName = dict[@"lastName"];
        self.middleInitial = dict[@"middleInitial"];
        self.ssn = dict[@"ssn"];
        self.dob = [[AFBBancBoxPerson birthdateDateFormatter] dateFromString:dict[@"dob"]];
        self.addressLine1 = dict[@"address"][@"line1"];
        self.addressLine2 = dict[@"address"][@"line2"];
        self.addressCity = dict[@"address"][@"city"];
        self.addressState = dict[@"address"][@"state"];
        self.addressZipCode = dict[@"address"][@"zipcode"];
        self.homePhone = dict[@"homePhone"];
        self.mobilePhone = dict[@"mobilePhone"];
        self.workPhone = dict[@"workPhone"];
        self.email = dict[@"email"];
        self.username = dict[@"username"];
        self.clientStatus = dict[@"clientStatus"];
        self.cipStatus = dict[@"cipStatus"];
    }
    return self;
}

+ (AFBBancBoxClient *)clientFromDictionary:(NSDictionary *)dict
{
    return [[AFBBancBoxClient alloc] initWithClientFromDictionary:dict];
}

- (NSString *)description
{
    return self.dictionary.description;
}

- (NSDictionary *)dictionaryForCreate
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.clientIdSubscriberReferenceId) dict[@"referenceId"] = self.clientIdSubscriberReferenceId;
    
    [dict addEntriesFromDictionary:[self detailsDictionary]];
    
    return dict;
}

- (NSDictionary *)dictionaryForUpdate
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"clientId"] = [NSMutableDictionary dictionary];
    if (self.clientIdSubscriberReferenceId) dict[@"clientId"][@"subscriberReferenceId"] = self.clientIdSubscriberReferenceId;
    if (self.clientIdBancBoxId) dict[@"clientId"][@"bancBoxId"] = [NSNumber numberWithInteger:self.clientIdBancBoxId];
    
    [dict addEntriesFromDictionary:[self detailsDictionary]];
    
    return dict;
}

- (NSDictionary *)detailsDictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.firstName) dict[@"firstName"] = self.firstName;
    if (self.lastName) dict[@"lastName"] = self.lastName;
    if (self.middleInitial) dict[@"middleInitial"] = self.middleInitial;
    if (self.ssn) dict[@"ssn"] = self.ssn;
    if (self.dob) dict[@"dob"] = [[AFBBancBoxPerson birthdateDateFormatter] stringFromDate:self.dob];
    
    NSMutableDictionary *address = [NSMutableDictionary dictionary];
    if (self.addressLine1) address[@"line1"] = self.addressLine1;
    if (self.addressLine2) address[@"line2"] = self.addressLine2;
    if (self.addressCity) address[@"city"] = self.addressCity;
    if (self.addressState) address[@"state"] = self.addressState;
    if (self.addressZipCode) address[@"zipcode"] = self.addressZipCode;
    
    if ([address count] > 0) dict[@"address"] = address;
    if (self.homePhone) dict[@"homePhone"] = self.homePhone;
    if (self.mobilePhone) dict[@"mobilePhone"] = self.mobilePhone;
    if (self.workPhone) dict[@"workPhone"] = self.workPhone;
    if (self.email) dict[@"email"] = self.email;
    if (self.username) dict[@"username"] = self.username;

    return dict;
}

+ (BOOL)clientStatusIsValid:(NSString *)status
{
    NSSet *clientStatuses = [NSSet setWithObjects:BancBoxClientStatusActive, BancBoxClientStatusInactive, BancBoxClientStatusSuspended, BancBoxClientStatusDeleted, BancBoxClientStatusCancelled, nil];
    return [clientStatuses containsObject:status];
}

+ (BOOL)cipStatusIsValid:(NSString *)status
{
    NSSet *cipStatuses = [NSSet setWithObjects:BancBoxClientCipStatusVerified, BancBoxClientCipStatusRejected, BancBoxClientCipStatusIgnored, BancBoxClientCipStatusUnverified, nil];
    return [cipStatuses containsObject:status];
}

@end
