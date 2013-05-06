//
//  AFBBancBoxResponse.h
//  Breeze
//
//  Created by Adam Block on 4/26/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    BancBoxResponseStatusNotRequested = -1,
    BancBoxResponseStatusFail,
    BancBoxResponseStatusPass
} BancBoxResponseStatus;

extern NSString * const BancBoxResponseStatusDescriptionNotRequested;
extern NSString * const BancBoxResponseStatusDescriptionFail;
extern NSString * const BancBoxResponseStatusDescriptionPass;

@interface AFBBancBoxResponseWarning : NSObject

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *message;

- (id)initWithWarningFromDictionary:(NSDictionary *)dict;
- (NSString *)description;

@end


@interface AFBBancBoxResponseError : NSObject

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *message;

- (id)initWithErrorFromDictionary:(NSDictionary *)dict;
- (NSString *)description;

@end


@interface AFBBancBoxResponse : NSObject

@property (nonatomic) uint64_t requestId;
@property (nonatomic) BancBoxResponseStatus status;
@property (nonatomic, strong) NSArray *warnings;
@property (nonatomic, strong) NSArray *errors;
@property (nonatomic, strong) NSDictionary *response;

- (id)initWithResponse:(NSDictionary *)response;
- (id)initWithErrorCode:(NSString *)errorCode errorMessage:(NSString *)errorMessage;
- (NSString *)description;
- (NSString *)statusDescription;

@end