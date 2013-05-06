//
//  AFBBancBoxResponse.m
//  Breeze
//
//  Created by Adam Block on 4/26/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import "AFBBancBoxResponse.h"

@implementation AFBBancBoxResponse

NSString * const BancBoxResponseStatusDescriptionNotRequested = @"NOT REQUESTED";
NSString * const BancBoxResponseStatusDescriptionFail = @"FAIL";
NSString * const BancBoxResponseStatusDescriptionPass = @"PASS";

- (id)initWithResponse:(NSDictionary *)response
{
    self = [super init];
    if (self) {
        self.response = response;
        self.warnings = [self warningsFromResponse:response];
        self.errors = [self errorsFromResponse:response];
        self.status = [response[@"status"] integerValue];
        self.requestId = [response[@"requestId"] longLongValue];
    }
    return self;
}

- (id)initWithErrorCode:(NSString *)errorCode errorMessage:(NSString *)errorMessage
{
    self = [super init];
    if (self) {
        AFBBancBoxResponseError *error = [[AFBBancBoxResponseError alloc] initWithErrorFromDictionary:@{@"code": errorCode, @"message": errorMessage}];
        self.status = BancBoxResponseStatusNotRequested;
        self.errors = @[ error ];
    }
    return self;
}

- (NSArray *)warningsFromResponse:(NSDictionary *)response
{
    id responseWarnings = response[@"warnings"];
    NSMutableArray *warnings = [NSMutableArray array];
    if ([responseWarnings isKindOfClass:[NSArray class]]) {
        [responseWarnings enumerateObjectsUsingBlock:^(id responseWarning, NSUInteger idx, BOOL *stop) {
            AFBBancBoxResponseWarning *warning = [[AFBBancBoxResponseWarning alloc] initWithWarningFromDictionary:responseWarning];
            [warnings addObject:warning];
        }];
    }
    return warnings;
}

- (NSArray *)errorsFromResponse:(NSDictionary *)response
{
    NSArray *responseErrors = response[@"errors"];
    NSMutableArray *errors = [NSMutableArray array];
    if ([responseErrors isKindOfClass:[NSArray class]]) {
        [responseErrors enumerateObjectsUsingBlock:^(id responseError, NSUInteger idx, BOOL *stop) {
            AFBBancBoxResponseError *error = [[AFBBancBoxResponseError alloc] initWithErrorFromDictionary:responseError];
            [errors addObject:error];
        }];
    }
    return errors;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"BancBox API call status %@ for requestId %lli. Response: %@", self.statusDescription, self.requestId, self.response];
}

- (NSString *)statusDescription
{
    switch (self.status) {
        case BancBoxResponseStatusNotRequested: return BancBoxResponseStatusDescriptionNotRequested; break;
        case BancBoxResponseStatusFail: return BancBoxResponseStatusDescriptionFail; break;
        case BancBoxResponseStatusPass: return BancBoxResponseStatusDescriptionPass;
    }
    return @"";
}

@end


@implementation AFBBancBoxResponseWarning

- (id)initWithWarningFromDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.code = dict[@"code"];
        self.message = dict[@"message"];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Warning %@: %@", self.code, self.message];
}

@end


@implementation AFBBancBoxResponseError

- (id)initWithErrorFromDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.code = dict[@"code"];
        self.message = dict[@"message"];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Error %@: %@", self.code, self.message];
}

@end