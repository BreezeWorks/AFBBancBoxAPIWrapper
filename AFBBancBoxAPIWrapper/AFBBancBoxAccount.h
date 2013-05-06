//
//  AFBBancBoxAccount.h
//  Breeze
//
//  Created by Adam Block on 4/30/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

// Abstract class for BancBox accounts -- internal, linked external, and new external

#import <Foundation/Foundation.h>

extern NSString * const BancBoxAccountTypeGeneral;
extern NSString * const BancBoxAccountTypeSpecial;
extern NSString * const BancBoxAccountStatusOpen;
extern NSString * const BancBoxAccountStatusClosed;

@interface AFBBancBoxAccount : NSObject

@property (nonatomic, strong) NSDictionary *dictionary;
@property (nonatomic) uint64_t bancBoxId;
@property (nonatomic, strong) NSString *subscriberReferenceId;

- (NSString *)description;

@end
